//
//  PasswordButton.m
//  Gesture
//
//  Created by 袁斌 on 15/11/6.
//  Copyright © 2015年 yinbanke. All rights reserved.
//

#import "PasswordButton.h"
#import "JVAlertButton.h"
static const long Color_mainGreen = 0x21c9b8;
@implementation PasswordButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect bounds = self.bounds;
    if (_selected) {//在画的时候
        if (_success) {//验证成功的
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextSetFillColorWithColor(context, UIColorFromRGB(Color_mainGreen).CGColor);
        }
        else {//验证失败
            CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextSetFillColorWithColor(context, UIColorFromRGB(0xff6666).CGColor);
        }
        CGRect frame = CGRectMake((bounds.size.width-12)/2, (bounds.size.width-12)/2, 12, 12);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
    }
    else{
        
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        CGContextSetFillColorWithColor(context, UIColorFromRGB(0xdee0e4).CGColor);
        CGRect frame = CGRectMake((bounds.size.width-12)/2, (bounds.size.width-12)/2, 12, 12);
        
        CGContextAddEllipseInRect(context,frame);
        CGContextFillPath(context);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);//线条颜色
    }
    
    CGContextSetLineWidth(context,2);
    CGRect frame = CGRectMake(2, 2, bounds.size.width-3, bounds.size.height-3);
    CGContextAddEllipseInRect(context,frame);
    CGContextStrokePath(context);
    if (_success) {
        
        CGContextSetRGBFillColor(context,30/255.f, 175/255.f, 235/255.f,0.000001);
    }
    else {
        CGContextSetRGBFillColor(context,208/255.f, 36/255.f, 36/255.f,0.000001);
    }
    CGContextAddEllipseInRect(context,frame);
    if (_selected) {
        CGContextFillPath(context);
    }
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
