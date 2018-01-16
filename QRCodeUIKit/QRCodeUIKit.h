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

#if __has_include("QuickTextQRResultController.h")
#import "QuickTextQRResultController.h"
#endif
