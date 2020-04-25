//
//  CardHomeViewController.m
//  CreditCard
//
//  Created by liujingtao on 2019/1/14.
//  Copyright © 2019年 liujingtao. All rights reserved.
//如果还款日为29、30、31这三个特殊日期 基本上都是账单日后多少天还款，一定要填写明白。本月没有对应的还款日 该信用卡
#import "CardHomeViewController.h"
#import "CardListTableViewCell.h"
#import "CardInfoModel.h"
#import "AddCardViewController.h"
#import "ConsumInfoModel.h"
#import "RepaymentViewController.h"
#import "JVCCreatImage.h"
#import "ConsumeBillVC.h"
@interface CardHomeViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshCardInfoDelegate>
@property (nonatomic,strong) UITableView *cardTableView;
@property (nonatomic,strong) NSMutableArray *dataSourceMuArray;
@property (nonatomic,strong) UILabel *allLimitMoneyLabel;
@property (nonatomic,strong) UILabel *arrearsMoneyLabel;
@property (nonatomic,strong) NSMutableArray *fontArray;
@end

@implementation CardHomeViewController
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
        };
        bbNavigation.panEndFailedBlock = ^{
            
            self.cardTableView.scrollEnabled =YES;
        };
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"信用卡";
    self.view.backgroundColor =[UIColor whiteColor];
    self.dataSourceMuArray =[[NSMutableArray alloc]init];
    [self creatTableView];
    [self firstGetCardListData];
    UIButton *addButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 25)];
    [addButton addTarget:self action:@selector(addCardButton:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:addButton];
}
-(void)addCardButton:(UIButton *)button{
    
    AddCardViewController *addCardVC =[[AddCardViewController alloc]init];
    addCardVC.isEdit =NO;
    __weak typeof(self)weakSelf =self;
    addCardVC.RefreshTableViewBlock = ^{
      
        [weakSelf getCardListData];
    };
    [self.navigationController pushViewController:addCardVC animated:YES];
}
-(void)firstGetCardListData{
   
    self.dataSourceMuArray =[[CardDataFMDB shareSqlite]queryRecordsFromCardInfoCardNumber];
    //需要将数据进行整理并且更新数据（月份还款之间的转化）
    NSDateFormatter *dateformatter =[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateString= [dateformatter stringFromDate:[NSDate date]];
    NSArray *dateArray =[newDateString componentsSeparatedByString:@"-"];
    int month =[dateArray[1] intValue];
    int year =[dateArray[0] intValue];
    for (CardInfoModel *cardInfoModel in self.dataSourceMuArray) {
        
        NSString *bankNumber =cardInfoModel.bankNumber;
        NSString *dueMoneyS =cardInfoModel.dueDateMoney;
        NSString *lastMoneyS =cardInfoModel.lastDueDateMoney;
        if (month !=[cardInfoModel.month intValue] || year !=[cardInfoModel.year intValue]) {
            
            NSArray *noUsedArray =[[CardDataFMDB shareSqlite]queryNoUsedRecordsFromConsumInfoCardNumber:bankNumber withMonth:cardInfoModel.month withYear:cardInfoModel.year];
            float noUsedSum =0.00; //下个月账单需要的金额。
            if (noUsedArray.count>0) {
                for (ConsumInfoModel *consumModel in noUsedArray) {
                    
                    noUsedSum +=[consumModel.everyConsume floatValue];
                }
            }
            //直接换账单
            dueMoneyS =[NSString stringWithFormat:@"%0.2f",([lastMoneyS floatValue] +[dueMoneyS floatValue])];
            lastMoneyS =[NSString stringWithFormat:@"%0.2f",noUsedSum];
            NSDictionary *cardInfoDic =@{@"dueDateMoney":dueMoneyS,@"lastDueDateMoney":lastMoneyS,@"arrears":cardInfoModel.arrears,@"availabilityLimit":cardInfoModel.availabilityLimit,@"bankNumber":cardInfoModel.bankNumber,@"month":[NSString stringWithFormat:@"%d",month],@"year":[NSString stringWithFormat:@"%d",year],@"bankStyle":cardInfoModel.bankStyle,@"dueDate":cardInfoModel.dueDate,@"billDate":cardInfoModel.billDate,@"limitNumber":cardInfoModel.limitNumber,@"dueDateDay":cardInfoModel.dueDateDay};
            [[CardDataFMDB shareSqlite]updateCardInfo:cardInfoDic];
        }
    }
    self.dataSourceMuArray =[[CardDataFMDB shareSqlite]queryRecordsFromCardInfoCardNumber];
    NSDictionary *dic =[self sumAllLimitAndArrears];
    self.allLimitMoneyLabel.text =dic[@"allLimit"];
    self.arrearsMoneyLabel.text =dic[@"arrears"];
    [self.cardTableView reloadData];
}
-(void)getCardListData{
   
    self.dataSourceMuArray =[[CardDataFMDB shareSqlite]queryRecordsFromCardInfoCardNumber];
    NSDictionary *dic =[self sumAllLimitAndArrears];
    self.allLimitMoneyLabel.text =dic[@"allLimit"];
    self.arrearsMoneyLabel.text =dic[@"arrears"];
    [self.cardTableView reloadData];
}
-(NSDictionary *)sumAllLimitAndArrears{

    float allLimit =0.00;
    float arrears =0.00;
    if (self.dataSourceMuArray.count>0) {
       
        for (CardInfoModel *model in self.dataSourceMuArray) {
            allLimit +=[model.limitNumber floatValue];
            arrears +=[model.arrears floatValue];
        }
    }
    return @{@"allLimit":[NSString stringWithFormat:@"%.2f",allLimit],@"arrears":[NSString stringWithFormat:@"%.2f",arrears]};
}
-(void)creatTableView{
    
//    self.cardTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,iphoneX||iphoneXR||iphoneXSM?84:64, self.view.width,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88+34:64)) style:UITableViewStylePlain];
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0,iphoneX||iphoneXR||iphoneXSM?88:64,self.view.width,0)];
    headView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:headView];
    
    self.cardTableView =[[UITableView alloc]initWithFrame:CGRectMake(0,headView.bottom, self.view.width,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88+34:64)) style:UITableViewStyleGrouped];
    self.cardTableView.delegate =self;
    self.cardTableView.dataSource =self;
    self.cardTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    self.cardTableView.tableHeaderView =[self tableViewHeadView];
    self.cardTableView.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    [self.view addSubview:self.cardTableView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=11.0) {

        self.cardTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
-(UIView *)tableViewHeadView{
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,100)];
    UIImage *backImage =[JVCCreatImage creatImageFromColors:@[[UIColor colorWithRed:0.97 green:0.42 blue:0.38 alpha:1.00],[UIColor colorWithRed:0.91 green:0.13 blue:0.20 alpha:1.00]] ByGradientType:leftToRight withFrame:CGRectMake(0, 0, self.view.width, 100)];
    headView.backgroundColor =[UIColor colorWithPatternImage:backImage];
    UILabel *allLimitLabel =[[UILabel alloc]initWithFrame:CGRectMake(20,10, 100,15)];
    allLimitLabel.font =[UIFont systemFontOfSize:13];
    allLimitLabel.textColor =[UIColor whiteColor];
    allLimitLabel.text =@"总额度";
    allLimitLabel.textAlignment =NSTextAlignmentLeft;
    [headView addSubview:allLimitLabel];
    
    self.allLimitMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 25,100,25)];
    self.allLimitMoneyLabel.font =[UIFont systemFontOfSize:16];
    [self.allLimitMoneyLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    self.allLimitMoneyLabel.text =@"0.00";
    self.allLimitMoneyLabel.textColor =[UIColor whiteColor];
    self.allLimitMoneyLabel.textAlignment =NSTextAlignmentLeft;
    [headView addSubview:self.allLimitMoneyLabel];
    
    UILabel *arrearsLabel =[[UILabel alloc]initWithFrame:CGRectMake(20,60, 100,15)];
    arrearsLabel.font =[UIFont systemFontOfSize:13];
    arrearsLabel.textColor =[UIColor whiteColor];
    arrearsLabel.text =@"总欠款";
    arrearsLabel.textAlignment =NSTextAlignmentLeft;
    [headView addSubview:arrearsLabel];
    
    self.arrearsMoneyLabel =[[UILabel alloc]initWithFrame:CGRectMake(20,75,100,25)];
    self.arrearsMoneyLabel.font =[UIFont systemFontOfSize:16];
    [self.arrearsMoneyLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    self.arrearsMoneyLabel.text =@"0.00";
    self.arrearsMoneyLabel.textColor =[UIColor whiteColor];
    self.arrearsMoneyLabel.textAlignment =NSTextAlignmentLeft;
    [headView addSubview:self.arrearsMoneyLabel];
    
    UIButton *button =[[UIButton alloc]initWithFrame:CGRectMake(self.view.width-60,25,50, 50)];
    button.backgroundColor =[UIColor orangeColor];
    button.layer.cornerRadius =25;
    button.clipsToBounds =YES;
    [button setTitle:@"记账" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushConsumeBillVC:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button];

    return headView;
}
-(void)pushConsumeBillVC:(UIButton *)button{

    ConsumeBillVC *consumBill =[[ConsumeBillVC alloc]init];
    [self.navigationController pushViewController:consumBill animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,0.01)];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width,0.01)];
