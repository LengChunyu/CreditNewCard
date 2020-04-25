//
//  AccountBookTableViewCell.m
//  CreditCard
//
//  Created by liujingtao on 2019/6/3.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import "AccountBookTableViewCell.h"
@interface AccountBookTableViewCell ()

@property (nonatomic,strong) UILabel *accountNameLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *showImageView;
@property (nonatomic,strong) UILabel *showLabel;
@property (nonatomic,strong) UIImageView *lockImageView;
@property (nonatomic,strong) UILabel *lockLabel;
@property (nonatomic,strong) UIImageView *eyeImageView;
@property (nonatomic,strong) UIImageView *secretImageView;
@property (nonatomic,strong) UIImageView *selectImageView;
@property (nonatomic,strong) UIImageView *editSelectImageView;

@end
@implementation AccountBookTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGRect rect = CGRectMake(0, 0, self.width, 160);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        //高亮颜色值
        UIColor *selectedColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
        CGContextSetFillColorWithColor(context, [selectedColor CGColor]);
        CGContextFillRect(context, rect);
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageView *backImageView =[[UIImageView alloc]initWithImage:image];
        self.selectedBackgroundView = backImageView;
        
        self.backView =[[UIView alloc] init];
        self.backView.layer.cornerRadius =10;
        self.backView.clipsToBounds =YES;
        self.backView.backgroundColor =[UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.accountNameLabel =[[UILabel alloc]init];
        self.accountNameLabel.font =[UIFont systemFontOfSize:16];
        self.accountNameLabel.textColor =[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
        self.accountNameLabel.textAlignment =NSTextAlignmentLeft;
        [self.backView addSubview:self.accountNameLabel];
        
        self.timeLabel =[[UILabel alloc]init];
        self.timeLabel.font =[UIFont systemFontOfSize:13];
        self.timeLabel.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        self.timeLabel.textAlignment =NSTextAlignmentLeft;
        [self.backView addSubview:self.timeLabel];
        
        self.showImageView =[[UIImageView alloc]init];
        self.showImageView.image =[UIImage imageNamed:@"eye_open_small"];
        [self.contentView addSubview:self.showImageView];
        self.showLabel =[[UILabel alloc] init];
        self.showLabel.text =@"在总账本中显示";
        self.showLabel.textAlignment =NSTextAlignmentLeft;
        self.showLabel.font =[UIFont systemFontOfSize:12];
        self.showLabel.textColor =[UIColor redColor];
        [self.contentView addSubview:self.showLabel];
        
        self.lockImageView =[[UIImageView alloc]init];
        self.lockImageView.image =[UIImage imageNamed:@"lock_close_small"];
        [self.contentView addSubview:self.lockImageView];
        self.lockLabel =[[UILabel alloc] init];
        self.lockLabel.text =@"带有密保";
        self.lockLabel.textAlignment =NSTextAlignmentLeft;
        self.lockLabel.font =[UIFont systemFontOfSize:12];
        self.lockLabel.textColor =[UIColor redColor];
        [self.contentView addSubview:self.lockLabel];
        
        self.showLabel.hidden =YES;
        self.showImageView.hidden =YES;
        self.lockLabel.hidden =YES;
        self.lockImageView.hidden =YES;
        
        self.eyeImageView =[[UIImageView alloc] init];
        [self.backView addSubview:self.eyeImageView];
        
        self.secretImageView =[[UIImageView alloc] init];
        [self.backView addSubview:self.secretImageView];
        
        self.selectImageView =[[UIImageView alloc] init];
        self.selectImageView.image =[UIImage imageNamed:@"select_image"];
        [self.backView addSubview:self.selectImageView];
        
        self.editSelectImageView =[[UIImageView alloc] init];
        [self.contentView addSubview:self.editSelectImageView];
        self.editSelectImageView.hidden =YES;
        
        self.selectImageView.hidden =YES;
        self.contentView.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    }
    return self;
}
//改变frome
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backView.backgroundColor =[UIColor whiteColor];
    if (self.indexPath.row==0) {
        if (self.isEdit) {
            
            self.backView.frame =CGRectMake(0,25,self.contentView.width-20-20,self.contentView.height-35);
        }else{
            
            self.backView.frame =CGRectMake(10,25,self.contentView.width-20,self.contentView.height-35);
        }
        self.selectImageView.frame =CGRectMake(self.backView.width-30,20,20,20);
        
        self.accountNameLabel.frame =CGRectMake(10,0,self.contentView.width-20-20,self.backView.height);
        self.timeLabel.frame =CGRectZero;
        self.lockLabel.frame =CGRectMake(self.contentView.width-10-60,5,60,20);
        self.lockImageView.frame =CGRectMake(self.lockLabel.left-20,5,20,20);
        self.showLabel.frame =CGRectMake(self.lockImageView.left-90,5,90,20);
        self.showImageView.frame =CGRectMake(self.showLabel.left-20,5,20,20);
        
        self.showLabel.hidden =NO;
        self.showImageView.hidden =NO;
        self.lockLabel.hidden =NO;
        self.lockImageView.hidden =NO;
        self.eyeImageView.hidden =YES;
        self.secretImageView.hidden =YES;
        self.editSelectImageView.hidden =YES;
    }else{
        if (self.isEdit) {
            
            self.backView.frame =CGRectMake(0,0,self.contentView.width-20-20,self.contentView.height-10);
            self.editSelectImageView.hidden =NO;
        }else{
            
            self.backView.frame =CGRectMake(10,0,self.contentView.width-20,self.contentView.height-10);
            self.editSelectImageView.hidden =YES;
        }
        self.selectImageView.frame =CGRectMake(self.backView.width-30,20,20,20);
        
        self.accountNameLabel.frame =CGRectMake(10,0,self.contentView.width-20-20,(self.contentView.height-10)/2);
        self.timeLabel.frame =CGRectMake(10,(self.contentView.height-10)/2,self.contentView.width-20-20,(self.contentView.height-10)/2);
        if (self.indexPath.row==self.selectIndex) {
            
            self.secretImageView.frame =CGRectMake(self.selectImageView.left-25,17.5,25,25);
        }else{
            
            self.secretImageView.frame =CGRectMake(self.backView.width-35,17.5,25,25);
        }
        self.eyeImageView.frame =CGRectMake(self.secretImageView.left-25,17.5,25,25);
        self.showLabel.hidden =YES;
        self.showImageView.hidden =YES;
        self.lockLabel.hidden =YES;
        self.lockImageView.hidden =YES;
        self.eyeImageView.hidden =NO;
        self.secretImageView.hidden =NO;
    }
    self.editSelectImageView.frame =CGRectMake(self.contentView.width-30,(self.contentView.height-10-20)/2, 20,20);
}
-(void)setAccountModel:(AccountBookModel *)accountModel{
    _accountModel =accountModel;
    self.accountNameLabel.text =accountModel.accountBookName;
    self.timeLabel.text =accountModel.time;
    if (self.indexPath.row==self.selectIndex) {
        
        self.selectImageView.hidden =NO;
    }else{
        
        self.selectImageView.hidden =YES;
    }
    if (accountModel.isSecret) {
        self.secretImageView.image =[UIImage imageNamed:@"lock_close_big"];
    }else{
        self.secretImageView.image =[UIImage imageNamed:@"lock_open_big"];
    }
    if (accountModel.isShowSwitch) {
        
        self.eyeImageView.image =[UIImage imageNamed:@"eye_open_big"];
    }else{
        self.eyeImageView.image =[UIImage imageNamed:@"eye_close_big"];
    }
}
-(void)setIsSelect:(BOOL)isSelect{
    _isSelect =isSelect;
    if (isSelect) {
        self.editSelectImageView.image =[UIImage imageNamed:@"cycle_select_image"];
    }else{
        self.editSelectImageView.image =[UIImage imageNamed:@"cycle_noSelect_image"];
    }
}
@end
