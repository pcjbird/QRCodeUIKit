//
//  QuickQRCodeScanView.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/3.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickQRCodeScanViewStyle.h"

@interface QuickQRCodeScanView : UIView

@property (nonatomic, readonly)CGRect scanAreaRect;

/**
@brief  初始化
@param frame 位置大小
@param style 样式

@return instancetype
*/
-(id)initWithFrame:(CGRect)frame style:(QuickQRCodeScanViewStyle*)style;


/**
 *  开始扫描动画
 */
- (void)startScanAnimation;

/**
 *  结束扫描动画
 */
- (void)stopScanAnimation;


/**
 @brief  根据矩形区域，获取Native扫码识别兴趣区域
 @param view  视频流显示UIView
 @param style 效果界面参数
 @return 识别区域
 */
+ (CGRect)getScanRectWithPreview:(UIView*)view style:(QuickQRCodeScanViewStyle*)style;


/**
 根据矩形区域，获取ZXing库扫码识别兴趣区域
 
 @param view 视频流显示视图
 @param style 效果界面参数
 @return 识别区域
 */
+ (CGRect)getZXingScanRectWithPreview:(UIView*)view style:(QuickQRCodeScanViewStyle*)style;

@end
