//
//  QuickQRCodeScanController.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickQRCodeScanViewStyle.h"
#import "QuickQRCodeScanResultHandler.h"

@interface QuickQRCodeScanController : UIViewController

/*
 * @brief 样式
 */
@property (nonatomic, strong, readonly, nonnull) QuickQRCodeScanViewStyle *style;

/*
 * @brief 扫描结果处理者
 */
@property (nonatomic, strong, nullable) id<QuickQRCodeScanResultHandler> resultHandler;

/*
 * @brief 扫描提示
 */
-(NSString *_Nonnull) scanTipText;

/*
 * @brief 我的二维码，为nil或空字符串时将不显示该按钮
 */
-(NSString *_Nullable) myQRText;

/*
 * @brief "我的二维码"按钮点击处理
 */
-(void)OnMyQRBtnClick:(id _Nonnull )sender;

/*
 * @brief 是否支持"可以扫什么"按钮
 */
-(BOOL) supportQABtn;

/*
 * @brief "可以扫什么"按钮点击处理
 */
-(void)OnQABtnClick:(id _Nonnull )sender;

@end
