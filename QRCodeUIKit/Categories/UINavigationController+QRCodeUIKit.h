//
//  UINavigationController+QRCodeUIKit.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (QRCodeUIKit)<UINavigationBarDelegate, UINavigationControllerDelegate>

- (void)qrcodeuikit_SetNeedsNavigationBackground:(CGFloat)alpha;

@end
