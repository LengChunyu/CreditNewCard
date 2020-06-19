//
//  NoteViewController.m
//  CreditCard
//
//  Created by liujingtao on 2019/3/30.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "NoteViewController.h"
#import "PassTextFild.h"
#import "JVCCreatImage.h"
#import "LcyCollectionViewLayout.h"
#import "CollectionModel.h"
#import <sys/utsname.h>
@interface NoteViewController ()<UIScrollViewDelegate,PassTextFieldViewDelegate,UITextFieldDelegate,UICollectionViewDelegate,UICollectionViewDataSource,JVAlertViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UILabel *payLabel;
@property (nonatomic,strong) UILabel *incomeLabel;
@property (nonatomic,strong) UIScrollView *backScrollView;
@property (nonatomic,strong) UIScrollView *contentScrollView;
@property (nonatomic,assign) CGFloat lastContentOffset;
//@property (nonatomic,strong) UIScrollView *payScrollView;
@property (nonatomic,strong) UILabel *moneyTextLabel;
@property (nonatomic,strong) PassTextFild *moneyTextField;
@property (nonatomic,strong) UITextField *timeTextField;
@property (nonatomic,strong) UITextField *remarkTextField;
@property (nonatomic,strong) UIButton *remenberButton;
@property (nonatomic,strong) NSDate *customDate;
@property (nonatomic,copy) NSString *lastSecondString;//最后的秒数避免时间重复（只能做到尽量）

@property (nonatomic,strong) NSMutableArray *sourceMuArray;
@property (nonatomic,strong) UICollectionView *myCollectionView;
//@property (nonatomic,strong) LcyCollectionViewLayout *myLayout;
@property (nonatomic,strong) NSMutableDictionary *cellDic;
@property (nonatomic,strong) UIButton *paySaveButton;
@property (nonatomic,assign) int selectIndex;
@property (nonatomic,strong) JVAlertView *alertview;

@property (nonatomic,assign) BOOL firstOpen;
@property (nonatomic,copy) NSString *deviceName;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UITapGestureRecognizer *oneTapResponders;

