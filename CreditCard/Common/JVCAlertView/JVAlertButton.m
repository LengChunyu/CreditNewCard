//
//  JVAlertButton.m
//  JVAlertView
//
//  Created by Joey on 15/12/31.
//  Copyright © 2015年 Joey. All rights reserved.
//

#import "JVAlertButton.h"

static const long defaultPositiveColor = 0x13CEA7;
static const long defaultNegativeColor = 0xffffff;
static const long defaultTextSize = 16.0f;

@implementation JVAlertButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)init{
    self = [super init];
    if (self) {
        [self setUpDefault];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setUpDefault{
    self.positiveColor = UIColorFromRGB(defaultPositiveColor);
    self.negativeColor = UIColorFromRGB(defaultNegativeColor);
}
/**
 * 设置按钮样式
 */
- (void)setButtonStyle:(JVAlertButtonStyle)buttonStyle{
    [self setUpDefault];
    _buttonStyle = buttonStyle;
    switch (buttonStyle) {
        case JVAlertButtonStyleDefault:
        case JVAlertButtonStyleNegative:
            //[self setBackgroundColor:self.negativeColor];
//            [self.layer setBorderWidth:0.5];
//            [self.layer setBorderColor:[UIColorFromRGB(0xd8d8de) CGColor]];
            [self setTitleColor:UIColorFromRGB(0x707082) forState:UIControlStateNormal];
            break;
        case JVAlertButtonStylePositive:
            //[self setBackgroundColor:self.negativeColor];
//            [self.layer setBorderWidth:0.5];
//            [self.layer setBorderColor:[UIColorFromRGB(0xd8d8de) CGColor]];
            [self setTitleColor:UIColorFromRGB(0x2c9efe) forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
}


@end
