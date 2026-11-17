# SNOW Launcher (iPad Edition)
A lightweight, standalone Minecraft Bedrock Launcher designed for iPadOS / iOS (Sideloadable via SideStore).

## Features
- **V-Sync Disabler & FPS Unlocker:** Modifies Minecraft `options.txt` directly to reduce input lag and unlock frame rates.
- **iPad Gyroscope Engine:** Built-in CoreMotion gyroscope calibration and sensitivity controls.
- **In-Game Pack Changer Manager:** Easily import, manage, and organize `.mcpack` and `.zip` resource packs.
- **Quick Launch:** Direct URL Scheme launch (`minecraft://`).

## How to Build `.ipa` (Without Mac / With GitHub Actions)
1. Upload this repository to GitHub.
2. Use the included `.github/workflows/build.yml` workflow to automatically compile an unsigned `.ipa` file on GitHub's macOS runners.
3. Download the `.ipa` artifact and install it on your iPad using **SideStore**.
