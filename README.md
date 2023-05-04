# Desktop Layout Manager

日本語版(Japanese version): [README-ja.md](README-ja.md)

## Overview
Desktop Layout Manager is a tool that allows you to easily save and restore the icon layout of your desktop on Windows.

## Disclaimer
This tool may cause data corruption due to registry operations and explorer task kills.  
If you use this tool, please use it at your own risk.

## How to use
Download DesktopLayoutManager-en.bat and double-click to start it.  

The first time, a warning message "Windows protected your PC" will appear.    

In this case, click on "More info" and then "Run anyway".

Then, follow the instructions on the screen to complete the operation.

## Customize
To disable the startup screen, change the value below from 1 to 0.
```
set showWelcomeScreen=1
```

To disable the Explorer ASCII art, change the value below from 1 to 0.
```
set showExplorerAsciiArt=1
```

To change the folder name to save the desktop layout, change the value below.
```
set savedDirName=SavedDesktopLayout
```