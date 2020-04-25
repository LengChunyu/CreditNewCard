//
//  RepayViewController.h
//  CreditCard
//
//  Created by liujingtao on 2019/5/26.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import "BBGestureBaseController.h"
#import "AllConsumInfoModel.h"
@protocol RepayDataRefreshDelegate <NSObject>
-(void)customBackDelegateWithYearString:(NSString *)timeString;
@end
@interface RepayViewController : BBGestureBaseController
@property (nonatomic,weak) id<RepayDataRefreshDelegate> refreshDelegate;
@property (nonatomic,copy) NSString *accountNameS;
@property (nonatomic,copy) NSString *currentTime;
@property (nonatomic,assign) BOOL isEdit;                   //编辑状态
@property (nonatomic,strong) AllConsumInfoModel *infoModel; //需要修改的信息
@end
