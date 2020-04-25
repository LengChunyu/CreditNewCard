//
//  AccountBookViewController.h
//  CreditCard
//
//  Created by liujingtao on 2019/6/3.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import "BBGestureBaseController.h"
#import "AccountBookModel.h"
@protocol SelectAccountBackDelegate <NSObject>
-(void)accoutBackSelectModel:(AccountBookModel *)selectModel withIsReload:(BOOL)isReload;
@end
@interface AccountBookViewController : BBGestureBaseController
@property (nonatomic,weak) id<SelectAccountBackDelegate> accountBackDelegate;
@property (nonatomic,copy) NSString *titleString;
@end
