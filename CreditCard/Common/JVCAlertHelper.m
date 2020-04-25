//
//  JVCAlertHelper.m
//  CloudSEE_II
//
//  Created by Yanghu on 9/24/14.
//  Copyright (c) 2014 Yanghu. All rights reserved.
//

#import "JVCAlertHelper.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
static  const    double animation               =   20;
static  const    double TimerMax                =   3;

static  const   NSTimeInterval TIMERDURATION    = 1;//让toast自动消失的时间

@interface JVCAlertHelper ()
{
    
    MBProgressHUD *HUD;

}

@end
@implementation JVCAlertHelper
@synthesize alertViewIos7;

static JVCAlertHelper *shareAlertHelper = nil;

/**
 *  单例
 *
 *  @return 返回JVCAlertHelper 对象
 */
+(JVCAlertHelper *)shareAlertHelper
{
    @synchronized(self)
    {
        if (shareAlertHelper == nil) {
            
            shareAlertHelper = [[self alloc] init];
        }
        
        return shareAlertHelper;
    }
    
    return shareAlertHelper;

}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (shareAlertHelper == nil) {
            
            shareAlertHelper = [super allocWithZone:zone];
            
            return shareAlertHelper;
        }
    }
    
    return nil;
}

#pragma mark 系统的alert
/**
 *  只有message的提示
 */
- (void)alertWithMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:nil
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil, nil];
    self.alertViewIos7 = alertView;
    [alertView show];
    [alertView release];

}

/**
 *  带标题以及消息的alert
 */
- (void)alertWithTitile:(NSString *)title  andMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:nil
                              cancelButtonTitle:@"确定"
                              otherButtonTitles: nil];
    self.alertViewIos7 = alertView;

    [alertView show];
    [alertView release];
}

#pragma mark  toast
/**********************安卓toast显示**********************************/
/**
 *    显示在viewcontroller上面的toast，2秒后自动消失
 *
 *  @param viewController 显示的viewcontroler
 *  @param message        显示的内容
 */
- (void)alertToastWithController:(UIViewController *)viewController  andMessage:(NSString *)message
{
    [self alertHidenToastOnWindow];
    if (viewController==nil  || viewController.view==nil) {
      viewController=[(AppDelegate *)[UIApplication sharedApplication].delegate getTopViewController];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
	hud.mode = MBProgressHUDModeText;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 0.0f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:NO afterDelay:TIMERDURATION];
    
}


/**
 *  再keywindow上显示文字
 *
 *  @param message 显示的文字
 */
- (void)alertToastWithKeyWindowWithMessage:(NSString *)message
{
    [self alertHidenToastOnWindow];
    
    NSInteger stringLength = [message lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    double timerAnimation = stringLength/animation;
    if (timerAnimation>TimerMax) {
        timerAnimation = TimerMax;
    }else if(timerAnimation <1)
    {
        timerAnimation = 1;
    }
        
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
	hud.labelText = message;
    hud.tag = HUDTAG;
	hud.margin = 10.f;
	hud.yOffset = 0.0f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:NO afterDelay:timerAnimation];
}

/**
 *  再keywindow上显示文字
 *
 *  @param message 显示的文字
 *
 *  @timer 消失时间
 */
- (void)alertToastWithMessage:(NSString *)message  andTimer:(NSTimeInterval )timer
{
    [self alertHidenToastOnWindow];
    
    NSInteger stringLength = [message lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    double timerAnimation = stringLength/animation;
    if (timerAnimation>TimerMax) {
        timerAnimation = TimerMax;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
	hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoomOut;
	hud.labelText = message;
	hud.margin = 10.f;
	hud.yOffset = 0.0f;
	hud.removeFromSuperViewOnHide = YES;
	[hud hide:NO afterDelay:timerAnimation];
}

/**
 *  再keywindow上显示文字,主线程
 *
 *  @param message 显示的文字
 */
- (void)alertToastMainThreadOnWindow:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSInteger stringLength = [message lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        
        double timerAnimation = stringLength/animation;
        if (timerAnimation>TimerMax) {
            timerAnimation = TimerMax;
        }else if (timerAnimation<1.0) {
            timerAnimation = 1.5;
        }
        NSLog(@"timerAnimation======%f",timerAnimation);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.animationType = MBProgressHUDAnimationZoomOut;
        hud.labelText = message;
        hud.margin = 10.f;
        hud.yOffset = 0.0f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:NO afterDelay:timerAnimation];
        
    });
}

