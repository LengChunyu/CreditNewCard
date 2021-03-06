//
//  JVCAlertHelper.h
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>


static const int  KTagDealWithSelf    = 1028323;//本身处理的tag
static  const    int    HUDTAG                  =   54545554;//HUd的tag

@interface JVCAlertHelper : NSObject<MBProgressHUDDelegate>
{
    UIAlertView *alertViewIos7;
}
@property(nonatomic,retain)UIAlertView *alertViewIos7;
/**
 *  单例
 *
 *  @return 返回JVCAlertHelper 对象
 */
+(JVCAlertHelper *)shareAlertHelper;

#pragma mark 系统的alert
/**
 *  只有message的提示
 */
- (void)alertWithMessage:(NSString *)message;

/**
 *  带标题以及消息的alert
 */
- (void)alertWithTitile:(NSString *)title  andMessage:(NSString *)message;

#pragma mark  toast
/**********************安卓toast显示**********************************/
/**
 *    显示在viewcontroller上面的toast，2秒后自动消失
 *
 *  @param viewController 显示的viewcontroler
 *  @param message        显示的内容
 */
- (void)alertToastWithController:(UIViewController *)viewController  andMessage:(NSString *)message;

- (void)alertToastWithController11:(UIViewController*)view  andMessage:(NSString *)message;
/**
 *  再keywindow上显示文字
 *
 *  @param message 显示的文字
 */
- (void)alertToastWithKeyWindowWithMessage:(NSString *)message;

/**
 *    显示在viewcontroller上面的toast，
 *
 *  @param viewController 显示的viewcontroler
 */
- (void)alertToastWithController:(UIView *)viewControllerView;

/**
 *  在window上显示hub
 */
- (void)alertShowToastOnWindow;

/**
 *  在window上隐藏hub
 */
-(void)alertHidenToastOnWindow;

/**
 *  再window上显示用户等待框加文字
 *
 *  @param textString 文字
 *  @param timerDelay 时间
 */
-(void)alertToastOnWindowWithText:(NSString *)textString  delayTime:(int)timerDelay;

/**
 *  判断网路状态,里面带有return
 */
- (BOOL)predicateNetWorkState;

/**
 *  再keywindow上显示文字,主线程
 *
 *  @param message 显示的文字
 */
- (void)alertToastMainThreadOnWindow:(NSString *)message;

/**
 *  再keywindow上显示文字
 *
 *  @param message 显示的文字
 *
 *  @timer 消失时间
 */
- (void)alertToastWithMessage:(NSString *)message  andTimer:(NSTimeInterval )timer;


///处理ios8 aletview的问题
- (void)alertControllerWithTitle:(NSString *)title
                        delegate:(id)delegate
                    selectAction:(SEL)selectActon
                    cancelAction:(SEL)cancelActon
                     selectTitle:(NSString *)selectTitle
                     cancelTitle:(NSString *)titlecancel
                       alertTage:(int) alertTage;


/**
 *  关闭alertview
 */
- (void)closeAlertViewIos7;
@end
