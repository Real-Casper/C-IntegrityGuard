# C-IntegrityGuard
![C-IntegrityGuard](./doc/banner.png)

[![Latest Release](https://img.shields.io/github/v/release/Real-Casper/C-IntegrityGuard?label=Release&logo=github)](https://github.com/Real-Casper/C-IntegrityGuard/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/Real-Casper/C-IntegrityGuard/build-test.yml?label=Build%20Test%20Module)](https://github.com/Real-Casper/C-IntegrityGuard/actions/workflows/build-test.yml)
[![Downloads](https://img.shields.io/github/downloads/Real-Casper/C-IntegrityGuard/total)](https://github.com/Real-Casper/C-IntegrityGuard/releases)

## Purpose
C-IntegrityGuard is a root module designed to assist Android devices in achieving Play Integrity's STRONG verdict through automated management of keybox updates, fingerprint refreshes, and system property spoofing.

## Installation
1. Ensure device is rooted with Magisk, KernelSU, or APatch.
2. Install required dependencies:
   - Tricky Store
   - Play Integrity Fix [INJECT] or Play Integrity Fork
3. Download the latest release zip from the Releases section.
4. Flash the zip using your root manager.
5. Reboot if necessary.
6. Launch your root manager, locate C-IntegrityGuard, and select Action.

## Operation
Upon activation, the module performs the following sequence:
- Terminates relevant Google processes to clear cached integrity data.
- Generates and writes a target list to Tricky Store for hiding from known detection apps.
- Adjusts system properties (boot state, verified boot, warranty bits, etc.) to values consistent with a genuine, locked device.
- Downloads and installs the latest keybox into Tricky Store.
- Invokes Play Integrity Refresh to update the device fingerprint.
- Reports success via a toast message.

## Verification
After running the Action button, verify the device's integrity status using an application such as SPIC or the Play Integrity Checker app from the Play Store. A successful run should result in a MEETS_STRONG_INTEGRITY verdict.

## Notes
- This module does not collect, transmit, or store any personal data.
- The keybox source is publicly available and updated as needed; future releases will include updated keyboxes when required.
- For troubleshooting, ensure that both Tricky Store and a PIF module are correctly installed and functional.

## License
GPL-3.0 © 2024-2025 Real-Casper