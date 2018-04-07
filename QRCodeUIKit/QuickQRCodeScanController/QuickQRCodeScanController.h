//
//  QuickQRCodeScanController.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
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
 * @return 提示文本
 */
-(NSString *_Nonnull) scanTipText;

/*
 * @brief 无法识别提示
 * @return 提示文本
 */
-(NSString *_Nonnull) unknownCodeTipText;

/*
 * @brief 是否应该放弃并继续扫描
 * @param format 格式
 * @param detectedText 探测到的文本
 * @return 是否应该放弃并继续扫描
 */
-(BOOL) shouldGiveUpAndContinueWithFormat:(AVMetadataObjectType)format detectedText:(NSString *_Nullable)detectedText;

/*
 * @brief 支持的扫码支持的编码格式
 * @return 扫码支持的编码格式数组
 */
-(NSArray<AVMetadataObjectType> *) supportedAVMetadataObjectTypes;

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

/*
 * @brief 当从相册识别二维码时是否应该打开相册的编辑属性
 */
-(BOOL)shouldQRCodeFromAlbumWithEdittedImage;

@end
