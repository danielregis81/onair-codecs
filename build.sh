#!/bin/bash
# Compila os codecs (DMR AMBE+2 e TETRA) para o OnAir, no Windows com MSYS2.
# Rode no shell "MSYS2 MINGW64".
set -e

echo "== Dependencias (MSYS2 MINGW64) =="
pacman -S --needed --noconfirm git mingw-w64-x86_64-gcc mingw-w64-x86_64-cmake mingw-w64-x86_64-make

echo "== 1) mbelib-neo -> libmbe-neo.dll =="
[ -d mbelib-neo ] || git clone https://github.com/arancormonk/mbelib-neo
cd mbelib-neo
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON \
      -DMBELIB_BUILD_TESTS=OFF -DMBELIB_BUILD_EXAMPLES=OFF -DMBELIB_WARNINGS_AS_ERRORS=OFF
cmake --build build -j
cd ..

INC=mbelib-neo/include
LIB=mbelib-neo/build

echo "== 2) plugin TETRA -> onair-codec-tetra.dll =="
gcc -shared -O2 -DMBELIB_NEO src/onair_tetra_wrapper.c -I"$INC" -L"$LIB" -lmbe-neo -o codecs/onair-codec-tetra.dll

echo "== 3) plugin DMR (AMBE+2) -> onair-codec-ambe2.dll =="
gcc -shared -O2 -DCODEC_AMBE2 -DMBELIB_NEO src/mbelib_wrapper.c -I"$INC" -L"$LIB" -lmbe-neo -o codecs/onair-codec-ambe2.dll

echo "== 4) copiar lib + runtimes para codecs/ =="
cp "$LIB/libmbe-neo.dll" codecs/
cp /mingw64/bin/libgcc_s_seh-1.dll codecs/
cp /mingw64/bin/libwinpthread-1.dll codecs/

echo "== OK. Arquivos em codecs/ =="
ls -la codecs/
