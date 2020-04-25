//
//  BYMNavigationController.m
//  SweetHome
//
//  Created by baoym on 15/12/8.
//  Copyright © 2015年 baoym. All rights reserved.
//

#import "BYMNavigationController.h"

@interface BYMNavigationController ()

@end

@implementation BYMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate {
    
    return [[self.viewControllers lastObject] shouldAutorotate];
}


-(NSUInteger)supportedInterfaceOrientations {
    
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    UIInterfaceOrientation origin = [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
    if (IOS_VERSION<IOS7 &&origin == UIInterfaceOrientationUnknown) {
        
        origin = UIInterfaceOrientationPortrait;
    }
    
    return origin;
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
