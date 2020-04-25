//
//  AddCardViewController.h
//  CreditCard
//
//  Created by liujingtao on 2019/1/27.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "BBGestureBaseController.h"
#import "CardInfoModel.h"
@interface AddCardViewController : BBGestureBaseController

@property (nonatomic,copy)void(^RefreshTableViewBlock)(void);
@property (nonatomic,strong) CardInfoModel *cardInfoModel;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,assign) int dueDate;
@property (nonatomic,assign) int nextDueDate;

@end
