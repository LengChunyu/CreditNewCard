//
//  RepaymentViewController.h
//  CreditCard
//
//  Created by liujingtao on 2019/2/18.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "BBGestureBaseController.h"
#import "CardInfoModel.h"
@protocol RefreshCardInfoDelegate <NSObject>
-(void)saveButtonClickDelegateBankNumber:(NSString *)bankNumber withIndexPath:(NSIndexPath *)indexPath;
@end
@interface RepaymentViewController : BBGestureBaseController

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) CardInfoModel *cardModel;
@property (nonatomic,copy) NSString *monthDueString;
@property (nonatomic,copy) NSString *nextMonthDueString;
@property (nonatomic,weak) id<RefreshCardInfoDelegate> delegate;
@end
