//
//  UIViewController+QRCodeUIKit.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "UIViewController+QRCodeUIKit.h"
#import <objc/runtime.h>
#import "UINavigationController+QRCodeUIKit.h"

@implementation UIViewController (QRCodeUIKit)

static char *QRCodeUIKitNavBarBgAlphaKey = "QRCodeUIKitNavBarBgAlphaKey";

-(void)setQrcodeuikit_NavBarBgAlpha:(NSString *)qrcodeuikit_NavBarBgAlpha
{
    objc_setAssociatedObject(self, QRCodeUIKitNavBarBgAlphaKey, qrcodeuikit_NavBarBgAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.navigationController qrcodeuikit_SetNeedsNavigationBackground:[qrcodeuikit_NavBarBgAlpha floatValue]];
}

- (NSString *)qrcodeuikit_NavBarBgAlpha {
    return objc_getAssociatedObject(self, QRCodeUIKitNavBarBgAlphaKey) ? : @"1.0";
}

@end
