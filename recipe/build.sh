#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
echo "[dependencies.gmp-mpfr-sys]" >> cli/Cargo.toml
echo 'version = "1.6"' >> cli/Cargo.toml
echo 'default-features = false' >> cli/Cargo.toml
echo 'features = ["mpfr", "force-cross-"]' >> cli/Cargo.toml

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path cli
