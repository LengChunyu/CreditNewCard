//
//  JVAlertView.h
//  JVAlertView
//
//  Created by Joey on 15/12/31.
//  Copyright © 2015年 Joey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JVAlertButton.h"
#import "UIView+ViewFrame.h"

// 监听对话框隐藏的消息
#define JVAlertViewHideNotification  @"JVAlertViewHideNotification"

enum XWAlertButtonType{
    XWAlertButtonType_sureAndCancle,
    XWAlertButtonType_Know,
};

typedef NS_ENUM(NSInteger,JVAlertViewStyle) {
    JVAlertViewStyleDefault = 0,
    JVAlertViewStyleEdit,
    JVAlertViewStyleTime,
    JVAlertViewStyleError,
    JVAlertViewStyleCustom,
    JVAlertViewStyleLoginAndPassword,
    JVAlertViewStyleNobtn
};
typedef NS_ENUM(NSInteger, headType) {
    
    headTypeShort = 0,
    
    headTypeLong = 1,
    
    headTypeNone = -1
    //headType==4时,代表只有一个确定按钮,并且是蓝色的长标题
};

typedef void(^ClickedButtonAtIndex)(NSInteger index);

@class JVAlertView;
@protocol JVAlertViewDelegate <NSObject>

- (void)alertView:(JVAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)dissMiss;

- (void)show;
//UIWindowLevelnormal
- (void)showMessage:(UIViewController *)viewController;

@end

@interface JVAlertView :UIView

@property(nonatomic,weak)id<JVAlertViewDelegate> delegate;
@property(nonatomic,assign) JVAlertViewStyle style;

@property (nonatomic,assign) BOOL userEditEnable;
@property (nonatomic,strong) UIColor *msgColor;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) NSString *editText;
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *password;
@property (nonatomic) NSInteger cancelButtonIndex;
@property (nonatomic,assign)NSString *title;
@property (nonatomic,assign)NSString *message;
@property (nonatomic,assign) BOOL isOnShowing;
@property (nonatomic,assign)BOOL isPlaying;
@property (nonatomic,retain)id target;
@property (nonatomic,assign)SEL action;
@property (nonatomic,assign)BOOL clickHidden;
@property (nonatomic,copy)ClickedButtonAtIndex clickedButtonAtIndex;

/**
 * 普通样式的
 */
- (id)initWithTitle:(NSString *)title headType:(int)headType
                 message:(NSString *)message
                delegate:(id<JVAlertViewDelegate>)delegate
             cancelTitle:(NSString *)cancel
              otherTitle:(NSString *)otherTitle;

/**
 *错误提示
 */
- (id)initWithErrorTitle:(NSString *)title headType:(int)headType
            message:(NSString *)message
           delegate:(id<JVAlertViewDelegate>)delegate
        cancelTitle:(NSString *)cancel
         otherTitle:(NSString *)otherTitle;

/**
 * 只有一个输入框
 */
- (id)initWithEdit:(NSString *)title headType:(int)headType
                     placeHolder:(NSString *)holder
                    delegate:(id<JVAlertViewDelegate>)delegate
                 cancelTitle:(NSString *)cancel
                  otherTitle:(NSString *)otherTitle;
/**
 *  自定义样式的
 */
- (id)initWithCustomStyle:(JVAlertViewStyle)style headType:(int)headType
                    Title:(NSString *)title
                  custom:(UIView*)custom
                 delegate:(id<JVAlertViewDelegate>)delegate
              cancelTitle:(NSString *)cancel
               otherTitle:(NSString *)otherTitle;

/**
 * 账号密码格式的
 */
- (id)initWithLoginAndPassword:(NSString *)title headType:(int)headType
                       message:(NSString *)message
            userPlaceHolder:(NSString *)userholder
            pwdPlaceHolder:(NSString *)pwdholder
               delegate:(id<JVAlertViewDelegate>)delegate
            cancelTitle:(NSString *)cancel
             otherTitle:(NSString *)otherTitle;



-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title view:(UIView *)view buttonType:(int)buttonType;

/**
 *  展示
 */
- (void)show:(UIViewController *)viewController;
-(void)changeAlertInterFaceOrientation;
//UIWindowLevelnormal
- (void)showMessage:(UIViewController *)viewController;
/**
 *  消失
 */
- (void)hide;

- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;


@end