/**
 *    显示在viewcontroller上面的toast，
 *
 *  @param viewController 显示的viewcontroler
 */
- (void)alertToastWithController:(UIView *)viewControllerView  {
    
    [self alertHidenToastOnWindow];
    MBProgressHUD *hub = (MBProgressHUD *)[viewControllerView viewWithTag:HUDTAG];
    if (!hub) {
        
        hub = [MBProgressHUD showHUDAddedTo:viewControllerView animated:YES];
        
    }
    hub.tag = HUDTAG;
    [viewControllerView bringSubviewToFront:hub];
}

/**
 *  在window上显示hub
 */
- (void)alertShowToastOnWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hub = (MBProgressHUD *)[window viewWithTag:HUDTAG];
    if (!hub) {
        
        hub = [MBProgressHUD showHUDAddedTo:window animated:YES];
        
    }
    [window bringSubviewToFront:hub];
    hub.tag = HUDTAG;
    
}


/**
 *  在window上隐藏hub
 */
-(void)alertHidenToastOnWindow
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *view  = [window viewWithTag:HUDTAG];
    if (view) {
        MBProgressHUD *hub = (MBProgressHUD *)view;
        if (hub) {
            [hub removeFromSuperview];
        }
    }
}

/**
 *  再window上显示用户等待框加文字
 *
 *  @param textString 文字
 *  @param timerDelay 时间
 */
-(void)alertToastOnWindowWithText:(NSString *)textString  delayTime:(int)timerDelay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    
    hud.labelText = textString;
    
    hud.tag = HUDTAG;
	
    [hud hide:NO afterDelay:timerDelay];
}
///处理ios8 aletview的问题
- (void)alertControllerWithTitle:(NSString *)title
                        delegate:(id)delegate
                    selectAction:(SEL)selectActon
                    cancelAction:(SEL)cancelActon
                     selectTitle:(NSString *)selectTitle
                     cancelTitle:(NSString *)titlecancel
                       alertTage:(int) alertTage
{
    
    if (IOS8) {
        
        UIAlertController *controlAlert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        if (selectTitle !=nil) {
            
            [controlAlert addAction:[UIAlertAction actionWithTitle:selectTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (selectActon !=nil && delegate !=nil) {
                    
                    [delegate performSelector:selectActon withObject:nil];

                }
                
            }]];
        }
       
        if (titlecancel!=nil) {
            
            [controlAlert addAction:[UIAlertAction actionWithTitle:titlecancel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (cancelActon !=nil && delegate !=nil) {
                    
                    [delegate performSelector:cancelActon withObject:nil];
                    
                }

            }]];
        }
        
        
        if ([delegate isKindOfClass:[UIViewController class]]) {
            
            [delegate presentViewController:controlAlert animated:YES completion:nil];
            
        }else{
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate.window.rootViewController  presentViewController:controlAlert animated:YES completion:nil];
        }
        
    }else{
        
        if (self.alertViewIos7) {
            
            [self.alertViewIos7 dismissWithClickedButtonIndex:0 animated:NO];
            self.alertViewIos7  = nil;
        }
        
        if (alertTage !=  KTagDealWithSelf) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:delegate cancelButtonTitle:selectTitle otherButtonTitles:titlecancel, nil];
            [alertView show];
            self.alertViewIos7 = alertView;
            alertView.delegate = delegate;
            alertView.tag = alertTage;
            [alertView release];
            
        }else{
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:selectTitle otherButtonTitles:titlecancel, nil];
            [alertView show];
            self.alertViewIos7 = alertView;
            alertView.tag = alertTage;
            [alertView release];
        }
       
    }
    
}
/**
 *  关闭alertview
 */
- (void)closeAlertViewIos7
{
    if (self.alertViewIos7) {
        
        [self.alertViewIos7 dismissWithClickedButtonIndex:0 animated:NO];
        self.alertViewIos7  = nil;
    }
    
}

- (void)dealloc {
    
    [alertViewIos7 release];
    [super dealloc];
}

@end
