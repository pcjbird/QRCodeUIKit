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
#import <Toast/Toast.h>
#import <ZXingObjC/ZXingObjC.h>
#import "QuickQRCodeScanView.h"
#import "QuickTextQRResultController.h"


#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickQRCodeScanController class]] pathForResource:@"QRCodeUIKit" ofType:@"bundle"]]

@interface QuickQRCodeScanController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>
{
    NSString*      _resultText;
    CGAffineTransform _captureSizeTransform;
    BOOL           _translucent;
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

@property (nonatomic, strong) AVCaptureSession *captureSession;

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
    _translucent = self.navigationController.navigationBar.translucent;
    if(!_translucent)
    {
        self.navigationController.navigationBar.translucent = YES;
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.qrcodeuikit_NavBarBgAlpha = @"0.0";
    [self updateLeftBarButtonItems];
    
    _resultText = nil;
    __weak typeof (self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*0.3f), dispatch_get_main_queue(), ^{
        [weakSelf.scanView startScanAnimation];
        if(weakSelf.captureSession && !weakSelf.captureSession.running) [weakSelf.captureSession startRunning];
    });
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    if(_captureSession && _captureSession.running) [_captureSession stopRunning];
    [_scanView stopScanAnimation];
    [super viewWillDisappear:animated];
    if(!_translucent)
    {
        self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Scan", @"Localizable", SDK_BUNDLE, nil);
    self.navigationItem.hidesBackButton = YES;
    [self updateTitleView];
    self.view.backgroundColor = [UIColor blackColor];
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0)
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [self addScanView];
    [self addTipView];
    [self addBottomView];
    [self initCaptureSession];
}

-(BOOL) initCaptureSession
{
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return FALSE;
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGRect scanAreaRect = _scanView.scanAreaRect;
    output.rectOfInterest = [self getRectOfInterestWithScanArea:scanAreaRect];
    //初始化链接对象
    _captureSession = [[AVCaptureSession alloc] init];
    //高质量采集率
    [_captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
    
    [_captureSession addInput:input];
    [_captureSession addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes= [self supportedAVMetadataObjectTypes];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_captureSession];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_captureSession startRunning];
    return TRUE;
}

