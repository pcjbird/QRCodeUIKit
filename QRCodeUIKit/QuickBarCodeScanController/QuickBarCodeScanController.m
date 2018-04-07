//
//  QuickBarCodeScanController.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/2/4.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickBarCodeScanController.h"

#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickBarCodeScanController class]] pathForResource:@"QRCodeUIKit" ofType:@"bundle"]]

@interface QuickBarCodeScanController ()

@end

@implementation QuickBarCodeScanController

-(instancetype)init
{
    if(self = [super init])
    {
        self.style.whRatio = 5.0f;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) scanTipText
{
    return NSLocalizedStringFromTableInBundle(@"BarCodeScanTip", @"Localizable", SDK_BUNDLE, nil);
}

-(NSString *) unknownCodeTipText
{
    return NSLocalizedStringFromTableInBundle(@"unknown barcode", @"Localizable", SDK_BUNDLE, nil);
}

-(BOOL) shouldGiveUpAndContinueWithFormat:(AVMetadataObjectType)format detectedText:(NSString *)detectedText
{
    if([super shouldGiveUpAndContinueWithFormat:format detectedText:detectedText])
    {
        return YES;
    }
    return NO;
}

-(NSArray<AVMetadataObjectType> *)supportedAVMetadataObjectTypes
{
    return @[AVMetadataObjectTypeCode39Code,
             AVMetadataObjectTypeCode93Code,
             AVMetadataObjectTypeCode128Code,
             AVMetadataObjectTypeEAN8Code,
             AVMetadataObjectTypeEAN13Code,
             AVMetadataObjectTypeITF14Code,
             AVMetadataObjectTypeUPCECode
             ];
}

-(NSString *) myQRText
{
    return nil;
}

@end
