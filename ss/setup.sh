echo Usage
echo "curl -0 https://raw.githubusercontent.com/wanjochan/misctools/master/ss/setup.sh | sh"
# https://github.com/shadowsocks/go-shadowsocks2/releases
## wget https://github.com/shadowsocks/go-shadowsocks2/releases/download/v0.0.11/shadowsocks2-linux.gz -O shadowsocks2-linux.gz
wget https://github.com/shadowsocks/go-shadowsocks2/releases/download/v0.1.2/shadowsocks2-linux.gz -O shadowsocks2-linux.gz
gunzip shadowsocks2-linux.gz
chmod +x shadowsocks2-linux
./shadowsocks2-linux --help
