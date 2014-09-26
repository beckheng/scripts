#!bash

# build XHProf
# 1. download XHProf source from http://pecl.php.net/package/xhprof
# 2. uncompress file
# 3. goto extension directory
# 4. run this script
# 5. append setting to php.ini

phpize
./configure \
	--enable-xhprof \
	--with-php-config=php-config
make && make install
