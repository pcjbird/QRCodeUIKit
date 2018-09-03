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
 * @brief 授权标题
 * @return 标题文本
 */
-(NSString*_Nonnull) accessTitleText;

/*
 * @brief 授权描述
 * @return 描述文本
 */
-(NSString*_Nonnull) accessDescText;

/*
 * @brief 相机权限请求文本提示
 * @return 请求文本提示
 */
-(NSString*_Nonnull) requestCameraAuthText;

/*
 * @brief 相机权限受限文本提示
 * @return 受限文本提示
 */
-(NSString*_Nonnull) cameraAuthDeniedText;

/*
 * @brief 相机权限被允许文本提示
 * @return 被允许文本提示
 */
-(NSString*_Nonnull) cameraAuthAllowedText;

/*
 * @brief 相册权限请求文本提示
 * @return 请求文本提示
 */
-(NSString*_Nonnull) requestAlbumAuthText;

/*
 * @brief 相册权限受限文本提示
 * @return 受限文本提示
 */
-(NSString*_Nonnull) albumAuthDeniedText;

/*
 * @brief 相册权限被允许文本提示
 * @return 被允许文本提示
 */
-(NSString*_Nonnull) albumAuthAllowedText;

/*
 * @brief 扫描提示提示
 * @return 提示文本提示
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
-(void) OnMyQRBtnClick:(id _Nonnull )sender;

/*
 * @brief 是否支持"可以扫什么"按钮
 */
-(BOOL) supportQABtn;

/*
 * @brief "可以扫什么"按钮点击处理
 */
-(void) OnQABtnClick:(id _Nonnull )sender;

/*
 * @brief 当从相册识别二维码时是否应该打开相册的编辑属性, 默认YES
 */
-(BOOL) shouldQRCodeFromAlbumWithEdittedImage;

/*
 * @brief 当从相册识别二维码时是否支持条码识别, 默认NO
 */
-(BOOL) shouldQRCodeFromAlbumSupportBarCode;

@end
