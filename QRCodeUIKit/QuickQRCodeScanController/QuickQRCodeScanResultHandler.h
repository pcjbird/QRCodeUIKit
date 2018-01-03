//
//  QuickQRCodeScanResultHandler.h
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/3.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#ifndef QuickQRCodeScanResultHandler_h
#define QuickQRCodeScanResultHandler_h

@class QuickQRCodeScanController;
@protocol QuickQRCodeScanResultHandler<NSObject>

- (BOOL)handleResult:(NSString *)text withQRCodeScanController:(QuickQRCodeScanController *)scanVC;
@end


#endif /* QuickQRCodeScanResultHandler_h */
