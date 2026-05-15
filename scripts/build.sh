#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
IMAGE_NAME="schwung-midi-player-builder"

if [ -z "$CROSS_PREFIX" ] && [ ! -f "/.dockerenv" ]; then
    echo "=== Building MIDI Player Module (via Docker) ==="
    if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
        docker build -t "$IMAGE_NAME" -f "$SCRIPT_DIR/Dockerfile" "$REPO_ROOT"
    fi
    docker run --rm \
        -v "$REPO_ROOT:/build" \
        -u "$(id -u):$(id -g)" \
        -w /build \
        "$IMAGE_NAME" \
        ./scripts/build.sh
    exit 0
fi

CROSS_PREFIX="${CROSS_PREFIX:-aarch64-linux-gnu-}"

cd "$REPO_ROOT"
mkdir -p build dist/midi-player

${CROSS_PREFIX}gcc -O2 -shared -fPIC \
    -march=armv8-a -mtune=cortex-a72 \
    -fomit-frame-pointer -fno-stack-protector \
    -DNDEBUG \
    -Isrc/dsp \
    src/dsp/midi_player.c \
    -o build/midi-player.so

cp src/module.json dist/midi-player/module.json
cp build/midi-player.so dist/midi-player/midi-player.so
chmod +x dist/midi-player/midi-player.so

# Empty MIDI/ directory ships in the tarball so first-install via
# Module Store (which skips install.sh) still has somewhere to drop files.
mkdir -p dist/midi-player/MIDI
touch dist/midi-player/MIDI/.gitkeep

[ -f LICENSE ] && cp LICENSE dist/midi-player/LICENSE || true
[ -f README.md ] && cp README.md dist/midi-player/README.md || true

cd dist
tar -czvf midi-player-module.tar.gz midi-player/
echo "OK: dist/midi-player-module.tar.gz"
