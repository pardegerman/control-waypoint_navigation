WORKDIR=$(mktemp -d)/_deps
mkdir -p $WORKDIR && cd $WORKDIR
trap "{ rm -rf $WORKDIR; }" EXIT

sudo apt update
sudo apt install -y pkg-config libeigen3-dev
gem install --user-install rice

REPO=https://github.com/SINTEF-Geometry/SISL.git
SRCDIR=$WORKDIR/SISL
BLDDIR=$WORKDIR/_build/SISL
git clone https://github.com/SINTEF-Geometry/SISL.git
mkdir -p $BLDDIR && cd $BLDDIR
sed -i '/^#.*fPIC/s/^#//' $SRCDIR/CMakeLists.txt
cmake $SRCDIR
make && sudo make install

install_rockcomponent() {
    ROCKCOMPONENT=$1
    REPO=https://github.com/rock-core/$ROCKCOMPONENT.git
    SRCDIR=$WORKDIR/$ROCKCOMPONENT
    BLDDIR=$WORKDIR/_build/$ROCKCOMPONENT

    git clone $REPO $SRCDIR
    mkdir -p $BLDDIR && cd $BLDDIR
    cmake $SRCDIR
    make && sudo make install
}

install_rockcomponent base-cmake
install_rockcomponent base-logging
install_rockcomponent base-types