@end
struct utsname systemInfo;
@implementation NoteViewController
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

            UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
            if (self.moneyTextField.keyBoardBackView.superview == window) {
                
                [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                    self.moneyTextField.keyBoardBackView.frame = CGRectMake(0, self.moneyTextField.keyBoardBackView.bottom+self.moneyTextField.keyBoardBackView.height, self.moneyTextField.keyBoardBackView.width, self.moneyTextField.keyBoardBackView.height);
                } completion:^(BOOL finished) {
                    
                    [self.moneyTextField.keyBoardBackView removeFromSuperview];
                    self.moneyTextField.inputView = self.moneyTextField.keyBoardBackView;
                }];
            }
            if ([self.moneyTextField isFirstResponder]) {

                [self.moneyTextField finishButtonClick];
                [self.moneyTextField resignFirstResponder];
            }
            if ([self.timeTextField isFirstResponder]) {

                [self.timeTextField resignFirstResponder];
            }
            if ([self.remarkTextField isFirstResponder]) {

                [self.remarkTextField resignFirstResponder];
            }
            NSLog(@"scrollEnabled=====No");
            self.backScrollView.scrollEnabled =NO;
        };
        bbNavigation.panEndFailedBlock = ^{
            NSLog(@"scrollEnabled=====Yes");
            self.backScrollView.scrollEnabled =YES;
        };
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.firstOpen) {
       
        self.firstOpen = YES;
        UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
        [window addSubview:self.moneyTextField.keyBoardBackView];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.sourceMuArray =[[NSMutableArray alloc]init];
    uname(&systemInfo);
    NSString *mode= [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    self.deviceName =[self currentModel:mode];
    
    [self getData];
    [self creatSubViews];
    [self addNotification];
}
//创建子视图
-(void)creatSubViews{
    
    UIView *titileView =[[UIView alloc]initWithFrame:CGRectMake(0,0,150,44)];
    self.navigationItem.titleView =titileView;
    self.payLabel =[[UILabel alloc]initWithFrame:CGRectMake((titileView.width-50)/2,0,50,44)];
    self.payLabel.textColor =[UIColor blackColor];
    self.payLabel.textAlignment =NSTextAlignmentCenter;
    self.payLabel.font =[UIFont systemFontOfSize:20];
    self.payLabel.text =@"支出";
    [titileView addSubview:self.payLabel];
    self.payLabel.userInteractionEnabled =YES;
    UITapGestureRecognizer *oneTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClickOne:)];
    oneTap1.numberOfTapsRequired =1;
    oneTap1.numberOfTouchesRequired =1;
    [self.payLabel addGestureRecognizer:oneTap1];
    
    //开始创建backScrollView
    self.backScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,iphoneX||iphoneXR||iphoneXSM?88:64,SCREEN_WIDTH, SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64))];
    self.backScrollView.contentSize =CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64)+(SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64))/5*2-20);
    self.backScrollView.showsHorizontalScrollIndicator =NO;
    self.backScrollView.showsVerticalScrollIndicator =YES;
    self.backScrollView.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    self.backScrollView.delegate =self;
    [self.view addSubview:self.backScrollView];
    [self.backScrollView setContentOffset:CGPointMake(0,(SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64))/5*2-20)];
    if (@available(iOS 11.0, *)) {
        self.backScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    [self creatPay];
}
-(void)getData{

    NSString  *markString =[[NSUserDefaults standardUserDefaults]objectForKey:@"markSourceArray"];
    if (markString.length>0) {
        
        if ([markString containsString:@","]) {
            NSArray *stringArray =[markString componentsSeparatedByString:@","];
            for (int i=0;i<stringArray.count;i++) {
                NSString *string =stringArray[i];
                CollectionModel *model =[[CollectionModel alloc]init];
                model.markString =string;
                model.indexPath =[NSIndexPath indexPathForRow:i inSection:0];
                [self.sourceMuArray addObject:model];
            }
        }else{
            CollectionModel *model =[[CollectionModel alloc]init];
            model.markString =markString;
            model.indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
            [self.sourceMuArray addObject:model];
        }
    }
}
-(void)addNotification{
    
    //监听键盘
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWillShown:(NSNotification*)aNotification{
    
    NSDictionary *info = [aNotification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"高-%f",keyboardSize.height);
    NSLog(@"宽-%f",keyboardSize.width);
    //输入框位置动画加载
    [UIView animateWithDuration:duration animations:^{
        
        [self.backScrollView setContentOffset:CGPointMake(0,(SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64))/5*2-20)];
        
        //            CGFloat offset = self.backScrollView.contentSize.height - self.backScrollView.bounds.size.height;
        //            if (offset > 0){
        //
        //                [self.backScrollView setContentOffset:CGPointMake(0, offset) animated:NO];
        //            }
    }completion:^(BOOL finished) {
        
        //            for (UIGestureRecognizer *gestureRecognizer in  self.backScrollView.gestureRecognizers) {
        //                if (gestureRecognizer == self.oneTapResponders) {
        //                    [self.backScrollView removeGestureRecognizer:gestureRecognizer];
        //                    self.oneTapResponders = nil;
        //                }
        //                NSLog(@"current");
        //            }
        //            self.oneTapResponders =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondTapMethod:)];
        //            self.oneTapResponders.numberOfTapsRequired =1;
        //            self.oneTapResponders.numberOfTouchesRequired =1;
        //            [self.backScrollView addGestureRecognizer:self.oneTapResponders];
    }];
        
        
}
-(void)tapClickOne:(UITapGestureRecognizer *)tap{

//    if (self.backScrollView.contentOffset.x!=0) {
//
//        [self.backScrollView setContentOffset:CGPointMake(0,0) animated:YES];
//    }
}
-(void)tapClickTwo:(UITapGestureRecognizer *)tap{
   
    if (self.backScrollView.contentOffset.x!=self.view.width) {
       
        [self.backScrollView setContentOffset:CGPointMake(self.view.width,0) animated:YES];
    }
}
-(void)passTextFieldSearch:(NSString *)searchString{

    self.moneyTextLabel.text =searchString;
}
-(void)creatPay{

    self.oneTapResponders =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(respondTapMethod:)];
    self.oneTapResponders.delegate = self;
    self.oneTapResponders.numberOfTapsRequired =1;
    self.oneTapResponders.numberOfTouchesRequired =1;
    [self.backScrollView addGestureRecognizer:self.oneTapResponders];
    
    UIView *backView =[[UIView alloc]initWithFrame:CGRectMake(10,(SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64))/5*2,SCREEN_WIDTH-20,54)];
    backView.backgroundColor =[UIColor colorWithRed:0.46 green:0.67 blue:0.49 alpha:1.00];
    backView.layer.cornerRadius =7;
    backView.clipsToBounds =YES;
    [self.backScrollView addSubview:backView];

    UITapGestureRecognizer *oneTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moneyClick:)];
    oneTap.numberOfTapsRequired =1;
    oneTap.numberOfTouchesRequired =1;
    [backView addGestureRecognizer:oneTap];

    self.moneyTextLabel =[[UILabel alloc]initWithFrame:CGRectMake(20,12,backView.width-40,30)];
    self.moneyTextLabel.userInteractionEnabled =YES;
    self.moneyTextLabel.text =self.isEdit?self.infoModel.everyConsume:@"0.00";
    self.moneyTextLabel.textColor =[UIColor colorWithRed:0.67 green:0.84 blue:0.68 alpha:1.00];
    self.moneyTextLabel.textAlignment =NSTextAlignmentRight;
    self.moneyTextLabel.font =[UIFont systemFontOfSize:25];
    [backView addSubview:self.moneyTextLabel];
    
    //创建数字键盘
    self.moneyTextField =[[PassTextFild alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-10-20,backView.top+7,2,40)];
    self.moneyTextField.textColor=[UIColor clearColor];
    self.moneyTextField.delegate =self;
    self.moneyTextField.font =[UIFont systemFontOfSize:23];
    self.moneyTextField.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    self.moneyTextField.returnKeyType = UIReturnKeyDone;
    self.moneyTextField.keyboardType =UIKeyboardTypeDefault;
    self.moneyTextField.text =self.isEdit?self.infoModel.everyConsume:@"0.00";
    [self.backScrollView addSubview:self.moneyTextField];
    float openSecond;
    if ([self.deviceName isEqualToString:@"4"]) {
        
        openSecond =0.5;
    }else if ([self.deviceName isEqualToString:@"3"]){
        
        openSecond =0.7;
    }else{
       
        openSecond =0.8;
    }
    [self.moneyTextField becomeFirstResponder];
    [self.view addSubview:self.moneyTextField.keyBoardBackView];

    UIView *backView1 =[[UIView alloc]initWithFrame:CGRectMake(10,backView.bottom+20,SCREEN_WIDTH-20,100)];
    backView1.backgroundColor =[UIColor colorWithRed:0.46 green:0.67 blue:0.49 alpha:1.00];
    backView1.layer.cornerRadius =5;
    backView1.clipsToBounds =YES;
    backView1.backgroundColor =[UIColor whiteColor];
    [self.backScrollView addSubview:backView1];
    
    UILabel *timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0,0,60,50)];
    timeLabel.textColor =[UIColor blackColor];
    timeLabel.textAlignment =NSTextAlignmentCenter;
    timeLabel.text =@"时间";
    [backView1 addSubview:timeLabel];

    self.customDate =[NSDate date];
    
    NSDateFormatter *dateformatterDS =[[NSDateFormatter alloc]init];
    [dateformatterDS setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *quanTime =[dateformatterDS stringFromDate:self.customDate];
    self.lastSecondString =[quanTime substringWithRange:NSMakeRange(quanTime.length-2,2)];
    
    NSDateFormatter *dateformatterD =[[NSDateFormatter alloc]init];
    [dateformatterD setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *newDateStringD =[dateformatterD stringFromDate:self.customDate];
    NSString *firstTime =[newDateStringD componentsSeparatedByString:@" "].firstObject;
    NSString *yearString =[firstTime componentsSeparatedByString:@"-"].firstObject;
    if (self.currentTime.length>0) {

        NSString *timeYearMonthDayl =[self.currentTime componentsSeparatedByString:@" "].firstObject;
        if (![yearString isEqualToString:[timeYearMonthDayl componentsSeparatedByString:@"-"].firstObject]) {

            newDateStringD =[NSString stringWithFormat:@"%@ %@",timeYearMonthDayl,[newDateStringD componentsSeparatedByString:@" "].lastObject];
            self.customDate =[dateformatterD dateFromString:newDateStringD];
        }
    }
    if (self.isEdit) {
        
        self.customDate = [dateformatterDS dateFromString:self.infoModel.time];
        newDateStringD = [dateformatterD stringFromDate:self.customDate];
    }
    self.timeTextField =[[UITextField alloc]initWithFrame:CGRectMake(60,0,backView1.width-60,50)];
    self.timeTextField.delegate =self;
    self.timeTextField.tintColor =[UIColor clearColor];
    self.timeTextField.text =newDateStringD;
    self.timeTextField.textAlignment =NSTextAlignmentLeft;
    self.timeTextField.textColor =[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    self.timeTextField.font =[UIFont systemFontOfSize:15];
    self.timeTextField.userInteractionEnabled = self.isEdit?NO:YES;
    [backView1 addSubview:self.timeTextField];
    //影响相应的时间
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.datePicker = [[UIDatePicker alloc]init];
        self.datePicker.locale =[[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"];
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [self.datePicker setDate:[NSDate date] animated:YES];
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        
        self.timeTextField.inputView =self.datePicker;
    });
    UITapGestureRecognizer *timeTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeOneTaP:)];
    timeTap.numberOfTapsRequired =1;
    timeTap.numberOfTouchesRequired =1;
    [backView1 addGestureRecognizer:timeTap];

    UILabel *remarkLabel =[[UILabel alloc]initWithFrame:CGRectMake(0,50,60,50)];
    remarkLabel.textColor =[UIColor blackColor];
    remarkLabel.textAlignment =NSTextAlignmentCenter;
    remarkLabel.text =@"备注";
    [backView1 addSubview:remarkLabel];
    
    self.remarkTextField =[[UITextField alloc]initWithFrame:CGRectMake(60,50,backView1.width-120,50)];
    self.remarkTextField.placeholder =@"点击编辑备注";
    self.remarkTextField.font =[UIFont systemFontOfSize:15];
    self.remarkTextField.delegate =self;
    self.remarkTextField.textColor =[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
    [backView1 addSubview:self.remarkTextField];
    
    UIImage *backImage =[JVCCreatImage creatImageFromColors:@[[UIColor colorWithRed:0.97 green:0.42 blue:0.38 alpha:1.00],[UIColor colorWithRed:0.91 green:0.13 blue:0.20 alpha:1.00]] ByGradientType:leftToRight withFrame:CGRectMake(0, 0, self.view.width, 100)];
    self.remenberButton =[[UIButton alloc]initWithFrame:CGRectMake(self.remarkTextField.right+15,self.remarkTextField.top+10,30,30)];
    [self.remenberButton setImage:[UIImage imageNamed:@"sum_icon_"] forState:UIControlStateNormal];
    [self.remenberButton addTarget:self action:@selector(remenberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.remenberButton.clipsToBounds =YES;
    [backView1 addSubview:self.remenberButton];
    
    LcyCollectionViewLayout *myLayout =[[LcyCollectionViewLayout alloc]init];
    myLayout.sourceMuArray =self.sourceMuArray;
    __weak typeof(self)weakSelf =self;
    [myLayout configItemWidth:^CGFloat(NSIndexPath *indexPath, CGFloat height,CGFloat currentY,CGFloat currentX) {

        CollectionModel *model =weakSelf.sourceMuArray[indexPath.row];
        CGRect markBounds =[model.markString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        if (indexPath.row==weakSelf.sourceMuArray.count-1&&weakSelf.paySaveButton) {

            CGFloat itemW =markBounds.size.width;
            if (itemW > weakSelf.myCollectionView.width-20) {

                itemW = weakSelf.myCollectionView.width-20;
            }
            if (currentX+itemW > weakSelf.myCollectionView.width-10) {

                currentY += (height+10);
            }
            weakSelf.myCollectionView.frame =CGRectMake(0,backView1.bottom+10,SCREEN_WIDTH,currentY+30+10);
            weakSelf.paySaveButton.frame =CGRectMake(20,currentY+30+10+10+backView1.bottom+10,SCREEN_WIDTH-40,44);
            if (weakSelf.paySaveButton.bottom>=SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64)+(SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64))/5*2-20) {
                
                self.backScrollView.contentSize =CGSizeMake(self.backScrollView.width, weakSelf.paySaveButton.bottom+10);
            }else{
             
                self.backScrollView.contentSize =CGSizeMake(self.backScrollView.width, SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64)+(SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88:64))/5*2-20);
            }
        }
        return markBounds.size.width;
    }];
    myLayout.itemHeight =30;
    myLayout.itemSpace =10.0f;
    myLayout.lineSpace =10.0f;
    myLayout.sectionInsets =UIEdgeInsetsMake(10, 10, 10, 10);
    self.myCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0,backView1.bottom+10,SCREEN_WIDTH,10) collectionViewLayout:myLayout];
    [self.myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"LcyCollectionViewCell"];
    self.myCollectionView.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    self.myCollectionView.delegate =self;
    self.myCollectionView.dataSource =self;
    [self.backScrollView addSubview:self.myCollectionView];

    self.paySaveButton =[[UIButton alloc]initWithFrame:CGRectMake(20,self.myCollectionView.bottom+10,SCREEN_WIDTH-40,44)];
    [self.paySaveButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [self.paySaveButton setTitle:@"保存" forState:UIControlStateNormal];
    self.paySaveButton.layer.cornerRadius =5.0f;
    self.paySaveButton.clipsToBounds =YES;
    [self.paySaveButton addTarget:self action:@selector(paySaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.backScrollView addSubview:self.paySaveButton];
}
-(void)creatIncome{

}
-(void)creatCollectionView{
    
    
}
-(void)dateChange:(UIDatePicker *)datePicker{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];//设置输出的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    self.customDate =datePicker.date;
    NSString *timeString =[dateFormatter stringFromDate:datePicker.date];
    self.timeTextField.text =timeString;
}
-(void)respondTapMethod:(UITapGestureRecognizer *)oneTap{
    
    if (self.moneyTextField.isFirstResponder) {
        if ([self.moneyTextField judgeFinishString]) {
            
            UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
            if (self.moneyTextField.keyBoardBackView.superview == window) {
                
                [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                    self.moneyTextField.keyBoardBackView.frame = CGRectMake(0, self.moneyTextField.keyBoardBackView.bottom+self.moneyTextField.keyBoardBackView.height, self.moneyTextField.keyBoardBackView.width, self.moneyTextField.keyBoardBackView.height);
                } completion:^(BOOL finished) {
                    
                    [self.moneyTextField.keyBoardBackView removeFromSuperview];
                    self.moneyTextField.inputView = self.moneyTextField.keyBoardBackView;
                }];
            }
        }
        [self.moneyTextField finishButtonClick];
        [self.moneyTextField resignFirstResponder];
    }
    if (self.remarkTextField.isFirstResponder) {
        
        [self.remarkTextField resignFirstResponder];
    }
    if (self.timeTextField.isFirstResponder) {
        
        [self.timeTextField resignFirstResponder];
    }
}
-(void)moneyClick:(UITapGestureRecognizer *)oneTap{

    if (!self.moneyTextField.isFirstResponder) {
    
        [self.moneyTextField becomeFirstResponder];
    }
}
-(void)timeOneTaP:(UITapGestureRecognizer *)tap{

    if (self.moneyTextField.isFirstResponder) {
        
        [self.moneyTextField finishButtonClick];
        [self.moneyTextField resignFirstResponder];
    }
    if (self.remarkTextField.isFirstResponder) {
        
        [self.remarkTextField resignFirstResponder];
    }
}
-(void)remenberButtonClick:(UIButton *)button{

    if ([self.remarkTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0) {
        
        [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:@"标签不能为空"];
        return;
    }
    if (self.remarkTextField.isFirstResponder) {
        
        [self.remarkTextField resignFirstResponder];
    }
    if (self.sourceMuArray.count>=10) {
        
        //不添加了
        [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:@"最多添加10个标签，可以长按删除标签"];
    }else{
    
        for (int i=0;i<self.sourceMuArray.count;i++) {
            CollectionModel *model =self.sourceMuArray[i];
            if ([model.markString isEqualToString:self.remarkTextField.text]) {
                //提示错误
                [[JVCAlertHelper shareAlertHelper] alertToastMainThreadOnWindow:@"标签中已存在"];
                return;
            }
        }
        CollectionModel *model1 =[[CollectionModel alloc]init];
        model1.markString =self.remarkTextField.text;
        model1.indexPath =[NSIndexPath indexPathForRow:0 inSection:0];
        [self.sourceMuArray insertObject:model1 atIndex:0];
        NSMutableArray *muArray =[[NSMutableArray alloc]init];
        for (int i=0; i<self.sourceMuArray.count;i++) {
           
            CollectionModel *model =self.sourceMuArray[i];
            model.indexPath =[NSIndexPath indexPathForRow:i inSection:0];
            [muArray addObject:model.markString];
        }
        NSString *markString;
        if (muArray.count==1) {
          
            markString =muArray[0];
        }else{
          
            markString =[muArray componentsJoinedByString:@","];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:markString forKey:@"markSourceArray"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.myCollectionView performBatchUpdates:^{
            
            [self.myCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
        } completion:^(BOOL finished) {
            
            [self.myCollectionView reloadData];
        }];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //全局变量记录滑动前的contentOffset
    self.lastContentOffset = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

//    if (scrollView==self.backScrollView) {
//
//        if ([self.moneyTextField isFirstResponder]) {
//
//            [self.moneyTextField resignFirstResponder];
//        }
//        if ([self.timeTextField isFirstResponder]) {
//
//            [self.timeTextField resignFirstResponder];
//        }
//        if ([self.remarkTextField isFirstResponder]) {
//
//            [self.remarkTextField resignFirstResponder];
//        }
//        float oneMove =50.0/SCREEN_WIDTH;
//        float oneTextBig =6.0/SCREEN_WIDTH;
//        self.payLabel.frame =CGRectMake(50-oneMove*scrollView.contentOffset.x,0, 50, 44);
//        self.incomeLabel.frame =CGRectMake(100-oneMove*scrollView.contentOffset.x,0, 50, 44);
//        self.payLabel.font =[UIFont systemFontOfSize:20-oneTextBig*scrollView.contentOffset.x];
//        self.incomeLabel.font =[UIFont systemFontOfSize:14+oneTextBig*scrollView.contentOffset.x];
//    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    if (textField==self.remarkTextField) {
        
        if (self.moneyTextField.isFirstResponder) {
            
            [self.moneyTextField finishButtonClick];
            [self.remarkTextField becomeFirstResponder];
        }
    }else if(textField==self.timeTextField){
        
        if (self.moneyTextField.isFirstResponder) {
            
            [self.moneyTextField finishButtonClick];
            [self.remarkTextField becomeFirstResponder];
        }
        NSDateFormatter *dateformatterD =[[NSDateFormatter alloc]init];
        [dateformatterD setDateFormat:@"yyyy-MM-dd HH:mm"];
        if (self.timeTextField.text.length>0) {
            
            [self.datePicker setDate:[dateformatterD dateFromString:self.timeTextField.text] animated:NO];
        }
//        self.customDate =[NSDate date];
//        NSString *newDateStringD =[dateformatterD stringFromDate:self.customDate];
//        self.timeTextField.text =newDateStringD;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField==self.remarkTextField) {
        
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==self.remarkTextField) {
    
        [textField resignFirstResponder];
        return YES;
    }else{
        return NO;
    }
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textfile%@",textField);
    return YES;
}
#pragma mark-CollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.sourceMuArray.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"LcyCollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        
        [subView removeFromSuperview];
    }
    CollectionModel *model =self.sourceMuArray[indexPath.row];
    UIButton *selectButton =[[UIButton alloc]initWithFrame:CGRectMake(0, 0,cell.width,cell.height)];
    [selectButton setTitleColor:[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.tag =indexPath.row;
    selectButton.backgroundColor =[UIColor whiteColor];
    selectButton.titleLabel.font =[UIFont systemFontOfSize:14];
    selectButton.layer.cornerRadius =5;
    [selectButton setTitle:model.markString forState:UIControlStateNormal];
    selectButton.clipsToBounds =YES;
    UILongPressGestureRecognizer *deleteLongG =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longDelegateItemMethod:)];
    [selectButton addGestureRecognizer:deleteLongG];
    [cell.contentView addSubview:selectButton];
    return cell;
}
-(void)longDelegateItemMethod:(UILongPressGestureRecognizer *)longGestureR{
    
    if (longGestureR.state==UIGestureRecognizerStateBegan) {
        
        UIButton *selectButton =(UIButton *)longGestureR.view;
        CollectionModel *model =self.sourceMuArray[selectButton.tag];
        UIView *customView =[[UIView alloc]initWithFrame:CGRectMake(0, 10,280,100)];
        UILabel *contentLabel =[[UILabel alloc]initWithFrame:CGRectMake(30,(100-40)/2,220,40)];
        contentLabel.text =[NSString stringWithFormat:@"确定要删除\"%@\"此标签吗？",model.markString];
        contentLabel.numberOfLines =0;
        contentLabel.font =[UIFont systemFontOfSize:14];
        contentLabel.textColor =[UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
        [customView addSubview:contentLabel];
        self.selectIndex =(int)selectButton.tag;
        //给报警音起个名
        self.alertview=[[JVAlertView alloc]initWithCustomStyle:JVAlertViewStyleCustom headType:1 Title:@"提示" custom:customView delegate:self cancelTitle:@"取消" otherTitle:@"确定"];
        self.alertview.tag =100;
        [self.alertview show:self];
    }
}
- (void)alertView:(JVAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==100) {
        
        if (buttonIndex) {
        
            [self.sourceMuArray removeObjectAtIndex:self.selectIndex];
            NSMutableArray *muArray =[[NSMutableArray alloc]init];
            for (int i=0; i<self.sourceMuArray.count;i++) {

                CollectionModel *model =self.sourceMuArray[i];
                model.indexPath =[NSIndexPath indexPathForRow:i inSection:0];
                [muArray addObject:model.markString];
            }
            NSString *markString;
            if (muArray.count==1) {

                markString =muArray[0];
            }else{

                markString =[muArray componentsJoinedByString:@","];
            }

            [[NSUserDefaults standardUserDefaults]setObject:markString forKey:@"markSourceArray"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self.myCollectionView performBatchUpdates:^{

                [self.myCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:self.selectIndex inSection:0]]];
            } completion:^(BOOL finished) {

                [self.myCollectionView reloadData];
                if (self.sourceMuArray.count==0) {
                    
                    CGRect newRect =self.myCollectionView.frame;
                    newRect.size =CGSizeMake(self.myCollectionView.bounds.size.width,10);
                    self.myCollectionView.frame =newRect;
                    self.paySaveButton.frame =CGRectMake(20,self.myCollectionView.bottom+10,SCREEN_WIDTH-40,44);
                }
            }];
        }else{
            
        }
    }
}
-(void)selectButton:(UIButton *)button{
    
    int tag =(int)button.tag;
    CollectionModel *model =self.sourceMuArray[tag];
    self.remarkTextField.text =model.markString;
    [self.remarkTextField resignFirstResponder];
}
-(void)clickMethodCollectionModel:(CollectionModel *)model{
    
    self.remarkTextField.text =model.markString;
}
//支出的进行保存
-(void)paySaveButton:(UIButton *)button{
    
    if (self.moneyTextField.isFirstResponder) {
        
        [self.moneyTextField finishButtonClick];
    }
    NSDateFormatter *dateformatterD =[[NSDateFormatter alloc]init];
    [dateformatterD setDateFormat:@"yyyy-MM-dd"];
    NSString *newDateStringD =[dateformatterD stringFromDate:self.customDate];
    NSArray *dateArray =[newDateStringD componentsSeparatedByString:@"-"];
    NSDateFormatter *dateformatter =[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *newDateAllString =[dateformatter stringFromDate:self.customDate];
    newDateAllString =[newDateAllString substringWithRange:NSMakeRange(0, newDateAllString.length-2)];
    if (self.isEdit) {
        
        newDateAllString =self.infoModel.time;
    }else{
     
        newDateAllString =[NSString stringWithFormat:@"%@%@",newDateAllString,self.lastSecondString];
    }
    NSString *moneyString = [self.moneyTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *consumeDic =@{@"bankNumber":@"",@"everyConsume":[moneyString stringByReplacingOccurrencesOfString:@"-" withString:@""],@"detail":self.remarkTextField.text.length<=0?@"":self.remarkTextField.text,@"time":newDateAllString,@"month":dateArray [1],@"year":dateArray[0],@"bankStyle":@"",@"isCard":@"0",@"week":[self weekdayStringFromDate:self.customDate],@"moneyType":[moneyString containsString:@"-"]?@"2":@"1",@"accountBookName":self.accountNameS};
    if (self.isEdit) {
        [[CardDataFMDB shareSqlite]upDateConsumeAndIncome:consumeDic];
    }else{
        [[CardDataFMDB shareSqlite]addRecordToAllConsumeTable:consumeDic];
    }
    if (self.refreshDelegate && [self.refreshDelegate respondsToSelector:@selector(customBackDelegateWithYearString:)]) {
        [self.refreshDelegate customBackDelegateWithYearString:newDateStringD];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
- (NSString *)currentModel:(NSString *)phoneModel {
    
    if ([phoneModel isEqualToString:@"iPhone1,1"])    return @"1";
    if ([phoneModel isEqualToString:@"iPhone1,2"])    return @"1";
    if ([phoneModel isEqualToString:@"iPhone2,1"])    return @"1";
    if ([phoneModel isEqualToString:@"iPhone3,1"])    return @"1";
    if ([phoneModel isEqualToString:@"iPhone3,2"])    return @"1";
    if ([phoneModel isEqualToString:@"iPhone4,1"])    return @"1";
    //
    if ([phoneModel isEqualToString:@"iPhone5,2"])    return @"2";
    if ([phoneModel isEqualToString:@"iPhone5,3"])    return @"2";
    if ([phoneModel isEqualToString:@"iPhone5,4"])    return @"2";
    if ([phoneModel isEqualToString:@"iPhone6,1"])    return @"2";
    if ([phoneModel isEqualToString:@"iPhone6,2"])    return @"2";
    
    if ([phoneModel isEqualToString:@"iPhone7,1"])    return @"3";//6plus
    if ([phoneModel isEqualToString:@"iPhone7,2"])    return @"3";//6
    if ([phoneModel isEqualToString:@"iPhone8,1"])    return @"3";//6s
    if ([phoneModel isEqualToString:@"iPhone8,2"])    return @"3";//6s plus
    if ([phoneModel isEqualToString:@"iPhone8,4"])    return @"3";//SE
    //7以上
    if ([phoneModel isEqualToString:@"iPhone9,1"])    return @"4";
    if ([phoneModel isEqualToString:@"iPhone9,2"])    return @"4";
    if ([phoneModel isEqualToString:@"iPhone9,3"])    return @"4";
    if ([phoneModel isEqualToString:@"iPhone9,4"])    return @"4";
    if ([phoneModel isEqualToString:@"iPhone10,1"])   return @"4";
    if ([phoneModel isEqualToString:@"iPhone10,2"])   return @"4";
    if ([phoneModel isEqualToString:@"iPhone10,3"])   return @"4";
    if ([phoneModel isEqualToString:@"iPhone10,4"])   return @"4";
    if ([phoneModel isEqualToString:@"iPhone10,5"])   return @"4";
    if ([phoneModel isEqualToString:@"iPhone10,6"])   return @"4";
    
    if ([phoneModel isEqualToString:@"iPhone11,2"])   return @"4";
    if ([phoneModel isEqualToString:@"iPhone11,4"])   return @"4";
    if ([phoneModel isEqualToString:@"iPhone11,6"])   return @"4";
    if ([phoneModel isEqualToString:@"iPhone11,8"])   return @"4";
    
    
    return @"1";
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"是否有反应");
}
-(void)dealloc{
    
    NSLog(@"yijing销毁了");
}
@end
