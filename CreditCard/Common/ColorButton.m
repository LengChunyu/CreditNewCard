//
//  ColorButton.m
//  btn
//
//  Created by LYZ on 14-1-10.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "ColorButton.h"
@implementation ColorButton

- (id)initWithFrame:(CGRect)frame FromColorArrayNormal:(NSMutableArray*)colorArrayNormal ColorArrayHighlight:(NSMutableArray*)colorArrayHighlight ByGradientType:(GradientType)gradientType cornerRadius:(int)cornerRadius
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *backImageNormal = [self buttonImageFromColors:colorArrayNormal ByGradientType:gradientType];
        [self setBackgroundImage:backImageNormal forState:UIControlStateNormal];
        UIImage *backImageHighlight = [self buttonImageFromColors:colorArrayHighlight ByGradientType:gradientType];
        [self setBackgroundImage:backImageHighlight forState:UIControlStateHighlighted];
        self.layer.cornerRadius = cornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (UIImage*) buttonImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case 0:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        case 1:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, 0.0);
            break;
        case 2:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(self.frame.size.width, self.frame.size.height);
            break;
        case 3:
            start = CGPointMake(self.frame.size.width, 0.0);
            end = CGPointMake(0.0, self.frame.size.height);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    return image;
}

@end

