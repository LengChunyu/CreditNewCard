//
//  RepaymentViewController.m
//  CreditCard
//
//  Created by liujingtao on 2019/2/18.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "RepaymentViewController.h"
#import "UNNotificationsManager.h"
#import "FacePickerView.h"
@interface RepaymentViewController ()<UITextFieldDelegate,JVAlertViewDelegate>
@property (nonatomic,strong) UIScrollView *myScrollView;
@property (nonatomic,strong) UIView *firstBackView;
@property (nonatomic,strong) UILabel *dueDateMoneyLabel;//到期还款金额
@property (nonatomic,strong) UILabel *lastDueDateMoneyLabel;//下个月到期划款的金额
@property (nonatomic,strong) UILabel *dueDateLabel;
@property (nonatomic,strong) UILabel *lastDueDateLabel;
@property (nonatomic,strong) UIView  *firstLion;
@property (nonatomic,strong) UILabel *monthbillDateLabel;//本月账单日
@property (nonatomic,strong) UILabel *monthbillDate;
@property (nonatomic,strong) UILabel *nextMonthbillDateLabel;//下个月账单日
@property (nonatomic,strong) UILabel *nextMonthBillDate;
@property (nonatomic,strong) UILabel *availabilityLimitLabel;//剩余额度
@property (nonatomic,strong) UILabel *availabilityLimitMoneyLabel;

@property (nonatomic,strong) UIView *secondBackView;  //第二个
@property (nonatomic,strong) UILabel *repaymentNameLabel;
@property (nonatomic,strong) UILabel *repaymentMoneyLabel;
@property (nonatomic,strong) UILabel *showDateLabel;
@property (nonatomic,strong) UIImageView *rightImageView;
@property (nonatomic,strong) UISwitch *secondNoticeSwitch;

@property (nonatomic,strong) UIView *threeBackView; //第三个
@property (nonatomic,strong) UILabel *consumeNameLabel;
@property (nonatomic,strong) UILabel *consumeMoneyLabel;
@property (nonatomic,strong) UILabel *otherSowDateLabel;
@property (nonatomic,strong) UIImageView *otherRightImageView;
@property (nonatomic,strong) UISwitch *threeNoticeSwitch;

@property (nonatomic,strong) UITextField *contentTextField;
@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,assign) int selectIndex;

@property (nonatomic,copy) NSString *noticeDateS;
@property (nonatomic,copy) NSString *noticeBillDateS;
@property (nonatomic,strong) NSMutableArray *allNoticeMuArray;
@property (nonatomic,strong) FacePickerView *firstPickerView;


@end

