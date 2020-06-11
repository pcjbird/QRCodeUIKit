//
//  QRCodeUIKit.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//
//  框架名称:QRCodeUIKit
//  框架功能:一款让扫码变得简单的视图控制器。
//  修改记录:
//     pcjbird    2020-06-11  Version:1.2.1 Build:202006110001
//                            1.新增日语翻译。
//                            2.修正导航过渡可能产生的一些问题。
//
//     pcjbird    2019-10-23  Version:1.2.0 Build:201910230001
//                            1.修正iOS13扫不出码的问题。
//
//     pcjbird    2018-12-03  Version:1.1.9 Build:201812030002
//                            1.CocoaPods 本地化文件未能正确包含的问题修复。
//
//     pcjbird    2018-12-03  Version:1.1.8 Build:201812030001
//                            1.进一步适配iPhone XR/iPhone XS Max。
//
//     pcjbird    2018-09-18  Version:1.1.7 Build:201809180001
//                            1.修复在 iPhone XS Max 上 Crash 的问题。
//
//     pcjbird    2018-09-03  Version:1.1.6 Build:201809030004
//                            1.优化应用由后台转前台时刷新的问题。
//
//     pcjbird    2018-09-03  Version:1.1.5 Build:201809030003
//                            1.修复了"前往设置"按钮显示/隐藏的BUG
//
//     pcjbird    2018-09-03  Version:1.1.4 Build:201809030002
//                            1.修复了隐私权限UI显示的一些BUG
//
//     pcjbird    2018-09-03  Version:1.1.3 Build:201809030001
//                            1.新增隐私权限申请UI
//
//     pcjbird    2018-04-08  Version:1.1.2 Build:201804080004
//                            1.修复二维码生成的BUG
//                            2.新增演示demo
//
//     pcjbird    2018-04-08  Version:1.1.1 Build:201804080003
//                            1.修复无法从相册识别的问题
//
//     pcjbird    2018-04-08  Version:1.1.0 Build:201804080002
//                            1.新增二维码和条码识别工具类
//                            2.重新使用 ZXingObjC 从相册识别条码（非扫描）
//
//     pcjbird    2018-04-08  Version:1.0.9 Build:201804080001
//                            1.新增二维码和条码生成工具类
//
//     pcjbird    2018-04-07  Version:1.0.8 Build:201804070001
//                            1.弃用 ZXingObjC 第三方框架，由于该框架扫码时 CPU 占用 100%，导致手机发烫耗电，官方尚未修复该问题
//
//     pcjbird    2018-03-12  Version:1.0.7 Build:201803120001
//                            1.修复bundle plist "Unexpected CFBundleExecutable Key"的问题
//
//     pcjbird    2018-02-04  Version:1.0.6 Build:201802040001
//                            1.支持放弃扫描结果并继续扫描
//                            2.支持自定义未识别的扫描结果提示文本
//                            3.新增单独条码扫描(QuickBarCodeScanController)支持
//
//     pcjbird    2018-01-16  Version:1.0.5 Build:201801160001
//                            1.修改toast样式为共享样式
//
//     pcjbird    2018-01-05  Version:1.0.4 Build:201801050002
//                            1.修复iOS 9 Crash的问题
//
//     pcjbird    2018-01-05  Version:1.0.3 Build:201801050001
//                            1.修复当UINavigationBar的translucent为No时的显示问题。
//
//     pcjbird    2018-01-04  Version:1.0.2 Build:201801040002
//                            1.bug修复
//
//     pcjbird    2018-01-04  Version:1.0.1 Build:201801040001
//                            1.调整目录
//
//     pcjbird    2018-01-02  Version:1.0.0 Build:201801020001
//                            1.首次发布SDK版本

#import <UIKit/UIKit.h>

//! Project version number for QRCodeUIKit.
FOUNDATION_EXPORT double QRCodeUIKitVersionNumber;

//! Project version string for QRCodeUIKit.
FOUNDATION_EXPORT const unsigned char QRCodeUIKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <QRCodeUIKit/PublicHeader.h>

#if __has_include("QuickQRCodeScanController.h")
#import "QuickQRCodeScanController.h"
#endif

#if __has_include("QuickQRCodeScanViewStyle.h")
#import "QuickQRCodeScanViewStyle.h"
#endif

#if __has_include("QuickQRCodeScanResultHandler.h")
#import "QuickQRCodeScanResultHandler.h"
#endif

#if __has_include("QuickBarCodeScanController.h")
#import "QuickBarCodeScanController.h"
#endif

#if __has_include("QuickTextQRResultController.h")
#import "QuickTextQRResultController.h"
#endif

#if __has_include("QuickQRCodeGenerator.h")
#import "QuickQRCodeGenerator.h"
#endif

#if __has_include("QuickBarCodeGenerator.h")
#import "QuickBarCodeGenerator.h"
#endif

#if __has_include("QuickQRCodeDetector.h")
#import "QuickQRCodeDetector.h"
#endif
