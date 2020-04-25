//
//  ConsumeTableViewCell.h
//  CreditCard
//
//  Created by liujingtao on 2019/3/12.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllConsumInfoModel.h"
#import "AccountBookModel.h"
@interface ConsumeTableViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic,strong) AllConsumInfoModel *consumeModel;
@property (nonatomic,strong) AccountBookModel *accountModel;//账本的信息
@end
