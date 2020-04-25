//
//  ConsumeBillVC.m
//  CreditCard
//
//  Created by liujingtao on 2019/3/8.
//  Copyright © 2019年 liujingtao. All rights reserved.

#import "ConsumeBillVC.h"
#import "JVCCreatImage.h"
#import "AllConsumInfoModel.h"
#import "ConsumeTableViewCell.h"
#import "MJRefresh.h"
#import "NoteViewController.h"
#import "RepayViewController.h"
#import "AccountBookViewController.h"
#import "AccountBookModel.h"
#import "GestureViewController.h"
@interface ConsumeBillVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,AddDataRefreshDelegate,SelectAccountBackDelegate,PasswordSetBack,RepayDataRefreshDelegate>{
    CGFloat kSuspendBtnWidth;
    CGFloat kSuspendBtnHeight;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UITableView *cardTableView;
@property (nonatomic,strong) UITableView *otherCardTableView;
@property (nonatomic,strong) NSMutableArray *consumeMuArray;
@property (nonatomic,strong) NSMutableArray *yearStringMuArray;
@property (nonatomic,assign) int selectIndex;
@property (nonatomic,assign) int otherSelectIndex;
@property (nonatomic,strong) NSMutableDictionary *markMuDic;
@property (nonatomic,strong) NSMutableArray *consumeSumMuArray;
@property (nonatomic,strong) NSMutableArray *incomSumMuArray;
@property (nonatomic,assign) CGFloat headAndFootY;
@property (nonatomic,assign) BOOL isRefreshOffset;
@property (nonatomic,assign) BOOL footLion;
@property (nonatomic,strong) UIButton *addNoteButton;
@property (nonatomic,strong) UILabel *allConsumeLabel;
@property (nonatomic,strong) UILabel *allRepayLabel;
@property (nonatomic,strong) UILabel *yearLabel;

@property (nonatomic,strong) UIView *rAndCView;
@property (nonatomic,strong) UIButton *accountBookButton; //账本button
@property (nonatomic,strong) AccountBookModel *selectAccountModel;//当前选中的账本
@property (nonatomic,assign) BOOL isReload;//将要显示的时候是否需要刷新刷剧
@property (nonatomic,copy) NSString *currentDateFirstTime;  //当前年份第一个数据的时间
@end

@implementation ConsumeBillVC
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
            
