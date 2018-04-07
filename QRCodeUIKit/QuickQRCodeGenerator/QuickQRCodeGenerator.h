//
//  QuickQRCodeGenerator.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/4/7.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    QuickQRCodeGeneratorType_QRCode = 0,
    QuickQRCodeGeneratorType_AztecCode = 1,
    QuickQRCodeGeneratorType_PDF417Barcode = 2,
}QuickQRCodeGeneratorType;

@interface QuickQRCodeGenerator : NSObject

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;
+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height logo:(UIImage*)logo;
+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height logo:(UIImage*)logo logoSize:(CGSize)logoSize;

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height type:(QuickQRCodeGeneratorType)codeType;
+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height logo:(UIImage*)logo type:(QuickQRCodeGeneratorType)codeType;
+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height logo:(UIImage*)logo logoSize:(CGSize)logoSize type:(QuickQRCodeGeneratorType)codeType;
@end
