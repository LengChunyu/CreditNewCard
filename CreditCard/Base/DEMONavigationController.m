//
//  DEMONavigationController.m
//  REFrostedViewControllerExample
//
//  Created by Roman Efimov on 9/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMONavigationController.h"
@interface DEMONavigationController ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIPanGestureRecognizer *fullScreenPopPanGesture;
@end

@implementation DEMONavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置导航栏的颜色
    NSMutableArray *colorArrayNormal = [@[UIColorFromRGB(0x2c9efe),UIColorFromRGB(0x50adfc)] mutableCopy];
    
    UIImage *bgImage = [CardCreatImage creatImageFromColors:colorArrayNormal ByGradientType:leftToRight withFrame:CGRectMake(0, 0, self.view.width, 64)];
    [[UINavigationBar appearance] setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    //设置导航栏标题的颜色和字体大小
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self addFullScreenPopPanGesture];
}
- (void)addFullScreenPopPanGesture{
    
    self.fullScreenPopPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    self.fullScreenPopPanGesture.delegate = self;
    [self.view addGestureRecognizer:self.fullScreenPopPanGesture];
    [self.interactivePopGestureRecognizer requireGestureRecognizerToFail:self.fullScreenPopPanGesture];
    self.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isEqual:self.fullScreenPopPanGesture]) {
        //获取手指移动后的相对偏移量
        CGPoint translationPoint = [self.fullScreenPopPanGesture translationInView:self.view];
        //向右滑动 && 不是跟视图控制器
        if (translationPoint.x > 0 && self.childViewControllers.count > 1) {
            return YES;
        }
        return NO;
    }
    return YES;
    
}

//
//
//#pragma mark -
//#pragma mark Gesture recognizer
//
//- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
//{
//    UINavigationController *navigationController = (UINavigationController *)self.frostedViewController.contentViewController;
//    if ([navigationController.topViewController isKindOfClass:NSClassFromString(@"DEMOHomeViewController")]) {
//        [self.frostedViewController panGestureRecognized:sender];
//    }
//    
//}

@end
