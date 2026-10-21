# VAULT Hub 🧰

## ▶ Start here (about 2 minutes)

1. 📁 Copy this repo's files into your **VAULT folder root** (the folder that contains `01. DRAWERS`).
2. 🔧 Run once: `python3 _hub/update_index.py`
3. 🚀 Double-click **`Open VAULT Hub (Mac).command`** or **`Open VAULT Hub (Windows).bat`**.

✅ **Done when** your browser opens `http://127.0.0.1:8765` and shows the Builder. Keep the terminal window open.

❓ No VAULT folder yet? Download the files from your own Kickstarter / USSA account first. This repo contains none.

![Builder: pick a unit, get the parts list, see it in 3D](docs/builder-drawer.png)

**English** | [简体中文](README.zh-CN.md)

> 🔍 Search, preview and plan prints for the **VAULT** modular toolbox STL pack (700+ files), on your own computer.
> ⚠️ Unofficial fan tool. Not affiliated with or endorsed by USSA.

## ✨ What you get (5 things)

| | |
|---|---|
| 📋 **Plan a print** | Pick drawer or sustainer, size, options → the full list of files to print. Switch any part on or off. Watch it in a live 3D preview. |
| 🎨 **Pick colors** | 8 Matte + 13 Basic colors on a 3D tower. Shuffle, save templates, import / export. |
| 🏷️ **Know the filament** | Every STL is tagged Matte / Basic / TPU, filled with your chosen color. |
| ✅ **Print it** | Tick parts off, saved progress, copy the list, gather the files into one folder. |
| 🔍 **Browse the pack** | Search 700+ files, orbit any STL in 3D, read the manuals. English / 中文, phone-friendly. |

## 🔎 Details (click one to open)

<details>
<summary><b>📋 Plan a print</b></summary>

- **Pick:** drawer / sustainer, width S–XL, depth 3–7, height 1F / 2F / 4F, quantity.
- **Options:** lock type, roof (none / bowl / grid / heavyweight (L, XL) / table / under-table), handle, dividers, baseplate, locks per unit.
- **Spec strip:** size, Gridfinity grid, print time, filament weight (where published).
- **Tags:** "2 pcs in file" = print once. "Supports" = turn supports on.
- **Hardware counts:** bolts and other non-printed parts.

![Sustainer in the Builder](docs/builder-sustainer.png)

</details>

<details>
<summary><b>🎛️ Every part has a switch</b></summary>

- The list shows **all** files the unit could use: both key types, handle, every roof, dividers, baseplates, lock set, hinges.
- Parts your options select start **on**. The rest start **off** (greyed). Flip any switch.
- Off parts are skipped by the file count, tag totals, progress bar, *Copy list* and *Gather*.
- Changing an option resets the switches to that option's defaults.
- Not listed: L² / XL² families (no such size in the Builder) and the loose grid-divider pieces.

![Parts with switches](docs/parts-switches.png)

</details>

<details>
<summary><b>🧊 Live 3D preview</b></summary>

- Follows size, depth, height, quantity (up to 6 high), lock, roof, handle. Drag to rotate. **↻ flips to the back.**
- Outside only, shaped like the real product: rounded modules, centered rotary key, label, runner stoppers, feet.
- **Sustainer:** flat lid with bevelled edge and side tabs, hooked lock latches (1 on S / M, 2 on L / XL), hinges with rods at the back. Latch and hinge never rise above the roof.
- **Roofs:** grid (low ribs), bowl (shallow dish), table (thin groove), under-table (screw holes), heavyweight (thick lid + bar handle).
- Uses your Colors-tab colors. Needs no STL files.

![Six sizes and shapes](docs/builder-preview.png)

![Sustainer from the back](docs/sustainer-hinge.png)

</details>

<details>
<summary><b>🎨 Color picker</b></summary>

