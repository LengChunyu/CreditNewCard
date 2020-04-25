//
//  CardListTableViewCell.m
//  CreditCard
//
//  Created by liujingtao on 2019/1/14.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "CardListTableViewCell.h"
@interface CardListTableViewCell ()<UITextFieldDelegate>


@property (nonatomic,strong) UILabel *bankNameLabel;
@property (nonatomic,strong) UILabel *bankNumberLabel;
@property (nonatomic,strong) UILabel *billDateLabel;//账单日日期
@property (nonatomic,strong) UIView *firstLion;//第一条分割线
@property (nonatomic,strong) UILabel *dueDateMoneyLabel;//到期还款金额
@property (nonatomic,strong) UILabel *lastDueDateMoneyLabel;//下个月到期划款的金额
@property (nonatomic,strong) UILabel *distanceDay;//距离本期还款天数

@end
@implementation CardListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withIndexPath:(NSIndexPath *)indexPath{
    
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGRect rect = CGRectMake(0, 0, self.width, 110);
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
        
        self.bankNameLabel =[[UILabel alloc]init];
        self.bankNameLabel.font =[UIFont systemFontOfSize:13];
        self.bankNameLabel.textColor =[UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
        self.bankNameLabel.textAlignment =NSTextAlignmentLeft;
        [self.backView addSubview:self.bankNameLabel];
        
        self.bankNumberLabel =[[UILabel alloc]init];
        self.bankNumberLabel.userInteractionEnabled =YES;
        self.bankNumberLabel.textAlignment =NSTextAlignmentLeft;
        self.bankNumberLabel.font =[UIFont systemFontOfSize:12];
        self.bankNumberLabel.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        [self.backView addSubview:self.bankNumberLabel];
        
        self.billDateLabel =[[UILabel alloc]init];
        self.billDateLabel.font =[UIFont systemFontOfSize:13];
        self.billDateLabel.textAlignment =NSTextAlignmentRight;
        self.billDateLabel.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];;
        [self.backView addSubview:self.billDateLabel];
        
        self.dueDateLabel =[[UILabel alloc]init];
        self.dueDateLabel.font =[UIFont systemFontOfSize:13];
        self.dueDateLabel.textAlignment =NSTextAlignmentRight;
        self.dueDateLabel.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        [self.backView addSubview:self.dueDateLabel];
        
        self.firstLion =[[UIView alloc]init];
        self.firstLion.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self.backView addSubview:self.firstLion];
        
        self.dueDateMoneyLabel =[[UILabel alloc]init];
        self.dueDateMoneyLabel.font =[UIFont systemFontOfSize:13];
        self.dueDateMoneyLabel.textColor =self.dueDateLabel.textColor;
        self.dueDateMoneyLabel.textAlignment =NSTextAlignmentLeft;
        [self.backView addSubview:self.dueDateMoneyLabel];
        
        self.lastDueDateMoneyLabel =[[UILabel alloc]init];
        self.lastDueDateMoneyLabel.font =[UIFont systemFontOfSize:13];
        self.lastDueDateMoneyLabel.textColor =self.dueDateLabel.textColor;
        self.lastDueDateMoneyLabel.textAlignment =NSTextAlignmentLeft;
        [self.backView addSubview:self.lastDueDateMoneyLabel];
        
        self.distanceDay =[[UILabel alloc]init];
        self.distanceDay.textAlignment =NSTextAlignmentRight;
        [self.backView addSubview:self.distanceDay];
        
        self.nextDueDate =[[UILabel alloc]init];
        self.nextDueDate.font =[UIFont systemFontOfSize:13];
        self.nextDueDate.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
        self.nextDueDate.textAlignment =NSTextAlignmentRight;
        [self.backView addSubview:self.nextDueDate];
    
        self.contentView.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    }
    return self;
}
//改变frome
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.backView.backgroundColor =[UIColor whiteColor];
    self.backView.frame =CGRectMake(10,10,self.contentView.width-20,self.contentView.height-10);
