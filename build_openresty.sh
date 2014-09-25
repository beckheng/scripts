#!bash

# build openresty under MacOS
# 1. brew install pcre
# 2. download openresty source
# 3. run this script

./configure \
	--with-cc-opt="-I/usr/local/include" \
	--with-ld-opt="-L/usr/local/lib" \
	--with-pcre-jit \
&& make \
&& make install
