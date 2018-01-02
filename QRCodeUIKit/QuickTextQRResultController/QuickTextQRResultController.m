//
//  QuickTextQRResultController.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/2.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickTextQRResultController.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

#define SDK_BUNDLE [NSBundle bundleWithPath:[[NSBundle bundleForClass:[QuickTextQRResultController class]] pathForResource:@"QRCodeUIKit" ofType:@"bundle"]]

@interface QuickTextQRResultController ()<UIGestureRecognizerDelegate>
{
    NSString  *             _qrText;
    TTTAttributedLabel*     _qrTextLabel;
    UIView*                 _qrTextLabelBack;
}

@end

@implementation QuickTextQRResultController

-(id)initWithText:(NSString*)text
{
    if(self = [super init]){
        _qrText = text;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"Scan Result", @"Localizable", SDK_BUNDLE, nil);
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = NO;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0)
    {
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [self initControls];
}

-(void) initControls
{
    _qrTextLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    [_qrTextLabel setBackgroundColor:[UIColor clearColor]];
    [_qrTextLabel setVerticalAlignment:TTTAttributedLabelVerticalAlignmentCenter];
    [_qrTextLabel setTextAlignment:NSTextAlignmentCenter];
    [_qrTextLabel setLineSpacing:1.0f];
    [_qrTextLabel setNumberOfLines:4];
    [_qrTextLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [_qrTextLabel setTextInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    _qrTextLabel.layer.masksToBounds = YES;
    _qrTextLabel.layer.cornerRadius = 6.0f;
    [_qrTextLabel setTextColor:[UIColor darkGrayColor]];
    if(_qrText)[_qrTextLabel setText:_qrText];
    CGSize maxSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 60.0f - 10.0f*2,2000);
    CGSize labelsize = [TTTAttributedLabel sizeThatFitsAttributedString:_qrTextLabel.attributedText withConstraints:maxSize limitedToNumberOfLines:4];
    [_qrTextLabel setBounds:CGRectMake(0,0, labelsize.width + 10.0f *2, labelsize.height + 10.0f*2)];
    _qrTextLabel.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)/2, CGRectGetHeight([UIScreen mainScreen].bounds)/2 - 60.0f);
    
    _qrTextLabelBack = [[UIView alloc] initWithFrame:CGRectInset(_qrTextLabel.frame, 2, 2)];
    [_qrTextLabelBack setBackgroundColor:[UIColor clearColor]];
    _qrTextLabelBack.layer.masksToBounds = YES;
    _qrTextLabelBack.layer.cornerRadius = 6.0f;
    [self.view addSubview:_qrTextLabelBack];
    [self.view addSubview:_qrTextLabel];
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRoundedRect:_qrTextLabel.bounds cornerRadius:4.0f];
    CAShapeLayer* _border = [CAShapeLayer layer];
    _border.strokeColor = [UIColor darkGrayColor].CGColor;
    _border.fillColor = nil;
    _border.lineWidth = 4.0f;
    _border.lineDashPattern = @[@4, @4];
    
    [_qrTextLabel.layer addSublayer:_border];
    _border.path = [clipPath CGPath];
    _border.frame = _qrTextLabel.layer.bounds;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    [tipLabel setBackgroundColor:[UIColor clearColor]];
    [tipLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [tipLabel setTextColor:[UIColor grayColor]];
    [tipLabel setTextAlignment:NSTextAlignmentJustified];
    [tipLabel setNumberOfLines:0];
    [tipLabel setText:NSLocalizedStringFromTableInBundle(@"PressCopyTip", @"Localizable", SDK_BUNDLE, nil)];
    CGSize size = [tipLabel sizeThatFits:CGSizeMake(CGRectGetWidth(_qrTextLabel.bounds), HUGE)];
    tipLabel.frame = CGRectMake((CGRectGetWidth([UIScreen mainScreen].bounds) - size.width)/2, CGRectGetMaxY(_qrTextLabel.frame) + 12.0f, size.width, size.height);
    [self.view addSubview:tipLabel];
    
    _qrTextLabel.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longtapGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longtap:)];
    longtapGesture.delegate = self;
    [_qrTextLabel addGestureRecognizer:longtapGesture];
}

-(void)menuControllerWillShow:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [_qrTextLabelBack setBackgroundColor:[UIColor lightGrayColor]];
}
-(void)menuControllerWillHide:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [_qrTextLabelBack setBackgroundColor:[UIColor clearColor]];
}

-(void)longtap:(UILongPressGestureRecognizer * )longtapGes
{
    if (longtapGes.state == UIGestureRecognizerStateBegan)
    {
        [_qrTextLabel becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:_qrTextLabel.frame inView:self.view];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillShow:) name:UIMenuControllerWillShowMenuNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuControllerWillHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
        [menu setMenuVisible:YES animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
