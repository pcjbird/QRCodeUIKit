//
//  QuickQRCodeScanController.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickQRCodeScanController.h"
#import "UIViewController+QRCodeUIKit.h"
#import "UINavigationController+QRCodeUIKit.h"
#import <ZXingObjC/ZXingObjC.h>

#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickQRCodeScanController class]] pathForResource:@"QRCodeUIKit" ofType:@"bundle"]]

@interface QuickQRCodeScanController ()<ZXCaptureDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSTimer * scanLineTimer;
    
    //UIButton*      btnOpenTorch;
    NSString*      resultText;
    
    //AlignedUIImageView *bottomAdView;
    CGAffineTransform _captureSizeTransform;
}
@property (nonatomic, strong) ZXCapture *capture;
@property (nonatomic, strong) UIImageView *scanRectView;
@property (nonatomic, strong) UIImageView *scanLine;
@end

@implementation QuickQRCodeScanController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.qrcodeuikit_NavBarBgAlpha = @"0.0";
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    /*resultText = nil;
    if (!scanLineTimer)
    {
        scanLineTimer = [NSTimer scheduledTimerWithTimeInterval:0.0075f target:self selector:@selector(UpdateScanLine:) userInfo:nil repeats:YES];
    }*/
}

-(void)viewWillDisappear:(BOOL)animated
{
/*
    if (scanLineTimer)
    {
        [scanLineTimer invalidate];
        scanLineTimer = nil;
    }*/
    
    {
        UIBarButtonItem *appearance = [UIBarButtonItem appearance];
        UIColor * tintColor = appearance.tintColor;
        if([tintColor isKindOfClass:[UIColor class]])
        {
            self.navigationItem.backBarButtonItem.tintColor = tintColor;
        }
        else
        {
            self.navigationItem.backBarButtonItem.tintColor = nil;
        }
    }
    
    {
        UINavigationBar *apperance = [UINavigationBar appearance];
        if([apperance.tintColor isKindOfClass:[UIColor class]])
        {
            self.navigationController.navigationBar.tintColor = apperance.tintColor;
        }
        else
        {
            self.navigationController.navigationBar.tintColor = nil;
        }
        NSDictionary<NSAttributedStringKey, id> *titleTextAttributes = [apperance titleTextAttributes];
        if([titleTextAttributes isKindOfClass:[NSDictionary class]])
        {
            UIColor *titleColor = [titleTextAttributes objectForKey:NSForegroundColorAttributeName];
            if([titleColor isKindOfClass:[UIColor class]])
            {
                [self.navigationController.navigationBar setTitleTextAttributes: @{NSForegroundColorAttributeName:titleColor}];
            }
            else
            {
                NSMutableDictionary<NSAttributedStringKey, id> * newTitleTextAttributes = [self.navigationController.navigationBar.titleTextAttributes mutableCopy];
                [newTitleTextAttributes removeObjectForKey:NSForegroundColorAttributeName];
                [self.navigationController.navigationBar setTitleTextAttributes: [newTitleTextAttributes copy]];
            }
        }
    }
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Scan", @"Localizable", SDK_BUNDLE, nil);
    self.navigationController.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0)
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    
    self.capture = [[ZXCapture alloc] init];
    self.capture.camera = self.capture.back;
    self.capture.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    self.capture.rotation = 90.0f;
    
    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
    self.capture.delegate = self;
    [self applyOrientation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applyOrientation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    float scanRectRotation;
    float captureRotation;
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            captureRotation = 90;
            scanRectRotation = 180;
            break;
        case UIInterfaceOrientationLandscapeRight:
            captureRotation = 270;
            scanRectRotation = 0;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            captureRotation = 180;
            scanRectRotation = 270;
            break;
        default:
            captureRotation = 0;
            scanRectRotation = 90;
            break;
    }
    [self applyRectOfInterest:orientation];
    CGAffineTransform transform = CGAffineTransformMakeRotation((CGFloat) (captureRotation / 180 * M_PI));
    [self.capture setTransform:transform];
    [self.capture setRotation:scanRectRotation];
    self.capture.layer.frame = self.view.frame;
}

