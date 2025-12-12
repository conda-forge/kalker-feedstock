#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
sed -i 's/\[dependencies\]/[dependencies]\ngmp-mpfr-sys = { version = "*", features = ["mpfr", "force-cross"], optional = true }/' kalk/Cargo.toml

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path cli