//    float bankNameLabelWidth = [@"招商银行" boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,30)
//                                               options:NSStringDrawingUsesLineFragmentOrigin
//                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}context:nil].size.width;
    self.bankNameLabel.frame =CGRectMake(10,5,(self.backView.width-20)/2,20);
    self.bankNumberLabel.frame =CGRectMake(self.bankNameLabel.left,self.bankNameLabel.bottom,(self.backView.width-20)/2,20);
    self.billDateLabel.frame =CGRectMake(self.bankNameLabel.right,self.bankNameLabel.top,(self.backView.width-20)/2,20);
    self.dueDateLabel.frame =CGRectMake(self.bankNameLabel.right,self.billDateLabel.bottom, self.billDateLabel.width, 20);
    
    self.firstLion.frame =CGRectMake(self.bankNameLabel.left, self.dueDateLabel.bottom+5, self.backView.width-20, 1);
    
    self.dueDateMoneyLabel.frame =CGRectMake(self.bankNameLabel.left,self.firstLion.bottom+5, self.backView.width-20,20);
    self.lastDueDateMoneyLabel.frame =CGRectMake(self.dueDateMoneyLabel.left,self.dueDateMoneyLabel.bottom, self.dueDateMoneyLabel.width, 20);
    
    self.distanceDay.frame =CGRectMake(0,self.dueDateMoneyLabel.top, self.backView.width-10, 20);
    self.nextDueDate.frame =CGRectMake(0,self.distanceDay.bottom,self.distanceDay.width,20);
}
-(void)setCardInfoModel:(CardInfoModel *)cardInfoModel{
    
    _cardInfoModel =cardInfoModel;
    
    NSDateFormatter *dateformatter =[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString= [dateformatter stringFromDate:[NSDate date]];
    int monthDays =[self numberOfDayInMonthWithDateStr:newDateString];
    NSArray *dateArray =[newDateString componentsSeparatedByString:@"-"];
    
    self.bankNameLabel.text =[NSString stringWithFormat:@"%@",cardInfoModel.bankStyle];
    self.bankNumberLabel.text =cardInfoModel.bankNumber;
    self.billDateLabel.text =[NSString stringWithFormat:@"账单日：%@月%@日",dateArray[1],[self changeLowTen:cardInfoModel.billDate]];
    NSString *billExplain;
    if ([dateArray.lastObject intValue] > [cardInfoModel.billDate intValue]) {
        billExplain = @"本月账单已出";
    }else if ([dateArray.lastObject intValue] == [cardInfoModel.billDate intValue]){
        billExplain = @"今天就是账单日呦";
    }else {
        billExplain = [NSString stringWithFormat:@"距离账单日还有%d天",[cardInfoModel.billDate intValue]-[dateArray.lastObject intValue]];
    }
    self.dueDateLabel.text = billExplain;
    NSString *dueDateCommon;
    int type = 0;
    if ([cardInfoModel.dueDate intValue]==0) {

        if (([cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue])>monthDays) {
        
            int upMonthDays =[self numberOfDayInMonthWithDateStr:[self setupRequestMonth:-1]];
            if ([cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue]<=upMonthDays) {
                dueDateCommon = @"";
                type = 1;//当前情况是直接顺延下一个月
            }else{
                dueDateCommon =[self changeLowTen:[NSString stringWithFormat:@"%d",[cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue]-upMonthDays]] ;
            }
        }else{
        
            dueDateCommon =[self changeLowTen:[NSString stringWithFormat:@"%d",[cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue]]];
        }
    }else{
        if ([cardInfoModel.dueDate intValue] > monthDays) {
            dueDateCommon =@"";
            type = 2;
        }else{
            dueDateCommon =cardInfoModel.dueDate;
        }
    }
    NSString *currentDetailS;
    NSString *currentDateS;
    if (type == 1) {
        
        currentDetailS = @"本月还款日顺延和下个月还款日一致";
        currentDateS = @"";
    }else if (type == 2){

        currentDetailS = [NSString stringWithFormat:@"本月没有%@日，还款日建议重新设定（有些卡使用的是间隔天数）",cardInfoModel.dueDate];
        currentDateS = @"";
    }else{
        
        currentDetailS = [NSString stringWithFormat:@"本月还款日：%@月%@日",dateArray[1],[self changeLowTen:dueDateCommon]];
        if ([dateArray[2] intValue]>[cardInfoModel.dueDate intValue]) {
            //已经逾期了提醒
            currentDateS =@"当月还款日已过";
        }else if ([dateArray[2] intValue]==[cardInfoModel.dueDate intValue]){
            currentDateS = @"今天就是还款日呦";
        }else{
            //距离天数处理
            currentDateS =[NSString stringWithFormat:@"距当月还款%d天",([dueDateCommon intValue]-[dateArray[2] intValue])];
        }
    }
    self.dueDateMoneyLabel.text =currentDetailS;
    self.distanceDay.text = currentDateS;
    
    NSString *lastDueDate;
    int lastType = 0;
    if ([cardInfoModel.dueDate intValue]==0) {
        
        if (([cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue])>monthDays) {
            
            lastDueDate =[self changeLowTen:[NSString stringWithFormat:@"%d",[cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue]-monthDays]];
        }else{
            int nextMonthDays =[self numberOfDayInMonthWithDateStr:[self setupRequestMonth:1]];
            if ([cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue]>nextMonthDays) {
                
                lastType = 1;
                lastDueDate =[self changeLowTen:[NSString stringWithFormat:@"%d",[cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue]-nextMonthDays]];
            }else{
                
                lastDueDate =[self changeLowTen:[NSString stringWithFormat:@"%d",[cardInfoModel.billDate intValue]+[cardInfoModel.dueDateDay intValue]]];
            }
        }
    }else{
    
        int nextMonthDays =[self numberOfDayInMonthWithDateStr:[self setupRequestMonth:1]];
        if ([cardInfoModel.dueDate intValue] > nextMonthDays) {
            lastDueDate = @"";
            lastType = 2;
        }else{
            
            lastDueDate =cardInfoModel.dueDate;
        }
    }
    if (lastType == 1) {
        
        int dayNumber = [dateArray[1] intValue];
        currentDetailS = [NSString stringWithFormat:@"下月还款日：%@月%@日",[self changeLowTen:[NSString stringWithFormat:@"%d",(dayNumber==12?2:dayNumber==11?1:[dateArray[1] intValue]+1)]],[self changeLowTen:lastDueDate]];
        
        int currentMonthdays = [self calculationThisMonthDays:[NSDate date]];
        int nextMonthDays =[self numberOfDayInMonthWithDateStr:[self setupRequestMonth:1]];
        currentDateS =[NSString stringWithFormat:@"距下月还款%d天",currentMonthdays-[dateArray.lastObject intValue]+[lastDueDate intValue]+nextMonthDays];
    }else if (lastType == 2){

        currentDetailS = [NSString stringWithFormat:@"下月没有%@日，还款日建议重新设定（有些卡使用的是间隔天数）",cardInfoModel.dueDate];
        currentDateS = @"";
    }else{
        
        
        currentDetailS = [NSString stringWithFormat:@"下月还款日：%@月%@日",[self changeLowTen:[NSString stringWithFormat:@"%d",([dateArray[1] intValue]+1)>12?1:([dateArray[1] intValue]+1)]],[self changeLowTen:lastDueDate]];
        int currentMonthdays = [self calculationThisMonthDays:[NSDate date]];
        currentDateS =[NSString stringWithFormat:@"距下月还款%d天",currentMonthdays-[dateArray.lastObject intValue]+[lastDueDate intValue]];
    }
    self.lastDueDateMoneyLabel.text =currentDetailS;
    self.nextDueDate.text =currentDateS;
}
#pragma mark-textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)buttonCopyMethod:(UIButton *)button{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.bankNumberLabel.text;
    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"提示" message:@"卡号已粘贴" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [alertView show];
}
-(NSString *)changeLowTen:(NSString *)numberS{
    
    if ([numberS intValue]<10&&numberS.length<=1) {
        
        numberS=[NSString stringWithFormat:@"0%@",numberS];
    }
    return numberS;
}
- (int)numberOfDayInMonthWithDateStr:(NSString *)dateStr {
    
    NSDate * date = [self dateWithdateSr:dateStr];
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange monthRange =  [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return (int)monthRange.length;
}
- (NSDate *)dateWithdateSr:(NSString *)dateStr {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:dateStr];
    return date;
}
-(NSString *)setupRequestMonth:(int)month
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:month];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}
- (int)calculationThisMonthDays:(NSDate *)day
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    if (day) {
        
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:day];
        return (int)range.length;
    }
    return 30;
}
@end