- (void)applyRectOfInterest:(UIInterfaceOrientation)orientation {
    CGFloat scaleVideo, scaleVideoX, scaleVideoY;
    CGFloat videoSizeX, videoSizeY;
    CGRect transformedVideoRect = self.scanRectView.frame;
    if([self.capture.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        videoSizeX = 1080;
        videoSizeY = 1920;
    } else {
        videoSizeX = 720;
        videoSizeY = 1280;
    }
    if(UIInterfaceOrientationIsPortrait(orientation)) {
        scaleVideoX = self.view.frame.size.width / videoSizeX;
        scaleVideoY = self.view.frame.size.height / videoSizeY;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeY - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeX - self.view.frame.size.width) / 2;
        }
    } else {
        scaleVideoX = self.view.frame.size.width / videoSizeY;
        scaleVideoY = self.view.frame.size.height / videoSizeX;
        scaleVideo = MAX(scaleVideoX, scaleVideoY);
        if(scaleVideoX > scaleVideoY) {
            transformedVideoRect.origin.y += (scaleVideo * videoSizeX - self.view.frame.size.height) / 2;
        } else {
            transformedVideoRect.origin.x += (scaleVideo * videoSizeY - self.view.frame.size.width) / 2;
        }
    }
    _captureSizeTransform = CGAffineTransformMakeScale(1/scaleVideo, 1/scaleVideo);
    self.capture.scanRect = CGRectApplyAffineTransform(transformedVideoRect, _captureSizeTransform);
}

#pragma mark - Private Methods

- (NSString *)barcodeFormatToString:(ZXBarcodeFormat)format {
    switch (format) {
        case kBarcodeFormatAztec:
            return @"Aztec";
            
        case kBarcodeFormatCodabar:
            return @"CODABAR";
            
        case kBarcodeFormatCode39:
            return @"Code 39";
            
        case kBarcodeFormatCode93:
            return @"Code 93";
            
        case kBarcodeFormatCode128:
            return @"Code 128";
            
        case kBarcodeFormatDataMatrix:
            return @"Data Matrix";
            
        case kBarcodeFormatEan8:
            return @"EAN-8";
            
        case kBarcodeFormatEan13:
            return @"EAN-13";
            
        case kBarcodeFormatITF:
            return @"ITF";
            
        case kBarcodeFormatPDF417:
            return @"PDF417";
            
        case kBarcodeFormatQRCode:
            return @"QR Code";
            
        case kBarcodeFormatRSS14:
            return @"RSS 14";
            
        case kBarcodeFormatRSSExpanded:
            return @"RSS Expanded";
            
        case kBarcodeFormatUPCA:
            return @"UPCA";
            
        case kBarcodeFormatUPCE:
            return @"UPCE";
            
        case kBarcodeFormatUPCEANExtension:
            return @"UPC/EAN extension";
            
        default:
            return @"Unknown";
    }
}

#pragma mark - ZXCaptureDelegate Methods

- (void)captureResult:(ZXCapture *)capture result:(ZXResult *)result {
    if (!result) return;
    if (resultText) return;
    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    //[self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
    NSLog(@"%@",display);
    resultText = result.text;
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    /*[MobClick event:@"qrcodeScanResultEvent"];
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result.text]] || ![AppDelegate handleURL:result.text withRootViewController:self])
    {
        TextQRResultViewController* textQRVC = [[TextQRResultViewController alloc] initWithQRText:resultText];
        [self.navigationController pushViewController:textQRVC animated:YES];
    }*/
}

-(void)QRCodeFromAlbum:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (resultText) return;
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    CGImageRef imageToDecode = image.CGImage;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    NSError *error = nil;
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap
                                hints:hints
                                error:&error];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
        NSString *formatString = [self barcodeFormatToString:format];
        NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, contents];
        //[self.decodedLabel performSelectorOnMainThread:@selector(setText:) withObject:display waitUntilDone:YES];
        //APP_LOG(@"%@",display);
        resultText = result.text;
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        /*[MobClick event:@"qrcodeRecogResultEvent"];
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:result.text]] || ![AppDelegate handleURL:result.text withRootViewController:self])
        {
            TextQRResultViewController* textQRVC = [[TextQRResultViewController alloc] initWithQRText:resultText];
            [self.navigationController pushViewController:textQRVC animated:YES];
        }*/
    } else {
        // Use error to determine why we didn't get a result, such as a barcode
        // not being found, an invalid checksum, or a format inconsistency.
        //[[[[iToast makeText:NSLocalizedString(@"unknown qrcode", nil)] setGravity:iToastGravityCenter] setFontSize:ITOAST_FONT_SIZE] show];
        //APP_LOG(@"unknown qrcode");
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