#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getRectOfInterestWithScanArea:(CGRect)rect
{
    CGRect bounds = self.view.bounds;
    CGFloat x = CGRectGetMinX(bounds);
    CGFloat y = CGRectGetMinY(bounds);
    CGFloat w = CGRectGetWidth(bounds);
    CGFloat h = CGRectGetHeight(bounds);
    CGFloat x1 = CGRectGetMinX(rect);
    CGFloat y1 = CGRectGetMinY(rect);
    CGFloat w1 = CGRectGetWidth(rect);
    CGFloat h1 = CGRectGetHeight(rect);
    return CGRectMake(y1/y, x1/x, h1/h, w1/w);
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

-(NSString *) unknownCodeTipText
{
    return NSLocalizedStringFromTableInBundle(@"unknown qrcode", @"Localizable", SDK_BUNDLE, nil);
}

-(BOOL) shouldGiveUpAndContinueWithFormat:(AVMetadataObjectType)format detectedText:(NSString *)detectedText
{
    if(![detectedText isKindOfClass:[NSString class]] || [detectedText length] ==0)
    {
        return YES;
    }
    return NO;
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
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device || !device.hasTorch || !device.hasFlash)
    {
        [self.view makeToast:NSLocalizedStringFromTableInBundle(@"Your device has no torch.", @"Localizable", SDK_BUNDLE, nil) duration:3.0f position:CSToastPositionCenter style:[CSToastManager sharedStyle]];
        return;
    }
    [device lockForConfiguration:nil];
    BOOL isOn = (device.torchMode == AVCaptureTorchModeOn) || (device.flashMode == AVCaptureFlashModeOn);
    [device setTorchMode:isOn ? AVCaptureTorchModeOff : AVCaptureTorchModeOn];
    [device setFlashMode:isOn ? AVCaptureFlashModeOff : AVCaptureFlashModeOn];
    isOn = (device.torchMode == AVCaptureTorchModeOn) || (device.flashMode == AVCaptureFlashModeOn);
    ((UIButton*)sender).selected = isOn;
    [device unlockForConfiguration];
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

-(BOOL)shouldQRCodeFromAlbumWithEdittedImage
{
    return YES;
}

-(BOOL) shouldQRCodeFromAlbumSupportBarCode
{
    return NO;
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


#pragma mark - Private Methods

-(NSArray<AVMetadataObjectType> *) supportedAVMetadataObjectTypes
{
    return @[AVMetadataObjectTypeAztecCode,
             AVMetadataObjectTypeCode39Code,
             AVMetadataObjectTypeCode93Code,
             AVMetadataObjectTypeCode128Code,
             AVMetadataObjectTypeDataMatrixCode,
             AVMetadataObjectTypeEAN8Code,
             AVMetadataObjectTypeEAN13Code,
             AVMetadataObjectTypeITF14Code,
             AVMetadataObjectTypePDF417Code,
             AVMetadataObjectTypeQRCode,
             AVMetadataObjectTypeUPCECode
             ];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0)
    {
        if (_resultText) return;
        
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects firstObject];
        if([self shouldGiveUpAndContinueWithFormat:metadataObject.type detectedText:metadataObject.stringValue]) return;
        NSString *formatString = metadataObject.type;
        NSString *display = [NSString stringWithFormat:@"已扫描到对象!\n\n格式: %@\n\n内容:\n%@", formatString, metadataObject.stringValue];
        NSLog(@"%@",display);
        _resultText = metadataObject.stringValue;
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
}

#pragma mark - QRCodeFromAlbum Button Click
-(void)QRCodeFromAlbum:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    BOOL bShouldEdittedImage = [self shouldQRCodeFromAlbumWithEdittedImage];
    if(bShouldEdittedImage)
    {
        imagePickerController.allowsEditing = YES;
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    if (_resultText) return;
    UIImage *image = nil;
    BOOL bShouldEdittedImage = [self shouldQRCodeFromAlbumWithEdittedImage];
    
    if(bShouldEdittedImage)
    {
        image = [info valueForKey:UIImagePickerControllerEditedImage];
    }
    else
    {
        image = [info valueForKey:UIImagePickerControllerOriginalImage];
    }
    if(![image isKindOfClass:[UIImage class]])
    {
        [self.view makeToast:[self unknownCodeTipText] duration:3.0f position:CSToastPositionCenter style:[CSToastManager sharedStyle]];
        [self dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    if(![self shouldQRCodeFromAlbumSupportBarCode])
    {
        //初始化一个监测器
        CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        //监测到的结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        
        if(features.count >=1 )
        {
            [self dismissViewControllerAnimated:YES completion:NULL];
            /**结果对象 */
            CIQRCodeFeature *feature = [features firstObject];
            NSString *formatString = CIDetectorTypeQRCode;
            NSString *display = [NSString stringWithFormat:@"已扫描到对象!\n\n格式: %@\n\n内容:\n%@", formatString, feature.messageString];
            NSLog(@"%@",display);
            _resultText = feature.messageString;
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
            [self.view makeToast:[self unknownCodeTipText] duration:3.0f position:CSToastPositionCenter style:[CSToastManager sharedStyle]];
            [self dismissViewControllerAnimated:YES completion:NULL];
            return;
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
        if ([result isKindOfClass:[ZXResult class]] && ![self shouldGiveUpAndContinueWithFormat:[self toAVMetadataObjectTypeWithZXing:result.barcodeFormat] detectedText:result.text])
        {
            // The coded result as a string. The raw data can be accessed with
            // result.rawBytes and result.length.
            NSString *contents = result.text;
            
            // The barcode format, such as a QR code or UPC-A
            ZXBarcodeFormat format = result.barcodeFormat;
            NSString *formatString = [self toAVMetadataObjectTypeWithZXing:format];
            NSString *display = [NSString stringWithFormat:@"已扫描到对象!\n\n格式: %@\n\n内容:\n%@", formatString, contents];
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
            [self.view makeToast:[self unknownCodeTipText] duration:3.0f position:CSToastPositionCenter style:[CSToastManager sharedStyle]];
        }
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (AVMetadataObjectType)toAVMetadataObjectTypeWithZXing:(ZXBarcodeFormat)format {
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

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
