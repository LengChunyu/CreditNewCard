//
//  JVCControlFactory.m
//  CloudSEENew
//
//  Created by David on 16/5/10.
//  Copyright © 2016年 baoym. All rights reserved.
//
/*
 这个类就可以为我们专门来创建一些基本的控件，那么如果要创建Label button textField 就可以通过这个类来创建
 这个类好像一个工厂一样专门生产一些基本控件
 类似于工厂设计模式
 */
#import "JVCControlFactory.h"

@implementation JVCControlFactory

+ (UILabel *)creatLabelWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor{

    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = backgroundColor;
    return label;
    
}
+ (UILabel *)creatLabelWithFrame:(CGRect)frame text:(NSString *)text font:(UIFont *)font textColor:(UIColor *)textColor target:(id)target action:(SEL)action{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    
    if(target){
    
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
        tapClick.numberOfTapsRequired=1;
        tapClick.numberOfTouchesRequired=1;
        tapClick.delegate = target;
        [label addGestureRecognizer:tapClick];
        
    }
    
    return label;
}
#pragma mark - 添加的方法
+ (UILabel *)creatLabelWithFrame:(CGRect)frame textOne:(NSString *)textOne textTow:(NSString *)textTow font:(UIFont *)font textOneColor:(UIColor *)textOneColor textTowColor:(UIColor *)textTowColor target:(id)target action:(SEL)action{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = [textOne stringByAppendingString:textTow];
    label.font = font;
    label.backgroundColor = [UIColor clearColor];

    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];

    NSRange rangeOne = NSMakeRange(0, textOne.length-1);
    NSRange rangeTow = NSMakeRange(textOne.length, textTow.length);
    [str addAttribute:NSForegroundColorAttributeName value:textOneColor range:rangeOne];//(0,7)
    [str addAttribute:NSForegroundColorAttributeName value:textTowColor range:rangeTow];//(8,4)
    label.attributedText = str;
    if(target){
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapClick=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
        tapClick.numberOfTapsRequired=1;
        tapClick.numberOfTouchesRequired=1;
        tapClick.delegate = target;
        [label addGestureRecognizer:tapClick];
        
    }
    
    return label;
}

//+ (UIButton *)
#pragma mark -

+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag colorArrNormal:(NSMutableArray *)colorArrNormal colorArrHighlight:(NSMutableArray *)colorArrHighlight  ByGradientType:(GradientType)gradientType cornerRadius:(int)cornerRadius{
    
    ColorButton *button = [[ColorButton alloc]initWithFrame:frame FromColorArrayNormal:colorArrNormal ColorArrayHighlight:colorArrHighlight ByGradientType:gradientType cornerRadius:cornerRadius];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return  button;
}

+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag colorArrNormal:(NSMutableArray *)colorArrNormal colorArrHighlight:(NSMutableArray *)colorArrHighlight  ByGradientType:(GradientType)gradientType{
    
    ColorButton *button = [[ColorButton alloc]initWithFrame:frame FromColorArrayNormal:colorArrNormal ColorArrayHighlight:colorArrHighlight ByGradientType:gradientType cornerRadius:5];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return  button;

}
+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag backgroundColor:(UIColor*)backgroundColor{
    
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:backgroundColor];
    return  button;
}

+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag normalBackgroundImage:(UIImage *)normalBackgroundImage highlightedBackgroundImage:(UIImage *)highlightedBackgroundImage{
    
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
    return  button;
}
+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag normalBackgroundImage:(UIImage *)normalBackgroundImage selectedBackgroundImage:(UIImage *)selectedBackgroundImage{
    
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setImage:normalBackgroundImage forState:UIControlStateNormal];
    [button setImage:selectedBackgroundImage forState:UIControlStateSelected];
    return  button;
}
+ (UITextField *)creatTextFieldWithFrame:(CGRect)frame placeHolder:(NSString *)string delegate:(id<UITextFieldDelegate>)delegate tag:(NSInteger)tag textColor:(UIColor*)textColor placeholderTextColor:(UIColor*)placeholderTextColor{
    
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];

    textField.placeholder = string;
    //设置代理
    textField.delegate = delegate;
    //设置tag值
    textField.tag = tag;
    //设置颜色
    textField.textColor = textColor;
    //设置
    if(placeholderTextColor){
        
        [textField setValue:placeholderTextColor forKeyPath:@"_placeholderLabel.textColor"];
    
    }
    return textField;
    
}

+ (UIImageView *)creatImageViewWithFrame:(CGRect)frame image:(NSString *)imageName{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:imageName];
    return imageView;
}
+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage {
    
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    return  button;
}
/*
 设置Button图片normal/highlighted
 **/
+ (UIButton *)creatButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)sel tag:(NSInteger)tag normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage {
    
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    return  button;
}
@end