            self.cardTableView.scrollEnabled =NO;
            self.otherCardTableView.scrollEnabled =NO;
        };
        bbNavigation.panEndFailedBlock = ^{
            
            self.cardTableView.scrollEnabled =YES;
            self.otherCardTableView.scrollEnabled =YES;
        };
    }
    if (!self.isReload) {
        
        [self onlyReloadUI];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"列表";
    self.isReload =YES;
    self.consumeMuArray =[[NSMutableArray alloc]init];
    self.consumeSumMuArray =[[NSMutableArray alloc]init];
    self.incomSumMuArray =[[NSMutableArray alloc]init];
    self.yearStringMuArray =[[NSMutableArray alloc]init];
    self.markMuDic =[[NSMutableDictionary alloc]init];
    [self.markMuDic setObject:@"1" forKey:@"0"];
    self.view.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    self.selectIndex =0;
    
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *accountNameS=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectAccountName"];
    AccountBookModel *model;
    if ([accountNameS isEqualToString:@"总账本"]||accountNameS.length<=0) {
        
        model =[[AccountBookModel alloc] init];
        model.accountBookName =@"总账本";
        model.secretString =@"";
        model.isConsume =YES;
        model.isRepay =YES;
        model.isSecret =NO;
        model.isShowSwitch =YES;
        model.time =[dateFormatter stringFromDate:[NSDate date]];
    }else{
        
        NSArray *arrayAccountN =[[CardDataFMDB shareSqlite]queryAccountBookList:accountNameS];
        if (arrayAccountN.count>0) {
    
            AccountBookModel *otherModel =arrayAccountN[0];
            if (otherModel.isSecret) {
                //需要弹出密码锁
                GestureViewController *gestureVC =[[GestureViewController alloc] init];
                gestureVC.oldPassword =otherModel.secretString;
                gestureVC.isChangePassWord =NO;
                gestureVC.isHideDelete =YES;
                gestureVC.bookModel =otherModel;
                gestureVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                gestureVC.billPopBlock = ^{
                    [self.navigationController popViewControllerAnimated:NO];
                };
                [self presentViewController:gestureVC animated:NO completion:nil];
            }
            model =otherModel;
        }else{
            
            model =[[AccountBookModel alloc] init];
            model.accountBookName =@"总账本";
            model.secretString =@"";
            model.isConsume =YES;
            model.isRepay =YES;
            model.isSecret =NO;
            model.isShowSwitch =YES;
            model.time =[dateFormatter stringFromDate:[NSDate date]];
        }
    }
    self.selectAccountModel =model;
    [self creatTableView];
    //获取当前
    [self reloadDataSource:self.selectAccountModel.accountBookName];
}
-(void)creatTableView{
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0,iphoneX||iphoneXR||iphoneXSM?88:64,self.view.width,100)];
    UIImage *backImage =[JVCCreatImage creatImageFromColors:@[[UIColor colorWithRed:0.97 green:0.42 blue:0.38 alpha:1.00],[UIColor colorWithRed:0.91 green:0.13 blue:0.20 alpha:1.00]] ByGradientType:leftToRight withFrame:CGRectMake(0, 0, self.view.width, 100)];
    headView.backgroundColor =[UIColor colorWithPatternImage:backImage];
    
    self.accountBookButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-120-20,(100-30)/2,120,30)];
    [self.accountBookButton setTitle:self.selectAccountModel.accountBookName forState:UIControlStateNormal];
    [self.accountBookButton addTarget:self action:@selector(changeAccountBookButton:) forControlEvents:UIControlEventTouchUpInside];
    self.accountBookButton.layer.cornerRadius =5.0f;
    self.accountBookButton.clipsToBounds =YES;
    self.accountBookButton.backgroundColor =[UIColor orangeColor];
    [headView addSubview:self.accountBookButton];
    [self.view addSubview:headView];
    
    self.yearLabel =[[UILabel alloc] initWithFrame:CGRectMake(20,0,150,40)];
    self.yearLabel.textAlignment =NSTextAlignmentLeft;
    self.yearLabel.textColor =[UIColor blackColor];
    self.yearLabel.font =[UIFont boldSystemFontOfSize:20];
    [headView addSubview:self.yearLabel];
    
    self.allConsumeLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, self.yearLabel.bottom,200,30)];
    self.allConsumeLabel.textAlignment =NSTextAlignmentLeft;
    self.allConsumeLabel.textColor =[UIColor whiteColor];
    self.allConsumeLabel.font =[UIFont systemFontOfSize:15];
    [headView addSubview:self.allConsumeLabel];
    
    self.allRepayLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, self.allConsumeLabel.bottom,200,30)];
    self.allRepayLabel.textAlignment =NSTextAlignmentLeft;
    self.allRepayLabel.textColor =[UIColor whiteColor];
    self.allRepayLabel.font =[UIFont systemFontOfSize:15];
    [headView addSubview:self.allRepayLabel];
    
    
    self.backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10,headView.bottom+10, self.view.width-20,SCREEN_HEIGHT-headView.bottom-(iphoneX||iphoneXR||iphoneXSM?34:20))];
    self.backScrollView.delegate =self;
    self.backScrollView.showsVerticalScrollIndicator = NO;
    self.backScrollView.showsHorizontalScrollIndicator = NO;
    self.backScrollView.bounces = NO;
    self.backScrollView.pagingEnabled = YES;
    self.backScrollView.scrollEnabled = NO;
    [self.view addSubview:self.backScrollView];
    
    self.cardTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,0,self.view.width-20,SCREEN_HEIGHT-headView.bottom-(iphoneX||iphoneXR||iphoneXSM?34:20)) style:UITableViewStylePlain];
    self.cardTableView.showsVerticalScrollIndicator = NO;
    self.cardTableView.showsHorizontalScrollIndicator = NO;
    self.cardTableView.layer.cornerRadius =10;
    self.cardTableView.clipsToBounds =YES;
    self.cardTableView.delegate =self;
    self.cardTableView.dataSource =self;
    self.cardTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.cardTableView.backgroundColor =[UIColor whiteColor];
    [self.backScrollView addSubview:self.cardTableView];
    
    self.otherCardTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,self.backScrollView.height,self.backScrollView.width,self.backScrollView.height) style:UITableViewStylePlain];
    self.otherCardTableView.showsVerticalScrollIndicator = NO;
    self.otherCardTableView.showsHorizontalScrollIndicator = NO;
    self.otherCardTableView.layer.cornerRadius =10;
    self.otherCardTableView.clipsToBounds =YES;
    self.otherCardTableView.delegate =self;
    self.otherCardTableView.dataSource =self;
    self.otherCardTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.otherCardTableView.backgroundColor =[UIColor whiteColor];
    [self.backScrollView addSubview:self.otherCardTableView];
    
    MJRefreshBackStateFooter *footer= [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshingData)];
    
    [footer setTitle:@"上拉查看上一年数据" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开可查看上一年数据" forState:MJRefreshStatePulling];
    [footer setTitle:@"没有更多的数据" forState:MJRefreshStateNoMoreData];
    
    MJRefreshStateHeader *header= [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshingData)];
    [header setTitle:@"下拉查看下一年数据" forState:MJRefreshStateIdle];
    [header setTitle:@"松开可查看下一年数据" forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden =YES;
    
    MJRefreshBackStateFooter *otherFooter = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshingData)];
    
    [otherFooter setTitle:@"上拉查看上一年数据" forState:MJRefreshStateIdle];
    [otherFooter setTitle:@"松开可查看上一年数据" forState:MJRefreshStatePulling];
    [otherFooter setTitle:@"我是有底线的" forState:MJRefreshStateNoMoreData];
    
    MJRefreshStateHeader *otherHeader = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshingData)];
    [otherHeader setTitle:@"下拉查看上一年数据" forState:MJRefreshStateIdle];
    [otherHeader setTitle:@"松开可查看上一年数据" forState:MJRefreshStatePulling];
    otherHeader.lastUpdatedTimeLabel.hidden =YES;
    
    
    self.cardTableView.mj_header =header;
    self.cardTableView.mj_footer =footer;
    
    self.otherCardTableView.mj_header =otherHeader;
    self.otherCardTableView.mj_footer =otherFooter;
    [self addRepayAndConsumButton:self.selectAccountModel.isConsume withRepay:self.selectAccountModel.isRepay];
}
-(void)addRepayAndConsumButton:(BOOL)isConsum withRepay:(BOOL)isRepay{
    
    [self.rAndCView removeFromSuperview];
    //创建添加按钮 -34*WIDTHRATIO
    UIImage *addImage =[UIImage imageNamed:@"btn_addRecod_n"];
    float buttonHeight =addImage.size.width*2*WIDTHRATIO-20;
    
    self.rAndCView =[[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-addImage.size.width*2*WIDTHRATIO,[UIScreen mainScreen].bounds.size.height-(iphoneX||iphoneXR||iphoneXSM?88:64)-24*WIDTHRATIO-addImage.size.width*2*WIDTHRATIO*(isConsum&&isRepay?2:1), addImage.size.width*2*WIDTHRATIO,(isConsum&&isRepay? buttonHeight*2:buttonHeight))];
    [self.view addSubview:self.rAndCView];
    
    if (isConsum&&isRepay) {
        
        self.addNoteButton =[[UIButton alloc]initWithFrame:CGRectMake(10,0, buttonHeight,buttonHeight)];
        self.addNoteButton.backgroundColor =[UIColor colorWithRed:0.46 green:0.67 blue:0.49 alpha:1.00];
        [self.addNoteButton addTarget:self action:@selector(addNoteClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.addNoteButton setTitle:@"支出" forState:UIControlStateNormal];
        self.addNoteButton.titleLabel.font =[UIFont systemFontOfSize:30*WIDTHRATIO];
        self.addNoteButton.layer.cornerRadius =addImage.size.width*WIDTHRATIO-10;
        self.addNoteButton.clipsToBounds =YES;
        [self.rAndCView addSubview:self.addNoteButton];
        
        UIButton *repayButton =[[UIButton alloc]initWithFrame:CGRectMake(10,buttonHeight, buttonHeight,buttonHeight)];
        repayButton.backgroundColor =[UIColor colorWithRed:0.95 green:0.21 blue:0.11 alpha:1.00];
        [repayButton addTarget:self action:@selector(addIncomeClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        [repayButton setTitle:@"收入" forState:UIControlStateNormal];
        repayButton.titleLabel.font =[UIFont systemFontOfSize:30*WIDTHRATIO];
        repayButton.layer.cornerRadius =addImage.size.width*WIDTHRATIO-10;
        repayButton.clipsToBounds =YES;
        [self.rAndCView addSubview:repayButton];
    }else{
        
        if (isConsum) {
            self.addNoteButton =[[UIButton alloc]initWithFrame:CGRectMake(10,0, buttonHeight,buttonHeight)];
            self.addNoteButton.backgroundColor =[UIColor colorWithRed:0.46 green:0.67 blue:0.49 alpha:1.00];
            [self.addNoteButton addTarget:self action:@selector(addNoteClickMethod:) forControlEvents:UIControlEventTouchUpInside];
            [self.addNoteButton setTitle:@"支出" forState:UIControlStateNormal];
            self.addNoteButton.titleLabel.font =[UIFont systemFontOfSize:30*WIDTHRATIO];
            self.addNoteButton.layer.cornerRadius =addImage.size.width*WIDTHRATIO-10;
            self.addNoteButton.clipsToBounds =YES;
            [self.rAndCView addSubview:self.addNoteButton];
        }else{
            UIButton *repayButton =[[UIButton alloc]initWithFrame:CGRectMake(10,0, buttonHeight,buttonHeight)];
            repayButton.backgroundColor =[UIColor colorWithRed:0.95 green:0.21 blue:0.11 alpha:1.00];
            [repayButton addTarget:self action:@selector(addIncomeClickMethod:) forControlEvents:UIControlEventTouchUpInside];
            [repayButton setTitle:@"收入" forState:UIControlStateNormal];
            repayButton.titleLabel.font =[UIFont systemFontOfSize:30*WIDTHRATIO];
            repayButton.layer.cornerRadius =addImage.size.width*WIDTHRATIO-10;
            repayButton.clipsToBounds =YES;
            [self.rAndCView addSubview:repayButton];
        }
    }
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesturAction:)];
    [self.rAndCView addGestureRecognizer:panGesture];
    
    kSuspendBtnWidth =addImage.size.width*2*WIDTHRATIO;
    kSuspendBtnHeight = (isConsum&&isRepay)?buttonHeight*2:buttonHeight;
    screenHeight =iphoneX||iphoneXR||iphoneXSM?SCREEN_HEIGHT-34:SCREEN_HEIGHT;
    screenWidth =SCREEN_WIDTH;
}
-(void)addNoteClickMethod:(UIButton *)button{
    //点击跳转添加界面
    NoteViewController *noteViewController =[[NoteViewController alloc]init];
    noteViewController.refreshDelegate =self;
    noteViewController.accountNameS =self.selectAccountModel.accountBookName;
    noteViewController.currentTime =self.currentDateFirstTime;
    [self.navigationController pushViewController:noteViewController animated:YES];
}
-(void)addIncomeClickMethod:(UIButton *)button{
    //点击跳转添加界面
    RepayViewController *repayViewController =[[RepayViewController alloc]init];
    repayViewController.refreshDelegate =self;
    repayViewController.accountNameS =self.selectAccountModel.accountBookName;
    repayViewController.currentTime =self.currentDateFirstTime;
    [self.navigationController pushViewController:repayViewController animated:YES];
}
-(void)changeAccountBookButton:(UIButton *)button{
    
    AccountBookViewController *accountBookVC =[[AccountBookViewController alloc]init];
    accountBookVC.accountBackDelegate =self;
    accountBookVC.titleString =button.titleLabel.text;
    [self.navigationController pushViewController:accountBookVC animated:YES];
}
//切换账本后的返回代理方法
-(void)accoutBackSelectModel:(AccountBookModel *)selectModel withIsReload:(BOOL)isReload{

    [self.accountBookButton setTitle:selectModel.accountBookName forState:UIControlStateNormal];
    self.selectAccountModel =selectModel;
    [self addRepayAndConsumButton:selectModel.isConsume withRepay:selectModel.isRepay];
    //根据选择的账本筛选数据 只是筛选数据不刷新
    self.isReload =isReload;
    if (isReload) {
       
        [self reloadDataSource:selectModel.accountBookName];
    }else{
        
        [self onlyReloadData:selectModel.accountBookName];
    }
}
-(void)customBackDelegateWithYearString:(NSString *)timeString{
    //获取当前的年份的数据，并且将数据插入到当前的self.customMuArray中
    NSArray *yearTimeArray =[timeString componentsSeparatedByString:@"-"];
    NSString *yearString =yearTimeArray[0];
    NSString *monthString =yearTimeArray[1];
    
    NSMutableArray *yearDataMuArray;
    if ([self.selectAccountModel.accountBookName isEqualToString:@"总账本"]) {
        NSArray *arrayAccountN =[[CardDataFMDB shareSqlite]queryAccountBookList:@""];
        NSMutableArray *accountNameArray=[[NSMutableArray alloc] init];
        [accountNameArray addObject:@"accountBookName = '总账本'"];
        for (AccountBookModel *bookModel in arrayAccountN) {
            
            if (!bookModel.isSecret||bookModel.isShowSwitch) {
                
                [accountNameArray addObject:[NSString stringWithFormat:@"accountBookName = '%@'",bookModel.accountBookName]];
            }
        }
        NSString *accountBackNameString;
        if (accountNameArray.count>1) {
            
            accountBackNameString =[accountNameArray componentsJoinedByString:@" or "];
        }else{
            accountBackNameString =@"accountBookName = '总账本'";
        }
        //遍历所有账本找出需要暂时的账本
        yearDataMuArray =[[CardDataFMDB shareSqlite]queryRecordsFromConsumInfoAccountName:accountBackNameString withYear:yearString];
    }else{
        //单独的账本遍历就行
        yearDataMuArray =[[CardDataFMDB shareSqlite]queryRecordsFromConsumInfoAccountName:[NSString stringWithFormat:@"accountBookName = '%@'",self.selectAccountModel.accountBookName] withYear:yearString];
    }
    
    
//    NSMutableArray *yearDataMuArray =[[CardDataFMDB shareSqlite]queryRecordsFromConsumInfoYearString:yearString];
    NSMutableArray *yearMuArray;
    NSMutableArray *monthMuArray;
    NSMutableArray *dayMuArray;
    NSMutableArray *yearSumMuArray;
    NSMutableArray *incomYearSumMuArray;
    NSMutableArray *monthSumMuArray;
    NSMutableArray *incomMonthSumMuArray;
    AllConsumInfoModel *otherModel;
    AllConsumInfoModel *sumOtherModel;
    int scrollViewMonth =1;
    NSDecimalNumber *monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
    NSDecimalNumber *incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
    NSDecimalNumber *daySum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
    NSDecimalNumber *dayIncomSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
    for (int i=0;i<yearDataMuArray.count;i++) {
        
        AllConsumInfoModel *allModel =yearDataMuArray[i];
        if (![[otherModel.time substringToIndex:10] isEqualToString:[allModel.time substringToIndex:10]]) {
            
            if (sumOtherModel) {
                
                sumOtherModel.daySumMoney =[NSString stringWithFormat:@"%@",daySum];
                sumOtherModel.dayIncomSumMoney =[NSString stringWithFormat:@"%@",dayIncomSum];
            }
            if ([[otherModel.time substringToIndex:7] isEqualToString:[allModel.time substringToIndex:7]]) {
                
                allModel.isDrawLion =YES;
            }
            allModel.isMarkTime =YES;
            daySum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
            dayIncomSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
            //判断是支持还是收入：1为支出。2位收入。
            if ([allModel.moneyType isEqualToString:@"1"]) {
                
                NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                daySum =[daySum decimalNumberByAdding:everyConsume];
            }else{
                
                NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                dayIncomSum =[dayIncomSum decimalNumberByAdding:everyConsume];
            }
            sumOtherModel =allModel;
        }else{
            
            if ([allModel.moneyType isEqualToString:@"1"]) {
                
                NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                daySum =[daySum decimalNumberByAdding:everyConsume];
            }else{
                
                NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                dayIncomSum =[dayIncomSum decimalNumberByAdding:everyConsume];
            }
        }
        if (i==yearDataMuArray.count-1&&sumOtherModel) {
            
            sumOtherModel.daySumMoney =[NSString stringWithFormat:@"%@",daySum];
            sumOtherModel.dayIncomSumMoney =[NSString stringWithFormat:@"%@",dayIncomSum];
        }
        otherModel =allModel;
        if (i==0) {
            
            yearMuArray =[[NSMutableArray alloc]init];
            monthMuArray =[[NSMutableArray alloc]init];
            dayMuArray =[[NSMutableArray alloc]init];
            yearSumMuArray =[[NSMutableArray alloc]init];
            incomYearSumMuArray =[[NSMutableArray alloc]init];
            monthSumMuArray =[[NSMutableArray alloc]init];
            incomMonthSumMuArray =[[NSMutableArray alloc]init];
            
            monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
            incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
            [dayMuArray addObject:allModel];
            if ([allModel.moneyType isEqualToString:@"1"]) {
                
                NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                monthSum =[monthSum decimalNumberByAdding:everyConsume];
            }else{
                
                NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
            }
            
        }else{
            
            AllConsumInfoModel *secondModel =dayMuArray[0];
            if ([secondModel.month intValue]!=[allModel.month intValue]&&i!=0) {
                if ([secondModel.year intValue]!=[allModel.year intValue]) {
                    
                    [monthMuArray addObject:dayMuArray];
                    [yearMuArray addObject:monthMuArray];
                    monthMuArray =[[NSMutableArray alloc]init];
                    dayMuArray =[[NSMutableArray alloc]init];
                    [dayMuArray addObject:allModel];
                    
                    [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                    [yearSumMuArray addObject:monthSumMuArray];
                    monthSumMuArray =[[NSMutableArray alloc]init];
                    monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                    
                    
                    [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                    [incomYearSumMuArray addObject:incomMonthSumMuArray];
                    incomMonthSumMuArray =[[NSMutableArray alloc]init];
                    incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                    
                    if ([allModel.moneyType isEqualToString:@"1"]) {
                        NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                        monthSum =[monthSum decimalNumberByAdding:everyConsume];
                    }else{
                        NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                        incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                    }
                }else{
                    
                    [monthMuArray addObject:dayMuArray];
                    dayMuArray =[[NSMutableArray alloc]init];
                    [dayMuArray addObject:allModel];
                    
                    [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                    monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                    
                    [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                    incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                    
                    if ([allModel.moneyType isEqualToString:@"1"]) {
                       
                        NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                        monthSum =[monthSum decimalNumberByAdding:everyConsume];
                    }else{
                        
                        NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                        incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                    }
                    
                }
            }else{
                
                if ([secondModel.year intValue]==[allModel.year intValue]) {
                    if ([allModel.moneyType isEqualToString:@"1"]) {
                        
                        NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                        monthSum =[monthSum decimalNumberByAdding:everyConsume];
                    }else{
                        
                        NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                        incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                    }
                    [dayMuArray addObject:allModel];
                }else{
                    
                    [monthMuArray addObject:dayMuArray];
                    [yearMuArray addObject:monthMuArray];
                    monthMuArray =[[NSMutableArray alloc]init];
                    dayMuArray =[[NSMutableArray alloc]init];
                    [dayMuArray addObject:allModel];
                    
                    [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                    [yearSumMuArray addObject:monthSumMuArray];
                    monthSumMuArray =[[NSMutableArray alloc]init];
                    monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                    
                    [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                    [incomYearSumMuArray addObject:incomMonthSumMuArray];
                    incomMonthSumMuArray =[[NSMutableArray alloc]init];
                    incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                    
                    if ([allModel.moneyType isEqualToString:@"1"]) {
                        
                        NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                        monthSum =[monthSum decimalNumberByAdding:everyConsume];
                    }else{
                        NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                        incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                    }
                }
            }
        }
        if (i==yearDataMuArray.count-1) {
            
            [monthMuArray addObject:dayMuArray];
            [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
            [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
            if (self.consumeMuArray.count==0) {
               
                [self.consumeMuArray addObject:monthMuArray];
                [self.consumeSumMuArray addObject:monthSumMuArray];
                [self.incomSumMuArray addObject:incomMonthSumMuArray];
                [self.yearStringMuArray addObject:yearString];
                self.selectIndex =0;
//                [self.cardTableView reloadData];
            }else{
                //开始对比相应的年份选出当前年份
                if ([self.yearStringMuArray containsObject:yearString]) {
                    //当前有这个年份
                    int curentIndex =(int)[self.yearStringMuArray indexOfObject:yearString];
                    [self.consumeMuArray replaceObjectAtIndex:curentIndex withObject:monthMuArray];
                    [self.consumeSumMuArray replaceObjectAtIndex:curentIndex withObject:monthSumMuArray];
                    [self.incomSumMuArray replaceObjectAtIndex:curentIndex withObject:incomMonthSumMuArray];
                    self.selectIndex =curentIndex;
                }else{
                    int currentIndex = 0;
                    BOOL isBigOne =NO;
                    for (int j=0;j<self.yearStringMuArray.count;j++) {
                        NSString *yearS =self.yearStringMuArray[j];
                        if ([yearString intValue]>[yearS intValue]) {
                            
                            currentIndex =j;
                            isBigOne =YES;
                            break;
                        }
                    }
                    if (isBigOne) {
                        
                        [self.yearStringMuArray insertObject:yearString atIndex:currentIndex];
                        [self.consumeMuArray insertObject:monthMuArray atIndex:currentIndex];
                        [self.consumeSumMuArray insertObject:monthSumMuArray atIndex:currentIndex];
                        [self.incomSumMuArray insertObject:incomMonthSumMuArray atIndex:currentIndex];
                        self.selectIndex =currentIndex;
                    }else{
                        
                        [self.yearStringMuArray addObject:yearString];
                        [self.consumeMuArray addObject:monthMuArray];
                        [self.consumeSumMuArray addObject:monthSumMuArray];
                        [self.incomSumMuArray addObject:incomMonthSumMuArray];
                        self.selectIndex =(int)self.yearStringMuArray.count-1;
                    }
                }
            }
        }
    }
    int currentIndex = 0;
    NSArray *mothMuarray =self.consumeMuArray[self.selectIndex];
    for (int j=0;j<mothMuarray.count;j++) {
        NSArray *dayMuArray =mothMuarray[j];
        AllConsumInfoModel *consumModel =dayMuArray.firstObject;
        if ([monthString intValue]==[consumModel.month intValue]){
            
            currentIndex =j;
            break;
        }
    }
    [self.markMuDic removeAllObjects];
    [self.markMuDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",currentIndex]];
    if (self.selectIndex%2) {
        //找到相应的月份将self.markMudic改变一下并且刷新。
        if (self.otherCardTableView.mj_footer.state ==MJRefreshStateNoMoreData) {
            
            self.otherCardTableView.mj_footer.state =MJRefreshStateIdle;
        }
        self.otherCardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
        self.otherCardTableView.scrollEnabled =YES;
        [self.otherCardTableView reloadData];
        if (self.cardTableView.frame.origin.y==self.selectIndex*self.backScrollView.height) {
            
            self.cardTableView.frame =CGRectMake(0, (self.selectIndex-1)*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
        }
    }else{
        if (self.cardTableView.mj_footer.state ==MJRefreshStateNoMoreData) {
            
            self.cardTableView.mj_footer.state =MJRefreshStateIdle;
        }
        self.cardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
        self.cardTableView.scrollEnabled =YES;
        [self.cardTableView reloadData];
        if (self.otherCardTableView.frame.origin.y==self.selectIndex*self.backScrollView.height) {
            
            self.otherCardTableView.frame =CGRectMake(0, (self.selectIndex-1)*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
        }
    }

    [self.backScrollView setContentOffset:CGPointMake(0,self.backScrollView.height*self.selectIndex) animated:NO];
    
    if (self.consumeMuArray.count>self.selectIndex) {
        
        NSArray *monthArrayOther =self.consumeMuArray[self.selectIndex];
        NSArray *dayArray =monthArrayOther.firstObject;
        AllConsumInfoModel *model =dayArray.firstObject;
        self.currentDateFirstTime =model.time;
        
        self.yearLabel.text =[NSString stringWithFormat:@"%@年度总汇",yearString];
        NSArray *monthSumMuArrayOther=self.consumeSumMuArray[self.selectIndex];
        NSArray *repayMonthSumMuArray =self.incomSumMuArray[self.selectIndex];
        NSString *cSum =[self yearSumBackArray:monthSumMuArrayOther];
        NSString *rSum =[self yearSumBackArray:repayMonthSumMuArray];
        self.allConsumeLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"支出：%@",cSum]];
        self.allRepayLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"收入：%@",rSum]];
    }
}
//富文本的使用
-(NSMutableAttributedString *)getAttributedString:(NSString *)string{
    
    NSMutableAttributedString *attributeS =[[NSMutableAttributedString alloc]initWithString:string];
    NSRange range =NSMakeRange(3, string.length-3);
    NSDictionary *dic =@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};
    [attributeS addAttributes:dic range:range];
    return attributeS;
}
-(void)panGesturAction:(UIPanGestureRecognizer *)panGesture{

    //移动状态
    UIGestureRecognizerState recState =  panGesture.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            UIViewController *viewVC = self;
            CGPoint translation = [panGesture translationInView:viewVC.navigationController.view];
            panGesture.view.center = CGPointMake(panGesture.view.center.x + translation.x, panGesture.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, screenHeight/2.0);
            
            if (panGesture.view.center.x < SCREEN_WIDTH / 2.0)
            {
                if (panGesture.view.center.y <= screenHeight/2.0) {
                    //左上
                    if (panGesture.view.center.x  >= panGesture.view.center.y-(iphoneX||iphoneXR||iphoneXSM?88:64)) {
                        stopPoint = CGPointMake(panGesture.view.center.x, kSuspendBtnHeight/2.0);
                    }else{
                        stopPoint = CGPointMake(kSuspendBtnWidth/2.0, panGesture.view.center.y);
                    }
                }
                else{
                    //左下
                    if (panGesture.view.center.x  >= screenHeight - panGesture.view.center.y) {
                        stopPoint = CGPointMake(panGesture.view.center.x, screenHeight - kSuspendBtnHeight/2.0);
                    }else{
                        stopPoint = CGPointMake(kSuspendBtnWidth/2.0, panGesture.view.center.y);
                    }
                }
            }else{
                if (panGesture.view.center.y <= screenHeight/2.0) {
                    //右上
                    if (SCREEN_WIDTH - panGesture.view.center.x  >= panGesture.view.center.y) {
                        stopPoint = CGPointMake(panGesture.view.center.x, kSuspendBtnHeight/2.0);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - kSuspendBtnWidth/2.0, panGesture.view.center.y);
                    }
                }else{
                    //右下
                    if (SCREEN_WIDTH - panGesture.view.center.x  >= screenHeight - panGesture.view.center.y) {
                        stopPoint = CGPointMake(panGesture.view.center.x, screenHeight - kSuspendBtnHeight/2.0);
                    }else{
                        stopPoint = CGPointMake(SCREEN_WIDTH - kSuspendBtnWidth/2.0,panGesture.view.center.y);
                    }
                }
            }
            
            if (stopPoint.x - kSuspendBtnWidth/2.0 <= 0) {
                stopPoint = CGPointMake(kSuspendBtnWidth/2.0, stopPoint.y);
            }
            
            if (stopPoint.x + kSuspendBtnWidth/2.0 >= SCREEN_WIDTH) {
                stopPoint = CGPointMake(SCREEN_WIDTH - kSuspendBtnWidth/2.0, stopPoint.y);
            }
            
            if (stopPoint.y-kSuspendBtnHeight/2.0<=(iphoneX||iphoneXR||iphoneXSM?88:64)) {
                stopPoint = CGPointMake(stopPoint.x, kSuspendBtnHeight/2.0+(iphoneX||iphoneXR||iphoneXSM?88:64));
            }
            
            if (stopPoint.y + kSuspendBtnHeight/2.0 >= screenHeight) {
                stopPoint = CGPointMake(stopPoint.x, screenHeight - kSuspendBtnHeight/2.0);
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                panGesture.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [panGesture setTranslation:CGPointMake(0, 0) inView:self.view];
}
-(void)headerRefreshingData{

    [self.cardTableView.mj_header endRefreshing];
    [self.otherCardTableView.mj_header endRefreshing];
}
-(void)footerRefreshingData{

    if (self.footLion) {
        
        if (self.selectIndex%2) {
            
            self.otherCardTableView.mj_footer.state =MJRefreshStateNoMoreData;
        }else{
            
            self.cardTableView.mj_footer.state =MJRefreshStateNoMoreData;
        }
    }else{
        
        [self.cardTableView.mj_footer endRefreshing];
        [self.otherCardTableView.mj_footer endRefreshing];
    }
}
-(void)reloadDataSource:(NSString *)accountBookName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (int i=0;i<2000;i++) {
//
//            NSDictionary *consumeDic =@{@"bankNumber":@"xixixixi",@"everyConsume":@"50",@"detail":@"消费",@"time":@"2019-09-10 05:34:04",@"isUsed":@"1",@"month":@"9",@"year":@"2019",@"bankStyle":@"早上",@"isCard":@"1",@"week":@"星期一",@"moneyType":@"1",@"accountBookName":@"总账本"};
//            [[CardDataFMDB shareSqlite]addRecordToAllConsumeTable:consumeDic];
//        }
        [self.yearStringMuArray removeAllObjects];
        [self.incomSumMuArray removeAllObjects];
        [self.consumeSumMuArray removeAllObjects];
        [self.consumeMuArray removeAllObjects];
        NSArray *dataSourceArray;
        if ([accountBookName isEqualToString:@"总账本"]) {
            NSArray *arrayAccountN =[[CardDataFMDB shareSqlite]queryAccountBookList:@""];
            NSMutableArray *accountNameArray=[[NSMutableArray alloc] init];
            [accountNameArray addObject:@"accountBookName = '总账本'"];
            for (AccountBookModel *bookModel in arrayAccountN) {
                
                if (!bookModel.isSecret||bookModel.isShowSwitch) {
                    
                    [accountNameArray addObject:[NSString stringWithFormat:@"accountBookName = '%@'",bookModel.accountBookName]];
                }
            }
            NSString *accountBackNameString;
            if (accountNameArray.count>1) {
                
                accountBackNameString =[accountNameArray componentsJoinedByString:@" or "];
            }else{
                accountBackNameString =@"accountBookName = '总账本'";
            }
            //遍历所有账本找出需要暂时的账本
            dataSourceArray =[[CardDataFMDB shareSqlite]queryRecordsFromConsumInfoAccountName:accountBackNameString withYear:@""];
        }else{
            //单独的账本遍历就行
            dataSourceArray =[[CardDataFMDB shareSqlite]queryRecordsFromConsumInfoAccountName:[NSString stringWithFormat:@"accountBookName = '%@'",accountBookName] withYear:@""];
        }
        [self.consumeMuArray removeAllObjects];
        NSMutableArray *yearMuArray;
        NSMutableArray *monthMuArray;
        NSMutableArray *dayMuArray;
        NSMutableArray *yearSumMuArray;
        NSMutableArray *incomYearSumMuArray;
        NSMutableArray *monthSumMuArray;
        NSMutableArray *incomMonthSumMuArray;
        AllConsumInfoModel *otherModel;
        AllConsumInfoModel *sumOtherModel;
        
        NSDecimalNumber *monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
        NSDecimalNumber *incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
        NSDecimalNumber *daySum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
        NSDecimalNumber *dayIncomSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
        
        for (int i=0;i<dataSourceArray.count;i++) {
            
            AllConsumInfoModel *allModel =dataSourceArray[i];
            if (![[otherModel.time substringToIndex:10] isEqualToString:[allModel.time substringToIndex:10]]) {
                
                if (sumOtherModel) {
                    
                    sumOtherModel.daySumMoney =[NSString stringWithFormat:@"%@",daySum];
                    sumOtherModel.dayIncomSumMoney =[NSString stringWithFormat:@"%@",dayIncomSum];
                }
                if ([[otherModel.time substringToIndex:7] isEqualToString:[allModel.time substringToIndex:7]]) {
                    
                    allModel.isDrawLion =YES;
                }
                allModel.isMarkTime =YES;
                daySum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                dayIncomSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                if ([allModel.moneyType isEqualToString:@"1"]) {
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    daySum =[daySum decimalNumberByAdding:everyConsume];
                }else{
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    dayIncomSum =[dayIncomSum decimalNumberByAdding:everyConsume];
                }
                sumOtherModel =allModel;
            }else{
                
                if ([allModel.moneyType isEqualToString:@"1"]) {
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    daySum =[daySum decimalNumberByAdding:everyConsume];
                }else{
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    dayIncomSum =[dayIncomSum decimalNumberByAdding:everyConsume];
                }
            }
            if (i==dataSourceArray.count-1&&sumOtherModel) {
                
                sumOtherModel.daySumMoney =[NSString stringWithFormat:@"%@",daySum];
                sumOtherModel.dayIncomSumMoney =[NSString stringWithFormat:@"%@",dayIncomSum];
            }
            otherModel =allModel;
            
            if (i==0) {
                
                yearMuArray =[[NSMutableArray alloc]init];
                monthMuArray =[[NSMutableArray alloc]init];
                dayMuArray =[[NSMutableArray alloc]init];
                yearSumMuArray =[[NSMutableArray alloc]init];
                incomYearSumMuArray =[[NSMutableArray alloc]init];
                monthSumMuArray =[[NSMutableArray alloc]init];
                incomMonthSumMuArray =[[NSMutableArray alloc]init];
                monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                [dayMuArray addObject:allModel];
                if ([allModel.moneyType isEqualToString:@"1"]) {
                    
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    monthSum =[monthSum decimalNumberByAdding:everyConsume];
                }else{
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                }
                
            }else{
                
                AllConsumInfoModel *secondModel =dayMuArray[0];
                if ([secondModel.month intValue]!=[allModel.month intValue]&&i!=0) {
                    if ([secondModel.year intValue]!=[allModel.year intValue]) {
                        
                        [monthMuArray addObject:dayMuArray];
                        [yearMuArray addObject:monthMuArray];
                        [self.yearStringMuArray addObject:secondModel.year];
                        monthMuArray =[[NSMutableArray alloc]init];
                        dayMuArray =[[NSMutableArray alloc]init];
                        [dayMuArray addObject:allModel];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [yearSumMuArray addObject:monthSumMuArray];
                        monthSumMuArray =[[NSMutableArray alloc]init];
                        monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                        [incomYearSumMuArray addObject:incomMonthSumMuArray];
                        incomMonthSumMuArray =[[NSMutableArray alloc]init];
                        incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        if ([allModel.moneyType isEqualToString:@"1"]) {
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            monthSum =[monthSum decimalNumberByAdding:everyConsume];
                        }else{
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                        }
                    }else{
                        
                        [monthMuArray addObject:dayMuArray];
                        dayMuArray =[[NSMutableArray alloc]init];
                        [dayMuArray addObject:allModel];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                        incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        if ([allModel.moneyType isEqualToString:@"1"]) {
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            monthSum =[monthSum decimalNumberByAdding:everyConsume];
                        }else{
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                        }

                    }
                }else{
                    
                    if ([secondModel.year intValue]==[allModel.year intValue]) {
                        
                        if ([allModel.moneyType isEqualToString:@"1"]) {
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            monthSum =[monthSum decimalNumberByAdding:everyConsume];
                        }else{
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                        }
                        [dayMuArray addObject:allModel];
                    }else{
                        
                        [monthMuArray addObject:dayMuArray];
                        [yearMuArray addObject:monthMuArray];
                        [self.yearStringMuArray addObject:secondModel.year];
                        monthMuArray =[[NSMutableArray alloc]init];
                        dayMuArray =[[NSMutableArray alloc]init];
                        [dayMuArray addObject:allModel];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [yearSumMuArray addObject:monthSumMuArray];
                        monthSumMuArray =[[NSMutableArray alloc]init];
                        monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [incomYearSumMuArray addObject:incomMonthSumMuArray];
                        incomMonthSumMuArray =[[NSMutableArray alloc]init];
                        incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        if ([allModel.moneyType isEqualToString:@"1"]) {
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            monthSum =[monthSum decimalNumberByAdding:everyConsume];
                        }else{
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                        }
                    }
                }
            }
            if (i==dataSourceArray.count-1) {
                
                if (dataSourceArray.count==1) {
                    
                    [monthMuArray addObject:dayMuArray];
                    [self.consumeMuArray addObject:monthMuArray];
                    
                    [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                    [self.consumeSumMuArray addObject:monthSumMuArray];
                    
                    [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                    [self.incomSumMuArray addObject:incomMonthSumMuArray];
                    
                    [self.yearStringMuArray addObject:allModel.year];
                }else{
                    
                    if (yearMuArray.count==0) {
                        
                        [monthMuArray addObject:dayMuArray];
                        [self.consumeMuArray addObject:monthMuArray];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [self.consumeSumMuArray addObject:monthSumMuArray];
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                        [self.incomSumMuArray addObject:incomMonthSumMuArray];
                        
                        [self.yearStringMuArray addObject:allModel.year];
                    }else{
                        
                        [monthMuArray addObject:dayMuArray];
                        [yearMuArray addObject:monthMuArray];
                        [self.consumeMuArray addObjectsFromArray:yearMuArray];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [yearSumMuArray addObject:monthSumMuArray];
                        [self.consumeSumMuArray addObjectsFromArray:yearSumMuArray];
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                        [incomYearSumMuArray addObject:incomMonthSumMuArray];
                        [self.incomSumMuArray addObjectsFromArray:incomYearSumMuArray];
                        
                        AllConsumInfoModel *firstInfoModel =dayMuArray[0];
                        [self.yearStringMuArray addObject:firstInfoModel.year];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.consumeMuArray.count<=0) {
                
                self.backScrollView.contentSize =CGSizeMake(SCREEN_WIDTH,self.backScrollView.height);
                [self.cardTableView reloadData];
                self.yearLabel.text =@"";
                self.allConsumeLabel.attributedText =[self getAttributedString:@"支出：0"];
                self.allRepayLabel.attributedText =[self getAttributedString:@"收入：0"];
                self.currentDateFirstTime =@"";
            }else{
                
                self.backScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, self.backScrollView.height*self.consumeMuArray.count);
                //找到当前年份并且滑动相应的位置
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                NSString *timeString =[dateFormatter stringFromDate:[NSDate date]];
                NSArray *dateArray =[timeString componentsSeparatedByString:@"-"];
                NSString *yearString =dateArray[0];
                if ([self.yearStringMuArray containsObject:yearString]) {
                    
                    int currentIndex =(int)[self.yearStringMuArray indexOfObject:yearString];
                    self.selectIndex =currentIndex;
                    [self.markMuDic removeAllObjects];
                    [self.markMuDic setObject:@"1" forKey:@"0"];
                    if (self.selectIndex%2) {
                        if (self.otherCardTableView.mj_footer.state ==MJRefreshStateNoMoreData) {
                            
                            self.otherCardTableView.mj_footer.state =MJRefreshStateIdle;
                        }
                        self.otherCardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                        self.otherCardTableView.scrollEnabled =YES;
                        [self.otherCardTableView reloadData];
                        if (self.cardTableView.frame.origin.y==self.selectIndex*self.backScrollView.height) {
                            
                            self.cardTableView.frame =CGRectMake(0, (self.selectIndex-1)*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                        }
                    }else{
                        if (self.cardTableView.mj_footer.state ==MJRefreshStateNoMoreData) {
                            
                            self.cardTableView.mj_footer.state =MJRefreshStateIdle;
                        }
                        self.cardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                        self.cardTableView.scrollEnabled =YES;
                        [self.cardTableView reloadData];
                        if (self.otherCardTableView.frame.origin.y==self.selectIndex*self.backScrollView.height) {
                            
                            self.otherCardTableView.frame =CGRectMake(0, (self.selectIndex-1)*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                        }
                    }
                    [self.backScrollView setContentOffset:CGPointMake(0,self.backScrollView.height*self.selectIndex) animated:NO];
                }else{
                    
                    self.selectIndex =0;
                    [self.cardTableView reloadData];
                    self.cardTableView.scrollEnabled =YES;
                    if (self.backScrollView.contentOffset.y!=0) {
                        
                        [self.backScrollView setContentOffset:CGPointMake(0,self.backScrollView.height*self.selectIndex) animated:NO];
                    }
                }
                if (self.consumeMuArray.count>self.selectIndex) {
                    
                    NSArray *monthArrayOther =self.consumeMuArray[self.selectIndex];
                    NSArray *dayArray =monthArrayOther.firstObject;
                    AllConsumInfoModel *model =dayArray.firstObject;
                    self.currentDateFirstTime =model.time;
                    
                    self.yearLabel.text =[NSString stringWithFormat:@"%@年度总汇",self.yearStringMuArray[self.selectIndex]];
                    NSArray *monthSumMuArray=self.consumeSumMuArray[self.selectIndex];
                    NSArray *repayMonthSumMuArray =self.incomSumMuArray[self.selectIndex];
                    NSString *cSum =[self yearSumBackArray:monthSumMuArray];
                    NSString *rSum =[self yearSumBackArray:repayMonthSumMuArray];
                    self.allConsumeLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"支出：%@",cSum]];
                    self.allRepayLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"收入：%@",rSum]];
                }
            }
            
        });
    });
}
-(UIView *)tableViewHeadView{
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,100)];
    UIImage *backImage =[JVCCreatImage creatImageFromColors:@[[UIColor colorWithRed:0.97 green:0.42 blue:0.38 alpha:1.00],[UIColor colorWithRed:0.91 green:0.13 blue:0.20 alpha:1.00]] ByGradientType:leftToRight withFrame:CGRectMake(0, 0, self.view.width, 100)];
    headView.backgroundColor =[UIColor colorWithPatternImage:backImage];
    return headView;
}
#pragma mark-tableviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.consumeMuArray.count>0) {
        
        NSMutableArray *monthMuArray;
        if (self.selectIndex%2) {
            if (tableView!=self.otherCardTableView) {
                
                monthMuArray=self.consumeMuArray[self.otherSelectIndex];
            }else{
                
                monthMuArray=self.consumeMuArray[self.selectIndex];
            }
        }else{
            
            if (tableView!=self.cardTableView) {
                
                monthMuArray=self.consumeMuArray[self.otherSelectIndex];
            }else{
                
                monthMuArray=self.consumeMuArray[self.selectIndex];
            }
        }
//        NSMutableArray *monthMuArray =self.consumeMuArray[self.selectIndex];
        NSMutableArray *dayMuArray =monthMuArray[section];
        if ([[self.markMuDic objectForKey:[NSString stringWithFormat:@"%ld",section]] intValue]) {
            NSLog(@"xixixiixixiix---%d",(int)dayMuArray.count);
            return dayMuArray.count;
        }else{
            
            return 0;
        }
    }else{
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.consumeMuArray.count>0) {
        
        NSMutableArray *monthMuArray;
        if (self.selectIndex%2) {
            if (tableView!=self.otherCardTableView) {
                
                monthMuArray=self.consumeMuArray[self.otherSelectIndex];
            }else{
                
                monthMuArray=self.consumeMuArray[self.selectIndex];
            }
        }else{
            
            if (tableView!=self.cardTableView) {
                
                monthMuArray=self.consumeMuArray[self.otherSelectIndex];
            }else{
                
                monthMuArray=self.consumeMuArray[self.selectIndex];
            }
        }
//        NSMutableArray *monthMuArray =self.consumeMuArray[self.selectIndex];
        return monthMuArray.count;
    }else{
       
        return 1;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.consumeMuArray.count<=0) {
        
        UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width,0.01)];
        return headView;
    }else{
        
        NSMutableArray *monthSumMuArray;
        NSMutableArray *repayMonthSumMuArray;
        NSMutableArray *monthMuArray;
        if (self.selectIndex%2) {
            if (tableView!=self.otherCardTableView) {
                
                monthSumMuArray=self.consumeSumMuArray[self.otherSelectIndex];
                repayMonthSumMuArray =self.incomSumMuArray[self.otherSelectIndex];
                monthMuArray =self.consumeMuArray[self.otherSelectIndex];
                
            }else{
                
                monthSumMuArray=self.consumeSumMuArray[self.selectIndex];
                repayMonthSumMuArray =self.incomSumMuArray[self.selectIndex];
                monthMuArray =self.consumeMuArray[self.selectIndex];
            }
        }else{
            
            if (tableView!=self.cardTableView) {
                
                monthSumMuArray=self.consumeSumMuArray[self.otherSelectIndex];
                repayMonthSumMuArray =self.incomSumMuArray[self.otherSelectIndex];
                monthMuArray =self.consumeMuArray[self.otherSelectIndex];
            }else{
                
                monthSumMuArray=self.consumeSumMuArray[self.selectIndex];
                repayMonthSumMuArray =self.incomSumMuArray[self.selectIndex];
                monthMuArray =self.consumeMuArray[self.selectIndex];
            }
        }
        NSDecimalNumber *monthSum =[NSDecimalNumber decimalNumberWithString:monthSumMuArray[section]];
        NSDecimalNumber *incomSum =[NSDecimalNumber decimalNumberWithString:repayMonthSumMuArray[section]];
        NSMutableArray *dayMuArray =monthMuArray[section];
        AllConsumInfoModel *allModel =dayMuArray[0];
        UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width-20,50)];
        headView.backgroundColor =[UIColor whiteColor];
        headView.tag =section+1000;
        UILabel *yearMonthLabel =[[UILabel alloc]initWithFrame:CGRectMake(10,0,80,50)];
        yearMonthLabel.textColor =[UIColor blackColor];
        yearMonthLabel.text =[NSString stringWithFormat:@"%@.%@",allModel.year,[self changeLowTen:allModel.month]];
        yearMonthLabel.textAlignment =NSTextAlignmentLeft;
        yearMonthLabel.font =[UIFont systemFontOfSize:14];
        [headView addSubview:yearMonthLabel];
    
        
        NSString *string =[NSString stringWithFormat:@"支 %@",[monthSumMuArray[section] isEqualToString:@"0"]?@"0.00":monthSum];
        
        CGRect consumeSumRect =[string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        
        UILabel *sumLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.view.width-10-10-30-consumeSumRect.size.width,0,consumeSumRect.size.width,50)];
        sumLabel.textColor =[UIColor colorWithRed:0.46 green:0.67 blue:0.49 alpha:1.00];
        sumLabel.textAlignment =NSTextAlignmentLeft;
        sumLabel.font =[UIFont systemFontOfSize:13];
        
        NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
        NSRange pointRange = NSMakeRange(0,2);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        [attribut addAttributes:dic range:pointRange];
        sumLabel.attributedText =attribut;
        [headView addSubview:sumLabel];
        
        
        UILabel *markLabel =[[UILabel alloc]initWithFrame:CGRectMake(sumLabel.left-10,sumLabel.top,10, sumLabel.height)];
        markLabel.text =@"/";
        markLabel.textAlignment =NSTextAlignmentCenter;
        markLabel.textColor =[UIColor blackColor];
        markLabel.font =[UIFont systemFontOfSize:15];
        [headView addSubview:markLabel];
        
        NSString *repayString =[NSString stringWithFormat:@"收 %@",[repayMonthSumMuArray[section] isEqualToString:@"0"]?@"0.00":incomSum];
        CGRect repaySumRect =[repayString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
        UILabel *repayLabel =[[UILabel alloc]initWithFrame:CGRectMake(markLabel.left-repaySumRect.size.width,0,repaySumRect.size.width,50)];
        repayLabel.textColor =[UIColor colorWithRed:0.95 green:0.21 blue:0.11 alpha:1.00];
        repayLabel.textAlignment =NSTextAlignmentRight;
        repayLabel.font =[UIFont systemFontOfSize:13];
        
        NSMutableAttributedString *repayAttribut = [[NSMutableAttributedString alloc]initWithString:repayString];
        NSRange pointRange1 = NSMakeRange(0,2);
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        dic1[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        [repayAttribut addAttributes:dic1 range:pointRange1];
        repayLabel.attributedText =repayAttribut;
        [headView addSubview:repayLabel];
        
        if (!self.selectAccountModel.isConsume&&self.selectAccountModel.isRepay) {
            
            markLabel.hidden =YES;
            sumLabel.hidden =YES;
            repayLabel.hidden =NO;
            repayLabel.frame =CGRectMake(self.view.width-10-10-30-repaySumRect.size.width,0,repaySumRect.size.width,50);
            repayLabel.textAlignment =NSTextAlignmentLeft;
        }else if (self.selectAccountModel.isConsume&&!self.selectAccountModel.isRepay){
            
            markLabel.hidden =YES;
            repayLabel.hidden =YES;
            sumLabel.hidden =NO;
        }
        if ([[self.markMuDic objectForKey:[NSString stringWithFormat:@"%d",(int)section]] intValue]) {
            
            UIImageView *upImageView =[[UIImageView alloc]initWithFrame:CGRectMake(sumLabel.right+10,20, 10, 10)];
            upImageView.image =[UIImage imageNamed:@"up_icon"];
            [headView addSubview:upImageView];
        }else{
            
            UIImageView *downImageView =[[UIImageView alloc]initWithFrame:CGRectMake(sumLabel.right+10,20, 10, 10)];
            downImageView.image =[UIImage imageNamed:@"down_icon"];
            [headView addSubview:downImageView];
        }
        UITapGestureRecognizer *oneTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openOrCloseSection:)];
        oneTap.numberOfTapsRequired =1;
        oneTap.numberOfTouchesRequired =1;
        [headView addGestureRecognizer:oneTap];
        if (section==0) {
            
            if ([[self.markMuDic objectForKey:[NSString stringWithFormat:@"%d",(int)section]] intValue]||monthMuArray.count==1) {
                
                UIView *secondLionView =[[UIView alloc]initWithFrame:CGRectMake(10,49,self.view.width-40,1)];
                secondLionView.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
                [headView addSubview:secondLionView];
            }
        }else{
           
            if (![[self.markMuDic objectForKey:[NSString stringWithFormat:@"%d",(int)section]] intValue]&&monthMuArray.count>section+1) {
                
                UIView *lionView =[[UIView alloc]initWithFrame:CGRectMake(10,0,self.view.width-40,1)];
                lionView.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
                [headView addSubview:lionView];
            }else{
                
                UIView *lionView =[[UIView alloc]initWithFrame:CGRectMake(10,0,self.view.width-40,1)];
                lionView.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
                [headView addSubview:lionView];
                
                UIView *secondLionView =[[UIView alloc]initWithFrame:CGRectMake(10,49,self.view.width-40,1)];
                secondLionView.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
                [headView addSubview:secondLionView];
            }
    
        }
        return headView;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 50;
}
-(void)openOrCloseSection:(UITapGestureRecognizer *)tap{
    
    int section =(int)tap.view.tag-1000;
    if ([[self.markMuDic objectForKey:[NSString stringWithFormat:@"%d",section]] intValue]) {
        
        [self.markMuDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d",section]];
    }else{
        [self.markMuDic setObject:@"1" forKey:[NSString stringWithFormat:@"%d",section]];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
    if (self.selectIndex%2) {
        
        [self.otherCardTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    }else{
       
        [self.cardTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (self.consumeMuArray.count<=0) {
        
        UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width,0.01)];
        return footView;
    }
    NSMutableArray *monthMuArray;
    if (self.selectIndex%2) {
        if (tableView!=self.otherCardTableView) {
            
            monthMuArray=self.consumeMuArray[self.otherSelectIndex];
        }else{
            
            monthMuArray=self.consumeMuArray[self.selectIndex];
        }
    }else{
        
        if (tableView!=self.cardTableView) {
            
            monthMuArray=self.consumeMuArray[self.otherSelectIndex];
        }else{
            
            monthMuArray=self.consumeMuArray[self.selectIndex];
        }
    }
//    NSMutableArray *monthMuArray =self.consumeMuArray[self.selectIndex];
    if (monthMuArray.count>0) {
        
        if (section==monthMuArray.count-1) {
            if (![[self.markMuDic objectForKey:[NSString stringWithFormat:@"%ld",section]] intValue]) {
                
                UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width,0.01)];
                return footView;
            }else{
               
                UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width,0.01)];
                UIView *lionView =[[UIView alloc]initWithFrame:CGRectMake(10,0,self.view.width-40,1)];
                lionView.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
                [footView addSubview:lionView];
                return footView;
            }
        }else{
           
            UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width,0.01)];
            return footView;
        }
    }else{
      
        UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0,self.view.width,0.01)];
        return footView;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (self.consumeMuArray.count<=0) {
        
        return 0.01;
    }
    NSMutableArray *monthMuArray;
    if (self.selectIndex%2) {
        if (tableView!=self.otherCardTableView) {
            
            monthMuArray=self.consumeMuArray[self.otherSelectIndex];
        }else{
            
            monthMuArray=self.consumeMuArray[self.selectIndex];
        }
    }else{
        
        if (tableView!=self.cardTableView) {
            
            monthMuArray=self.consumeMuArray[self.otherSelectIndex];
        }else{
            
            monthMuArray=self.consumeMuArray[self.selectIndex];
        }
    }