@implementation RepaymentViewController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if ([self.navigationController isKindOfClass:[BBNavigationController class]]) {
        
        BBNavigationController *bbNavigation =(BBNavigationController *)self.navigationController;
        bbNavigation.panBeginBlock =nil;
        bbNavigation.panEndFailedBlock = nil;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.navigationController isKindOfClass:[BBNavigationController class]]) {
        
        BBNavigationController *bbNavigation =(BBNavigationController *)self.navigationController;
        bbNavigation.panBeginBlock = ^{
            
            self.myScrollView.scrollEnabled =NO;
        };
        bbNavigation.panEndFailedBlock = ^{
            
            self.myScrollView.scrollEnabled =YES;
        };
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    NSArray *userDefaultArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"allNotice"];
    if (userDefaultArray) {
        self.allNoticeMuArray = [[NSMutableArray alloc] initWithArray:userDefaultArray];
    }else{
        self.allNoticeMuArray = [[NSMutableArray alloc] init];
    }
    [self creatSubViews];
}
-(void)creatSubViews{
 
    NSDateFormatter *dateformatter =[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString= [dateformatter stringFromDate:[NSDate date]];
    NSArray *dateArray =[newDateString componentsSeparatedByString:@"-"];
    
    self.myScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,(iphoneX||iphoneXR||iphoneXSM?88:64), self.view.width,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88+34:64))];
    self.myScrollView.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    self.myScrollView.contentSize =CGSizeMake(self.view.width,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88+33:63));
    [self.view addSubview:self.myScrollView];
    
    UITapGestureRecognizer *oneTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap:)];
    oneTap.numberOfTapsRequired =1;
    oneTap.numberOfTouchesRequired =1;
    [self.myScrollView addGestureRecognizer:oneTap];
    
    self.firstBackView =[[UIView alloc] initWithFrame:CGRectMake(10,10,self.view.width-20,120)];
    self.firstBackView.layer.cornerRadius =10;
    self.firstBackView.clipsToBounds =YES;
    self.firstBackView.backgroundColor =[UIColor whiteColor];
    [self.myScrollView addSubview:self.firstBackView];
    
    self.dueDateMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5,(self.firstBackView.width-20)/2,20)];
    self.dueDateMoneyLabel.font =[UIFont systemFontOfSize:13];
    self.dueDateMoneyLabel.text =[NSString stringWithFormat:@"本月应还：%0.2f",[self.cardModel.dueDateMoney floatValue]];
    self.dueDateMoneyLabel.textColor =[UIColor blackColor];
    self.dueDateMoneyLabel.textAlignment =NSTextAlignmentLeft;
    [self.firstBackView addSubview:self.dueDateMoneyLabel];
    
    self.lastDueDateMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.dueDateMoneyLabel.left, self.dueDateMoneyLabel.bottom,self.dueDateMoneyLabel.width,20)];
    self.lastDueDateMoneyLabel.font =[UIFont systemFontOfSize:13];
    self.lastDueDateMoneyLabel.textColor =[UIColor blackColor];
    self.lastDueDateMoneyLabel.text =[NSString stringWithFormat:@"下月应还：%0.2f",[self.cardModel.lastDueDateMoney floatValue]];
    self.lastDueDateMoneyLabel.textAlignment =NSTextAlignmentLeft;
    [self.firstBackView addSubview:self.lastDueDateMoneyLabel];
    
    
    self.dueDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.dueDateMoneyLabel.right, self.dueDateMoneyLabel.top, self.dueDateMoneyLabel.width, 20)];
    self.dueDateLabel.font =[UIFont systemFontOfSize:13];
    self.dueDateLabel.textColor =[UIColor blackColor];
    self.dueDateLabel.textAlignment =NSTextAlignmentRight;
    self.dueDateLabel.text =self.monthDueString;
    [self.firstBackView addSubview:self.dueDateLabel];
    
    self.lastDueDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.lastDueDateMoneyLabel.right, self.lastDueDateMoneyLabel.top, self.lastDueDateMoneyLabel.width, 20)];
    self.lastDueDateLabel.font =[UIFont systemFontOfSize:13];
    self.lastDueDateLabel.textColor =[UIColor blackColor];
    self.lastDueDateLabel.textAlignment =NSTextAlignmentRight;
    self.lastDueDateLabel.text =self.nextMonthDueString;
    [self.firstBackView addSubview:self.lastDueDateLabel];
    
    self.firstLion =[[UIView alloc]initWithFrame:CGRectMake(10,self.lastDueDateLabel.bottom+5,self.firstBackView.width-20, 1)];
    self.firstLion.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    [self.firstBackView addSubview:self.firstLion];
    
    self.monthbillDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, self.firstLion.bottom+5, self.lastDueDateLabel.width, 20)];
    self.monthbillDateLabel.font =[UIFont systemFontOfSize:13];
    self.monthbillDateLabel.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    self.monthbillDateLabel.textAlignment =NSTextAlignmentLeft;
    self.monthbillDateLabel.text =@"本月的账单日";
    [self.firstBackView addSubview:self.monthbillDateLabel];
    
    self.monthbillDate =[[UILabel alloc]initWithFrame:CGRectMake(self.monthbillDateLabel.right,self.monthbillDateLabel.top, self.monthbillDateLabel.width, 20)];
    self.monthbillDate.font =[UIFont systemFontOfSize:13];
    self.monthbillDate.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    self.monthbillDate.textAlignment =NSTextAlignmentRight;
    self.monthbillDate.text =[NSString stringWithFormat:@"%@月%@日",dateArray[1],[self changeLowTen:self.cardModel.billDate]];
    [self.firstBackView addSubview:self.monthbillDate];
    
    self.nextMonthbillDateLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, self.monthbillDateLabel.bottom, self.monthbillDateLabel.width, 20)];
    self.nextMonthbillDateLabel.font =[UIFont systemFontOfSize:13];
    self.nextMonthbillDateLabel.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    self.nextMonthbillDateLabel.textAlignment =NSTextAlignmentLeft;
    self.nextMonthbillDateLabel.text =@"下个月的账单日";
    [self.firstBackView addSubview:self.nextMonthbillDateLabel];
    
    self.nextMonthBillDate =[[UILabel alloc]initWithFrame:CGRectMake(self.nextMonthbillDateLabel.right, self.monthbillDateLabel.bottom, self.nextMonthbillDateLabel.width, 20)];
    self.nextMonthBillDate.font =[UIFont systemFontOfSize:13];
    self.nextMonthBillDate.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    self.nextMonthBillDate.textAlignment =NSTextAlignmentRight;
    self.nextMonthBillDate.text =[NSString stringWithFormat:@"%@月%@日",[self changeLowTen:[NSString stringWithFormat:@"%d",([dateArray[1] intValue]+1)>12?1:([dateArray[1] intValue]+1)]],[self changeLowTen:self.cardModel.billDate]];
    [self.firstBackView addSubview:self.nextMonthBillDate];
    
    self.availabilityLimitLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, self.nextMonthbillDateLabel.bottom, self.nextMonthbillDateLabel.width, 20)];
    self.availabilityLimitLabel.font =[UIFont systemFontOfSize:13];
    self.availabilityLimitLabel.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    self.availabilityLimitLabel.textAlignment =NSTextAlignmentLeft;
    self.availabilityLimitLabel.text =@"可用额度";
    [self.firstBackView addSubview:self.availabilityLimitLabel];
    
    self.availabilityLimitMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.availabilityLimitLabel.right, self.availabilityLimitLabel.top, self.availabilityLimitLabel.width, 20)];
    self.availabilityLimitMoneyLabel.font =[UIFont systemFontOfSize:13];
    self.availabilityLimitMoneyLabel.textColor =[UIColor colorWithRed:0.40 green:0.40 blue:0.40 alpha:1.00];
    self.availabilityLimitMoneyLabel.textAlignment =NSTextAlignmentRight;
    self.availabilityLimitMoneyLabel.text =[NSString stringWithFormat:@"%0.2f",[self.cardModel.availabilityLimit floatValue]];
    [self.firstBackView addSubview:self.availabilityLimitMoneyLabel];
    
    self.secondBackView =[[UIView alloc]initWithFrame:CGRectMake(10, self.firstBackView.bottom+20,self.view.width-20, 80)];
    self.secondBackView.layer.cornerRadius =10;
    self.secondBackView.clipsToBounds =YES;
    self.secondBackView.backgroundColor =[UIColor whiteColor];
    [self.myScrollView addSubview:self.secondBackView];
    
    self.repaymentNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0,(self.secondBackView.width-20)/2, 40)];
    self.repaymentNameLabel.font =[UIFont systemFontOfSize:13];
    self.repaymentNameLabel.textColor =[UIColor blackColor];
    self.repaymentNameLabel.textAlignment =NSTextAlignmentLeft;
    self.repaymentNameLabel.text =@"还款提醒";
    [self.secondBackView addSubview:self.repaymentNameLabel];
    
    self.repaymentMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(10,self.repaymentNameLabel.bottom,100,40)];
    self.repaymentMoneyLabel.text =@"提醒日期";
    self.repaymentMoneyLabel.font =[UIFont systemFontOfSize:13];
    self.repaymentMoneyLabel.textColor =[UIColor blackColor];
    self.repaymentMoneyLabel.textAlignment =NSTextAlignmentLeft;
    [self.secondBackView addSubview:self.repaymentMoneyLabel];
    
    
    self.secondNoticeSwitch =[[UISwitch alloc]initWithFrame:CGRectZero];
    [self.secondNoticeSwitch addTarget:self action:@selector(secondNoticeChanged:) forControlEvents:UIControlEventValueChanged];
    self.secondNoticeSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.secondBackView addSubview:self.secondNoticeSwitch];
    [self.secondNoticeSwitch setOn:[self.cardModel.isOpenDueNotice intValue]];
    self.secondNoticeSwitch.frame =CGRectMake(self.secondBackView.width-self.secondNoticeSwitch.width-30*WIDTHRATIO,(40-self.secondNoticeSwitch.height)/2,self.secondNoticeSwitch.width,self.secondNoticeSwitch.height);

    UIImage *rightImage = [UIImage imageNamed:@"icon-right-n"];
    self.showDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.secondBackView.width-200, 40, 200-rightImage.size.width-5, 40)];
    self.showDateLabel.font = [UIFont systemFontOfSize:13];
    self.showDateLabel.textColor = [UIColor redColor];
    self.showDateLabel.textAlignment = NSTextAlignmentRight;
    [self.secondBackView addSubview:self.showDateLabel];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.showDateLabel.right, self.showDateLabel.top+(40-rightImage.size.height)/2, rightImage.size.width, rightImage.size.height)];
    self.rightImageView.image = rightImage;
    [self.secondBackView addSubview:self.rightImageView];
    
    UIButton *secondTopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.repaymentNameLabel.bottom, self.secondBackView.width, 40)];
    secondTopButton.tag = 500;
    [secondTopButton addTarget:self action:@selector(selectDateButton:) forControlEvents:UIControlEventTouchUpInside];
    [secondTopButton addTarget:self action:@selector(selectDateCanncelButton:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    [secondTopButton addTarget:self action:@selector(selectDateDownButton:) forControlEvents:UIControlEventTouchDown];
    [self.secondBackView addSubview:secondTopButton];
    
    
    self.threeBackView =[[UIView alloc]initWithFrame:CGRectMake(10, self.secondBackView.bottom+20,self.view.width-20, 80)];
    self.threeBackView.layer.cornerRadius =10;
    self.threeBackView.clipsToBounds =YES;
    self.threeBackView.backgroundColor =[UIColor whiteColor];
    [self.myScrollView addSubview:self.threeBackView];
    
    
    self.consumeNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0,(self.threeBackView.width-20)/2, 40)];
    self.consumeNameLabel.font =[UIFont systemFontOfSize:13];
    self.consumeNameLabel.textColor =[UIColor blackColor];
    self.consumeNameLabel.textAlignment =NSTextAlignmentLeft;
    self.consumeNameLabel.text =@"账单提醒";
    [self.threeBackView addSubview:self.consumeNameLabel];
    
    self.consumeMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(10,self.consumeNameLabel.bottom,100,40)];
    self.consumeMoneyLabel.text =@"提醒日期";
    self.consumeMoneyLabel.font =[UIFont systemFontOfSize:13];
    self.consumeMoneyLabel.textColor =[UIColor blackColor];
    self.consumeMoneyLabel.textAlignment =NSTextAlignmentLeft;
    [self.threeBackView addSubview:self.consumeMoneyLabel];
    

    self.threeNoticeSwitch =[[UISwitch alloc]initWithFrame:CGRectZero];
    [self.threeNoticeSwitch addTarget:self action:@selector(secondNoticeChanged:) forControlEvents:UIControlEventValueChanged];
    self.threeNoticeSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
    [self.threeBackView addSubview:self.threeNoticeSwitch];
    [self.threeNoticeSwitch setOn:[self.cardModel.isOpenBillNotice intValue]];
    self.threeNoticeSwitch.frame =CGRectMake(self.threeBackView.width-self.threeNoticeSwitch.width-30*WIDTHRATIO,(40-self.threeNoticeSwitch.height)/2,self.threeNoticeSwitch.width,self.threeNoticeSwitch.height);
    

    self.otherSowDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.threeBackView.width-200, 40, 200-rightImage.size.width-5, 40)];
    self.otherSowDateLabel.font = [UIFont systemFontOfSize:13];
    self.otherSowDateLabel.textColor = [UIColor redColor];
    self.otherSowDateLabel.textAlignment = NSTextAlignmentRight;
    [self.threeBackView addSubview:self.otherSowDateLabel];
    
    self.otherRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.otherSowDateLabel.right, self.otherSowDateLabel.top+(40-rightImage.size.height)/2, rightImage.size.width, rightImage.size.height)];
    self.otherRightImageView.image = rightImage;
    [self.threeBackView addSubview:self.otherRightImageView];
    
    UIButton *secondOtherTopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.repaymentNameLabel.bottom, self.secondBackView.width, 40)];
    secondOtherTopButton.tag = 501;
    [secondOtherTopButton addTarget:self action:@selector(selectDateButton:) forControlEvents:UIControlEventTouchUpInside];
    [secondOtherTopButton addTarget:self action:@selector(selectDateCanncelButton:) forControlEvents:UIControlEventTouchCancel|UIControlEventTouchUpOutside];
    [secondOtherTopButton addTarget:self action:@selector(selectDateDownButton:) forControlEvents:UIControlEventTouchDown];
    [self.threeBackView addSubview:secondOtherTopButton];
    
    if ([self.cardModel.dueNoticeDate intValue]==0) {
        
        self.noticeDateS = [[self getCurrentMonthDueDate] isEqualToString:@"顺延"]?[self getLastMonthDueDate]:[self getCurrentMonthDueDate];
        if (self.secondNoticeSwitch.isOn) {
            
            [self secondNoticeChanged:self.secondNoticeSwitch];
        }
    }else{
        
        self.noticeDateS = [self changeLowTen:self.cardModel.dueNoticeDate];
    }
    if ([self.cardModel.billNoticeDate intValue]==0) {
        
        self.noticeBillDateS = [self changeLowTen:self.cardModel.billDate];
        if (self.threeNoticeSwitch.isOn) {
            
            [self secondNoticeChanged:self.threeNoticeSwitch];
        }
    }else{
        
        self.noticeBillDateS = [self changeLowTen:self.cardModel.billNoticeDate];
    }
    self.showDateLabel.text = [NSString stringWithFormat:@"每月%@日",self.noticeDateS];
    self.otherSowDateLabel.text = [NSString stringWithFormat:@"每月%@日",self.noticeBillDateS];
    self.firstPickerView = [self selectDateView:0];
    [self.view addSubview:self.firstPickerView];
}
-(void)secondNoticeChanged:(UISwitch *)buttton{
    
    if (buttton==self.secondNoticeSwitch) {

        if (buttton.isOn) {
            //首先删除之前的推送
            NSMutableArray *copyMuArray = [self.allNoticeMuArray mutableCopy];
            for (NSString *identifer in copyMuArray) {
                if ([identifer hasPrefix:[NSString stringWithFormat:@"%@_due",self.cardModel.bankNumber]]) {
                    
                    [UNNotificationsManager removeNotificationWithIdentifer:identifer];
                    [self.allNoticeMuArray removeObject:identifer];
                }
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString =[dateFormatter stringFromDate:[NSDate date]];
            NSString *preDate = [dateString substringToIndex:dateString.length-11];
            //添加对应的推送
            if ([self.cardModel.dueNoticeDate intValue]==0) {
                //计算出当月的和下月的日期一起加上
                if ([self.cardModel.dueDate intValue]==0) {
                    //这个月和下个月都需要弄一下
                    NSString *currentDueDay = [self getCurrentMonthDueDate];
                    if ([currentDueDay isEqualToString:@"顺延"]) {
                        
                        NSString *lastDueDay = [self getLastMonthDueDate];
                        NSString *lastMonthTime = [self setupRequestMonth:[NSDate date] withMonth:1];
                        NSString *lastPreDateS = [lastMonthTime substringToIndex:8];
                        NSString *lastResultDateS = [lastPreDateS stringByAppendingString:[NSString stringWithFormat:@"%@ 09:00:00",lastDueDay]];
                        NSDate *lastResultDate = [dateFormatter dateFromString:lastResultDateS];
                        
                        if (@available(iOS 10.0, *)) {
                        
                            NSString *lastIdentifer = [NSString stringWithFormat:@"%@_due_%@",self.cardModel.bankNumber,lastResultDateS];
                            [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound defaultSound]] dateComponents:[UNNotificationsManager componentsWithDate:lastResultDate] identifer:lastIdentifer isRepeat:NO completionHanler:^(NSError *error) {
                                NSLog(@"add error %@", error);
                                [self.allNoticeMuArray addObject:lastIdentifer];
                                [self saveLocalData];
                            }];
                        }
                    }else{
                        
                        NSString *lastDueDay = [self getLastMonthDueDate];
                        NSString *resultDateS = [preDate stringByAppendingString:[NSString stringWithFormat:@"%@ 09:00:00",currentDueDay]];
                        NSDate *resultDate = [dateFormatter dateFromString:resultDateS];
                        
                        NSString *lastMonthTime = [self setupRequestMonth:[NSDate date] withMonth:1];
                        NSString *lastPreDateS = [lastMonthTime substringToIndex:8];
                        NSString *lastResultDateS = [lastPreDateS stringByAppendingString:[NSString stringWithFormat:@"%@ 09:00:00",lastDueDay]];
                        NSDate *lastResultDate = [dateFormatter dateFromString:lastResultDateS];
                        
                        if (@available(iOS 10.0, *)) {
                            
                            NSString *identifer = [NSString stringWithFormat:@"%@_due_%@",self.cardModel.bankNumber,resultDateS];
                            NSString *lastIdentifer = [NSString stringWithFormat:@"%@_due_%@",self.cardModel.bankNumber,lastResultDateS];
                            [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound defaultSound]] dateComponents:[UNNotificationsManager componentsWithDate:resultDate] identifer:identifer isRepeat:NO completionHanler:^(NSError *error) {
                                NSLog(@"add error %@", error);
                                [self.allNoticeMuArray addObject:identifer];
                                [self saveLocalData];
                            }];
                            [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound defaultSound]] dateComponents:[UNNotificationsManager componentsWithDate:lastResultDate] identifer:lastIdentifer isRepeat:NO completionHanler:^(NSError *error) {
                                NSLog(@"add error %@", error);
                                [self.allNoticeMuArray addObject:lastIdentifer];
                                [self saveLocalData];
                            }];
                        }
                    }
                }else{
                    //直接添加一个日期就行  preDate
                    NSString *resultDateS = [@"2020-03-" stringByAppendingString:[NSString stringWithFormat:@"%@ 09:00:00",[self changeLowTen:self.cardModel.dueDate]]];
                    NSDate *resultDate = [dateFormatter dateFromString:resultDateS];
                    NSString *identifer = [NSString stringWithFormat:@"%@_due_%@",self.cardModel.bankNumber,resultDateS];
                    if (@available(iOS 10.0, *)) {
                        
                        [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound defaultSound]] dateComponents:[UNNotificationsManager componentsEveryMonthWithDate:resultDate] identifer:[NSString stringWithFormat:@"%@_due_%@",self.cardModel.bankNumber,resultDateS] isRepeat:YES completionHanler:^(NSError *error) {
                            NSLog(@"add error %@", error);
                            [self.allNoticeMuArray addObject:identifer];
                            [self saveLocalData];
                        }];
                    }
                }
                
            }else{
        
                NSString *resultDateS = [@"2020-03-" stringByAppendingString:[NSString stringWithFormat:@"%@ 09:00:00",[self changeLowTen:self.cardModel.dueNoticeDate]]];
                NSDate *resultDate = [dateFormatter dateFromString:resultDateS];
                NSString *identifer = [NSString stringWithFormat:@"%@_due_%@",self.cardModel.bankNumber,resultDateS];
                if (@available(iOS 10.0, *)) {
                    
                    [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound defaultSound]] dateComponents:[UNNotificationsManager componentsEveryMonthWithDate:resultDate] identifer:[NSString stringWithFormat:@"%@_due_%@",self.cardModel.bankNumber,resultDateS] isRepeat:YES completionHanler:^(NSError *error) {
                        NSLog(@"add error %@", error);
                        [self.allNoticeMuArray addObject:identifer];
                        [self saveLocalData];
                    }];
                } else {
                    
                }
            }
        }else{
            //直接删除对应的推送
            NSMutableArray *copyMuArray = [self.allNoticeMuArray mutableCopy];
            for (NSString *identifer in copyMuArray) {
                if ([identifer hasPrefix:[NSString stringWithFormat:@"%@_due",self.cardModel.bankNumber]]) {
                    
                    [UNNotificationsManager removeNotificationWithIdentifer:identifer];
                    [self.allNoticeMuArray removeObject:identifer];
                }
            }
            [self saveLocalData];
        }
        self.cardModel.isOpenDueNotice = buttton.isOn?@"1":@"0";
    }else if (buttton==self.threeNoticeSwitch){
        if (buttton.isOn) {
            NSMutableArray *copyMuArray = [self.allNoticeMuArray mutableCopy];
            for (NSString *identifer in copyMuArray) {
                if ([identifer hasPrefix:[NSString stringWithFormat:@"%@_bill",self.cardModel.bankNumber]]) {
                    
                    [UNNotificationsManager removeNotificationWithIdentifer:identifer];
                    [self.allNoticeMuArray removeObject:identifer];
                }
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *dateString =[dateFormatter stringFromDate:[NSDate date]];
            NSString *preDate = [dateString substringToIndex:dateString.length-11];
            NSString *resultDateS = [@"2020-03-" stringByAppendingString:[NSString stringWithFormat:@"%@ 09:00:00",[self changeLowTen:self.cardModel.billDate]]];
            NSDate *resultDate = [dateFormatter dateFromString:resultDateS];
            NSString *identifer = [NSString stringWithFormat:@"%@_bill_%@",self.cardModel.bankNumber,resultDateS];
            if (@available(iOS 10.0, *)) {
                
                [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound defaultSound]] dateComponents:[UNNotificationsManager componentsEveryMonthWithDate:resultDate] identifer:[NSString stringWithFormat:@"%@_bill_%@",self.cardModel.bankNumber,resultDateS] isRepeat:YES completionHanler:^(NSError *error) {
                    NSLog(@"add error %@", error);
                    [self.allNoticeMuArray addObject:identifer];
                    [self saveLocalData];
                }];
            } else {
                
            }
            
        }else{
            NSMutableArray *copyMuArray = [self.allNoticeMuArray mutableCopy];
            for (NSString *identifer in copyMuArray) {
                if ([identifer hasPrefix:[NSString stringWithFormat:@"%@_bill",self.cardModel.bankNumber]]) {
                    
                    [UNNotificationsManager removeNotificationWithIdentifer:identifer];
                    [self.allNoticeMuArray removeObject:identifer];
                }
            }
            [self saveLocalData];
        }
        self.cardModel.isOpenBillNotice = buttton.isOn?@"1":@"0";
    }
    //更新数据
    NSDictionary *cardInfoDic =@{@"bankNumber":self.cardModel.bankNumber,@"isOpenDueNotice":self.cardModel.isOpenDueNotice,@"isOpenBillNotice":self.cardModel.isOpenBillNotice,@"dueNoticeDate":self.cardModel.dueNoticeDate,@"billNoticeDate":self.cardModel.billNoticeDate};
    [[CardDataFMDB shareSqlite]updateCardNotice:cardInfoDic];
    if (self.delegate && [self.delegate respondsToSelector:@selector(saveButtonClickDelegateBankNumber:withIndexPath:)]) {
        //更新信用卡的数据
        [self.delegate saveButtonClickDelegateBankNumber:self.cardModel.bankNumber withIndexPath:self.indexPath];
    }
}
-(void)saveLocalData{
    
    [[NSUserDefaults standardUserDefaults]setObject:self.allNoticeMuArray forKey:@"allNotice"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(void)selectDateButton:(UIButton *)button{
    
    self.selectIndex = (int)button.tag-500;
    
    if (self.selectIndex==0) {
        
        NSString *firstS = [self.showDateLabel.text substringToIndex:self.showDateLabel.text.length-1];
        NSString *secondS = [firstS substringFromIndex:2];
        [self.firstPickerView setSelectIndex:[secondS intValue]-1];
    }else{
        
        NSString *firstS = [self.otherSowDateLabel.text substringToIndex:self.otherSowDateLabel.text.length-1];
        NSString *secondS = [firstS substringFromIndex:2];
        [self.firstPickerView setSelectIndex:[secondS intValue]-1];
    }
    [UIView animateWithDuration:0.5 animations:^{

        if (button.tag==500) {

            self.showDateLabel.alpha = 1.0;
            self.repaymentMoneyLabel.alpha = 1.0;
            self.rightImageView.alpha = 1.0;
        }else{

            self.otherSowDateLabel.alpha = 1.0;
            self.consumeMoneyLabel.alpha = 1.0;
            self.otherRightImageView.alpha = 1.0;
        }
        self.firstPickerView.transform = CGAffineTransformMakeTranslation(0, -self.firstPickerView.height);
    }];
    NSLog(@"出现了\n");
}
-(void)selectDateDownButton:(UIButton *)button{
   
    if (button.tag==500) {
        
        self.showDateLabel.alpha = 0.5;
        self.repaymentMoneyLabel.alpha = 0.5;
        self.rightImageView.alpha = 0.5;
    }else{
        
        self.otherSowDateLabel.alpha = 0.5;
        self.consumeMoneyLabel.alpha = 0.5;
        self.otherRightImageView.alpha = 0.5;
    }
    NSLog(@"刚开始\n");
}
-(void)selectDateCanncelButton:(UIButton *)button{
    
    [UIView animateWithDuration:0.5 animations:^{
        if (button.tag==500) {
            
            self.showDateLabel.alpha = 1.0;
            self.repaymentMoneyLabel.alpha = 1.0;
            self.rightImageView.alpha = 1.0;
        }else{
            
            self.otherSowDateLabel.alpha = 1.0;
            self.consumeMoneyLabel.alpha = 1.0;
            self.otherRightImageView.alpha = 1.0;
        }
    }];
    NSLog(@"离开了\n");
}
-(void)buttonClick:(UIButton *)button{
    

    
}
-(void)neverAlertButton:(UIButton *)button{
    
    button.selected =!button.selected;
}
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *packUpButton = [[UIBarButtonItem alloc] initWithTitle:@"收起" style:UIBarButtonItemStylePlain target:self action:@selector(packUpButton)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[space,packUpButton];
    return toolbar;
}
-(void)packUpButton{
    
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}
-(NSString *)changeLowTen:(NSString *)numberS{
    
    if ([numberS intValue]<10&&numberS.length<=1) {
        
        numberS=[NSString stringWithFormat:@"0%@",numberS];
    }
    return numberS;
}
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
-(void)dealloc{
    
    NSLog(@"dealloc");
}
#pragma mark-获取下个月的还款日
-(NSString *)getLastMonthDueDate{
    
    NSString *lastDueDate;
    if ([self.cardModel.dueDate intValue]==0) {
        
        NSDateFormatter *dateformatter =[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *newDateString= [dateformatter stringFromDate:[NSDate date]];
        int monthDays =[self numberOfDayInMonthWithDateStr:newDateString];
        if (([self.cardModel.billDate intValue]+[self.cardModel.dueDateDay intValue])>monthDays) {
            
            lastDueDate =[self changeLowTen:[NSString stringWithFormat:@"%d",[self.cardModel.billDate intValue]+[self.cardModel.dueDateDay intValue]-monthDays]] ;
        }else{
            
            lastDueDate =[self changeLowTen:[NSString stringWithFormat:@"%d",[self.cardModel.billDate intValue]+[self.cardModel.dueDateDay intValue]]];
        }
    }else{
        
        lastDueDate =self.cardModel.dueDate;
    }
    return lastDueDate;
}
#pragma mark-获取当月的还款日期
-(NSString *)getCurrentMonthDueDate{
    
    NSString *dueDateCommon;
    if ([self.cardModel.dueDate intValue]==0) {

        NSDateFormatter *dateformatter =[[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"yyyy-MM-dd"];
        NSString *newDateString= [dateformatter stringFromDate:[NSDate date]];
        int monthDays =[self numberOfDayInMonthWithDateStr:newDateString];
        if (([self.cardModel.billDate intValue]+[self.cardModel.dueDateDay intValue])>monthDays) {
        
            int upMonthDays =[self numberOfDayInMonthWithDateStr:[self setupRequestMonth:[NSDate date] withMonth:-1]];
            if ([self.cardModel.billDate intValue]+[self.cardModel.dueDateDay intValue]<=upMonthDays) {
                
                dueDateCommon =[self changeLowTen:[NSString stringWithFormat:@"%d",[self.cardModel.billDate intValue]+[self.cardModel.dueDateDay intValue]-upMonthDays]];
                //直接顺延了。
                return @"顺延";
            }else{
                
                dueDateCommon =[self changeLowTen:[NSString stringWithFormat:@"%d",[self.cardModel.billDate intValue]+[self.cardModel.dueDateDay intValue]-upMonthDays]];
            }
        }else{
        
            dueDateCommon =[self changeLowTen:[NSString stringWithFormat:@"%d",[self.cardModel.billDate intValue]+[self.cardModel.dueDateDay intValue]]];
        }
    }else{
        
        dueDateCommon =self.cardModel.dueDate;
    }
    return dueDateCommon;
}
- (int)numberOfDayInMonthWithDateStr:(NSString *)dateStr {
    
    NSDate * date = [self dateWithdateSr:dateStr];
    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange monthRange =  [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return (int)monthRange.length;
}
-(NSString *)setupRequestMonth:(NSDate *)date withMonth:(int)month{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
    [lastMonthComps setMonth:month];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:date options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    return dateStr;
}
- (NSDate *)dateWithdateSr:(NSString *)dateStr {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:dateStr];
    return date;
}
-(FacePickerView *)selectDateView:(int)tag{
    
    int keyBoardHeight =0;
    if (iphone4||iphone5||iPhone6||iphoneX||iphoneXS||iphoneXR) {
        
        keyBoardHeight =216;
    }else{
        keyBoardHeight =226;
    }
    if (iphoneXSM||iphoneXR||iphoneX) {
        keyBoardHeight += 34;
    }
    NSArray *commonArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"];
    FacePickerView *facePickerView =[[FacePickerView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen] .bounds.size.height,self.view.width,keyBoardHeight) withArray:commonArray withSelectIndex:4];
    facePickerView.pickerViewType = 0;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    backView.backgroundColor = [UIColor grayColor];
    [facePickerView addSubview:backView];
    UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-80, 0, 80, 40)];
    [sureButton setTitle:@"完成" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sureButton.tag = 400+tag;
    [backView addSubview:sureButton];
    
    return facePickerView;
}
-(void)sureButtonClick:(UIButton *)button{

    if (self.selectIndex==0) {
        
        self.showDateLabel.text = [NSString stringWithFormat:@"每月%d日",self.firstPickerView.pickerIndex+1];
    }else{
        
        self.otherSowDateLabel.text = [NSString stringWithFormat:@"每月%d日",self.firstPickerView.pickerIndex+1];
    }
    [UIView animateWithDuration:0.2 animations:^{
        
        self.firstPickerView.transform = CGAffineTransformIdentity;
    }];
}
-(void)oneTap:(UITapGestureRecognizer *)oneTap{
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.firstPickerView.transform = CGAffineTransformIdentity;
    }];
}
@end