//    return view;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//
//    return 0.01;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceMuArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardListTableViewCell *cardCell =[tableView dequeueReusableCellWithIdentifier:@"CardListTableViewCell"];
    if (cardCell == nil) {
        
        cardCell =[[CardListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CardListTableViewCell" withIndexPath:indexPath];
    }
    cardCell.selectionStyle =UITableViewCellSelectionStyleNone;
    cardCell.cardInfoModel =self.dataSourceMuArray[indexPath.row];
    return cardCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CardListTableViewCell *cell =(CardListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    RepaymentViewController *repaymentVC =[[RepaymentViewController alloc]init];
    repaymentVC.delegate =self;
    repaymentVC.cardModel =self.dataSourceMuArray[indexPath.row];
    repaymentVC.monthDueString =cell.dueDateLabel.text;
    repaymentVC.nextMonthDueString =cell.nextDueDate.text;
    [self.navigationController pushViewController:repaymentVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backView.alpha =0.5f;
    return YES;
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CardListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backView.alpha =1.0f;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CardInfoModel *cardInfoModel =self.dataSourceMuArray[indexPath.row];
    CardListTableViewCell *cell =(CardListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    UITableViewRowAction *deleteAction =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    
        [[CardDataFMDB shareSqlite]delRecordFromCardInfoData:cardInfoModel.bankNumber];
        [[CardDataFMDB shareSqlite]delRecordFromRepaymentData:cardInfoModel.bankNumber withTime:@"" isAll:YES];
        [[CardDataFMDB shareSqlite]delRecordFromConsumeData:cardInfoModel.bankNumber withTime:@"" isAll:YES];
        [self.dataSourceMuArray removeObjectAtIndex:indexPath.row];
        [self getCardListData];
    }];
    deleteAction.backgroundColor =[UIColor colorWithRed:0.96 green:0.30 blue:0.28 alpha:1.00];
    UITableViewRowAction *editeAction =[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        AddCardViewController *addCardVC =[[AddCardViewController alloc]init];
        addCardVC.isEdit =YES;
        addCardVC.cardInfoModel =cardInfoModel;
        addCardVC.dueDate =[[cell.dueDateLabel.text substringFromIndex:cell.dueDateLabel.text.length-2] intValue];
        addCardVC.nextDueDate =[[cell.nextDueDate.text substringFromIndex:cell.dueDateLabel.text.length-2] intValue];
        __weak typeof(self)weakSelf =self;
        addCardVC.RefreshTableViewBlock = ^{
            
            [weakSelf getCardListData];
        };
        [self.navigationController pushViewController:addCardVC animated:YES];
        [tableView setEditing:NO animated:YES];
    }];
    editeAction.backgroundColor =[UIColor colorWithRed:0.49 green:0.51 blue:0.97 alpha:1.00];
    return @[deleteAction,editeAction];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)saveButtonClickDelegateBankNumber:(NSString *)bankNumber withIndexPath:(NSIndexPath *)indexPath{
 
    [self getCardListData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
