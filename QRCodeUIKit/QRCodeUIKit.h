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
