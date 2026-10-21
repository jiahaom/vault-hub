// Optional: re-render thumbnails after adding STLs. Needs Node, Playwright and Chrome, plus the hub
// server running on port 8799 (VAULT_PORT=8799 python3 _hub/serve_hub.py). Then run
// python3 _hub/update_index.py.
// Renders a transparent iso thumbnail for every STL into _hub/thumbs/<sha1-16>.webp
import { chromium } from 'playwright';
import fs from 'fs';
import path from 'path';
import crypto from 'crypto';
const ROOT = path.resolve(path.dirname(decodeURIComponent(new URL(import.meta.url).pathname)), '..');
const OUT = path.join(ROOT, '_hub/thumbs');
const files = [];
(function walk(d) { for (const e of fs.readdirSync(d, { withFileTypes: true })) {
  if (e.name.startsWith('.') || e.name === '_hub') continue;
  const p = path.join(d, e.name);
  if (e.isDirectory()) walk(p); else if (/\.stl$/i.test(e.name)) files.push(path.relative(ROOT, p).normalize('NFC'));
} })(ROOT);
const id = p => crypto.createHash('sha1').update(p, 'utf8').digest('hex').slice(0, 16);
const todo = files.filter(p => !fs.existsSync(path.join(OUT, id(p) + '.webp')));
console.log(files.length, 'stl,', todo.length, 'to render');
const browser = await chromium.launch({ channel: 'chrome', args: ['--use-angle=swiftshader', '--enable-unsafe-swiftshader', '--ignore-gpu-blocklist', '--js-flags=--max-old-space-size=8192'] });
const page = await browser.newPage();
await page.goto('http://127.0.0.1:8799/_hub/thumbgen.html');
await page.waitForFunction(() => window.ready === true, null, { timeout: 60000 });
let i = 0;
for (const p of todo) {
  i++;
  try {
    const url = p.split('/').map(encodeURIComponent).join('/');
    const data = await page.evaluate(u => window.render('/' + u), url);
    fs.writeFileSync(path.join(OUT, id(p) + '.webp'), Buffer.from(data.split(',')[1], 'base64'));
    if (i % 25 === 0) console.log(i, '/', todo.length, p);
  } catch (e) { console.log('FAIL', p, e.message.slice(0, 120)); }
}
await browser.close();
console.log('done');
