//
//  QuickQRCodeDetector.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/4/8.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickQRCodeDetector.h"
#import <CoreImage/CoreImage.h>
#import <ZXingObjC/ZXingObjC.h>

@implementation QuickQRCodeDetector

+(NSString*)detectQRCodeWithImage:(UIImage*)image
{
    return [[self class] detectQRCodeOrBarCodeWithImage:image supportBarCode:NO];
}

+(NSString*)detectBarCodeWithImage:(UIImage*)image
{
    CGImageRef imageToDecode = image.CGImage;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap hints:hints error:nil];
    if ([result isKindOfClass:[ZXResult class]])
    {
        if(![[self class] isBarCode:result.barcodeFormat]) return @"";
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
        NSString *formatString = [[self class] toAVMetadataObjectTypeWithZXing:format];
        NSString *display = [NSString stringWithFormat:@"已扫描到对象!\n\n格式: %@\n\n内容:\n%@", formatString, contents];
        NSLog(@"%@",display);
        return contents;
    }
    else
    {
        return @"";
    }
}

+(NSString*)detectQRCodeOrBarCodeWithImage:(UIImage*)image
{
    return [[self class] detectQRCodeOrBarCodeWithImage:image supportBarCode:YES];
}

+(NSString*)detectQRCodeOrBarCodeWithImage:(UIImage*)image supportBarCode:(BOOL)supportBarCode
{
    if(![image isKindOfClass:[UIImage class]])
    {
        return @"";
    }
    
    if(!supportBarCode)
    {
        //初始化一个监测器
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        
        if(features.count >=1 )
        {
            /**结果对象 */
            CIQRCodeFeature *feature = [features firstObject];
            NSString *formatString = CIDetectorTypeQRCode;
            NSString *display = [NSString stringWithFormat:@"已扫描到对象!\n\n格式: %@\n\n内容:\n%@", formatString, feature.messageString];
            NSLog(@"%@",display);
            return feature.messageString;
        }
        else
        {
            return @"";
        }
    }
    else
    {
        CGImageRef imageToDecode = image.CGImage;  // Given a CGImage in which we are looking for barcodes
        
        ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
        ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
        
        // There are a number of hints we can give to the reader, including
        // possible formats, allowed lengths, and the string encoding.
        ZXDecodeHints *hints = [ZXDecodeHints hints];
        
        ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
        ZXResult *result = [reader decode:bitmap hints:hints error:nil];
        if ([result isKindOfClass:[ZXResult class]])
        {
            // The coded result as a string. The raw data can be accessed with
            // result.rawBytes and result.length.
            NSString *contents = result.text;
            
            // The barcode format, such as a QR code or UPC-A
            ZXBarcodeFormat format = result.barcodeFormat;
            NSString *formatString = [[self class] toAVMetadataObjectTypeWithZXing:format];
            NSString *display = [NSString stringWithFormat:@"已扫描到对象!\n\n格式: %@\n\n内容:\n%@", formatString, contents];
            NSLog(@"%@",display);
            return contents;
        }
        else
        {
            return @"";
        }
    }
}

+ (AVMetadataObjectType)toAVMetadataObjectTypeWithZXing:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return AVMetadataObjectTypeAztecCode;
        case kBarcodeFormatCode39:
            return AVMetadataObjectTypeCode39Code;
        case kBarcodeFormatCode93:
            return AVMetadataObjectTypeCode93Code;
        case kBarcodeFormatCode128:
            return AVMetadataObjectTypeCode128Code;
        case kBarcodeFormatDataMatrix:
            return AVMetadataObjectTypeDataMatrixCode;
        case kBarcodeFormatEan8:
            return AVMetadataObjectTypeEAN8Code;
        case kBarcodeFormatEan13:
            return AVMetadataObjectTypeEAN13Code;
        case kBarcodeFormatITF:
            return AVMetadataObjectTypeITF14Code;
        case kBarcodeFormatPDF417:
            return AVMetadataObjectTypePDF417Code;
        case kBarcodeFormatQRCode:
            return AVMetadataObjectTypeQRCode;
        case kBarcodeFormatUPCE:
            return AVMetadataObjectTypeUPCECode;
        case kBarcodeFormatCodabar:
            return @"CODABAR";
        case kBarcodeFormatRSS14:
            return @"RSS 14";
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
        case kBarcodeFormatUPCA:
            return @"UPCA";
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
        default:
            return @"Unknown";
    }
}

+ (BOOL) isBarCode:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return NO;
        case kBarcodeFormatCode39:
            return YES;
        case kBarcodeFormatCode93:
            return YES;
        case kBarcodeFormatCode128:
            return YES;
        case kBarcodeFormatDataMatrix:
            return NO;
        case kBarcodeFormatEan8:
            return YES;
        case kBarcodeFormatEan13:
            return YES;
        case kBarcodeFormatITF:
            return YES;
        case kBarcodeFormatPDF417:
            return NO;
        case kBarcodeFormatQRCode:
            return NO;
        case kBarcodeFormatUPCE:
            return YES;
        case kBarcodeFormatCodabar:
            return YES;
        case kBarcodeFormatRSS14:
            return YES;
        case kBarcodeFormatRSSExpanded:
            return YES;
        case kBarcodeFormatUPCA:
            return YES;
        case kBarcodeFormatUPCEANExtension:
            return YES;
        default:
            return NO;
    }
}
@end
