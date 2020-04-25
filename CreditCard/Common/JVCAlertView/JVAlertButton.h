//
//  JVAlertButton.h
//  JVAlertView
//
//  Created by Joey on 15/12/31.
//  Copyright © 2015年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorWithRGB(R,G,B) [UIColor \
colorWithRed:((float)R)/255.0 \
green:((float)G)/255.0 \
blue:((float)B)/255.0 alpha:1.0]


typedef NS_ENUM(NSInteger,JVAlertButtonStyle) {
    JVAlertButtonStyleNegative = 0,
    JVAlertButtonStylePositive = 1,
    JVAlertButtonStyleDefault = 2,
};

@interface JVAlertButton : UIButton

@property (nonatomic,assign) JVAlertButtonStyle buttonStyle;

@property (nonatomic,strong) UIColor *positiveColor;
@property (nonatomic,strong) UIColor *negativeColor;


@end
