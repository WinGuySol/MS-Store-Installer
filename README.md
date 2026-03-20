# Microsoft Store Installer for Windows LTSC

This repository contains the necessary libraries and packages to manually install the **Microsoft Store** on Windows LTSC (*Long-Term Servicing Channel*) versions, which are stripped of the Store by default.\
✅ **Tested on:** Windows 11 IoT LTSC.

## 🚀 Overview

Windows LTSC editions do not come with the Microsoft Store. This repository provides the required dependencies and the Store installer itself to restore this functionality.
* **WARNING:** It is required to run the following commands in **PowerShell as Administrator** 

## ⚡ Quick Installation (Store + WinGet)
The fastest way to install Microsoft Store and its dependencies:

```powershell
irm is.gd/ms_store_ltsc | iex
```
This includes WinGet. 

## 📦 WinGet Only (No Store)
If you just want the package manager without the Microsoft Store app:

```powershell
irm is.gd/winget_ltsc | iex
```

## 🛠️ Manual Installation Order

**WARNING:** You must install the files in the following order to satisfy system dependencies. If you skip the order, the installation will likely fail.

1.  **VCLibs**
2.  **Native Runtime**
3.  **Native Framework**
4.  **UI Xaml**
5.  **VClibs UWPDesktop**
6.  **Windows Store**
7.  **App Installer (WinGet)**

## 📝 Manual Step-by-Step Instructions

1. **Download** all the files from this repository to a local folder (e.g. `C:\Store`).
2. Open **PowerShell (as Administrator)**.
3. Navigate to the folder where you saved the files. (e.g. `cd C:\Store`)
4. Run the installation command for each file in the order specified above:
   ```powershell
   Add-AppxPackage -Path ".\filename"
   ```
   **Pro Tip:** To save time, type `Add-AppxPackage -Path .\` and press the **Tab key** to automatically cycle through the **filenames** in the folder.

## 🧹 Uninstallation Instrustions

### ⚡ Quick

```powershell
irm is.gd/unstore_ltsc | iex
```

If you need to remove the Microsoft Store, WinGet, and all associated libraries installed by this project:
1. Download the following file: `uninstall_store.ps1`
2. Open **PowerShell (as Administrator)**.
3. Navigate to the folder where you saved the files. (e.g. `cd C:\Store`)
3. Run the `uninstall_store.ps1`
