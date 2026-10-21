# VAULT Hub 🧰

## ▶ Start here (1 minute)

1. 📁 Copy this repo's files into your **VAULT folder** (the one with `01. DRAWERS`).
2. 🚀 Double-click **`Open VAULT Hub (Mac).command`** or **`(Windows).bat`**.

✅ Done when your browser shows the hub at `http://127.0.0.1:8765`. Keep the terminal window open.

![Builder](docs/builder-drawer.png)

**English** | [简体中文](README.zh-CN.md)

> 🔍 Search, preview and plan prints for the **VAULT** toolbox STL pack, on your own computer.
> ⚠️ Unofficial fan tool. No VAULT files included: use your own copy from Kickstarter / USSA.

## ✨ What you get

| | |
|---|---|
| 📋 **Plan** | Pick drawer or sustainer, size, options → the files to print. Switch any part on or off. |
| 🧊 **See it** | Live 3D preview of your exact unit. ↻ flips to the back. |
| 🎨 **Color it** | 8 Matte + 13 Basic colors on a 3D tower. Save templates. |
| ✅ **Print it** | Tick parts off, copy the list, gather files into one folder. |
| 🔍 **Browse** | Search 700+ files, orbit any STL, read manuals. English / 中文, phone-friendly. |

## 🔎 Details

### 📋 Plan + 🧊 See it

- Pick type, width S–XL, depth 3–7, height 1F / 2F / 4F, quantity, lock, roof, handle, dividers, baseplate.
- Every part the unit can use is listed with a switch. Off parts are skipped by totals, *Copy list* and *Gather*.
- The preview shows the outside only (key, label, lid, latches, hinges, roofs) and follows your colors.

![Six sizes](docs/builder-preview.png)

### 🎨 Color it + 🏷️ filament tags

- Click a part in 3D or the list, pick a color. 🎲 Shuffle, ↺ Reset, Save / Import / Export.
- Every STL is tagged Matte / Basic / TPU in the Builder and filled with your color. Rules: `material()` in `index.html`.
- Screen colors are approximate: check a real swatch.

![Colors](docs/colors-custom-en.png)

### ✅ Print + 🔍 Browse

- Progress is saved in your browser. **Gather into folder** copies files to `_Print Jobs/`.
- File preview: orbit, wireframe, **Open in slicer**, **Show in folder**. Search: press `/`.

![3D preview](docs/preview-3d.png)

### 🛠️ More setup

- **Linux:** `python3 _hub/serve_hub.py`. **Windows without Python:** the launcher falls back to PowerShell.
- **New or renamed files:** `python3 _hub/update_index.py`
- **Thumbnails** (optional, needs Node, Playwright, Chrome): `VAULT_PORT=8799 python3 _hub/serve_hub.py`, then `node _hub/make_thumbs.mjs`, then `python3 _hub/update_index.py`
- The Colors tab and the Builder preview work without STL files.

## 🧯 If it breaks

1. **Python not found** → install Python 3, double-click the launcher again.
2. **File list empty** → run `python3 _hub/update_index.py`, refresh.
3. **3D is blank** → go online (three.js loads from a CDN), refresh.

## 📌 Notes

- Private: listens on `127.0.0.1` only. Nothing is uploaded.
- Code is MIT (see `LICENSE`). VAULT models, manuals and name belong to their owners.
- Issues and PRs welcome.

**Next:** open the hub → **Builder** → pick **M · 4 · 2F**.
