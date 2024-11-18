#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

echo '[dependencies.gmp-mpfr-sys]' >> kalk/Cargo.toml
echo 'version = "*"' >> kalk/Cargo.toml
echo 'features = ["use-system-libs", "force-cross"]' >> kalk/Cargo.tml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path cli

# strip debug symbols
"$STRIP" "$PREFIX/bin/${PKG_NAME}"
