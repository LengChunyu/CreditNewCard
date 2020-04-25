//
//  AddAccoutBookViewController.h
//  CreditCard
//
//  Created by liujingtao on 2019/6/4.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import "BBGestureBaseController.h"

@protocol  AddAccountBookDelegate <NSObject>
-(void)addAccountBookFinishBack;
@end
@interface AddAccoutBookViewController : BBGestureBaseController
@property (nonatomic,weak) id<AddAccountBookDelegate> callBackDelegate;
@property (nonatomic,strong) NSArray *allAccountBookArray;
@end

