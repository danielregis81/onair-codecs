# OnAir Codecs - DMR e TETRA (PP5RD)

Codecs de voz para o receptor SDR **OnAir** (adswill/OnAir) no Windows 64-bit:

- **DMR / NXDN / dPMR** (AMBE+2) - `onair-codec-ambe2.dll`
- **TETRA** (ACELP) - `onair-codec-tetra.dll`

Ambos sao plugins finos construidos em torno do **mbelib-neo**
(https://github.com/arancormonk/mbelib-neo). O OnAir nao inclui esses
codecs (sao patenteados); voce os instala por conta propria.

## Instalacao rapida (Windows 64-bit)

1. Baixe/clone este repositorio.
2. Rode o instalador (baixa o OnAir e o Zadig das fontes oficiais e
   copia os codecs):

   ```powershell
   powershell -ExecutionPolicy Bypass -File instalar.ps1
   ```

3. Abra o OnAir, escolha o modo (DMR ou TETRA) e, na primeira chamada,
   aceite o aviso legal do codec.

Ou, manualmente: copie os 5 arquivos de `codecs/` para
`%LOCALAPPDATA%\OnAir\codecs\` e use "Look again" no OnAir.

## RTL-SDR

Para um dongle RTL-SDR, instale o driver WinUSB com o **Zadig**:
Options > List All Devices, selecione "Bulk-In, Interface (Interface 0)"
(USB ID `0BDA 2838`), driver **WinUSB** > Install.

## Conteudo

```
codecs/     os 5 .dll prontos (ambe2, tetra, libmbe-neo, 2 runtimes)
src/        codigo-fonte dos wrappers (onair_tetra_wrapper.c, mbelib_wrapper.c)
build.sh    compila tudo do zero (MSYS2 MINGW64)
instalar.ps1  instalador (baixa OnAir/Zadig, copia codecs)
```

## Compilar do zero

No shell **MSYS2 MINGW64**:

```bash
bash build.sh
```

Gera `codecs/onair-codec-ambe2.dll` e `codecs/onair-codec-tetra.dll`
(mais o `libmbe-neo.dll` e os runtimes do MinGW).

- TETRA: wrapper chama `mbe_tetraDecodeFrame` (137 bits -> 240 samples @ 8 kHz).
- DMR (AMBE+2): wrapper oficial de exemplo do OnAir com `-DCODEC_AMBE2`.
  (Para D-STAR use `-DCODEC_AMBE`; P25 `-DCODEC_IMBE`.)

## IMPORTANTE - audio so em chamadas claras

Chamadas criptografadas aparecem como "enc"/"encrypted" e **nunca** tem
audio: o OnAir nao entrega chamada cifrada ao codec e nada e
descriptografado. A maioria das redes TETRA de seguranca publica e
criptografada.

## Aviso legal / patentes

Os vocoders AMBE/AMBE+2/IMBE e o codec TETRA sao patenteados em varios
paises; a situacao de patentes do mbelib-neo nao foi resolvida. A
responsabilidade do uso e sua, conforme a lei do seu pais. Este repo
traz binarios que voce mesmo compila/instala; o OnAir nao os inclui nem
distribui.

## Referencias

- OnAir: https://github.com/adswill/OnAir  (docs/CODECS.md)
- mbelib-neo: https://github.com/arancormonk/mbelib-neo

PP5RD - contato@pp5rd.com.br
