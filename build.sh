set -ex

git clone https://git.fuwafuwa.moe/premiere/premiere-libtorrent.git --depth=1
git clone https://git.fuwafuwa.moe/premiere/premiere-deluge-plugin.git --depth=1
git clone https://github.com/deluge-torrent/deluge.git --depth=1
git clone https://github.com/boostorg/boost.git --depth=1 --branch=boost-1.72.0

apt update
apt install build-essential libssl-dev -y

cd boost || exit
export BOOST_ROOT=$PWD
git submodule update --init --depth=1
./bootstrap.sh
./b2 cxxstd=11 release install --with-python --with-system
cd tools/build || exit
./bootstrap.sh
./b2 install --prefix=/usr/
ln -s /usr/local/lib/libboost_python38.so /usr/local/lib/libboost_python.so # Modified Python version
export PATH=$BOOST_ROOT:$PATH
cd - || exit
cd - || exit

cd premiere-libtorrent || exit
git submodule update --init --recursive --depth=1
b2 toolset=gcc link=shared variant=release target-os=linux address-model=64 crypto=openssl
cp bin/gcc-*/release/address-model-64/crypto-openssl/threading-multi/libtorrent.so* /usr/local/lib
ldconfig
cd bindings/python/ || exit
b2 toolset=gcc link=shared variant=release target-os=linux address-model=64 libtorrent-link=shared
cp bin/gcc*/release/address-model-64/lt-visibility-hidden/python-3.10/libtorrent.so /usr/local/lib/python3.10/site-packages # Modified Python version
cd - || exit
cd - || exit

cd deluge || exit
git tag -d deluge-2.0.0
git tag deluge-2.0.0
pip3 install . # Modified pip command
cd - || exit

deluged
sleep 3
pkill -f deluged

cd premiere-deluge-plugin || exit
python3 setup.py bdist_egg # Modified Python version
cp dist/*.egg ~/.config/deluge/plugins
cd - || exit
