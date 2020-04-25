//
//  AllConsumInfoModel.h
//  CreditCard
//
//  Created by liujingtao on 2019/3/8.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AllConsumInfoModel : NSObject

@property (nonatomic,copy) NSString *bankStyle;
@property (nonatomic,copy) NSString *bankNumber;
@property (nonatomic,copy) NSString *isCard;
@property (nonatomic,copy) NSString *everyConsume;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *year;
@property (nonatomic,copy) NSString *week;
@property (nonatomic,assign) BOOL isMarkTime;
@property (nonatomic,assign) BOOL isDrawLion;
@property (nonatomic,copy) NSString *daySumMoney;
@property (nonatomic,copy) NSString *moneyType;
@property (nonatomic,copy) NSString *dayIncomSumMoney;//每天的收入总数
@property (nonatomic,copy) NSString *accountBookName;//账本的名称（总版本没有名称）
@end


