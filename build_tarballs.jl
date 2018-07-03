# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

# Collection of sources required to build libpng
sources = [
    "http://www.imagemagick.org/download/delegates/libpng-1.6.31.tar.gz" =>
    "042e8701abc737a72f1393d0d8fca8ca86146460fe94c6c396261868f489c2de",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd $WORKSPACE/srcdir
cd libpng-1.6.31/
mkdir build
cd build/
cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain ..
make -j${ncore}
make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    #Linux(:armv7l, :glibc, :eabihf),
    #Linux(:powerpc64le, :glibc),
    #Linux(:i686, :musl),
    #Linux(:x86_64, :musl),
    #Linux(:aarch64, :musl),
   # Linux(:armv7l, :musl, :eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpng16", :libpng)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/bicycle1885/ZlibBuilder/releases/download/v1.0.0/build.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "libpng", sources, script, platforms, products, dependencies)

