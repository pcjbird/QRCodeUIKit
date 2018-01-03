//
//  QuickQRCodeScanView.m
//  QRCodeUIKit
//
//  Created by pcjbird on 2018/1/3.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "QuickQRCodeScanView.h"
#import "QuickQRCodeScanLineAnimation.h"
#import "QuickQRCodeScanGridAnimation.h"

@interface QuickQRCodeScanView()

//扫码区域各种参数
@property (nonatomic, strong,nullable) QuickQRCodeScanViewStyle* viewStyle;


//扫码区域
@property (nonatomic,assign)CGRect scanAreaRect;

//线条扫码动画封装
@property (nonatomic,strong,nullable)QuickQRCodeScanLineAnimation *scanLineAnimation;
//网格扫码动画封装
@property (nonatomic,strong,nullable)QuickQRCodeScanGridAnimation *scanGridAnimation;

//线条在中间位置，不移动
@property (nonatomic,strong,nullable)UIImageView *scanLineStill;

@end

@implementation QuickQRCodeScanView

-(id)initWithFrame:(CGRect)frame style:(QuickQRCodeScanViewStyle*)style
{
    if (self = [super initWithFrame:frame])
    {
        self.viewStyle = style;
        self.backgroundColor = [UIColor clearColor];
        [self calcScanRect];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [self drawScanRect];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}


/**
 *  开始扫描动画
 */
- (void)startScanAnimation
{
    switch (_viewStyle.animationStyle)
    {
        case QuickQRCodeScanViewAnimationStyle_LineMove:
        {
            //线动画
            if (!_scanLineAnimation)
            {
                self.scanLineAnimation = [QuickQRCodeScanLineAnimation new];
                self.scanLineAnimation.tintColor = _viewStyle.colorScanAreaCorner;
            }
            
            [_scanLineAnimation startAnimatingWithRect:_scanAreaRect inView:self image:_viewStyle.animationImage];
        }
            break;
        case QuickQRCodeScanViewAnimationStyle_NetGrid:
        {
            //网格动画
            if (!_scanGridAnimation)
            {
                self.scanGridAnimation = [QuickQRCodeScanGridAnimation new];
                self.scanGridAnimation.tintColor = _viewStyle.colorScanAreaCorner;
            }
            
            [_scanGridAnimation startAnimatingWithRect:_scanAreaRect inView:self image:_viewStyle.animationImage];
        }
            break;
        case QuickQRCodeScanViewAnimationStyle_LineStill:
        {
            if (!_scanLineStill)
            {
                
                CGRect stillRect = CGRectMake(_scanAreaRect.origin.x+20, _scanAreaRect.origin.y + _scanAreaRect.size.height/2, _scanAreaRect.size.width-40, 2);
                _scanLineStill = [[UIImageView alloc] initWithFrame:stillRect];
                _scanLineStill.image = _viewStyle.animationImage;
            }
            [self addSubview:_scanLineStill];
        }
            
        default:
            break;
    }
    
}



/**
 *  结束扫描动画
 */
- (void)stopScanAnimation
{
    if (_scanLineAnimation) {
        [_scanLineAnimation stopAnimating];
    }
    
    if (_scanGridAnimation) {
        [_scanGridAnimation stopAnimating];
    }
    
    if (_scanLineStill) {
        [_scanLineStill removeFromSuperview];
    }
}

-(void) calcScanRect
{
    int xMargin = _viewStyle.scanAreaMarginX;
    
    CGSize sizeRect = CGSizeMake(self.frame.size.width - xMargin*2, self.frame.size.width - xMargin*2);
    
    if (_viewStyle.whRatio != 1)
    {
        CGFloat w = sizeRect.width;
        CGFloat h = w / _viewStyle.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRect = CGSizeMake(w, h);
        
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRect.height/2.0 - _viewStyle.centerUpOffset;
    
    _scanAreaRect = CGRectMake(xMargin, YMinRetangle, sizeRect.width, sizeRect.height);
}

- (void)drawScanRect
{
    int xMargin = _viewStyle.scanAreaMarginX;
    
    CGSize sizeRect = CGSizeMake(self.frame.size.width - xMargin*2, self.frame.size.width - xMargin*2);
    
    if (_viewStyle.whRatio != 1)
    {
        CGFloat w = sizeRect.width;
        CGFloat h = w / _viewStyle.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRect = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = self.frame.size.height / 2.0 - sizeRect.height/2.0 - _viewStyle.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRect.height;
    CGFloat XRetangleRight = self.frame.size.width - xMargin;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //非扫码区域半透明
    {
        //设置非识别区域颜色
        
        const CGFloat *components = CGColorGetComponents(_viewStyle.notRecoginitonArea.CGColor);
        
        
        CGFloat red_notRecoginitonArea = components[0];
        CGFloat green_notRecoginitonArea = components[1];
        CGFloat blue_notRecoginitonArea = components[2];
        CGFloat alpa_notRecoginitonArea = components[3];
        
        
        CGContextSetRGBFillColor(context, red_notRecoginitonArea, green_notRecoginitonArea, blue_notRecoginitonArea, alpa_notRecoginitonArea);
        
        //填充矩形
        
        //扫码区域上面填充
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, YMinRetangle);
        CGContextFillRect(context, rect);
        
        
        //扫码区域左边填充
        rect = CGRectMake(0, YMinRetangle, xMargin, sizeRect.height);
        CGContextFillRect(context, rect);
        
        //扫码区域右边填充
        rect = CGRectMake(XRetangleRight, YMinRetangle, xMargin, sizeRect.height);
        CGContextFillRect(context, rect);
        
        //扫码区域下面填充
        rect = CGRectMake(0, YMaxRetangle, self.frame.size.width,self.frame.size.height - YMaxRetangle);
        CGContextFillRect(context, rect);
        //执行绘画
        CGContextStrokePath(context);
    }
    
    if (_viewStyle.drawScanAreaRect)
    {
        //中间画矩形(正方形)
        CGContextSetStrokeColorWithColor(context, _viewStyle.colorScanAreaRectLine.CGColor);
        CGContextSetLineWidth(context, 1);
        
        CGContextAddRect(context, CGRectMake(xMargin, YMinRetangle, sizeRect.width, sizeRect.height));
        
        CGContextStrokePath(context);
        
    }
    _scanAreaRect = CGRectMake(xMargin, YMinRetangle, sizeRect.width, sizeRect.height);
    
    
    //画矩形框4格外围相框角
    
    //相框角的宽度和高度
    int wAngle = _viewStyle.scanAreaCornerW;
    int hAngle = _viewStyle.scanAreaCornerH;
    
    //4个角的 线的宽度
    CGFloat linewidthAngle = _viewStyle.scanAreaCornerLineW;// 经验参数：6和4
    
    //画扫码矩形以及周边半透明黑色坐标参数
    CGFloat diffAngle = 0.0f;
    //diffAngle = linewidthAngle / 2; //框外面4个角，与框有缝隙
    //diffAngle = linewidthAngle/2;  //框4个角 在线上加4个角效果
    //diffAngle = 0;//与矩形框重合
    
    switch (_viewStyle.scanAreaCornerStyle)
    {
        case QuickQRCodeScanAreaCornerStyle_Outer:
        {
            diffAngle = linewidthAngle/3;//框外面4个角，与框紧密联系在一起
        }
            break;
        case QuickQRCodeScanAreaCornerStyle_On:
        {
            diffAngle = 0;
        }
            break;
        case QuickQRCodeScanAreaCornerStyle_Inner:
        {
            diffAngle = -_viewStyle.scanAreaCornerLineW/2;
            
        }
            break;
            
        default:
        {
            diffAngle = linewidthAngle/3;
        }
            break;
    }
    
    CGContextSetStrokeColorWithColor(context, _viewStyle.colorScanAreaCorner.CGColor);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, linewidthAngle);
    CGContextSetLineCap(context,kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    //
    CGFloat leftX = xMargin - diffAngle;
    CGFloat topY = YMinRetangle - diffAngle;
    CGFloat rightX = XRetangleRight + diffAngle;
    CGFloat bottomY = YMaxRetangle + diffAngle;
    
    //左上角水平线
    CGContextMoveToPoint(context, leftX, topY);
    CGContextAddLineToPoint(context, leftX + wAngle, topY);
    
    //左上角垂直线
    CGContextMoveToPoint(context, leftX, topY);
    CGContextAddLineToPoint(context, leftX, topY+hAngle);
    
    
    //左下角水平线
    CGContextMoveToPoint(context, leftX, bottomY);
    CGContextAddLineToPoint(context, leftX + wAngle, bottomY);
    
    //左下角垂直线
    CGContextMoveToPoint(context, leftX, bottomY);
    CGContextAddLineToPoint(context, leftX, bottomY - hAngle);
    
    
    //右上角水平线
    CGContextMoveToPoint(context, rightX, topY);
    CGContextAddLineToPoint(context, rightX - wAngle, topY);
    
    //右上角垂直线
    CGContextMoveToPoint(context, rightX, topY);
    CGContextAddLineToPoint(context, rightX, topY + hAngle);
    
    
    //右下角水平线
    CGContextMoveToPoint(context, rightX, bottomY);
    CGContextAddLineToPoint(context, rightX - wAngle, bottomY);
    
    //右下角垂直线
    CGContextMoveToPoint(context, rightX, bottomY);
    CGContextAddLineToPoint(context, rightX, bottomY - hAngle);
    
    CGContextStrokePath(context);
}



//根据矩形区域，获取识别区域
+ (CGRect)getScanRectWithPreview:(UIView*)view style:(QuickQRCodeScanViewStyle*)style
{
    int XRetangleLeft = style.scanAreaMarginX;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft*2, view.frame.size.width - XRetangleLeft*2);
    
    if (style.whRatio != 1)
    {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / style.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height/2.0 - style.centerUpOffset;
    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft, YMinRetangle, sizeRetangle.width, sizeRetangle.height);
    
    
    //计算兴趣区域
    CGRect rectOfInterest;
    
    CGSize size = view.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用了1080p的图像输出
    if (p1 < p2)
    {
        CGFloat fixHeight = size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight, cropRect.origin.x/size.width, cropRect.size.height/fixHeight, cropRect.size.width/size.width);
    }
    else
    {
        CGFloat fixWidth = size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        rectOfInterest = CGRectMake(cropRect.origin.y/size.height, (cropRect.origin.x + fixPadding)/fixWidth, cropRect.size.height/size.height, cropRect.size.width/fixWidth);
    }
    
    
    return rectOfInterest;
}

//根据矩形区域，获取识别区域
+ (CGRect)getZXingScanRectWithPreview:(UIView*)view style:(QuickQRCodeScanViewStyle*)style
{
    int XRetangleLeft = style.scanAreaMarginX;
    CGSize sizeRetangle = CGSizeMake(view.frame.size.width - XRetangleLeft*2, view.frame.size.width - XRetangleLeft*2);
    
    if (style.whRatio != 1)
    {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / style.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = view.frame.size.height / 2.0 - sizeRetangle.height/2.0 - style.centerUpOffset;
    
    XRetangleLeft = XRetangleLeft/view.frame.size.width * 1080;
    YMinRetangle = YMinRetangle / view.frame.size.height * 1920;
    CGFloat width  = sizeRetangle.width / view.frame.size.width * 1080;
    CGFloat height = sizeRetangle.height / view.frame.size.height * 1920;
    
    //扫码区域坐标
    CGRect cropRect =  CGRectMake(XRetangleLeft, YMinRetangle, width,height);
    
    return cropRect;
}

@end