- **Palettes:** Matte (White, Black, Lime, Grey, Pink, Light blue, Violet, Avocado). Basic (Orange, Red, Yellow, Green, Blue, Dark Blue, White, Beige, Black, Brown, Grey, Blue Grey, Dark Green).
- **11 parts:** Body, Facade, Roof · Handle, Key lock, Key cap, Lock latch, Hinge, Hinge rod, Label, Runner stopper. Click a part in 3D or in the list.
- 🎲 **Shuffle** · ↺ **Reset colors**.
- **Templates:** *Save* stores the combo as color dots. Click to load, × to delete.
- **Import / Export:** `colors.json`. On-screen colors are approximate: check a real swatch.

![Colors tab](docs/colors-custom-en.png)

</details>

<details>
<summary><b>🏷️ Filament tags</b></summary>

- Shown in the Builder and *All files*, added to *Copy list*. Filled with the color you picked.
- Rules live in `material()` in `index.html`. Change them there.

| Finish | Parts |
|---|---|
| **Matte** | Modules, boxes, roofs, facades, baseplates, dividers, wheel cover |
| **Basic** | Handles, runners, key, latch, springs, rails, labels; hinges, rods, locks; accessories; supports; backbones, bases, feet, pegboard, wall mounts; wheel parts |
| **TPU** | Wheel tyre |

</details>

<details>
<summary><b>✅ Print · 🔍 Browse · 🌐 Language · 📱 Phone</b></summary>

- **Checklist:** tick parts off (saved in your browser), **Copy list**, **Gather into folder** (`_Print Jobs/<name>`).
- **3D file preview:** orbit / zoom / pan, wireframe, ← / → between parts, **Open in slicer**, **Show in folder**, or drop any STL on the panel.
- **Search:** press `/`. Filter Drawers / Sustainers / Modifications / Images & PDFs. **Manuals:** the 5 official PDFs open in the hub.
- **Language:** English / 中文 in one click.
- **Phone:** the preview comes first; vertical swipes still scroll.

![3D file preview](docs/preview-3d.png)

![Search](docs/files.png)

![Chinese interface](docs/builder-zh.png)

<p><img src="docs/mobile-builder.png" width="240" alt="Builder on a phone"> &nbsp; <img src="docs/mobile-colors.png" width="240" alt="Colors on a phone"></p>

</details>

## 🛠️ Setup details

<details>
<summary>Folder layout, other systems, thumbnails</summary>

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

- **macOS:** double-click the `.command` (first time: right-click → Open).
- **Windows:** double-click the `.bat`. It uses Python, or a built-in PowerShell server.
- **Linux:** `python3 _hub/serve_hub.py`
- **After you add or rename files:** `python3 _hub/update_index.py`
- **Optional thumbnails** (not included; needs Node, Playwright, Chrome): `VAULT_PORT=8799 python3 _hub/serve_hub.py`, then `node _hub/make_thumbs.mjs`, then `python3 _hub/update_index.py`

The Colors tab and the Builder preview are drawn from plain shapes and work without the STL files. The file list, thumbnails, 3D file preview and manuals need your copy.

</details>

## 🧯 If something breaks

1. **Terminal says Python not found** → install Python 3 from python.org, then double-click the launcher again.
2. **Page opens but the file list is empty** → you skipped step 2. Run `python3 _hub/update_index.py`, then refresh.
3. **3D views are blank** → no internet. three.js loads from a CDN. Reconnect and refresh.
4. **Hub stops after a few seconds** → the terminal window was closed. Re-run the launcher and leave the window open.
5. **"Show in folder" does nothing** → you opened `index.html` directly. Use the launcher.

## 📌 Good to know

- **Private:** the server listens on `127.0.0.1` only and serves only your project folder. Nothing is uploaded.
- **Contributing:** issues and PRs welcome, especially parts rules and translations.
- **License:** code is MIT (see `LICENSE`). VAULT models, manuals and name belong to their owners and are **not** covered.

**Next:** open the hub, click **Builder**, pick **M · 4 · 2F**, and watch the 3D preview change.
