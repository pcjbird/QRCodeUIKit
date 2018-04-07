//
//  QuickBarCodeGenerator.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/4/7.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickBarCodeGenerator.h"

#define kCICode128BarcodeGenerator @"CICode128BarcodeGenerator"

@implementation QuickBarCodeGenerator

+(UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height
{
    return [[self class] generateQRCode:code width:width height:height type:QuickBarCodeGeneratorType_Code128];
}

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height type:(QuickBarCodeGeneratorType)codeType
{
    // 生成条码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:[[self class] generatorWithType:codeType]];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

+ (NSString *)formatCode:(NSString *)code
{
    return [[self class] formatCode:code type:QuickBarCodeGeneratorType_Code128];
}

+ (NSString *)formatCode:(NSString *)code type:(QuickBarCodeGeneratorType)codeType
{
    if(codeType == QuickBarCodeGeneratorType_Code128)
    {
        NSMutableArray *chars = [[NSMutableArray alloc] init];
        
        for (int i = 0, j = 0 ; i < [code length]; i++, j++) {
            [chars addObject:[NSNumber numberWithChar:[code characterAtIndex:i]]];
            if (j == 3) {
                j = -1;
                [chars addObject:[NSNumber numberWithChar:' ']];
                [chars addObject:[NSNumber numberWithChar:' ']];
            }
        }
        
        int length = (int)[chars count];
        char str[length];
        for (int i = 0; i < length; i++) {
            str[i] = [chars[i] charValue];
        }
        
        NSString *temp = [NSString stringWithUTF8String:str];
        return temp;
    }
    return code;
}

#pragma mark - Private Methods
+(NSString*)generatorWithType:(QuickBarCodeGeneratorType)codeType
{
    NSString *generator = kCICode128BarcodeGenerator;
    switch (codeType) {
        default:
            break;
    }
    return generator;
}
@end
