//
//  CardDataFMDB.h
//  CreditCard
//
//  Created by liujingtao on 2019/1/10.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardDataFMDB : NSObject
//单例
+(instancetype)shareSqlite;
#pragma mark-查询相应的方法
//首先查询信息方法
-(NSMutableArray *)queryRecordsFromCardInfoCardNumber;
//查询所有的消费
-(NSMutableArray *)queryRecordsFromConsumInfoCardNumber:(NSString *)cardNumberString;
//查询All所有的消费
-(NSMutableArray *)queryRecordsFromAllConsumInfo;
//查询当前年分的数据
-(NSMutableArray *)queryRecordsFromConsumInfoYearString:(NSString *)yearString;
//根据账本名称查询的数据/也可以根绝年份和账本名称一起查看
-(NSMutableArray *)queryRecordsFromConsumInfoAccountName:(NSString *)accountNameString withYear:(NSString *)yearString;
//查询未核算的消费
-(NSMutableArray *)queryNoUsedRecordsFromConsumInfoCardNumber:(NSString *)cardNumberString withMonth:(NSString *)monthString withYear:(NSString *)yearString;
//查询每一笔还款
-(NSMutableArray *)queryRecordsFromRepaymentCardNumber:(NSString *)cardNumberString;
#pragma mark-删除相应的数据方法
//删除信用卡的详情
-(void)delRecordFromCardInfoData:(NSString *)numberString;
//删除花销账单的方法
-(void)delRecordFromConsumeData:(NSString *)numberString withTime:(NSString *)timeString isAll:(BOOL)isAll;
//删除all花销账单的方法
-(void)delRecordFromAllConsumeData:(NSString *)numberString withTime:(NSString *)timeString;
//删除整个账本下的详情
-(void)delRecordFromAllAccountData:(NSString *)accountName;
//删除还款记录
-(void)delRecordFromRepaymentData:(NSString *)numberString withTime:(NSString *)timeString isAll:(BOOL)isAll;
//删除账本信息
-(void)delAccountBookData:(NSString *)accountName;
#pragma mark-插入相应的数据方法
//添加信用卡信息
-(void)addRecordToCardInfoTable:(NSDictionary *)dict;
//添加花费信息
-(void)addRecordToConsumeTable:(NSDictionary *)dict;
//添加All花费信息
-(void)addRecordToAllConsumeTable:(NSDictionary *)dict;
//添加还款信息
-(void)addRecordToRepaymentTable:(NSDictionary *)dict;
//更新卡的信息
-(void)updateCardInfo:(NSDictionary *)infoDic;
//更新卡的提醒日期和状态
-(void)updateCardNotice:(NSDictionary *)noticeDic;
#pragma mark-关于账本的方法
//添加账本
-(void)addRecordToAccountBook:(NSDictionary *)dict;
//删除账本信息
-(void)delAccountBookData:(NSString *)accountName;
//查询账本信息
-(NSMutableArray *)queryAccountBookList:(NSString *)accountNameString;
//更新支出和收入的信息
-(void)upDateConsumeAndIncome:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
