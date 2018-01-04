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
#import <Toast/Toast.h>
#import "QuickQRCodeScanView.h"
#import "QuickTextQRResultController.h"


#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickQRCodeScanController class]] pathForResource:@"QRCodeUIKit" ofType:@"bundle"]]

@interface QuickQRCodeScanController ()<ZXCaptureDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString*      _resultText;
    CGAffineTransform _captureSizeTransform;
}
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) QuickQRCodeScanViewStyle *style;
@property (nonatomic, strong) QuickQRCodeScanView * scanView;
@property (nonatomic, strong) UILabel* lblScanTip;
@property (nonatomic, strong) UIView *bottomView;
//相册
@property (nonatomic, strong) UIButton *btnAlbum;
//闪光灯
@property (nonatomic, strong) UIButton *btnTorch;
//我的二维码
@property (nonatomic, strong) UIButton *btnMyQR;
//可以扫什么
@property (nonatomic, strong) UIButton *btnQA;

@property (nonatomic, strong) ZXCapture *capture;

@end

@implementation QuickQRCodeScanController


-(instancetype)init
{
    if(self = [super init])
    {
        [self initVariables];
    }
    return self;
}

-(void) initVariables
{
    _resultText = nil;
    _style = [QuickQRCodeScanViewStyle new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.qrcodeuikit_NavBarBgAlpha = @"0.0";
    [self updateLeftBarButtonItems];
    
    _resultText = nil;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.3f), dispatch_get_main_queue(), ^{
        [_scanView startScanAnimation];
    });
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_scanView stopScanAnimation];
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Scan", @"Localizable", SDK_BUNDLE, nil);
    self.navigationItem.hidesBackButton = YES;
    [self updateTitleView];
    self.view.backgroundColor = [UIColor blackColor];
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
    [self addScanView];
    [self addTipView];
    [self addBottomView];
}

-(void) addScanView
{
    if([_scanView isKindOfClass:[UIView class]]) return;
    _scanView = [[QuickQRCodeScanView alloc] initWithFrame:self.view.bounds style:_style];
    _scanView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scanView];
    
}

-(void) addTipView
{
    if([_lblScanTip isKindOfClass:[UILabel class]]) return;
    CGRect scanAreaRect = _scanView.scanAreaRect;
    UILabel * _lblScanTip= [UILabel new];
    _lblScanTip.backgroundColor = [UIColor clearColor];
    _lblScanTip.numberOfLines = 0;
    _lblScanTip.textColor=[UIColor colorWithWhite:1.0f alpha:0.85f];
    _lblScanTip.font = [UIFont systemFontOfSize:14.0f];
    _lblScanTip.text = [self scanTipText];
    _lblScanTip.textAlignment = NSTextAlignmentJustified;
    CGSize size = [_lblScanTip sizeThatFits:CGSizeMake(CGRectGetWidth(scanAreaRect), HUGE)];
    _lblScanTip.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - size.width)/2, CGRectGetMaxY(scanAreaRect) + 25.0f, size.width, size.height);
    _lblScanTip.clipsToBounds = YES;
    [self.view addSubview:_lblScanTip];
}

-(NSString *) scanTipText
{
    return NSLocalizedStringFromTableInBundle(@"ScanTip", @"Localizable", SDK_BUNDLE, nil);
}


