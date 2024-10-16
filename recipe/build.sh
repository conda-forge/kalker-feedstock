#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --features force-cross --root ${PREFIX} --path cli

# strip debug symbols
"$STRIP" "$PREFIX/bin/${PKG_NAME}"