//    NSMutableArray *monthMuArray =self.consumeMuArray[self.selectIndex];
    if (monthMuArray.count>0) {
        
        if (section==monthMuArray.count-1) {
            
            if (![[self.markMuDic objectForKey:[NSString stringWithFormat:@"%ld",section]] intValue]) {
                
                return 0.01;
            }else{
               
                return 1;
            }
        }else{
            return 0.01;
        }
    }else{
       
        return 0.01;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConsumeTableViewCell *consumeCell =[tableView dequeueReusableCellWithIdentifier:@"ConsumeTableViewCell"];
    if (consumeCell == nil) {
        
        consumeCell =[[ConsumeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ConsumeTableViewCell" withIndexPath:indexPath];
    }
    consumeCell.selectionStyle =UITableViewCellSelectionStyleNone;
    consumeCell.accountModel =self.selectAccountModel;
    NSMutableArray *monthMuArray;
    if (self.selectIndex%2) {
        if (tableView!=self.otherCardTableView) {
            
            monthMuArray=self.consumeMuArray[self.otherSelectIndex];
        }else{
            
            monthMuArray=self.consumeMuArray[self.selectIndex];
        }
    }else{
        
        if (tableView!=self.cardTableView) {
            
            monthMuArray=self.consumeMuArray[self.otherSelectIndex];
        }else{
            
            monthMuArray=self.consumeMuArray[self.selectIndex];
        }
    }
    NSMutableArray *dayMuArray =monthMuArray[indexPath.section];
    AllConsumInfoModel *allConsumModel =dayMuArray[indexPath.row];
    consumeCell.consumeModel =allConsumModel;
    return consumeCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
// 自定义左滑显示编辑按钮
- (NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self)weakSelf =self;
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [weakSelf editModelTableView:tableView withIndexPath:indexPath withEditType:0];
    }];
    UITableViewRowAction *rowOtherAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        //首先删除本地的存储
        [weakSelf editModelTableView:tableView withIndexPath:indexPath withEditType:1];
        
    }];
    NSArray *arr = @[rowOtherAction,rowAction];
    return arr;
}
//获取对应的model
-(void)editModelTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withEditType:(int)editType{
    
    NSMutableArray *monthMuArray;
    if (self.selectIndex%2) {
        if (tableView!=self.otherCardTableView) {
            
            monthMuArray=self.consumeMuArray[self.otherSelectIndex];
        }else{
            
            monthMuArray=self.consumeMuArray[self.selectIndex];
        }
    }else{
        
        if (tableView!=self.cardTableView) {
            
            monthMuArray=self.consumeMuArray[self.otherSelectIndex];
        }else{
            
            monthMuArray=self.consumeMuArray[self.selectIndex];
        }
    }
    NSMutableArray *dayMuArray =monthMuArray[indexPath.section];
    AllConsumInfoModel *allConsumModel =dayMuArray[indexPath.row];
    if (!editType) {
        //编辑
        if ([allConsumModel.moneyType intValue] == 1) {
            [tableView setEditing:NO animated:YES];
            //花销
            NoteViewController *noteViewController =[[NoteViewController alloc]init];
            noteViewController.refreshDelegate =self;
            noteViewController.accountNameS =self.selectAccountModel.accountBookName;
            noteViewController.currentTime =self.currentDateFirstTime;
            noteViewController.isEdit      = YES;
            noteViewController.infoModel = allConsumModel;
            [self.navigationController pushViewController:noteViewController animated:YES];
            
//            tableView.editing = NO;
        }else{
            //收入
            RepayViewController *repayViewController =[[RepayViewController alloc]init];
            repayViewController.refreshDelegate =self;
            repayViewController.accountNameS =self.selectAccountModel.accountBookName;
            repayViewController.currentTime =self.currentDateFirstTime;
            repayViewController.isEdit      = YES;
            repayViewController.infoModel = allConsumModel;
            [self.navigationController pushViewController:repayViewController animated:YES];
        }
    }else{
        //删除
        [[CardDataFMDB shareSqlite]delRecordFromAllConsumeData:@"" withTime:allConsumModel.time];
        if (monthMuArray.count==1&&dayMuArray.count==1) {
            
            [self reloadDataSource:self.selectAccountModel.accountBookName];
        }else{
            
            [self customBackDelegateWithYearString:allConsumModel.time];
        }
    }
}
#pragma mark UIScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView==self.cardTableView || scrollView==self.otherCardTableView) {
        
        if (!scrollView.scrollEnabled && self.isRefreshOffset) {
            
            [scrollView setContentOffset:CGPointMake(0, self.headAndFootY)];
        }
    }
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView==self.backScrollView) {
        
        self.isRefreshOffset =NO;
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}
//判断屏幕手离开屏幕列表还在滑动触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView==self.cardTableView || scrollView==self.otherCardTableView) {
        NSMutableArray *monthSumMuArray;
        NSMutableArray *repayMonthSumMuArray;
        if (self.cardTableView.mj_header.state==MJRefreshStatePulling||self.otherCardTableView.mj_header.state==MJRefreshStatePulling) {
            
            if (self.selectIndex==0) {
                //已经没有数据了
                
            }else{
                
                self.headAndFootY =scrollView.contentOffset.y;
                self.isRefreshOffset =YES;
                scrollView.scrollEnabled =NO;
                int selectIndex =self.selectIndex;
                self.otherSelectIndex =selectIndex;
                self.selectIndex-=1;
                [self.markMuDic removeAllObjects];
                [self.markMuDic setObject:@"1" forKey:@"0"];
                if (self.selectIndex%2) {
                    
                    if (self.otherCardTableView.mj_footer.state==MJRefreshStateNoMoreData) {
                        
                        self.otherCardTableView.mj_footer.state =MJRefreshStateIdle;
                    }
                    self.otherCardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                    self.otherCardTableView.scrollEnabled =YES;
                    [self.otherCardTableView reloadData];
                    [self.otherCardTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }else{
                    
                    if (self.cardTableView.mj_footer.state==MJRefreshStateNoMoreData) {
                        
                        self.cardTableView.mj_footer.state =MJRefreshStateIdle;
                    }
                    self.cardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                    self.cardTableView.scrollEnabled =YES;
                    [self.cardTableView reloadData];
                    [self.cardTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                
                if (self.consumeMuArray.count>self.selectIndex) {
                    
                    NSArray *monthArrayOther =self.consumeMuArray[self.selectIndex];
                    NSArray *dayArray =monthArrayOther.firstObject;
                    AllConsumInfoModel *model =dayArray.firstObject;
                    self.currentDateFirstTime =model.time;
                    
                    monthSumMuArray=self.consumeSumMuArray[self.selectIndex];
                    repayMonthSumMuArray =self.incomSumMuArray[self.selectIndex];
                    NSString *cSum =[self yearSumBackArray:monthSumMuArray];
                    NSString *rSum =[self yearSumBackArray:repayMonthSumMuArray];
                    [self.backScrollView setContentOffset:CGPointMake(0,self.backScrollView.height*self.selectIndex) animated:YES];
                    self.yearLabel.text =[NSString stringWithFormat:@"%@年度总汇",self.yearStringMuArray[self.selectIndex]];
                    self.allConsumeLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"支出：%@",cSum]];
                    self.allRepayLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"收入：%@",rSum]];
                }
                    
                
                
                
            }
        }
        if (self.cardTableView.mj_footer.state==MJRefreshStatePulling||self.otherCardTableView.mj_footer.state==MJRefreshStatePulling) {
            
            if (self.consumeMuArray.count>self.selectIndex+1) {
                
                self.footLion =NO;
                self.headAndFootY =scrollView.contentOffset.y;
                self.isRefreshOffset =YES;
                scrollView.scrollEnabled =NO;
                int selectIndex =self.selectIndex;
                self.otherSelectIndex =selectIndex;
                self.selectIndex+=1;
                [self.markMuDic removeAllObjects];
                [self.markMuDic setObject:@"1" forKey:@"0"];
                if (self.selectIndex%2) {
                    if (self.otherCardTableView.mj_footer.state==MJRefreshStateNoMoreData) {
                        
                        self.otherCardTableView.mj_footer.state =MJRefreshStateIdle;
                    }
                    self.otherCardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                    self.otherCardTableView.scrollEnabled =YES;
                    [self.otherCardTableView reloadData];
                    [self.otherCardTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }else{
                    if (self.cardTableView.mj_footer.state==MJRefreshStateNoMoreData) {
                        
                        self.cardTableView.mj_footer.state =MJRefreshStateIdle;
                    }
                    self.cardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                    self.cardTableView.scrollEnabled =YES;
                    [self.cardTableView reloadData];
                    [self.cardTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                
                if (self.consumeMuArray.count>self.selectIndex) {
                    
                    NSArray *monthArrayOther =self.consumeMuArray[self.selectIndex];
                    NSArray *dayArray =monthArrayOther.firstObject;
                    AllConsumInfoModel *model =dayArray.firstObject;
                    self.currentDateFirstTime =model.time;
                    
                    monthSumMuArray=self.consumeSumMuArray[self.selectIndex];
                    repayMonthSumMuArray =self.incomSumMuArray[self.selectIndex];
                    NSString *cSum =[self yearSumBackArray:monthSumMuArray];
                    NSString *rSum =[self yearSumBackArray:repayMonthSumMuArray];
                    [self.backScrollView setContentOffset:CGPointMake(0,self.backScrollView.height*self.selectIndex) animated:YES];
                    self.yearLabel.text =[NSString stringWithFormat:@"%@年度总汇",self.yearStringMuArray[self.selectIndex]];
                    self.allConsumeLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"支出：%@",cSum]];
                    self.allRepayLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"收入：%@",rSum]];
                }
            }else{
                //已经到底线了
                self.footLion =YES;
            }
        }
    }
}
-(NSString *)yearSumBackArray:(NSArray *)everySumArray{
    NSDecimalNumber *yearsSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
    for (int i=0;i<everySumArray.count;i++) {
       
        NSString *item =everySumArray[i];
        NSDecimalNumber *everySum =[NSDecimalNumber decimalNumberWithString:item];
        yearsSum =[yearsSum decimalNumberByAdding:everySum];
    }
    return [NSString stringWithFormat:@"%@",yearsSum];
}
-(NSString *)changeLowTen:(NSString *)numberS{
    
    if ([numberS intValue]<10&&numberS.length<=1) {
        
        numberS=[NSString stringWithFormat:@"0%@",numberS];
    }
    return numberS;
}
-(void)onlyReloadData:(NSString *)accountBookName{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.yearStringMuArray removeAllObjects];
        [self.incomSumMuArray removeAllObjects];
        [self.consumeSumMuArray removeAllObjects];
        [self.consumeMuArray removeAllObjects];
        NSArray *dataSourceArray;
        if ([accountBookName isEqualToString:@"总账本"]) {
            NSArray *arrayAccountN =[[CardDataFMDB shareSqlite]queryAccountBookList:@""];
            NSMutableArray *accountNameArray=[[NSMutableArray alloc] init];
            [accountNameArray addObject:@"accountBookName = '总账本'"];
            for (AccountBookModel *bookModel in arrayAccountN) {
                
                if (!bookModel.isSecret||bookModel.isShowSwitch) {
                    
                    [accountNameArray addObject:[NSString stringWithFormat:@"accountBookName = '%@'",bookModel.accountBookName]];
                }
            }
            NSString *accountBackNameString;
            if (accountNameArray.count>1) {
                
                accountBackNameString =[accountNameArray componentsJoinedByString:@" or "];
            }else{
                accountBackNameString =@"accountBookName = '总账本'";
            }
            //遍历所有账本找出需要暂时的账本
            dataSourceArray =[[CardDataFMDB shareSqlite]queryRecordsFromConsumInfoAccountName:accountBackNameString withYear:@""];
        }else{
            //单独的账本遍历就行
            dataSourceArray =[[CardDataFMDB shareSqlite]queryRecordsFromConsumInfoAccountName:[NSString stringWithFormat:@"accountBookName = '%@'",accountBookName] withYear:@""];
        }
        [self.consumeMuArray removeAllObjects];
        NSMutableArray *yearMuArray;
        NSMutableArray *monthMuArray;
        NSMutableArray *dayMuArray;
        NSMutableArray *yearSumMuArray;
        NSMutableArray *incomYearSumMuArray;
        NSMutableArray *monthSumMuArray;
        NSMutableArray *incomMonthSumMuArray;
        AllConsumInfoModel *otherModel;
        AllConsumInfoModel *sumOtherModel;
        
        NSDecimalNumber *monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
        NSDecimalNumber *incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
        NSDecimalNumber *daySum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
        NSDecimalNumber *dayIncomSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
        
        for (int i=0;i<dataSourceArray.count;i++) {
            
            AllConsumInfoModel *allModel =dataSourceArray[i];
            if (![[otherModel.time substringToIndex:10] isEqualToString:[allModel.time substringToIndex:10]]) {
                
                if (sumOtherModel) {
                    
                    sumOtherModel.daySumMoney =[NSString stringWithFormat:@"%@",daySum];
                    sumOtherModel.dayIncomSumMoney =[NSString stringWithFormat:@"%@",dayIncomSum];
                }
                if ([[otherModel.time substringToIndex:7] isEqualToString:[allModel.time substringToIndex:7]]) {
                    
                    allModel.isDrawLion =YES;
                }
                allModel.isMarkTime =YES;
                daySum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                dayIncomSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                if ([allModel.moneyType isEqualToString:@"1"]) {
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    daySum =[daySum decimalNumberByAdding:everyConsume];
                }else{
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    dayIncomSum =[dayIncomSum decimalNumberByAdding:everyConsume];
                }
                sumOtherModel =allModel;
            }else{
                
                if ([allModel.moneyType isEqualToString:@"1"]) {
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    daySum =[daySum decimalNumberByAdding:everyConsume];
                }else{
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    dayIncomSum =[dayIncomSum decimalNumberByAdding:everyConsume];
                }
            }
            if (i==dataSourceArray.count-1&&sumOtherModel) {
                
                sumOtherModel.daySumMoney =[NSString stringWithFormat:@"%@",daySum];
                sumOtherModel.dayIncomSumMoney =[NSString stringWithFormat:@"%@",dayIncomSum];
            }
            otherModel =allModel;
            
            if (i==0) {
                
                yearMuArray =[[NSMutableArray alloc]init];
                monthMuArray =[[NSMutableArray alloc]init];
                dayMuArray =[[NSMutableArray alloc]init];
                yearSumMuArray =[[NSMutableArray alloc]init];
                incomYearSumMuArray =[[NSMutableArray alloc]init];
                monthSumMuArray =[[NSMutableArray alloc]init];
                incomMonthSumMuArray =[[NSMutableArray alloc]init];
                monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                [dayMuArray addObject:allModel];
                if ([allModel.moneyType isEqualToString:@"1"]) {
                    
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    monthSum =[monthSum decimalNumberByAdding:everyConsume];
                }else{
                    NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                    incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                }
                
            }else{
                
                AllConsumInfoModel *secondModel =dayMuArray[0];
                if ([secondModel.month intValue]!=[allModel.month intValue]&&i!=0) {
                    if ([secondModel.year intValue]!=[allModel.year intValue]) {
                        
                        [monthMuArray addObject:dayMuArray];
                        [yearMuArray addObject:monthMuArray];
                        [self.yearStringMuArray addObject:secondModel.year];
                        monthMuArray =[[NSMutableArray alloc]init];
                        dayMuArray =[[NSMutableArray alloc]init];
                        [dayMuArray addObject:allModel];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [yearSumMuArray addObject:monthSumMuArray];
                        monthSumMuArray =[[NSMutableArray alloc]init];
                        monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                        [incomYearSumMuArray addObject:incomMonthSumMuArray];
                        incomMonthSumMuArray =[[NSMutableArray alloc]init];
                        incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        if ([allModel.moneyType isEqualToString:@"1"]) {
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            monthSum =[monthSum decimalNumberByAdding:everyConsume];
                        }else{
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                        }
                    }else{
                        
                        [monthMuArray addObject:dayMuArray];
                        dayMuArray =[[NSMutableArray alloc]init];
                        [dayMuArray addObject:allModel];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                        incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        if ([allModel.moneyType isEqualToString:@"1"]) {
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            monthSum =[monthSum decimalNumberByAdding:everyConsume];
                        }else{
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                        }
                        
                    }
                }else{
                    
                    if ([secondModel.year intValue]==[allModel.year intValue]) {
                        
                        if ([allModel.moneyType isEqualToString:@"1"]) {
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            monthSum =[monthSum decimalNumberByAdding:everyConsume];
                        }else{
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                        }
                        [dayMuArray addObject:allModel];
                    }else{
                        
                        [monthMuArray addObject:dayMuArray];
                        [yearMuArray addObject:monthMuArray];
                        [self.yearStringMuArray addObject:secondModel.year];
                        monthMuArray =[[NSMutableArray alloc]init];
                        dayMuArray =[[NSMutableArray alloc]init];
                        [dayMuArray addObject:allModel];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [yearSumMuArray addObject:monthSumMuArray];
                        monthSumMuArray =[[NSMutableArray alloc]init];
                        monthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [incomYearSumMuArray addObject:incomMonthSumMuArray];
                        incomMonthSumMuArray =[[NSMutableArray alloc]init];
                        incomMonthSum =[NSDecimalNumber decimalNumberWithString:@"0.00"];
                        
                        if ([allModel.moneyType isEqualToString:@"1"]) {
                            
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            monthSum =[monthSum decimalNumberByAdding:everyConsume];
                        }else{
                            NSDecimalNumber *everyConsume =[NSDecimalNumber decimalNumberWithString:allModel.everyConsume];
                            incomMonthSum =[incomMonthSum decimalNumberByAdding:everyConsume];
                        }
                    }
                }
            }
            if (i==dataSourceArray.count-1) {
                
                if (dataSourceArray.count==1) {
                    
                    [monthMuArray addObject:dayMuArray];
                    [self.consumeMuArray addObject:monthMuArray];
                    
                    [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                    [self.consumeSumMuArray addObject:monthSumMuArray];
                    
                    [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                    [self.incomSumMuArray addObject:incomMonthSumMuArray];
                    
                    [self.yearStringMuArray addObject:allModel.year];
                }else{
                    
                    if (yearMuArray.count==0) {
                        
                        [monthMuArray addObject:dayMuArray];
                        [self.consumeMuArray addObject:monthMuArray];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [self.consumeSumMuArray addObject:monthSumMuArray];
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                        [self.incomSumMuArray addObject:incomMonthSumMuArray];
                        
                        [self.yearStringMuArray addObject:allModel.year];
                    }else{
                        
                        [monthMuArray addObject:dayMuArray];
                        [yearMuArray addObject:monthMuArray];
                        [self.consumeMuArray addObjectsFromArray:yearMuArray];
                        
                        [monthSumMuArray addObject:[NSString stringWithFormat:@"%@",monthSum]];
                        [yearSumMuArray addObject:monthSumMuArray];
                        [self.consumeSumMuArray addObjectsFromArray:yearSumMuArray];
                        
                        [incomMonthSumMuArray addObject:[NSString stringWithFormat:@"%@",incomMonthSum]];
                        [incomYearSumMuArray addObject:incomMonthSumMuArray];
                        [self.incomSumMuArray addObjectsFromArray:incomYearSumMuArray];
                        
                        AllConsumInfoModel *firstInfoModel =dayMuArray[0];
                        [self.yearStringMuArray addObject:firstInfoModel.year];
                    }
                }
            }
        }
    });
}
-(void)onlyReloadUI{
    
    if (self.consumeMuArray.count<=0) {
        
        self.backScrollView.contentSize =CGSizeMake(SCREEN_WIDTH,self.backScrollView.height);
        [self.cardTableView reloadData];
        self.yearLabel.text =@"";
        self.allConsumeLabel.attributedText =[self getAttributedString:@"支出：0"];
        self.allRepayLabel.attributedText =[self getAttributedString:@"收入：0"];
        self.currentDateFirstTime =@"";
    }else{
        
        self.backScrollView.contentSize =CGSizeMake(SCREEN_WIDTH, self.backScrollView.height*self.consumeMuArray.count);
        //找到当前年份并且滑动相应的位置
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *timeString =[dateFormatter stringFromDate:[NSDate date]];
        NSArray *dateArray =[timeString componentsSeparatedByString:@"-"];
        NSString *yearString =dateArray[0];
        if ([self.yearStringMuArray containsObject:yearString]) {
            
            int currentIndex =(int)[self.yearStringMuArray indexOfObject:yearString];
            self.selectIndex =currentIndex;
            [self.markMuDic removeAllObjects];
            [self.markMuDic setObject:@"1" forKey:@"0"];
            if (self.selectIndex%2) {
                if (self.otherCardTableView.mj_footer.state ==MJRefreshStateNoMoreData) {
                    
                    self.otherCardTableView.mj_footer.state =MJRefreshStateIdle;
                }
                self.otherCardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                self.otherCardTableView.scrollEnabled =YES;
                [self.otherCardTableView reloadData];
                if (self.cardTableView.frame.origin.y==self.selectIndex*self.backScrollView.height) {
                    
                    self.cardTableView.frame =CGRectMake(0, (self.selectIndex-1)*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                }
            }else{
                if (self.cardTableView.mj_footer.state ==MJRefreshStateNoMoreData) {
                    
                    self.cardTableView.mj_footer.state =MJRefreshStateIdle;
                }
                self.cardTableView.frame =CGRectMake(0, self.selectIndex*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                self.cardTableView.scrollEnabled =YES;
                [self.cardTableView reloadData];
                if (self.otherCardTableView.frame.origin.y==self.selectIndex*self.backScrollView.height) {
                    
                    self.otherCardTableView.frame =CGRectMake(0, (self.selectIndex-1)*self.backScrollView.height,self.backScrollView.width, self.backScrollView.height);
                }
            }
            [self.backScrollView setContentOffset:CGPointMake(0,self.backScrollView.height*self.selectIndex) animated:NO];
        }else{
            
            self.selectIndex =0;
            [self.cardTableView reloadData];
        }
        
        if (self.consumeMuArray.count>self.selectIndex) {
            
            NSArray *monthArrayOther =self.consumeMuArray[self.selectIndex];
            NSArray *dayArray =monthArrayOther.firstObject;
            AllConsumInfoModel *model =dayArray.firstObject;
            self.currentDateFirstTime =model.time;
            
            self.yearLabel.text =[NSString stringWithFormat:@"%@年度总汇",self.yearStringMuArray[self.selectIndex]];
            NSArray *monthSumMuArray=self.consumeSumMuArray[self.selectIndex];
            NSArray *repayMonthSumMuArray =self.incomSumMuArray[self.selectIndex];
            NSString *cSum =[self yearSumBackArray:monthSumMuArray];
            NSString *rSum =[self yearSumBackArray:repayMonthSumMuArray];
            self.allConsumeLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"支出：%@",cSum]];
            self.allRepayLabel.attributedText =[self getAttributedString:[NSString stringWithFormat:@"收入：%@",rSum]];
        }
    }
}
-(void)dealloc{
    
    NSLog(@"dealloc");
}
@end
