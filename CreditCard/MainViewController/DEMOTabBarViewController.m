//
//  DEMOTabBarViewController.m
//  CloudSEENew
//
//  Created by baoym on 16/4/20.
//  Copyright © 2016年 baoym. All rights reserved.
//

#import "DEMOTabBarViewController.h"
#import "BBNavigationController.h"
#import "CardHomeViewController.h"
#import "ConsumeBillVC.h"
#define TabbarItemNums 2.0    //tabbar的数量
@interface DEMOTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation DEMOTabBarViewController
static DEMOTabBarViewController *demoHomeVC    = nil;
static int selectedIndex=0;
+ (DEMOTabBarViewController *)shareDEMOHomeVC
{
    @synchronized(self)
    {
        if (demoHomeVC == nil) {
            
            demoHomeVC = [[self alloc] init];
        }
        
        return demoHomeVC;
    }
}
//销毁单例
+ (DEMOTabBarViewController *)DEMOHomeVCDealloc{
    
    @synchronized(self)
    {
        if (demoHomeVC) {
            
            demoHomeVC = nil;
            
        }
        
        return demoHomeVC;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    [self initTabBarItem];
}
-(void)initTabBarItem{
    
    NSArray *imageArr = @[@"tab_device_unselect",@"tab_Store_n"];
    NSArray *selectImageArr = @[@"tab_device_select",@"tab_Store_s"];
    NSMutableArray *controllers=[[NSMutableArray alloc]init];
    NSArray *titleArray=@[@"卡片",@"记账"];
    for (int i=0; i<3; i++) {

        if(i==0){
            
            CardHomeViewController*VC = [[CardHomeViewController alloc]init];
            BBNavigationController *navigationController = [[BBNavigationController alloc] initWithRootViewController:VC];
            [controllers addObject:navigationController];
            navigationController.tabBarItem.title=titleArray[i];
            navigationController.tabBarItem.image = [[UIImage imageNamed:imageArr[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navigationController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else if(i==1){
            
            ConsumeBillVC *VC = [[ConsumeBillVC alloc] init];
            BBNavigationController *navigationController = [[BBNavigationController alloc] initWithRootViewController:VC];
            [controllers addObject:navigationController];
            navigationController.tabBarItem.title=titleArray[i];
            navigationController.tabBarItem.image = [[UIImage imageNamed:imageArr[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            navigationController.tabBarItem.selectedImage = [[UIImage imageNamed:selectImageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
    }
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x707082), NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0x50adfc),NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    CGRect frame = CGRectMake(0, 0, self.view.width,iphoneX||iphoneXR||iphoneXSM?83:49);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    v.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:v atIndex:0];
    //自定义tabbar上边的黑线的颜色
//    [self deleteTabbarLine];

    self.tabBar.opaque = YES;
    self.viewControllers=controllers;
}
//-(void)deleteTabbarLine{
//
//    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [self.tabBar setBackgroundImage:img];
//    [self.tabBar setShadowImage:img];
//
//    UILabel *lineV =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
//    lineV.backgroundColor =UIColorFromRGB(0xb9b9c3);
//    [self.tabBar addSubview:lineV];
//}
//-(void)BadgeOnItem{
//    if (self.selectedIndex == 2) {
//        return;
//    }
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"todayFirstLogin"]) {
//        [self showBadgeOnItemIndex:2];
//    }else{
//        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"touchItem"]) {
//            [self showBadgeOnItemIndex:2];
//        }else{
//
//            [self  hideBadgeOnItemIndex:2];
//        }
//
//
//    }
//
//
//
//}
//
//- (void)showBadgeOnItemIndex:(int)index{
//
//    //移除之前的小红点
//    [self removeBadgeOnItemIndex:index];
//
//    //新建小红点
//    UIView *badgeView = [[UIView alloc]init];
//    badgeView.tag = 888 + index;
//    badgeView.layer.cornerRadius = 4;
//    badgeView.backgroundColor = [UIColor redColor];
//    CGRect tabFrame = self.tabBar.frame;
//
//    //确定小红点的位置
//    float percentX = (index +0.65) / TabbarItemNums;
//    CGFloat x = ceilf(percentX * tabFrame.size.width);
//    CGFloat y = ceilf(0.2 * tabFrame.size.height);
//    badgeView.frame = CGRectMake(x, y, 8, 8);
//    [self.tabBar addSubview:badgeView];
//
//}
//
//- (void)hideBadgeOnItemIndex:(int)index{
//
//    //移除小红点
//    [self removeBadgeOnItemIndex:index];
//
//}
//
//- (void)removeBadgeOnItemIndex:(int)index{
//
//    //按照tag值进行移除
//    for (UIView *subView in self.tabBar.subviews) {
//
//        if (subView.tag == 888+index) {
//
//            [subView removeFromSuperview];
//
//        }
//    }
//}



- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

