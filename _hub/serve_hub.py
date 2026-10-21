#!/usr/bin/env python3
"""Local server for the VAULT hub (macOS, Windows, Linux).

Serves the project folder on http://127.0.0.1:8765 so the hub can preview STL
files in 3D, and adds a few local-only actions the browser can't do itself:
reveal a file in Finder/Explorer, open it with the default app (your slicer),
and gather a parts list into one folder.
"""
import http.server
import json
import os
import pathlib
import shutil
import subprocess
import sys
import threading
import urllib.parse
import urllib.request
import webbrowser

ROOT = pathlib.Path(__file__).resolve().parent.parent
PORT = int(os.environ.get("VAULT_PORT", "8765"))
JOBS = ROOT / "_Print Jobs"


def resolve(rel):
    """Map a hub path to a real file, refusing anything outside the project."""
    target = (ROOT / rel).resolve()
    if ROOT not in target.parents and target != ROOT:
        raise ValueError("outside project")
    if not target.exists():
        raise FileNotFoundError(rel)
    return target


def reveal(path):
    if sys.platform == "darwin":
        subprocess.Popen(["open", "-R", str(path)])
    elif os.name == "nt":
        subprocess.Popen(f'explorer /select,"{path}"')
    else:
        subprocess.Popen(["xdg-open", str(path if path.is_dir() else path.parent)])


def open_default(path):
    if sys.platform == "darwin":
        subprocess.Popen(["open", str(path)])
    elif os.name == "nt":
        os.startfile(str(path))  # noqa: S606 - local, user-initiated
    else:
        subprocess.Popen(["xdg-open", str(path)])


def gather(name, paths):
    safe = "".join(c for c in name if c not in '<>:"/\\|?*').strip() or "Parts"
    dest = JOBS / safe
    dest.mkdir(parents=True, exist_ok=True)
    for rel in paths:
        src = resolve(rel)
        target = dest / src.name
        if not target.exists() or target.stat().st_size != src.stat().st_size:
            shutil.copy2(src, target)
    return dest


class Handler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)

    extensions_map = {**http.server.SimpleHTTPRequestHandler.extensions_map,
                      ".stl": "model/stl", ".webp": "image/webp", ".mjs": "text/javascript"}

    def log_message(self, *args):
        pass

    def send_json(self, code, body):
        data = json.dumps(body).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        if self.path == "/api/ping":
            return self.send_json(200, {"ok": True, "platform": sys.platform})
        return super().do_GET()

    def do_POST(self):
        # The custom header can't be sent cross-site without a CORS preflight,
        # which this server never approves, so other websites can't call these.
        if self.headers.get("X-Vault-Hub") != "1":
            return self.send_json(403, {"error": "forbidden"})
        try:
            length = int(self.headers.get("Content-Length", 0))
            body = json.loads(self.rfile.read(length) or b"{}")
            route = urllib.parse.urlparse(self.path).path
            if route == "/api/reveal":
                reveal(resolve(body["path"]))
                return self.send_json(200, {"ok": True})
            if route == "/api/open":
                open_default(resolve(body["path"]))
                return self.send_json(200, {"ok": True})
            if route == "/api/gather":
                dest = gather(body.get("name", "Parts"), body.get("paths", []))
                reveal(dest)
                return self.send_json(200, {"ok": True, "folder": str(dest.relative_to(ROOT))})
            return self.send_json(404, {"error": "unknown route"})
        except Exception as exc:  # report back to the page instead of crashing
            return self.send_json(400, {"error": str(exc)})


def is_hub(port):
    try:
        with urllib.request.urlopen(f"http://127.0.0.1:{port}/api/ping", timeout=1) as res:
            return json.load(res).get("ok") is True
    except Exception:
        return False


def main():
    # A busy port may be this hub (just reopen it) or some other server, such as a
    # leftover plain file server - then move on to the next port instead.
    for port in range(PORT, PORT + 10):
        url = f"http://127.0.0.1:{port}/index.html"
        try:
            server = http.server.ThreadingHTTPServer(("127.0.0.1", port), Handler)
            break
        except OSError:
            if is_hub(port):
                print(f"The hub is already running at {url} - opening it.")
                webbrowser.open(url)
                return
            print(f"Port {port} is used by another program, trying {port + 1}.")
    else:
        sys.exit(f"No free port between {PORT} and {PORT + 9}.")
    print(f"VAULT hub running at {url}")
    print("Leave this window open while you use the hub. Close it (or press Ctrl+C) to stop.")
    if not os.environ.get("VAULT_NO_BROWSER"):
        threading.Timer(0.5, webbrowser.open, args=[url]).start()
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass


if __name__ == "__main__":
    main()
