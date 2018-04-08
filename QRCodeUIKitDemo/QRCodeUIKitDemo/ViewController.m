//
//  ViewController.m
//  QRCodeUIKitDemo
//
//  Created by pcjbird on 2018/4/8.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "ViewController.h"
#import <QRCodeUIKit/QRCodeUIKit.h>
#import <YYWebImage/YYWebImage.h>

@interface ViewController ()

- (IBAction)OnQRCodeScan:(id)sender;
- (IBAction)OnBarCodeScan:(id)sender;
- (IBAction)OnGenQRCode:(id)sender;
- (IBAction)OnGenBarCode:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *barcode;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcode;
@property (weak, nonatomic) IBOutlet UIView *qrcodeback;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"QRCodeUIKit";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)OnQRCodeScan:(id)sender {
    QuickQRCodeScanController *scanVC = [QuickQRCodeScanController new];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (IBAction)OnBarCodeScan:(id)sender {
    QuickBarCodeScanController *scanVC = [QuickBarCodeScanController new];
    [self.navigationController pushViewController:scanVC animated:YES];
}

- (IBAction)OnGenQRCode:(id)sender {
    UIImage* logo = [[UIImage imageNamed:@"AppIcon60x60"] yy_imageByRoundCornerRadius:8.0f];
    self.qrcode.image = [QuickQRCodeGenerator generateQRCode:@"我是一个二维码" width:CGRectGetWidth(self.qrcode.frame) height:CGRectGetHeight(self.qrcode.frame) logo:logo logoSize:CGSizeMake(60, 60)];
    self.qrcodeback.hidden = NO;
}

- (IBAction)OnGenBarCode:(id)sender {
    NSString* code = @"8986011684013010860";
    self.barcodeLabel.text = [QuickBarCodeGenerator formatCode:code];
    self.barcode.image = [QuickBarCodeGenerator generateBarCode:code width:CGRectGetWidth(self.barcode.frame) height:CGRectGetHeight(self.barcode.frame)];
}
@end
