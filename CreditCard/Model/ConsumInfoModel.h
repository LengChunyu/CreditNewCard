//
//  ConsumInfoModel.h
//  CreditCard
//
//  Created by liujingtao on 2019/2/14.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsumInfoModel : NSObject

@property (nonatomic,copy) NSString *bankNumber;
@property (nonatomic,copy) NSString *everyConsume;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *isUsed;
@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *year;
@end

