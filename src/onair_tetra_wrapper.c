/* OnAir speech codec plug-in (id "tetra") around mbelib-neo's TETRA ACELP decoder.
 *
 * Contains no codec: only calls mbelib-neo (libmbe-neo), which you build yourself.
 * OnAir hands one 30 ms TETRA speech frame per call of onair_speech_decode:
 *   137 bytes, one bit per byte (0/1), B(1)..B(137) in EN 300 395-2 clause 4.2.2.7
 *   order -- exactly what mbe_tetraDecodeFrame expects.
 * Output: 240 int16 PCM samples at 8000 Hz (MBE_TETRA_FRAME_SAMPLES).
 *
 * Build (MSYS2 / MinGW64):
 *   cc -shared -O2 -DMBELIB_NEO onair_tetra_wrapper.c -I<mbelib-neo/include> -L<build> -lmbe-neo -o onair-codec-tetra.dll
 */
#include <mbelib-neo/mbelib.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

#ifdef _WIN32
#include <windows.h>
#define API __declspec(dllexport)
#else
#define API __attribute__((visibility("default")))
#endif

/* OnAir plug-in ABI version this file targets. */
API int onair_speech_abi(void) { return 1; }

/* Confirm the library actually loaded is mbelib-neo (only it exports these). */
static int loadedIsNeo(void) {
#ifdef _WIN32
    HMODULE mods[] = { GetModuleHandleA("libmbe-neo.dll"), GetModuleHandleA("mbe-neo.dll"),
                       GetModuleHandleA("libmbe.dll"), GetModuleHandleA("mbelib.dll") };
    for (size_t i = 0; i < sizeof mods / sizeof mods[0]; i++)
        if (mods[i] && GetProcAddress(mods[i], "mbe_tetraDecoderAlloc")) return 1;
    return 0;
#else
    return 1; /* on ELF the dynamic linker resolves mbe_tetraDecoderAlloc at load time */
#endif
}

API void* onair_speech_open(void) {
    if (!loadedIsNeo()) return NULL;          /* wrong library: refuse instead of corrupting memory */
    return (void*)mbe_tetraDecoderAlloc();    /* decoder context, NULL on failure */
}

API void onair_speech_close(void* state) {
    mbe_tetraDecoderFree((mbe_tetra_decoder*)state);
}

API int onair_speech_sample_rate(void) { return 8000; }

/* One coded TETRA frame in (137 bytes, 1 bit/byte), PCM out. Returns sample count, -1 on error. */
API int onair_speech_decode(void* state, const uint8_t* coded, size_t nbytes,
                            int16_t* pcm, size_t max_samples) {
    mbe_tetra_decoder* dec = (mbe_tetra_decoder*)state;
    if (!dec || !pcm || max_samples < (size_t)MBE_TETRA_FRAME_SAMPLES) return -1;

    /* A frame shorter than 137 bits cannot be a good frame: conceal it as a bad frame. */
    int bad = (!coded || nbytes < (size_t)MBE_TETRA_FRAME_BITS) ? 1 : 0;

    int rc = mbe_tetraDecodeFrame(dec, bad ? NULL : coded, bad, pcm);
    if (rc != 0) {
        /* On a decode error, retry as a concealed (bad) frame so audio keeps flowing. */
        if (mbe_tetraDecodeFrame(dec, NULL, 1, pcm) != 0) return -1;
    }
    return MBE_TETRA_FRAME_SAMPLES;   /* 240 samples @ 8 kHz */
}
