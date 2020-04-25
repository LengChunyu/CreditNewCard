//
//  DEMOTabBarViewController.h
//  CloudSEENew
//
//  Created by baoym on 16/4/20.
//  Copyright © 2016年 baoym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEMOTabBarViewController : UITabBarController
@property(nonatomic,assign) NSUInteger selectedIndexBefore;
+ (DEMOTabBarViewController *)shareDEMOHomeVC;
//- (void)showBadgeOnItemIndex:(int)index;   //显示小红点
//
//- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
