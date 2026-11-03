Real CRT Phosphor Preview (for shader v1.1)
===========================================

A web page that lets you tune Real CRT Phosphor on a single RetroArch screenshot
and save the values you like as a .slangp preset.
It is one file, crt-preview.html. It works offline in Chrome, Edge or Firefox.
Your images never leave the browser.

Try it right away
  It opens with the built-in sample picture (320×240) already shaded. Open your own game from the pop-up or "Open game screenshot".
  The sample is an original picture made for this tool, free for anyone to use.

How to take the screenshot
  1. Run RetroArch fullscreen and turn the shader off (Quick Menu > Shaders > Video Shaders off).
  2. Take a screenshot and open it as the game screenshot.
     The original game resolution is found automatically, and the result is drawn at the screenshot size.
  3. (Optional) Take the same scene again with the shader on and open it as the shader screenshot.
     You can compare against RetroArch side by side, or use "Find preset used".
     It also measures a changed RGB triad pitch and convergence from the screenshot.
  * You can also press PrintScreen and paste with Ctrl+V. Black bars at the sides of the monitor are removed.
    (If the capture is black, use windowed fullscreen in RetroArch. With several monitors, use Alt+PrintScreen, then Crop game area.)
  * In windowed mode, RetroArch's own screenshot (F8 by default) is easiest: it saves the game picture without the window frame.
  * Comparisons are most accurate when both shots are the same frame (pause first).

How to use
  - Your monitor resolution is read automatically; the tool starts at that screen size with the matching preset family (ally- at 1080p, 4k- at 1440p and 4K).
  - Simple / All at the top left: Simple shows the 8 most used values, All shows everything.
  - Undo / Redo (Ctrl+Z / Ctrl+Shift+Z). Reset all puts every value back to the current preset (can be undone).
  - View > Wipe: drag the yellow bar; original on the left, result on the right.
  - Tools menu: screen size & input, crop game area, find preset used, copy settings link.
    Whoever opens a settings link gets the same preset and values (copy it from the web address).
  - "System" at the top shows the detected system and resolution. Pick it yourself if it is wrong.
    Systems with their own preset (SNES, PS1, PS2, PSP) switch to it, unless you have already changed values.
  - If a window frame or margins were captured, use Crop game area and drag around the game picture.
    A rough drag is fine: the edges snap to the nearest border.
  - If the size does not match a known system, you are asked which system it is. For a big modern-game picture, pick a line count (240, 480, 540, 720) there too. For a partial capture,
    the missing area is filled with black to make the system's full screen.
  - Pick a preset in "Start from" and change values on the left. Changed values turn orange (↺ resets).
  - Zoom 1:1 = one RetroArch screen pixel per monitor pixel (like viewing a fullscreen screenshot at 100%).
    1:1 and above show the RGB stripes exactly; Windows display scaling (150% etc.) is corrected.
  - Actual screen: goes fullscreen, the same size as RetroArch fullscreen on your monitor. Esc to leave.
  - The bottom bar shows how the shader reads the picture: scanlines, average factor, triad pitch,
    and how many triads one game pixel covers.
  - Save .slangp asks where the file will go:
      - RetroArch's shaders folder (recommended): just drop the file there; every value is written into it
      - the shaders/shaders_slang folder: the same, one folder deeper
      - presets/4K or presets/Ally: points to the chosen preset, changed values only (must sit next to it)
    Then in RetroArch: Quick Menu > Shaders > Load, and Save Game Preset (or Core Preset) to keep it.
    The shaders folder is shown in Settings > Directory > Video Shaders.
    After Save Game Preset, don't delete or rename the file (the game preset points to it).
  - Load .slangp opens an existing game preset so you can keep tuning it.
  - Save image:
      - Whole result: the shader result at RetroArch's screen size
      - Comparison: the part you are looking at, original | result side by side, with preset and resolution labels
      - The view as shown: exactly what is on screen, wipe bar included, at 1:1
  - Vertical arcade games are detected automatically.
  - The top-right button switches between English and Korean.

Images from the web
  - Native-size PNGs and cleanly enlarged PNGs: read exactly (small images are drawn at 4K height)
  - JPEG-compressed enlargements: resolution is estimated (shown in the bottom bar)
  - Smoothly scaled images, or photos that already have a CRT look: a "no clean pixels" warning,
    240 lines assumed. A CRT photo gets the effect twice. Pick the system at the top.
  The best input is a screenshot taken in the emulator itself.

Modern games on a CRT (for fun)
  Open a high-resolution screenshot, then pick a line count under System > Modern games & photos:
  240 (old TV) / 480 (broadcast / PVM) / 540 (high-res CRT) / 720 (very sharp CRT).
  The picture is shrunk to that many lines and drawn with that many scanlines (Scanlines and average factor are set for you).

Checked against RetroArch (4K fullscreen captures, mean pixel difference on a 0-255 scale)
  - PS1 RayStorm + 4k-ps1                 : 0.12 (99% of pixels within 1 step)
  - MAME Raiden II (vertical) + 4k-ps1-slot : 0.11
  - PS1 Final Fantasy VII (ROG Ally 1080p, 368-wide screen) : 1.36, with the pitch (4) found by Find preset used

Rebuilding after a shader change (developers)
  python dev/build.py <real-crt-phosphor folder> crt-preview.html   (Python 3 only)

Terms: same as the Real CRT Phosphor shader (LICENSE.txt in the shader folder).
AI-assisted: code by Claude, planning and testing by gunkun.