-(void)addBottomView
{
    if ([_bottomView isKindOfClass:[UIView class]]) return;
    BOOL isIPhoneX = (CGRectGetHeight([UIScreen mainScreen].bounds) == 812.0f);
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds)- 100 - (isIPhoneX ? 34 : 0), CGRectGetWidth(self.view.frame), 100)];
    _bottomView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_bottomView];
    CGFloat width = 65.0f;
    CGFloat height = 87.0f;
    
    NSInteger totalBtn = 2;
    NSString *myQRText = [self myQRText];
    BOOL bMyQRBtnSupport = ([myQRText isKindOfClass:[NSString class]] && [myQRText length] > 0);
    if(bMyQRBtnSupport)
    {
        totalBtn += 1;
    }
    if([self supportQABtn])
    {
        totalBtn += 1;
    }
    
    CGFloat flexibleWidth = CGRectGetWidth(_bottomView.frame)/totalBtn;
    
    
    self.btnAlbum = [[UIButton alloc] init];
    _btnAlbum.bounds = CGRectMake(0, 0, width, height);
    _btnAlbum.center = CGPointMake(flexibleWidth*0.5f, CGRectGetHeight(_bottomView.frame)/2);
    [_btnAlbum setImage:[UIImage imageNamed:@"qrcode_scan_btn_album_normal" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_btnAlbum setImage:[UIImage imageNamed:@"qrcode_scan_btn_album_highlight" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
    [_btnAlbum addTarget:self action:@selector(QRCodeFromAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnAlbum];
    
    self.btnTorch = [[UIButton alloc] init];
    _btnTorch.bounds = CGRectMake(0, 0, width, height);
    _btnTorch.center = CGPointMake(flexibleWidth*1.5f, CGRectGetHeight(_bottomView.frame)/2);
    [_btnTorch setImage:[UIImage imageNamed:@"qrcode_scan_btn_opentorch_normal" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    [_btnTorch setImage:[UIImage imageNamed:@"qrcode_scan_btn_closetorch_normal" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
    [_btnTorch addTarget:self action:@selector(OnTorchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnTorch];
    
     if(bMyQRBtnSupport)
     {
         self.btnMyQR = [[UIButton alloc]init];
         _btnMyQR.bounds = CGRectMake(0, 0, width, height);
         _btnMyQR.center = CGPointMake(flexibleWidth*2.5f, CGRectGetHeight(_bottomView.frame)/2);
         [_btnMyQR setImage:[UIImage imageNamed:@"qrcode_scan_btn_myqrcode_normal" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
         [_btnMyQR setImage:[UIImage imageNamed:@"qrcode_scan_btn_myqrcode_highlight" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] forState:UIControlStateHighlighted];
         [_btnMyQR addTarget:self action:@selector(OnMyQRBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_bottomView addSubview:_btnMyQR];
     }

     if([self supportQABtn])
     {
         self.btnQA = [[UIButton alloc]init];
         _btnQA.bounds = CGRectMake(0, 0, width, height);
         _btnQA.center = CGPointMake(flexibleWidth*(bMyQRBtnSupport ? 3.5f : 2.5f), CGRectGetHeight(_bottomView.frame)/2);
         [_btnQA setImage:[UIImage imageNamed:@"qrcode_scan_btn_qa_normal" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
         [_btnQA addTarget:self action:@selector(OnQABtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_bottomView addSubview:_btnQA];
     }
   
}
                                   
                                   
-(void)OnTorchBtnClick:(id)sender
{
    if (!self.capture.hasTorch)
    {
        [self.view makeToast:NSLocalizedStringFromTableInBundle(@"Your device has no torch.", @"Localizable", SDK_BUNDLE, nil) duration:3.0f position:CSToastPositionCenter];
        return;
    }
    
    self.capture.torch = !self.capture.torch;
    ((UIButton*)sender).selected = self.capture.torch;
}

-(NSString *)myQRText
{
    return nil;
}

-(void)OnMyQRBtnClick:(id)sender
{
    
}

-(BOOL)supportQABtn
{
    return NO;
}

-(void)OnQABtnClick:(id)sender
{
    
}

#pragma mark - 更新标题
-(void) updateTitleView
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = NSLocalizedStringFromTableInBundle(@"Scan", @"Localizable", SDK_BUNDLE, nil);
    titleLabel.textAlignment = NSTextAlignmentJustified;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 更新导航左侧按钮
-(void) updateLeftBarButtonItems
{
    if(self.navigationController.viewControllers.count > 1)
    {
        self.navigationItem.leftBarButtonItems = @[self.backItem];
    }
    else
    {
        self.navigationItem.leftBarButtonItems = @[];
    }
}

#pragma mark - 返回按钮
- (UIBarButtonItem *)backItem
{
    if (!_backItem)
    {
        _backItem = [[UIBarButtonItem alloc] initWithImage:[self resolvedBackIndicatorImage] style:UIBarButtonItemStylePlain target:self action:@selector(goBack:)];
        _backItem.tintColor = [UIColor whiteColor];
    }
    return _backItem;
}

#pragma mark - 返回按钮图标
-(UIImage *)resolvedBackIndicatorImage
{
    return [[UIImage imageNamed:@"navbar_return" inBundle:SDK_BUNDLE compatibleWithTraitCollection:nil] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - 返回
-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    CGRect scanAreaRect = _scanView.scanAreaRect;
    CGRect transformedVideoRect = scanAreaRect;
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
    if (_resultText) return;
    // We got a result. Display information about the result onscreen.
    NSString *formatString = [self barcodeFormatToString:result.barcodeFormat];
    NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, result.text];
    NSLog(@"%@",display);
    _resultText = result.text;
    // Vibrate
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    BOOL bHandled = FALSE;
    if(self.resultHandler && [self.resultHandler conformsToProtocol:@protocol(QuickQRCodeScanResultHandler)])
    {
        bHandled = [self.resultHandler handleResult:_resultText withQRCodeScanController:self];
    }
    if(!bHandled)
    {
        QuickTextQRResultController * textQRVC = [[QuickTextQRResultController alloc] initWithText:_resultText];
        [self.navigationController pushViewController:textQRVC animated:YES];
    }
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
    if (_resultText) return;
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    CGImageRef imageToDecode = image.CGImage;  // Given a CGImage in which we are looking for barcodes
    
    ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode];
    ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    
    // There are a number of hints we can give to the reader, including
    // possible formats, allowed lengths, and the string encoding.
    ZXDecodeHints *hints = [ZXDecodeHints hints];
    
    ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
    ZXResult *result = [reader decode:bitmap hints:hints error:nil];
    if (result) {
        // The coded result as a string. The raw data can be accessed with
        // result.rawBytes and result.length.
        NSString *contents = result.text;
        
        // The barcode format, such as a QR code or UPC-A
        ZXBarcodeFormat format = result.barcodeFormat;
        NSString *formatString = [self barcodeFormatToString:format];
        NSString *display = [NSString stringWithFormat:@"Scanned!\n\nFormat: %@\n\nContents:\n%@", formatString, contents];
        NSLog(@"%@",display);
        _resultText = result.text;
        // Vibrate
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        BOOL bHandled = FALSE;
        if(self.resultHandler && [self.resultHandler conformsToProtocol:@protocol(QuickQRCodeScanResultHandler)])
        {
            bHandled = [self.resultHandler handleResult:_resultText withQRCodeScanController:self];
        }
        if(!bHandled)
        {
            QuickTextQRResultController * textQRVC = [[QuickTextQRResultController alloc] initWithText:_resultText];
            [self.navigationController pushViewController:textQRVC animated:YES];
        }
    }
    else
    {
        [self.view makeToast:NSLocalizedStringFromTableInBundle(@"unknown qrcode", @"Localizable", SDK_BUNDLE, nil) duration:3.0f position:CSToastPositionCenter];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
