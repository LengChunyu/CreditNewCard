//
//  CardHomeViewController.m
//  CreditCard
//
//  Created by liujingtao on 2019/12/3.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import "RootHomeViewController.h"
#import "CardHomeViewController.h"
#import "ConsumeBillVC.h"
#import "NoteViewController.h"
#import "RepayViewController.h"
#import "AccountBookModel.h"
#define PI 3.14159265358979323846
@interface RootHomeViewController ()
@property (nonatomic,strong) UIButton *consumeButton;
@property (nonatomic,strong) UIButton *repayButton;
@property (nonatomic,strong) UILabel *accountBookLabel;
@property (nonatomic,strong) UIButton *quickNButton;
@end

@implementation RootHomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self getCurrentAccountBookDetail];
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.title =@"首页";
    //只有三个视图 信用卡 账本 快速记账
    [self creatSubViews];
}
-(void)creatSubViews{

    UIImageView *backImageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    backImageView.contentMode =UIViewContentModeScaleAspectFit;
    if (iphoneX||iphoneXR||iphoneXSM) {
       
        backImageView.image =[UIImage imageNamed:@"xmax.jpeg"];
    }else{
    
        backImageView.image =[UIImage imageNamed:@"6and6s.jpeg"];
    }
//    [self.view addSubview:backImageView];
    
    UIButton *noteButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0,self.view.width/2,self.view.width/2)];
    noteButton.layer.cornerRadius =self.view.width/4;
    noteButton.clipsToBounds =YES;
    noteButton.tag =101;
    [noteButton setTitle:@"账本" forState:UIControlStateNormal];
    noteButton.backgroundColor =[UIColor orangeColor];
    noteButton.alpha =0.7;
    [noteButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:noteButton];
    noteButton.center =self.view.center;
    
    UIButton *creditButton =[[UIButton alloc] initWithFrame:CGRectMake(self.view.width/3, noteButton.top-10-self.view.width/3,self.view.width/3,self.view.width/3)];
    creditButton.tag =100;
    creditButton.backgroundColor =[UIColor blueColor];
    creditButton.layer.cornerRadius =self.view.width/6;
    creditButton.clipsToBounds =YES;
    [creditButton setTitle:@"信用卡" forState:UIControlStateNormal];
    [creditButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    creditButton.alpha =0.7;
    [self.view addSubview:creditButton];
    
    self.quickNButton =[[UIButton alloc] initWithFrame:CGRectMake(self.view.width/3, noteButton.bottom+10,self.view.width/3,self.view.width/3)];
    self.quickNButton.backgroundColor =[UIColor redColor];
    self.quickNButton.layer.cornerRadius =self.view.width/6;
    self.quickNButton.clipsToBounds =YES;
//    [quickNButton setTitle:@"快速记一笔" forState:UIControlStateNormal];
    self.quickNButton.alpha =0.7;
    [self.view addSubview:self.quickNButton];
    
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.quickNButton.left,self.quickNButton.top,self.view.width/3, self.view.width/3/4)];
    titleLabel.text =@"快速记一笔";
    titleLabel.textAlignment =NSTextAlignmentCenter;
    titleLabel.font =[UIFont systemFontOfSize:16];
    [self.view addSubview:titleLabel];
    
    self.accountBookLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.quickNButton.left,self.quickNButton.top+self.view.width/3/4,self.view.width/3, self.view.width/3/4)];
    self.accountBookLabel.textAlignment =NSTextAlignmentCenter;
    self.accountBookLabel.font =[UIFont systemFontOfSize:16];
    [self.view addSubview:self.accountBookLabel];

    self.consumeButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0,self.view.width/6,self.view.width/6)];
    self.consumeButton.tag =102;
    self.consumeButton.backgroundColor =[UIColor whiteColor];
    self.consumeButton.layer.cornerRadius =self.view.width/12;
    self.consumeButton.clipsToBounds =YES;
    [self.consumeButton setTitle:@"支出" forState:UIControlStateNormal];
    [self.consumeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.consumeButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.consumeButton];
    self.consumeButton.hidden =YES;
    
    
    self.repayButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0,self.view.width/6,self.view.width/6)];
    self.repayButton.tag =103;
    self.repayButton.backgroundColor =[UIColor whiteColor];
    self.repayButton.layer.cornerRadius =self.view.width/12;
    self.repayButton.clipsToBounds =YES;
    [self.repayButton setTitle:@"收入" forState:UIControlStateNormal];
    [self.repayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.repayButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.repayButton];
    self.repayButton.hidden =YES;
    
    
}
-(void)btnClick:(UIButton *)button{

    switch (button.tag) {
        case 100:{
            //信用卡
            CardHomeViewController *cardHomeVC =[[CardHomeViewController alloc]init];
            [self.navigationController pushViewController:cardHomeVC animated:YES];
        }
            break;
        case 101:{
        
            //账本
            ConsumeBillVC *consumeVC =[[ConsumeBillVC alloc]init];
            [self.navigationController pushViewController:consumeVC animated:YES];
        }
            break;
        case 102:{

            NSDateFormatter *dateformatterD =[[NSDateFormatter alloc]init];
            [dateformatterD setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *newDateStringD =[dateformatterD stringFromDate:[NSDate date]];
            //快速记一笔 默认是支出的界面，默认存的是上回打开的账本。如果一次没有打开就是总账本
            NoteViewController *noteViewController =[[NoteViewController alloc]init];
            noteViewController.accountNameS =self.accountBookLabel.text;
            noteViewController.currentTime =newDateStringD;//当前的时间
            [self.navigationController pushViewController:noteViewController animated:YES];
        }
            break;
        case 103:{

            NSDateFormatter *dateformatterD =[[NSDateFormatter alloc]init];
            [dateformatterD setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString *newDateStringD =[dateformatterD stringFromDate:[NSDate date]];
            //快速记一笔 默认是支出的界面，默认存的是上回打开的账本。如果一次没有打开就是总账本
            RepayViewController *repayViewController =[[RepayViewController alloc]init];
            repayViewController.accountNameS =self.accountBookLabel.text;
            repayViewController.currentTime =newDateStringD;//当前的时间
            [self.navigationController pushViewController:repayViewController animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(void)getCurrentAccountBookDetail{

    NSString *accountNameS=[[NSUserDefaults standardUserDefaults]objectForKey:@"selectAccountName"];
    if ([accountNameS isEqualToString:@"总账本"]||accountNameS.length<=0) {
        
        self.accountBookLabel.text =@"总账本";
        [self changeButtonFrame];
    }else{
        
        NSArray *arrayAccountN =[[CardDataFMDB shareSqlite]queryAccountBookList:accountNameS];
        if (arrayAccountN.count>0) {
    
            AccountBookModel *otherModel =arrayAccountN[0];
            self.accountBookLabel.text =otherModel.accountBookName;
            if (otherModel.isRepay&&!otherModel.isConsume) {
                self.repayButton.frame =CGRectMake(self.quickNButton.left+self.view.width/12,self.quickNButton.center.y,self.view.width/6, self.view.width/6);
                self.consumeButton.hidden =YES;
                self.repayButton.hidden =NO;
                self.repayButton.layer.cornerRadius =self.view.width/12;
                self.repayButton.clipsToBounds =YES;
            }else if (!otherModel.isRepay&&otherModel.isConsume){
            
                self.consumeButton.frame =CGRectMake(self.quickNButton.left+self.view.width/12,self.quickNButton.center.y,self.view.width/6, self.view.width/6);
                self.consumeButton.hidden =NO;
                self.repayButton.hidden =YES;
                self.consumeButton.layer.cornerRadius =self.view.width/12;
                self.consumeButton.clipsToBounds =YES;
            }else{
            
                [self changeButtonFrame];
            }
            
        }else{
            self.accountBookLabel.text =@"总账本";
            [self changeButtonFrame];
        }
    }
}
-(void)changeButtonFrame{

    CGFloat radius =self.view.width/6/(cos(PI/180*45)*2+1);
    self.consumeButton.hidden =NO;
    self.repayButton.hidden =NO;
    self.consumeButton.frame =CGRectMake(self.quickNButton.left+(self.view.width/3-radius*4)/2,self.quickNButton.center.y,radius*2,radius*2);
    self.repayButton.frame =CGRectMake(self.quickNButton.center.x,self.quickNButton.center.y,radius*2,radius*2);
    self.consumeButton.layer.cornerRadius =radius;
    self.consumeButton.clipsToBounds =YES;
    self.repayButton.layer.cornerRadius =radius;
    self.repayButton.clipsToBounds =YES;
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
