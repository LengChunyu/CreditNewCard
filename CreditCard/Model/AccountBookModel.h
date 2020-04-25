//
//  AccountBookModel.h
//  CreditCard
//
//  Created by liujingtao on 2019/6/3.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountBookModel : NSObject
/*
 accountBookName TEXT,secretString TEXT,isConsume TEXT,isRepay TEXT,isSecret TEXT,isShowSwitch TEXT
 */
@property (nonatomic,copy) NSString *accountBookName;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *secretString;
@property (nonatomic,assign) BOOL isConsume;
@property (nonatomic,assign) BOOL isRepay;
@property (nonatomic,assign) BOOL isSecret;
@property (nonatomic,assign) BOOL isShowSwitch;
@end


