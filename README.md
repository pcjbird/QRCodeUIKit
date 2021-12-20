![logo](logo.png)
[![Build Status](http://img.shields.io/travis/pcjbird/QRCodeUIKit/master.svg?style=flat)](https://travis-ci.org/pcjbird/QRCodeUIKit)
[![Pod Version](http://img.shields.io/cocoapods/v/QRCodeUIKit.svg?style=flat)](http://cocoadocs.org/docsets/QRCodeUIKit/)
[![Pod Platform](http://img.shields.io/cocoapods/p/QRCodeUIKit.svg?style=flat)](http://cocoadocs.org/docsets/QRCodeUIKit/)
[![Pod License](http://img.shields.io/cocoapods/l/QRCodeUIKit.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)
[![GitHub release](https://img.shields.io/github/release/pcjbird/QRCodeUIKit.svg)](https://github.com/pcjbird/QRCodeUIKit/releases)
[![GitHub release](https://img.shields.io/github/release-date/pcjbird/QRCodeUIKit.svg)](https://github.com/pcjbird/QRCodeUIKit/releases)
[![Website](https://img.shields.io/website-pcjbird-down-green-red/https/shields.io.svg?label=author)](https://pcjbird.github.io)

# QRCodeUIKit
一款让扫码变得简单的视图控制器。
    
    
## 演示 / Demo

<p align="center"><img src="demo.gif" title="demo"></p>
    
    
##  安装 / Installation

方法一：`QRCodeUIKit` is available through CocoaPods. To install it, simply add the following line to your Podfile:

```
pod 'QRCodeUIKit'
```
    
    
## 使用 / Usage   
```
#import <QRCodeUIKit/QRCodeUIKit.h>
     
- (IBAction)OnQRCodeScan:(id)sender {
     QuickQRCodeScanController *scanVC = [QuickQRCodeScanController new];
     [self.navigationController pushViewController:scanVC animated:YES];
}
     
- (IBAction)OnBarCodeScan:(id)sender {
     QuickBarCodeScanController *scanVC = [QuickBarCodeScanController new];
     [self.navigationController pushViewController:scanVC animated:YES];
}
     
- (IBAction)OnGenQRCode:(id)sender {
     UIImage* logo = [[UIImage imageNamed:@"AppIcon60x60"] yy_imageByRoundCornerRadius:8.0f];
     self.qrcode.image = [QuickQRCodeGenerator generateQRCode:@"我是一个二维码" width:CGRectGetWidth(self.qrcode.frame) height:CGRectGetHeight(self.qrcode.frame) logo:logo logoSize:CGSizeMake(60, 60)];
     self.qrcodeback.hidden = NO;
}
     
- (IBAction)OnGenBarCode:(id)sender {
     NSString* code = @"8986011684013010860";
     self.barcodeLabel.text = [QuickBarCodeGenerator formatCode:code];
     self.barcode.image = [QuickBarCodeGenerator generateBarCode:code width:CGRectGetWidth(self.barcode.frame) height:CGRectGetHeight(self.barcode.frame)];
}
```
    
    
## 关注我们 / Follow us
  
<a href="https://itunes.apple.com/cn/app/iclock-一款满足-挑剔-的翻页时钟与任务闹钟/id1128196970?pt=117947806&ct=com.github.pcjbird.QRCodeUIKit&mt=8"><img src="https://github.com/pcjbird/AssetsExtractor/raw/master/iClock.gif" width="400" title="iClock - 一款满足“挑剔”的翻页时钟与任务闹钟"></a>

[![Twitter URL](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=https://github.com/pcjbird/QRCodeUIKit)
[![Twitter Follow](https://img.shields.io/twitter/follow/pcjbird.svg?style=social)](https://twitter.com/pcjbird)
