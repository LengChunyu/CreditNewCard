//
//  BYMNavigationController.h
//  SweetHome
//
//  Created by baoym on 15/12/8.
//  Copyright © 2015年 baoym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYMNavigationController : UINavigationController
-(BOOL)shouldAutorotate ;

-(NSUInteger)supportedInterfaceOrientations ;

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation ;
@end
