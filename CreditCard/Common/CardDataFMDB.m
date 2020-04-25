//
//  CardDataFMDB.m
//  CreditCard
//
//  Created by liujingtao on 2019/1/10.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "CardDataFMDB.h"
#import "FMDatabase.h"
#import "CardInfoModel.h"
#import "ConsumInfoModel.h"
#import "AllConsumInfoModel.h"
#import "AccountBookModel.h"
@interface CardDataFMDB()

@property (nonatomic,strong) FMDatabase *db;
@property (nonatomic,copy) NSString *cardInfo;
@property (nonatomic,copy) NSString *cardName;
@property (nonatomic,copy) NSString *consumeName;
@property (nonatomic,copy) NSString *allConsumeName;
@property (nonatomic,copy) NSString *repaymentName;
@property (nonatomic,copy) NSString *accountBook;
@property (nonatomic, strong) NSLock *lock;
@end
@implementation CardDataFMDB
#pragma mark-开启相应的sqlite
//单例
+(instancetype)shareSqlite{
    
    static CardDataFMDB *cardSqlite = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        cardSqlite =[[CardDataFMDB alloc] init];
        [cardSqlite openDB];
    });
    return cardSqlite;
}
-(instancetype)init{
    
    if (self =[super init]) {
        
        self.cardInfo =@"cardInfoSqlite";
        self.cardName =@"cardInfo";
        self.consumeName =@"consumInfo";
        self.repaymentName =@"repaymentInfo";
        self.allConsumeName =@"allConsumInfo";
        self.accountBook =@"accountBook";
    }
    return self;
}
-(void)openDB{
    
    NSString *doc=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:self.cardInfo];
    self.db =[FMDatabase databaseWithPath:fileName];
    if ([self.db open]) {
        //打开数据库成功创建数据列表
        //卡详情 isOpenDueNotice-isOpenBillNotice-dueNoticeDate-billNoticeDate
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,bankStyle TEXT,bankNumber TEXT,dueDate TEXT,dueDateMoney TEXT,lastDueDateMoney TEXT,billDate TEXT,availabilityLimit TEXT,limitNumber TEXT,arrears TEXT,month TEXT,year TEXT,dueDateDay TEXT,isOpenDueNotice TEXT,isOpenBillNotice TEXT,dueNoticeDate TEXT,billNoticeDate TEXT)",self.cardName];
        [self.db executeUpdate:sql];
        //每一笔的消费
        NSString *consumeSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,bankNumber TEXT,everyConsume TEXT,detail TEXT,time TEXT,isUsed TEXT,month TEXT,year TEXT)", self.consumeName];
        [self.db executeUpdate:consumeSql];
        //每一次还款
        NSString *repaymentSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,bankNumber TEXT,everyRepayment TEXT,time TEXT,details TEXT)", self.repaymentName];
        [self.db executeUpdate:repaymentSql];
        //所有的消费
        NSString *allConsumeSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,bankStyle TEXT,bankNumber TEXT,everyConsume TEXT,detail TEXT,time TEXT,month TEXT,year TEXT,isCard TEXT,week TEXT,moneyType TEXT,accountBookName TEXT)", self.allConsumeName];
        [self.db executeUpdate:allConsumeSql];
        //所有的账本
        NSString *accountSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT,accountBookName TEXT,secretString TEXT,isConsume TEXT,isRepay TEXT,isSecret TEXT,isShowSwitch TEXT,time TEXT)",self.accountBook];
        [self.db executeUpdate:accountSql];
    }else{
        
        //打开数据库失败
    }
}
#pragma mark-查询相应的方法
//首先查询信息方法
-(NSMutableArray *)queryRecordsFromCardInfoCardNumber{
    
    [self.lock lock];
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ", self.cardName];
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        NSString *bankStyle = [rs stringForColumn:@"bankStyle"];
        NSString *bankNumber = [rs stringForColumn:@"bankNumber"];
        NSString *dueDate = [rs stringForColumn:@"dueDate"];
        NSString *dueDateMoney = [rs stringForColumn:@"dueDateMoney"];
        NSString *lastDueDateMoney = [rs stringForColumn:@"lastDueDateMoney"];
        NSString *billDate = [rs stringForColumn:@"billDate"];
        NSString *availabilityLimit = [rs stringForColumn:@"availabilityLimit"];
        NSString *limitNumber = [rs stringForColumn:@"limitNumber"];
        NSString *arrears = [rs stringForColumn:@"arrears"];
        NSString *month =[rs stringForColumn:@"month"];
        NSString *year =[rs stringForColumn:@"year"];
        NSString *dueDateDay =[rs stringForColumn:@"dueDateDay"];
        NSString *isOpenDueNotice = [rs stringForColumn:@"isOpenDueNotice"];
        NSString *isOpenBillNotice = [rs stringForColumn:@"isOpenBillNotice"];
        NSString *dueNoticeDate = [rs stringForColumn:@"dueNoticeDate"];
        NSString *billNoticeDate = [rs stringForColumn:@"billNoticeDate"];
        
        CardInfoModel *cardModel=[[CardInfoModel alloc]init];
        cardModel.bankStyle =bankStyle;
        cardModel.bankNumber =bankNumber;
        cardModel.dueDate =dueDate;
        cardModel.dueDateMoney =dueDateMoney;
        cardModel.lastDueDateMoney =lastDueDateMoney;
        cardModel.billDate =billDate;
        cardModel.availabilityLimit =availabilityLimit;
        cardModel.limitNumber =limitNumber;
        cardModel.arrears =arrears;
        cardModel.month =month;
        cardModel.year =year;
        cardModel.dueDateDay =dueDateDay;
        cardModel.isOpenDueNotice = isOpenDueNotice;
        cardModel.isOpenBillNotice = isOpenBillNotice;
        cardModel.dueNoticeDate = dueNoticeDate;
        cardModel.billNoticeDate = billNoticeDate;
        
        [records addObject:cardModel];
    }
    [self.lock unlock];
    return records;
}
//查询所有的消费
-(NSMutableArray *)queryRecordsFromConsumInfoCardNumber:(NSString *)cardNumberString{
    
    [self.lock lock];
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE bankNumber = '%@'", self.consumeName,cardNumberString];
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        NSString *bankNumber = [rs stringForColumn:@"bankNumber"];
        NSString *everyConsume = [rs stringForColumn:@"everyConsume"];
        NSString *detail = [rs stringForColumn:@"detail"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *isUsed =[rs stringForColumn:@"isUsed"];
        NSString *month =[rs stringForColumn:@"month"];
        NSString *year =[rs stringForColumn:@"year"];
        
        ConsumInfoModel *consumInfoModel =[[ConsumInfoModel alloc]init];
        consumInfoModel.bankNumber =bankNumber;
        consumInfoModel.everyConsume =everyConsume;
        consumInfoModel.detail =detail;
        consumInfoModel.time =time;
        consumInfoModel.isUsed =isUsed;
        consumInfoModel.month =month;
        consumInfoModel.year =year;
        [records addObject:consumInfoModel];
    }
    [self.lock unlock];
    return records;
}
//查询All所有的消费
-(NSMutableArray *)queryRecordsFromAllConsumInfo{
    
    [self.lock lock];
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY time DESC", self.allConsumeName];
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        NSString *bankStyle =[rs stringForColumn:@"bankStyle"];
        NSString *bankNumber =[rs stringForColumn:@"bankNumber"];
        NSString *isCard = [rs stringForColumn:@"isCard"];
        NSString *everyConsume = [rs stringForColumn:@"everyConsume"];
        NSString *detail = [rs stringForColumn:@"detail"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *month =[rs stringForColumn:@"month"];
        NSString *year =[rs stringForColumn:@"year"];
        NSString *week =[rs stringForColumn:@"week"];
        NSString *moneyType =[rs stringForColumn:@"moneyType"];
        NSString *accountBookName =[rs stringForColumn:@"accountBookName"];
        
        AllConsumInfoModel *consumInfoModel =[[AllConsumInfoModel alloc]init];
        consumInfoModel.bankStyle =bankStyle;
        consumInfoModel.bankNumber =bankNumber;
        consumInfoModel.isCard =isCard;
        consumInfoModel.everyConsume =everyConsume;
        consumInfoModel.detail =detail;
        consumInfoModel.time =time;
        consumInfoModel.month =month;
        consumInfoModel.year =year;
        consumInfoModel.week =week;
        consumInfoModel.moneyType =moneyType;
        consumInfoModel.accountBookName =accountBookName;
        [records addObject:consumInfoModel];
    }
    [self.lock unlock];
    return records;
}
//查询当前年分的数据
-(NSMutableArray *)queryRecordsFromConsumInfoYearString:(NSString *)yearString{
    
    [self.lock lock];
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE year = '%@' ORDER BY time DESC", self.allConsumeName,yearString];
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        NSString *bankStyle =[rs stringForColumn:@"bankStyle"];
        NSString *bankNumber =[rs stringForColumn:@"bankNumber"];
        NSString *isCard = [rs stringForColumn:@"isCard"];
        NSString *everyConsume = [rs stringForColumn:@"everyConsume"];
        NSString *detail = [rs stringForColumn:@"detail"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *month =[rs stringForColumn:@"month"];
        NSString *year =[rs stringForColumn:@"year"];
        NSString *week =[rs stringForColumn:@"week"];
        NSString *moneyType =[rs stringForColumn:@"moneyType"];
        NSString *accountBookName =[rs stringForColumn:@"accountBookName"];
        
        AllConsumInfoModel *consumInfoModel =[[AllConsumInfoModel alloc]init];
        consumInfoModel.bankStyle =bankStyle;
        consumInfoModel.bankNumber =bankNumber;
        consumInfoModel.isCard =isCard;
        consumInfoModel.everyConsume =everyConsume;
        consumInfoModel.detail =detail;
        consumInfoModel.time =time;
        consumInfoModel.month =month;
        consumInfoModel.year =year;
        consumInfoModel.week =week;
        consumInfoModel.moneyType =moneyType;
        consumInfoModel.accountBookName =accountBookName;
        [records addObject:consumInfoModel];
    }
    [self.lock unlock];
    return records;
}
//根据账本名称查询的数据/也可以根绝年份和账本名称一起查看
-(NSMutableArray *)queryRecordsFromConsumInfoAccountName:(NSString *)accountNameString withYear:(NSString *)yearString{
    
    [self.lock lock];
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSString *sql;
    if (yearString.length>0) {
    
        sql= [NSString stringWithFormat:@"SELECT * FROM %@ WHERE (%@) and year = '%@' ORDER BY time DESC", self.allConsumeName,accountNameString,yearString];
    }else{
       
        sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ORDER BY time DESC", self.allConsumeName,accountNameString];
    }
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        NSString *bankStyle =[rs stringForColumn:@"bankStyle"];
        NSString *bankNumber =[rs stringForColumn:@"bankNumber"];
        NSString *isCard = [rs stringForColumn:@"isCard"];
        NSString *everyConsume = [rs stringForColumn:@"everyConsume"];
        NSString *detail = [rs stringForColumn:@"detail"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *month =[rs stringForColumn:@"month"];
        NSString *year =[rs stringForColumn:@"year"];
        NSString *week =[rs stringForColumn:@"week"];
        NSString *moneyType =[rs stringForColumn:@"moneyType"];
        NSString *accountBookName =[rs stringForColumn:@"accountBookName"];
        
        AllConsumInfoModel *consumInfoModel =[[AllConsumInfoModel alloc]init];
        consumInfoModel.bankStyle =bankStyle;
        consumInfoModel.bankNumber =bankNumber;
        consumInfoModel.isCard =isCard;
        consumInfoModel.everyConsume =everyConsume;
        consumInfoModel.detail =detail;
        consumInfoModel.time =time;
        consumInfoModel.month =month;
        consumInfoModel.year =year;
        consumInfoModel.week =week;
        consumInfoModel.moneyType =moneyType;
        consumInfoModel.accountBookName =accountBookName;
        [records addObject:consumInfoModel];
    }
    [self.lock unlock];
    return records;
}
//查询未核算的消费
-(NSMutableArray *)queryNoUsedRecordsFromConsumInfoCardNumber:(NSString *)cardNumberString withMonth:(NSString *)monthString withYear:(NSString *)yearString{
    
    [self.lock lock];
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE bankNumber = '%@' and isUsed = '0' and month = '%@' and year = '%@'", self.consumeName,cardNumberString,monthString,yearString];
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        NSString *bankNumber = [rs stringForColumn:@"bankNumber"];
        NSString *everyConsume = [rs stringForColumn:@"everyConsume"];
        NSString *detail = [rs stringForColumn:@"detail"];
        NSString *time = [rs stringForColumn:@"time"];
        NSString *isUsed =[rs stringForColumn:@"isUsed"];
        NSString *month =[rs stringForColumn:@"month"];
        NSString *year =[rs stringForColumn:@"year"];
        
        ConsumInfoModel *consumInfoModel =[[ConsumInfoModel alloc]init];
        consumInfoModel.bankNumber =bankNumber;
        consumInfoModel.everyConsume =everyConsume;
        consumInfoModel.detail =detail;
        consumInfoModel.time =time;
        consumInfoModel.isUsed =isUsed;
        consumInfoModel.month =month;
        consumInfoModel.year =year;
        [records addObject:consumInfoModel];
    }
    [self.lock unlock];
    return records;
}
//查询每一笔还款
-(NSMutableArray *)queryRecordsFromRepaymentCardNumber:(NSString *)cardNumberString{
    
    [self.lock lock];
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE bankNumber = '%@'", self.repaymentName,cardNumberString];
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        NSString *bankNumber = [rs stringForColumn:@"bankNumber"];
        NSString *everyRepayment = [rs stringForColumn:@"everyRepayment"];
        NSString *time = [rs stringForColumn:@"time"];
        NSDictionary *recordDic = [[NSDictionary alloc]initWithObjectsAndKeys:bankNumber,@"bankNumber",
                                   everyRepayment, @"everyRepayment",time,@"time",nil];
        [records addObject:recordDic];
    }
    [self.lock unlock];
    return records;
}
//查询账本信息
-(NSMutableArray *)queryAccountBookList:(NSString *)accountNameString{
    
    [self.lock lock];
    NSMutableArray *records = [[NSMutableArray alloc]init];
    NSString *sql;
    if (accountNameString.length<=0) {
        
        sql =[NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY time ASC", self.accountBook];
    }else{
        
         sql=[NSString stringWithFormat:@"SELECT * FROM %@ WHERE accountBookName = '%@'", self.accountBook,accountNameString];
    }
    FMResultSet *rs = [self.db executeQuery:sql];
    while ([rs next]) {
        
        AccountBookModel *model =[[AccountBookModel alloc] init];
        model.accountBookName =[rs stringForColumn:@"accountBookName"];
        model.secretString =[rs stringForColumn:@"secretString"];
        model.isConsume =[rs stringForColumn:@"isConsume"].length<=0?NO:[[rs stringForColumn:@"isConsume"] boolValue];
        model.isRepay =[rs stringForColumn:@"isRepay"].length<=0?NO:[[rs stringForColumn:@"isRepay"] boolValue];
        model.isSecret =[rs stringForColumn:@"isSecret"].length<=0?NO:[[rs stringForColumn:@"isSecret"] boolValue];
        model.isShowSwitch =[rs stringForColumn:@"isShowSwitch"].length<=0?NO:[[rs stringForColumn:@"isShowSwitch"] boolValue];
        model.time =[rs stringForColumn:@"time"];
        [records addObject:model];
    }
    [self.lock unlock];
    return records;
}
#pragma mark-删除相应的数据方法
//删除信用卡的详情
-(void)delRecordFromCardInfoData:(NSString *)numberString
{
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE bankNumber = '%@'", self.cardName,numberString];
    //使用事物批处理
    BOOL isRoolBack = NO;
    [self.db beginTransaction];
    @try {
        if ([self.db executeUpdate:sql] == NO) {
            
            @throw @"删除失败";
        }
    }
    @catch (NSString *exception) {
        
        [self.db rollback];
        isRoolBack = YES;
    }
    @finally {
        
        if (!isRoolBack) {
            
            [self.db commit];
        }
    }
    [self.lock unlock];
}
//删除花销账单的方法
-(void)delRecordFromConsumeData:(NSString *)numberString withTime:(NSString *)timeString isAll:(BOOL)isAll{
    
    [self.lock lock];
    NSString *sql;
    if (isAll) {
        
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE bankNumber = '%@'", self.consumeName,numberString];
    }else{
       
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE bankNumber = '%@' and time = '%@'", self.consumeName,numberString,timeString];
    }
    //使用事物批处理
    BOOL isRoolBack = NO;
    [self.db beginTransaction];
    @try {
        if ([self.db executeUpdate:sql] == NO) {
            
            @throw @"删除失败";
        }
    }
    @catch (NSString *exception) {
        
        [self.db rollback];
        isRoolBack = YES;
    }
    @finally {
        
        if (!isRoolBack) {
            
            [self.db commit];
        }
    }
    [self.lock unlock];
}
//删除all花销账单的方法
-(void)delRecordFromAllConsumeData:(NSString *)numberString withTime:(NSString *)timeString{
    
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE time = '%@'", self.allConsumeName,timeString];
    //使用事物批处理
    BOOL isRoolBack = NO;
    [self.db beginTransaction];
    @try {
        if ([self.db executeUpdate:sql] == NO) {
            
            @throw @"删除失败";
        }
    }
    @catch (NSString *exception) {
        
        [self.db rollback];
        isRoolBack = YES;
    }
    @finally {
        
        if (!isRoolBack) {
            
            [self.db commit];
        }
    }
    [self.lock unlock];
}
//删除整个账本下的详情
-(void)delRecordFromAllAccountData:(NSString *)accountName{
    
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE accountBookName = '%@'", self.allConsumeName,accountName];
    //使用事物批处理
    BOOL isRoolBack = NO;
    [self.db beginTransaction];
    @try {
        if ([self.db executeUpdate:sql] == NO) {
            
            @throw @"删除失败";
        }
    }
    @catch (NSString *exception) {
        
        [self.db rollback];
        isRoolBack = YES;
    }
    @finally {
        
        if (!isRoolBack) {
            
            [self.db commit];
        }
    }
    [self.lock unlock];
}
//删除还款记录
-(void)delRecordFromRepaymentData:(NSString *)numberString withTime:(NSString *)timeString isAll:(BOOL)isAll{
    
    [self.lock lock];
    NSString *sql;
    if (isAll) {
        
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE bankNumber = '%@'", self.repaymentName,numberString];
    }else{
        
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE bankNumber = '%@' and time = '%@'", self.repaymentName,numberString,timeString];
    }
   
    //使用事物批处理
    BOOL isRoolBack = NO;
    [self.db beginTransaction];
    @try {
        if ([self.db executeUpdate:sql] == NO) {
            
            @throw @"删除失败";
        }
    }
    @catch (NSString *exception) {
        
        [self.db rollback];
        isRoolBack = YES;
    }
    @finally {
        
        if (!isRoolBack) {
            
            [self.db commit];
        }
    }
    [self.lock unlock];
}
//删除账本信息
-(void)delAccountBookData:(NSString *)accountName{
    
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE accountBookName = '%@'", self.accountBook,accountName];
    //使用事物批处理
    BOOL isRoolBack = NO;
    [self.db beginTransaction];
    @try {
        if ([self.db executeUpdate:sql] == NO) {
            
            @throw @"删除失败";
        }
    }
    @catch (NSString *exception) {
        
        [self.db rollback];
        isRoolBack = YES;
    }
    @finally {
        
        if (!isRoolBack) {
            
            [self.db commit];
        }
    }
    [self.lock unlock];
}
#pragma mark-插入相应的数据方法
//添加信用卡信息
-(void)addRecordToCardInfoTable:(NSDictionary *)dict{
    
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (bankStyle ,bankNumber, dueDate,dueDateMoney,lastDueDateMoney,billDate,availabilityLimit,limitNumber,arrears,month,year,dueDateDay,isOpenDueNotice,isOpenBillNotice,dueNoticeDate,billNoticeDate) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",self.cardName,[dict objectForKey:@"bankStyle"],[dict objectForKey:@"bankNumber"],[dict objectForKey:@"dueDate"],[dict objectForKey:@"dueDateMoney"],[dict objectForKey:@"lastDueDateMoney"],[dict objectForKey:@"billDate"],[dict objectForKey:@"availabilityLimit"],[dict objectForKey:@"limitNumber"],[dict objectForKey:@"arrears"],[dict objectForKey:@"month"],[dict objectForKey:@"year"],[dict objectForKey:@"dueDateDay"],[dict objectForKey:@"isOpenDueNotice"],[dict objectForKey:@"isOpenBillNotice"],[dict objectForKey:@"dueNoticeDate"],[dict objectForKey:@"billNoticeDate"]];
    BOOL result = [self.db executeUpdate:sql];
    NSLog(@"%@",result?@"YES":@"NO");
    [self.lock unlock];
}
//添加花费信息
-(void)addRecordToConsumeTable:(NSDictionary *)dict{
    
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (bankNumber, everyConsume,detail,time,isUsed,month,year) VALUES ('%@','%@','%@','%@','%@','%@','%@')",  self.consumeName,[dict objectForKey:@"bankNumber"],[dict objectForKey:@"everyConsume"],[dict objectForKey:@"detail"],[dict objectForKey:@"time"],[dict objectForKey:@"isUsed"],[dict objectForKey:@"month"],[dict objectForKey:@"year"]];
    BOOL result = [self.db executeUpdate:sql];
    NSLog(@"%@",result?@"YES":@"NO");
    [self.lock unlock];
}
//添加花费和收入都是这个方法moneyType==1为花销，moneyType==2为收入
-(void)addRecordToAllConsumeTable:(NSDictionary *)dict{

    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (isCard,everyConsume,detail,time,month,year,bankStyle,bankNumber,week,moneyType,accountBookName) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",  self.allConsumeName,[dict objectForKey:@"isCard"],[dict objectForKey:@"everyConsume"],[dict objectForKey:@"detail"],[dict objectForKey:@"time"],[dict objectForKey:@"month"],[dict objectForKey:@"year"],[dict objectForKey:@"bankStyle"],[dict objectForKey:@"bankNumber"],[dict objectForKey:@"week"],[dict objectForKey:@"moneyType"],[dict objectForKey:@"accountBookName"]];
    BOOL result = [self.db executeUpdate:sql];
    NSLog(@"存放成功加油%@",result?@"YES":@"NO");
    [self.lock unlock];
}
//添加还款信息
-(void)addRecordToRepaymentTable:(NSDictionary *)dict{
    
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (bankNumber, everyRepayment,time,details) VALUES ('%@','%@','%@','%@')",  self.repaymentName,[dict objectForKey:@"bankNumber"],[dict objectForKey:@"everyRepayment"],[dict objectForKey:@"time"],[dict objectForKey:@"details"]];
    BOOL result = [self.db executeUpdate:sql];
    NSLog(@"%@",result?@"YES":@"NO");
    [self.lock unlock];
}
//添加账本
-(void)addRecordToAccountBook:(NSDictionary *)dict{
    /*
     ,accountBookName TEXT,secretString TEXT,isConsume TEXT,isRepay TEXT,isSecret TEXT,isShowSwitch TEXT,time TEXT
     */
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (accountBookName, secretString,isConsume,isRepay,isSecret,isShowSwitch,time) VALUES ('%@','%@','%@','%@','%@','%@','%@')",  self.accountBook,[dict objectForKey:@"accountBookName"],[dict objectForKey:@"secretString"],[dict objectForKey:@"isConsume"],[dict objectForKey:@"isRepay"],[dict objectForKey:@"isSecret"],[dict objectForKey:@"isShowSwitch"],[dict objectForKey:@"time"]];
    BOOL result = [self.db executeUpdate:sql];
    NSLog(@"%@",result?@"YES":@"NO");
    [self.lock unlock];
}
//更新卡的信息
-(void)updateCardInfo:(NSDictionary *)infoDic{
    
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET dueDateMoney = '%@',arrears = '%@',availabilityLimit = '%@',lastDueDateMoney = '%@',month = '%@',year = '%@',bankStyle = '%@',lastDueDateMoney = '%@',billDate = '%@',limitNumber = '%@',dueDateDay = '%@',isOpenDueNotice = '%@',isOpenBillNotice = '%@',dueNoticeDate = '%@',billNoticeDate = '%@',dueDate = '%@' WHERE bankNumber = '%@'",  self.cardName,infoDic[@"dueDateMoney"],infoDic[@"arrears"],infoDic[@"availabilityLimit"],infoDic[@"lastDueDateMoney"],infoDic[@"month"],infoDic[@"year"],infoDic[@"bankStyle"],infoDic[@"lastDueDateMoney"],infoDic[@"billDate"],infoDic[@"limitNumber"],infoDic[@"dueDateDay"],infoDic[@"isOpenDueNotice"],infoDic[@"isOpenBillNotice"],infoDic[@"dueNoticeDate"],infoDic[@"billNoticeDate"],infoDic[@"dueDate"],infoDic[@"bankNumber"]];
    BOOL result = [self.db executeUpdate:sql];
    [self.lock unlock];
}
//更新卡的提醒日期和状态
-(void)updateCardNotice:(NSDictionary *)noticeDic{
    [self.lock lock];
    NSLog(@"noticeDic====%@",noticeDic);
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET isOpenDueNotice = '%@',isOpenBillNotice = '%@',dueNoticeDate = '%@',billNoticeDate = '%@' WHERE bankNumber = '%@'",  self.cardName,noticeDic[@"isOpenDueNotice"],noticeDic[@"isOpenBillNotice"],noticeDic[@"dueNoticeDate"],noticeDic[@"billNoticeDate"],noticeDic[@"bankNumber"]];
    BOOL result = [self.db executeUpdate:sql];
    [self.lock unlock];
}
//更新支出和收入的信息
-(void)upDateConsumeAndIncome:(NSDictionary *)dict{
    
    [self.lock lock];
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET isCard = '%@',everyConsume = '%@',detail = '%@',month = '%@',year = '%@',bankStyle = '%@',bankNumber = '%@',week = '%@',moneyType = '%@',accountBookName = '%@' WHERE time = '%@'", self.allConsumeName,[dict objectForKey:@"isCard"],[dict objectForKey:@"everyConsume"],[dict objectForKey:@"detail"],[dict objectForKey:@"month"],[dict objectForKey:@"year"],[dict objectForKey:@"bankStyle"],[dict objectForKey:@"bankNumber"],[dict objectForKey:@"week"],[dict objectForKey:@"moneyType"],[dict objectForKey:@"accountBookName"],[dict objectForKey:@"time"]];
    BOOL result = [self.db executeUpdate:sql];
    NSLog(@"存放成功加油%@",result?@"YES":@"NO");
    [self.lock unlock];
}
@end
