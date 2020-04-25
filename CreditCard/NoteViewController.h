//
//  NoteViewController.h
//  CreditCard
//
//  Created by liujingtao on 2019/3/30.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "BBGestureBaseController.h"
#import "AllConsumInfoModel.h"
@protocol AddDataRefreshDelegate <NSObject>
-(void)customBackDelegateWithYearString:(NSString *)timeString;
@end
@interface NoteViewController : BBGestureBaseController
@property (nonatomic,weak) id<AddDataRefreshDelegate> refreshDelegate;
@property (nonatomic,copy) NSString *accountNameS;
@property (nonatomic,copy) NSString *currentTime;
@property (nonatomic,assign) BOOL isEdit;                   //编辑状态
@property (nonatomic,strong) AllConsumInfoModel *infoModel; //需要修改的信息

@end
