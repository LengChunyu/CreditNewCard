//
//  JVCControlFactory.h
//  CloudSEENew
//
//  Created by David on 16/5/10.
//  Copyright © 2016年 baoym. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorButton.h"
@interface JVCControlFactory : NSObject

+ (UILabel *)creatLabelWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor;
+ (UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor target:(id)target action:(SEL)action;
+ (UILabel *)creatLabelWithFrame:(CGRect)frame textOne:(NSString *)textOne textTow:(NSString *)textTow font:(UIFont *)font textOneColor:(UIColor *)textOneColor textTowColor:(UIColor *)textTowColor target:(id)target action:(SEL)action;
/**
 
 */
+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag colorArrNormal:(NSMutableArray *)colorArrNormal colorArrHighlight:(NSMutableArray *)colorArrHighlight  ByGradientType:(GradientType)gradientType;
/**
 backgroundColor
 */
+ (UIButton *)creatButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                            target:(id)target
                            action:(SEL)sel
                               tag:(NSInteger)tag backgroundColor:(UIColor*)backgroundColor;
/**
 highlightedBackgroundImage
 */
+ (UIButton *)creatButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                            target:(id)target
                            action:(SEL)sel
                               tag:(NSInteger)tag normalBackgroundImage:(UIImage *)normalBackgroundImage highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage;
/**
 selectedBackgroundImage
 */
+ (UIButton *)creatButtonWithFrame:(CGRect)frame
                             title:(NSString *)title
                            target:(id)target
                            action:(SEL)sel
                               tag:(NSInteger)tag normalBackgroundImage:(UIImage *)normalBackgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage;
/**
 placeholderTextColor
 */
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame
                             placeHolder:(NSString *)string
                                delegate:(id <UITextFieldDelegate>)delegate
                                     tag:(NSInteger)tag textColor:(UIColor*)textColor placeholderTextColor:(UIColor*)placeholderTextColor;
/**
 imageName
 */
+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame
                                   image:(NSString *)imageName;
/**
 ByGradientType
 */
+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag colorArrNormal:(NSMutableArray *)colorArrNormal colorArrHighlight:(NSMutableArray *)colorArrHighlight  ByGradientType:(GradientType)gradientType cornerRadius:(int)cornerRadius;
/**
 create normalImage/selectedImage
 */
+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage;
/**
 设置Button图片normal/highlighted
 **/
+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage;
@end
