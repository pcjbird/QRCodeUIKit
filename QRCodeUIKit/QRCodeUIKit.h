//
//  QRCodeUIKit.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for QRCodeUIKit.
FOUNDATION_EXPORT double QRCodeUIKitVersionNumber;

//! Project version string for QRCodeUIKit.
FOUNDATION_EXPORT const unsigned char QRCodeUIKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <QRCodeUIKit/PublicHeader.h>

#if __has_include("QuickQRCodeScanController.h")
#import "QuickQRCodeScanController.h"
#endif

#if __has_include("QuickTextQRResultController.h")
#import "QuickTextQRResultController.h"
#endif
