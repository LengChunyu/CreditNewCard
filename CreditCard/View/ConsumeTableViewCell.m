//
//  ConsumeTableViewCell.m
//  CreditCard
//
//  Created by liujingtao on 2019/3/12.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "ConsumeTableViewCell.h"
@interface ConsumeTableViewCell ()
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UIView *vLionView;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *weekLabel;
@property (nonatomic,strong) UILabel *sumLabel;
@property (nonatomic,strong) UILabel *incomSumLabel;
@property (nonatomic,strong) UILabel *consumeLabel;
@property (nonatomic,strong) UILabel *consumeStyleLabel;
@property (nonatomic,strong) UILabel *defailLabel;
@property (nonatomic,strong) UILabel *allTimeLabel;
@property (nonatomic,strong) UIView *topLionV;
@property (nonatomic,assign) CGFloat currentWidth;
@end
@implementation ConsumeTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexPath{
    
    if (self ==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.indexPath =indexPath;
        
        self.vLionView =[[UIView alloc]init];
        self.vLionView.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self.contentView addSubview:self.vLionView];
        
        self.timeLabel =[[UILabel alloc]init];
        self.timeLabel.textAlignment =NSTextAlignmentCenter;
        self.timeLabel.hidden =YES;
        self.timeLabel.textColor =[UIColor blackColor];
        self.timeLabel.font =[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeLabel];
        
        self.weekLabel =[[UILabel alloc]init];
        self.weekLabel.textAlignment =NSTextAlignmentCenter;
        self.weekLabel.hidden =YES;
        self.weekLabel.textColor =[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
        self.weekLabel.font =[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.weekLabel];
        
        self.sumLabel =[[UILabel alloc]init];
        self.sumLabel.textAlignment =NSTextAlignmentCenter;
        self.sumLabel.hidden =YES;
        self.sumLabel.textColor =[UIColor colorWithRed:0.46 green:0.67 blue:0.49 alpha:1.00];
        self.sumLabel.font =[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.sumLabel];
        
        self.incomSumLabel =[[UILabel alloc]init];
        self.incomSumLabel.textAlignment =NSTextAlignmentCenter;
        self.incomSumLabel.hidden =YES;
        self.incomSumLabel.textColor =[UIColor colorWithRed:0.95 green:0.21 blue:0.11 alpha:1.00];
        self.incomSumLabel.font =[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.incomSumLabel];
        
        self.consumeLabel =[[UILabel alloc]init];
        self.consumeLabel.textAlignment =NSTextAlignmentRight;
        self.consumeLabel.textColor =[UIColor colorWithRed:0.46 green:0.67 blue:0.49 alpha:1.00];
        self.consumeLabel.font =[UIFont fontWithName:@"Menlo-Regular" size:17];
        [self.contentView addSubview:self.consumeLabel];
        
        self.consumeStyleLabel =[[UILabel alloc]init];
        self.consumeStyleLabel.textAlignment =NSTextAlignmentRight;
        self.consumeStyleLabel.textColor =[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
        self.consumeStyleLabel.font =[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.consumeStyleLabel];
        
        self.defailLabel =[[UILabel alloc]init];
        self.defailLabel.textAlignment =NSTextAlignmentLeft;
        self.defailLabel.textColor =[UIColor blackColor];
        self.defailLabel.font =[UIFont systemFontOfSize:15];
        self.defailLabel.numberOfLines = 0;
        [self.contentView addSubview:self.defailLabel];
        
        self.allTimeLabel =[[UILabel alloc]init];
        self.allTimeLabel.textAlignment =NSTextAlignmentLeft;
        self.allTimeLabel.numberOfLines =0;
        [self.allTimeLabel sizeToFit];
        self.allTimeLabel.textColor =[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
        self.allTimeLabel.font =[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.allTimeLabel];
        
        self.topLionV =[[UIView alloc]init];
        self.topLionV.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        self.topLionV.hidden =YES;
        [self.contentView addSubview:self.topLionV];
        
        CGRect bounds = [@"99999999.99" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        self.currentWidth = bounds.size.width;
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];

    self.consumeLabel.frame =CGRectMake((self.contentView.width-70-10)/2+70,10,(self.contentView.width-70-10)/2,25);
    self.consumeStyleLabel.frame =CGRectMake((self.contentView.width-70-10)/2+70,35,(self.contentView.width-70-10)/2,25);
    self.defailLabel.frame =CGRectMake(70+10,10,self.contentView.width-70-10-self.currentWidth,25);
    self.allTimeLabel.frame =CGRectMake(70+10,35,(self.contentView.width-70-10)/2,25);
    self.vLionView.frame =CGRectMake(70,0,1,70);

    //花销和收入是否显示
    if (self.accountModel.isConsume&&self.accountModel.isRepay){
        //花销和收入
        self.timeLabel.frame =CGRectMake(10,5,60,15);
        self.weekLabel.frame =CGRectMake(10,20,60,15);
        float sumLabelWidth =[self.sumLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
        if (sumLabelWidth>60) {
            
            self.sumLabel.frame =CGRectMake(0,35,70,15);
        }else{
            self.sumLabel.frame =CGRectMake(10,35,60,15);
        }
        float incomSumLabelWidth =[self.incomSumLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
        if (incomSumLabelWidth>60) {
            
            self.incomSumLabel.frame =CGRectMake(0,50,70,15);
        }else{
            self.incomSumLabel.frame =CGRectMake(10,50,60,15);
        }
        if (self.consumeModel.isMarkTime) {
            
            self.incomSumLabel.hidden =NO;
            self.sumLabel.hidden =NO;
        }else{
            self.incomSumLabel.hidden =YES;
            self.sumLabel.hidden =YES;
        }
        
    }else if(self.accountModel.isConsume||self.accountModel.isRepay){
        
        self.timeLabel.frame =CGRectMake(10,11,60,16);
        self.weekLabel.frame =CGRectMake(10,27,60,16);
        if (self.accountModel.isConsume) {
        
            float sumLabelWidth =[self.sumLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
            if (sumLabelWidth>60) {
                
                self.sumLabel.frame =CGRectMake(0,43,70,16);
            }else{
                self.sumLabel.frame =CGRectMake(10,43,60,16);
            }
            if (self.consumeModel.isMarkTime) {
                self.incomSumLabel.hidden =YES;
                self.sumLabel.hidden =NO;
            }else{
                self.incomSumLabel.hidden =YES;
                self.sumLabel.hidden =YES;
            }
        }else{
            float incomSumLabelWidth =[self.incomSumLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,16) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.width;
            if (incomSumLabelWidth>60) {
                
                self.incomSumLabel.frame =CGRectMake(0,43,70,16);
            }else{
                self.incomSumLabel.frame =CGRectMake(10,43,60,16);
            }
            if (self.consumeModel.isMarkTime) {
                self.incomSumLabel.hidden =NO;
                self.sumLabel.hidden =YES;
            }else{
                self.incomSumLabel.hidden =YES;
                self.sumLabel.hidden =YES;
            }
        }
    }
    
    self.topLionV.frame =CGRectMake(70,0,self.contentView.width-20-60,1);
}
-(void)setConsumeModel:(AllConsumInfoModel *)consumeModel{
    _consumeModel =consumeModel;
    if (consumeModel.isMarkTime) {
        
        self.timeLabel.hidden =NO;
        self.weekLabel.hidden =NO;
        self.sumLabel.hidden =NO;
        self.incomSumLabel.hidden =NO;
    }else{
        
        self.timeLabel.hidden =YES;
        self.weekLabel.hidden =YES;
        self.sumLabel.hidden =YES;
        self.incomSumLabel.hidden =YES;
    }
    self.timeLabel.text =[consumeModel.time substringWithRange:NSMakeRange(8,2)];
    self.weekLabel.text =consumeModel.week;
    
    self.sumLabel.text =[consumeModel.daySumMoney isEqualToString:@"0"]?@"0.00":[NSString stringWithFormat:@"%@",[NSDecimalNumber decimalNumberWithString:consumeModel.daySumMoney]];
    
    self.incomSumLabel.text =[consumeModel.dayIncomSumMoney isEqualToString:@"0"]?@"0.00":[NSString stringWithFormat:@"%@",[NSDecimalNumber decimalNumberWithString:consumeModel.dayIncomSumMoney]];
    
    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:consumeModel.everyConsume];
    self.consumeLabel.text =[NSString stringWithFormat:@"%@",everyConsume];
    if (consumeModel.isCard) {
        
        self.consumeStyleLabel.text =consumeModel.bankStyle;
    }else{
        
        self.consumeStyleLabel.text =@"现金";
    }
    if (consumeModel.detail.length<=0) {
        
        self.defailLabel.text =@"其他";
    }else{
        
        self.defailLabel.text =consumeModel.detail;
    }
    if (consumeModel.time.length>=16) {
        
        self.allTimeLabel.text =[consumeModel.time substringWithRange:NSMakeRange(11,5)];
    }else{
        self.allTimeLabel.text =consumeModel.time;
    }
    if (consumeModel.isDrawLion) {
        
        self.topLionV.hidden =NO;
    }else{
        self.topLionV.hidden =YES;
    }
    if ([consumeModel.moneyType isEqualToString:@"1"]) {
        
        self.consumeLabel.textColor =[UIColor colorWithRed:0.46 green:0.67 blue:0.49 alpha:1.00];
    }else{
        
        self.consumeLabel.textColor =[UIColor colorWithRed:0.95 green:0.21 blue:0.11 alpha:1.00];
    }
}
@end
