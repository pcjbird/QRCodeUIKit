//
//  QuickBarCodeGenerator.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/4/7.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    QuickBarCodeGeneratorType_Code128 = 0,
}QuickBarCodeGeneratorType;

@interface QuickBarCodeGenerator : NSObject

+(UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height type:(QuickBarCodeGeneratorType)codeType;

+ (NSString *)formatCode:(NSString *)code;

+ (NSString *)formatCode:(NSString *)code type:(QuickBarCodeGeneratorType)codeType;
@end
