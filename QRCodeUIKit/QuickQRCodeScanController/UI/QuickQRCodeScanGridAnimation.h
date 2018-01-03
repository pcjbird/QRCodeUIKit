//
//  QuickQRCodeScanGridAnimation.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/3.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickQRCodeScanGridAnimation : UIView

/**
 *  开始扫码网格效果
 *
 *  @param animationRect 显示在parentView中得区域
 *  @param parentView    动画显示在UIView
 *  @param image     扫码线的图像
 */
- (void)startAnimatingWithRect:(CGRect)animationRect inView:(UIView*)parentView image:(UIImage*)image;

/**
 *  停止动画
 */
- (void)stopAnimating;

@end
