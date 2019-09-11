iphone 连接osx（特别是旧款macbook pro）闪断（影响xcode开发）的几种可行方案

```
* 两个口都接上 iphone 【亲测有效，猜测是因为电压自均衡让iphone稳定了情绪】
* sudo killall -STOP -c usbd 【亲测也有效，猜是因为这个 服务比较降电压】
*　电话开启低电量模式【未测，但好像这样手机不太好用，要不算了】
```
