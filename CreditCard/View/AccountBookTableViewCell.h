//
//  AccountBookTableViewCell.h
//  CreditCard
//
//  Created by liujingtao on 2019/6/3.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountBookModel.h"
@interface AccountBookTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) AccountBookModel *accountModel;
@property (nonatomic,assign) int selectIndex;
@property (nonatomic,assign) BOOL isEdit;
@property (nonatomic,assign) BOOL isSelect;//是否被选中了
@end


