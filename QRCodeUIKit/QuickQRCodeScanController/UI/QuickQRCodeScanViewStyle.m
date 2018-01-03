//
//  QuickQRCodeScanViewStyle.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/3.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickQRCodeScanViewStyle.h"

#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickQRCodeScanViewStyle class]] pathForResource:@"QRCodeUIKit" ofType:@"bundle"]]

@implementation QuickQRCodeScanViewStyle

- (id)init
{
    if (self =  [super init])
    {
        _drawScanAreaRect = NO;
        
        _whRatio = 1.0;
        
        _colorScanAreaRectLine = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
        
        _centerUpOffset = 44;
        _scanAreaMarginX = 60;
        
        _animationStyle = QuickQRCodeScanViewAnimationStyle_LineMove;
        _scanAreaCornerStyle = QuickQRCodeScanAreaCornerStyle_Outer;
        _colorScanAreaCorner = [UIColor whiteColor];
        
        _notRecoginitonArea = [UIColor colorWithRed:0. green:.0 blue:.0 alpha:.0];
        
        
        _scanAreaCornerW = 12;
        _scanAreaCornerH = 12;
        _scanAreaCornerLineW = 3;
        
        _defaultScanLine = [[UIImage imageNamed:@"qrcode_scan_line" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _defaultScanGrid = [[UIImage imageNamed:@"qrcode_scan_grid" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _animationImage = _defaultScanLine;
        
        
    }
    
    return self;
}

@end
