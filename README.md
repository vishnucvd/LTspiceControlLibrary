LTspice Control Library
===========================
LTspice Control Library provides a set of control elements, that allow to design a controller of a circuit by drawing
a control block diagram and simulate the circuit and the controller on LTspice IV / XVII.

![3PhaseInverter example](examples/DC-ACConverter/3PhaseInverter.png)

Installation
==============
1. Install LTspice (IV/XVII/new). 
2. Download [LTspice Control Library](https://github.com/kanedahiroshi/LTspiceControlLibrary/archive/master.zip).
3. Unzip the downloaded file and run the script:
    * LTspice IV: Run "LTspiceControlLibrary\install.bat" (legacy fallback supported)
    * LTspice XVII / modern: Run "LTspiceControlLibrary\installXVII.bat" (modern auto-detect, no admin rights required)
  This script now works as below:
  * Detects Documents path via PowerShell + Registry + default fallback.
  * Detects LTspice install location:
    - `%USERPROFILE%\Documents\LTspice`
    - `%USERPROFILE%\Documents\LTspiceXVII`
    - `%ProgramFiles%\LTC\LTspiceIV`
  * Always renames/uninstalls existing control library folders first to prevent outdated config before install.
  * Copies "LTspiceControlLibrary\lib\sub\LTspiceControlLibrary" to "%LTSPICE_DIR%\lib\sub\LTspiceControlLibrary".
  * Copies "LTspiceControlLibrary\lib\sym\LTspiceControlLibrary" to "%LTSPICE_DIR%\lib\sym\LTspiceControlLibrary".
4. Restart LTspice. The library should now be usable.
5. Try examples in "LTspiceControlLibrary\examples" to confirm installation and learn how to use this library.

More Information
===========================
- List of [Control Elements](ControlElements.md)
- LTspice Control Library is released under the [MIT License](LICENSE.txt)
- [DCモータ制御 紹介記事用サンプル](examples/Introduction/201310Toragi)
- [DCブラシレスモータ制御 紹介記事用サンプル](examples/Introduction/201404Interface)
- [太陽電池 最大電力点追従制御 紹介記事用サンプル](examples/Introduction/201705Toragi)

Version History
===============
- 2026-03-28: Added modern installer auto-detection for LTspice XIX/XX; no admin rights required; combined legacy/modern workflows.
- 2014-02-06: Existing LTspice IV/XVII installer scripts (legacy behavior and registry-based path lookup).

Authors
=======
- Original author     : Hiroshi Kaneda (@kanedahiroshi)
- Maintainer / update : Vishnu CV (@vishnucvd) (current patch)
