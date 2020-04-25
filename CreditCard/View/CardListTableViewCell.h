//
//  CardListTableViewCell.h
//  CreditCard
//
//  Created by liujingtao on 2019/1/14.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardInfoModel.h"
@interface CardListTableViewCell : UITableViewCell
@property (nonatomic,strong) CardInfoModel *cardInfoModel;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic,strong) UILabel *dueDateLabel;//到期还款日期
@property (nonatomic,strong) UILabel *nextDueDate;//下期还款的日期
@property (nonatomic,strong) UIView *backView;
@end
