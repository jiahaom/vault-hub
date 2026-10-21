# VAULT Hub

**English** | [简体中文](README.zh-CN.md)

A local browser hub for finding your way around the VAULT modular stacking toolbox print files. It turns hundreds of loose STL files and nested folders into a searchable library with 3D previews and a "what do I need to print?" builder.

> **Unofficial fan tool.** Not affiliated with or endorsed by USSA. This repository contains **no** STL, PDF or image files from the VAULT project. You supply your own copy of the files you received as a backer / customer (see [Setup](#setup)).

## The problem

The VAULT file pack has 700+ STL files spread over dozens of nested folders (Drawers, Sustainers, Modifications, each split by size family S / M / L / XL, then by depth, modules, roofs, facades, dividers, baseplates...). Working out which files make up *one* drawer, and printing them without missing a part, takes a lot of clicking.

## Features

### Builder: "what do I need to print?"

![Builder showing an M4 2F drawer with 5 of 13 parts ticked off](docs/builder-drawer.png)

Pick a unit and the hub lists every file you need, so nothing gets missed.

- **Unit type** – Drawer or Sustainer (hinged-lid box).
- **Size** – width S / M / L / XL, depth 3–7, height 1F / 2F / 4F, each with its outer size in mm, plus a quantity.
- **Options** – lock style, roof for the top unit (none / bowl / grid / table / under-table mount), top handle, dividers, Gridfinity baseplate, locks per unit.
- **Spec strip** – outer and inside dimensions, Gridfinity grid size, and estimated print time and filament weight (published figures, where available).
- **Parts list** – grouped into Body, Slides / latch / lock, Hinges & rods, Lock set and Hardware, with a thumbnail, quantity and file size for each part.
- **Smart tags** – "2 pcs in file" marks files that already contain a pair (print once); "Supports" marks files that need support material.
- **Hardware counts** – bolts and other non-printed parts, with quantities.
- **Part names** – the official exploded diagram, one click away.

![Builder showing an M4 2F sustainer](docs/builder-sustainer.png)

*The sustainer view adds hinges & rods, a lock set and a locks-per-unit counter.*

### Print checklist

- Tick parts off as they come off the printer; a progress bar shows how far you are. Progress is saved in your browser, and **Clear checks** resets it.
- **Copy list** exports the checklist as plain text.
- **Gather into folder** copies the whole parts list into one `_Print Jobs/<name>` folder, ready to drag into your slicer.

### 3D preview

![3D preview of an STL file](docs/preview-3d.png)

- Orbit, zoom and pan any STL in the browser. Shows real size in mm and triangle count (works with 1M+ triangle files).
- Wireframe and reset-view buttons; ← / → steps through the parts, Esc closes.
- **Open in slicer** launches the file in your default app; **Show in folder** jumps to it in Finder / Explorer.
- Drop any STL onto the preview panel to view it, even a file from outside the project.

### All files

![Searching all files](docs/files.png)

- Instant search by file or folder name (press `/` to focus), with category filters: Drawers, Sustainers, Modifications, Images & PDFs.
- Results are grouped by folder, with thumbnails, sizes, preview and show-in-folder buttons on every row.

### Manuals

- The five official PDFs open inside the hub, next to a gallery of the reference images.

### English / 中文

![Chinese interface](docs/builder-zh.png)

- Full interface in English and Chinese, switchable with one click. Picks your browser language on first run and remembers your choice.

## Setup

1. Download the VAULT files from your own Kickstarter / USSA account and unzip them.
2. Copy the contents of this repository **into the root of that folder**, so it looks like:

   ```
   VAULT/
   ├── 01. DRAWERS/
   ├── 02. SUSTAINERS/
   ├── 03. MODIFICATIONS/
   ├── *.pdf
   ├── index.html                    ← this repo
   ├── Open VAULT Hub (Mac).command  ← this repo
   ├── Open VAULT Hub (Windows).bat  ← this repo
   └── _hub/                         ← this repo
   ```
3. Rebuild the file index once so it matches your copy:

   ```
   python3 _hub/update_index.py
   ```
4. Launch:
   - **macOS** – double-click `Open VAULT Hub (Mac).command` (first time: right-click → Open).
   - **Windows** – double-click `Open VAULT Hub (Windows).bat`. Uses Python if installed, otherwise a built-in PowerShell server.
   - **Linux** – `python3 _hub/serve_hub.py`

The hub opens at `http://127.0.0.1:8765`. Keep the terminal window open while you use it.

> Opening `index.html` directly (double-click) still works for browsing, but browsers block local file access, so 3D preview and "Show in folder" are disabled. Use the launcher.

### Optional: thumbnails

Thumbnails are not included (they are renders of the STL files). To generate them, start the server on port 8799 and run the renderer (needs Node, Playwright and Chrome):

```
VAULT_PORT=8799 python3 _hub/serve_hub.py
node _hub/make_thumbs.mjs
python3 _hub/update_index.py
```

## Requirements

- Python 3 (macOS and Linux) – Windows can fall back to PowerShell
- A modern browser
- Internet access for the 3D preview (three.js is loaded from a CDN)

## Privacy and security

The server binds to `127.0.0.1` only, serves only files inside the project folder, and its write actions (reveal, open, gather) require a custom header that other websites cannot send. Nothing is uploaded anywhere.

## Updating after you add or rename files

```
python3 _hub/update_index.py
```

## Contributing

Issues and pull requests are welcome, especially for new parts rules in the Builder and translations.

## License

Code in this repository: MIT (see `LICENSE`). The VAULT models, manuals and name belong to their respective owners and are **not** covered by this license.
