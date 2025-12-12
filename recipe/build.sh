#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

export CARGO_PROFILE_RELEASE_STRIP=symbols
export CARGO_PROFILE_RELEASE_LTO=fat
export CARGO_FEATURE_USE_SYSTEM_LIBS=1
export CARGO_FEATURE_FORCE_CROSS=1

# Shim hack to force gmp-mpfr-sys crate to use CFLAGS and LDFLAGS
if [[ ${target_platform} == "osx-arm64" ]]; then
tee ${BUILD_PREFIX}/bin/cc_shim << EOF
#!/bin/sh
if [[ "\$@" =~ system_* ]]; then
    exec \${CC_FOR_BUILD} \${CFLAGS//\${PREFIX}/\${BUILD_PREFIX}} \${LDFLAGS//\${PREFIX}/\${BUILD_PREFIX}} "\$@"
else
    exec \${CC} \${CFLAGS} \${LDFLAGS} "\$@"
fi
EOF
else
tee ${BUILD_PREFIX}/bin/cc_shim << EOF
#!/bin/sh
exec ${CC} ${CFLAGS} ${LDFLAGS} "\$@"
EOF
fi
chmod +x ${BUILD_PREFIX}/bin/cc_shim
export CC=${BUILD_PREFIX}/bin/cc_shim

export RUSTFLAGS="-L${PREFIX}/lib"

# check licenses
cargo-bundle-licenses \
    --format yaml \
    --output THIRDPARTY.yml

# build statically linked binary with Rust
cargo install --bins --no-track --locked --root ${PREFIX} --path cli
