*[Leia em Português](README.pt-BR.md)*

# OnAir Codecs - DMR and TETRA

Voice codecs for the **OnAir** SDR receiver (adswill/OnAir) on Windows 64-bit:

- **DMR / NXDN / dPMR** (AMBE+2) - `onair-codec-ambe2.dll`
- **TETRA** (ACELP) - `onair-codec-tetra.dll`

Both are thin plugins built around **mbelib-neo**
(https://github.com/arancormonk/mbelib-neo). OnAir doesn't include these
codecs (they're patented); you install them yourself.

## One-command install (fresh machine, no prior download needed)

Open **PowerShell** and paste (downloads OnAir + Zadig + codecs automatically):

```powershell
iwr -useb https://raw.githubusercontent.com/danielregis81/onair-codecs/main/instalar-online.ps1 | iex
```

## Quick install (Windows 64-bit)

1. Download/clone this repository (or download the ZIP via Code > Download ZIP).
2. **Double-click `INSTALAR.bat`** and accept the administrator prompt (UAC).
   The .bat runs PowerShell with bypass, so you won't hit the "unsigned script" block.

   Command-line alternative (if you prefer):
   ```powershell
   powershell -ExecutionPolicy Bypass -File instalar.ps1
   ```
   If Windows still complains the file was downloaded, run first:
   ```powershell
   Unblock-File instalar.ps1
   ```

3. Open OnAir, choose the mode (DMR or TETRA) and, on the first call,
   accept the codec legal notice.

Or, manually: copy the 5 files from `codecs/` to
`%LOCALAPPDATA%\OnAir\codecs\` and use "Look again" in OnAir.

## RTL-SDR

For an RTL-SDR dongle, install the WinUSB driver with **Zadig**:
Options > List All Devices, select "Bulk-In, Interface (Interface 0)"
(USB ID `0BDA 2838`), driver **WinUSB** > Install.

## Contents

```
codecs/     the 5 ready-to-use .dll files (ambe2, tetra, libmbe-neo, 2 runtimes)
src/        wrapper source code (onair_tetra_wrapper.c, mbelib_wrapper.c)
build.sh    builds everything from scratch (MSYS2 MINGW64)
instalar.ps1  installer (downloads OnAir/Zadig, copies codecs)
```

## Building from source

In the **MSYS2 MINGW64** shell:

```bash
bash build.sh
```

Generates `codecs/onair-codec-ambe2.dll` and `codecs/onair-codec-tetra.dll`
(plus `libmbe-neo.dll` and MinGW runtimes).

- TETRA: wrapper calls `mbe_tetraDecodeFrame` (137 bits -> 240 samples @ 8 kHz).
- DMR (AMBE+2): official OnAir example wrapper with `-DCODEC_AMBE2`.
  (For D-STAR use `-DCODEC_AMBE`; P25 `-DCODEC_IMBE`.)

## IMPORTANT - audio only on clear calls

Encrypted calls show as "enc"/"encrypted" and **never** have audio:
OnAir doesn't pass encrypted calls to the codec and nothing is decrypted.
Most public safety TETRA networks are encrypted.

## Legal notice / patents

AMBE/AMBE+2/IMBE vocoders and the TETRA codec are patented in several
countries; mbelib-neo's patent situation is unresolved. Use is your
responsibility, according to your country's laws. This repo provides
binaries that you compile/install yourself; OnAir doesn't include or
distribute them.

## References

- OnAir: https://github.com/adswill/OnAir (docs/CODECS.md)
- mbelib-neo: https://github.com/arancormonk/mbelib-neo

PP5RD - contato@pp5rd.com.br
