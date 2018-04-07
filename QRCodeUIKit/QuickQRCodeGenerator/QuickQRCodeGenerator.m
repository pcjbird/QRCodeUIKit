//
//  QuickQRCodeGenerator.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/4/7.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickQRCodeGenerator.h"

#define kCIAztecCodeGenerator @"CIAztecCodeGenerator"
#define kCIQRCodeGenerator @"CIQRCodeGenerator"
#define kCIPDF417BarcodeGenerator @"CIPDF417BarcodeGenerator"

@implementation QuickQRCodeGenerator

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height
{
    return [[self class] generateQRCode:code width:width height:height logo:nil];
}

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height logo:(UIImage*)logo
{
    return [[self class] generateQRCode:code width:width height:height logo:logo type:QuickQRCodeGeneratorType_QRCode];
}

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height logo:(UIImage*)logo logoSize:(CGSize)logoSize
{
    return [[self class] generateQRCode:code width:width height:height logo:logo logoSize:logoSize type:QuickQRCodeGeneratorType_QRCode];
}

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height type:(QuickQRCodeGeneratorType)codeType
{
    return [[self class] generateQRCode:code width:width height:height logo:nil type:codeType];
}

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height logo:(UIImage*)logo type:(QuickQRCodeGeneratorType)codeType
{
   return [[self class] generateQRCode:code width:width height:height logo:logo logoSize:CGSizeZero type:QuickQRCodeGeneratorType_QRCode];
}

+(UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height logo:(UIImage*)logo logoSize:(CGSize)logoSize type:(QuickQRCodeGeneratorType)codeType
{
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:[[self class] generatorWithType:codeType]];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width;
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    UIImage *qrcode = [UIImage imageWithCIImage:transformedImage];
    if([logo isKindOfClass:[UIImage class]] && codeType == QuickQRCodeGeneratorType_QRCode)
    {
        if(CGSizeEqualToSize(logoSize, CGSizeZero))
        {
            qrcode = [[self class] addIconToQRCodeImage:qrcode withIcon:logo];
        }
        else
        {
            qrcode = [[self class] addIconToQRCodeImage:qrcode withIcon:logo withIconSize:logoSize];
        }
    }
    return qrcode;
}

#pragma mark - Private Methods
+(NSString*)generatorWithType:(QuickQRCodeGeneratorType)codeType
{
    NSString *generator = kCIQRCodeGenerator;
    switch (codeType) {
        case QuickQRCodeGeneratorType_AztecCode:
        {
            generator = kCIAztecCodeGenerator;
        }
            break;
        case QuickQRCodeGeneratorType_PDF417Barcode:
        {
            generator = kCIPDF417BarcodeGenerator;
        }
            break;
        default:
            break;
    }
    return generator;
}

+(UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize
{
    UIGraphicsBeginImageContext(image.size);
    //通过两张图片进行位置和大小的绘制，实现两张图片的合并；其实此原理做法也可以用于多张图片的合并
    CGFloat widthOfImage = image.size.width;
    CGFloat heightOfImage = image.size.height;
    CGFloat widthOfIcon = iconSize.width;
    CGFloat heightOfIcon = iconSize.height;
    
    [image drawInRect:CGRectMake(0, 0, widthOfImage, heightOfImage)];
    [icon drawInRect:CGRectMake((widthOfImage-widthOfIcon)/2, (heightOfImage-heightOfIcon)/2,
                                widthOfIcon, heightOfIcon)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

+(UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon
{
    UIGraphicsBeginImageContext(image.size);
    
    //通过两张图片进行位置和大小的绘制，实现两张图片的合并；其实此原理做法也可以用于多张图片的合并
    CGFloat widthOfImage = image.size.width;
    CGFloat heightOfImage = image.size.height;
    CGFloat widthOfIcon = widthOfImage/image.scale;
    CGFloat heightOfIcon = heightOfImage/image.scale;
    
    [image drawInRect:CGRectMake(0, 0, widthOfImage, heightOfImage)];
    [icon drawInRect:CGRectMake((widthOfImage-widthOfIcon)/2, (heightOfImage-heightOfIcon)/2,
                                widthOfIcon, heightOfIcon)];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}

@end
