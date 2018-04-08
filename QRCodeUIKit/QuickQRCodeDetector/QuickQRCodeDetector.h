//
//  QuickQRCodeDetector.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/4/8.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QuickQRCodeDetector : NSObject

+(NSString*)detectQRCodeWithImage:(UIImage*)image;
+(NSString*)detectBarCodeWithImage:(UIImage*)image;
+(NSString*)detectQRCodeOrBarCodeWithImage:(UIImage*)image;

@end
