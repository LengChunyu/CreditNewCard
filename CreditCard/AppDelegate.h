//
//  AppDelegate.h
//  CreditCard
//
//  Created by liujingtao on 2019/1/8.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBGestureBaseController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) BBGestureBaseView *gestureBaseView;
@property (strong, nonatomic) UIWindow *window;
+ (AppDelegate* )shareAppDelegate;
- (UIViewController *)getTopViewController;
@end

