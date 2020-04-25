//
//  CardInfoModel.h
//  CreditCard
//
//  Created by liujingtao on 2019/1/15.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardInfoModel : NSObject

@property (nonatomic,copy) NSString *bankStyle;        //银行名称
@property (nonatomic,copy) NSString *bankNumber;       //银行卡号
@property (nonatomic,copy) NSString *dueDate;          //还款日
@property (nonatomic,copy) NSString *dueDateMoney;     //还款金额
@property (nonatomic,copy) NSString *lastDueDateMoney; //还款金额
@property (nonatomic,copy) NSString *billDate;         //账单日
@property (nonatomic,copy) NSString *availabilityLimit;//剩余额度
@property (nonatomic,copy) NSString *limitNumber;      //总额度
@property (nonatomic,copy) NSString *arrears;          //欠款
@property (nonatomic,copy) NSString *month;            //记录卡信息的月份
@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *dueDateDay;       //账单日到还款日的天数

@property (nonatomic,copy) NSString *isOpenDueNotice;  //是否开启了还款提醒
@property (nonatomic,copy) NSString *isOpenBillNotice; //是否开启了账单提醒
@property (nonatomic,copy) NSString *dueNoticeDate;    //还款的提醒日期（默认就是还款日）
@property (nonatomic,copy) NSString *billNoticeDate;   //账单日提醒日期（默认就是账单日）


@end
