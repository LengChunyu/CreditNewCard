//
//  BaseViewController.h
//  SweetHome
//
//  Created by David on 15/10/15.
//  Copyright (c) 2015年 baoym. All rights reserved.
//


#import "BaseViewController.h"
//#import "DEMONavigationController.h"
@interface BaseViewController (){

    BOOL  isViewDidDisappear; //判断视图是否可见
}

@end

@implementation BaseViewController
@synthesize tenCentKey;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        /**
         *  解决父类UIViewController带导航条添加ScorllView坐标系下沉64像素的问题（ios7）
         
         */
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setLeftBarItem];
    if (IOS7||IOS8) { // 判断是否是IOS7
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
        
    }
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(back) name:@"backToRootView" object:nil];
    [self getLineViewInNavigationBar:self.navigationController.navigationBar].hidden = YES;
}
- (void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSString* page = NSStringFromClass([self class]);
    NSLog(@"page:%@",page);
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
}
-(void)setLeftBarItem{
    
    if (self.navigationController.viewControllers.count != 1) {
        
        //菜单按钮
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame=CGRectMake(0, 0, 30, 30);
        [button setImage:[UIImage imageNamed:@"nav_back_n"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(BackClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:button];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -5;//这个数值可以根据情况自由变化
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, left];
    }
}

-(void)BackClick{
    NSLog(@"返回键");
    
    [self.navigationController popViewControllerAnimated:NO];
}
//设置导航栏有按钮
-(void)setRightItemWithImage:(NSString *)rightImageString{
    //菜单按钮
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 30, 30);
    [button setImage:[UIImage imageNamed:rightImageString] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)rightBarClicked:(UIButton *)sender{
    
    
    
}
//iOS 5
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIDeviceOrientationPortrait);
    
}
//iOS 6
- (BOOL) shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)setupObservers
{
    NSNotificationCenter *def = [NSNotificationCenter defaultCenter];
    [def addObserver:self
            selector:@selector(applicationDidEnterForeground:)
                name:UIApplicationDidBecomeActiveNotification
              object:[UIApplication sharedApplication]];
    [def addObserver:self
            selector:@selector(applicationDidEnterBackground:)
                name:UIApplicationWillResignActiveNotification
              object:[UIApplication sharedApplication]];
}
- (void)unSetupObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//进入前台
- (void)applicationDidEnterForeground:(NSNotification *)notification
{
    NSLog(@"DidEnterForeground******************");
    [self enterForeground];
}

-(void)enterForeground{
    
}
//进入后台
- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [self enterBackground];
}

-(void)enterBackground{
    
}
-(void)dealloc{
    
    [self setupObservers];
    
}
- (void)setControllerOrientation:(int)Orientation{
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val;
        if(Orientation==0){
            
            val= UIInterfaceOrientationPortrait;
            
        }else{
            
            val= UIInterfaceOrientationLandscapeRight;
            
        }
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}
@end
