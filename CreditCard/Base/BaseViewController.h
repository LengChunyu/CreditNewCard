//
//  BaseViewController.h
//  SweetHome
//
//  Created by David on 15/10/15.
//  Copyright (c) 2015年 baoym. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XWRGBHelper.h"

@interface BaseViewController : UIViewController <UIGestureRecognizerDelegate>
{
    NSString *tenCentKey;
}
@property(nonatomic,retain)  NSString *tenCentKey;
//设置导航栏有按钮
- (void)setRightItemWithImage:(NSString *)rightImageString;
- (void)rightBarClicked;
- (void)BackClick;
- (void)setControllerOrientation:(int)Orientation;
@end
