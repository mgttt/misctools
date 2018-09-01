# wget

@brew binary.for.macos
```
brew install wget
wget -v
```

@compile from src  (not working on mac, because some compile lib still missing... will patch later)
```
wget -O - http://ftp.gnu.org/gnu/wget/wget-1.17.tar.xz | tar xzvf -
cd wget*
./configure
make
make install
```
