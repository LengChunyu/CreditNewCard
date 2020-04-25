//
//  AddAccoutBookViewController.m
//  CreditCard
//
//  Created by liujingtao on 2019/6/4.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import "AddAccoutBookViewController.h"
#import "JVCCreatImage.h"
#import "GestureViewController.h"
#import "AccountBookModel.h"
@interface AddAccoutBookViewController ()<UIScrollViewDelegate,PasswordSetBack>
@property (nonatomic,strong) UITextField *nameTextField;
@property (nonatomic,strong) UIScrollView *myScrollView;
@property (nonatomic,strong) UISwitch *consumeSwitch;
@property (nonatomic,strong) UISwitch *incomeSwitch;

@property (nonatomic,strong) UISwitch *secretSwitch;
@property (nonatomic,strong) UILabel *modifyTLabel;
@property (nonatomic,strong) UIImageView *modifyImageView;
@property (nonatomic,strong) UILabel *showTLabel;
@property (nonatomic,strong) UISwitch *showSwitch;
@property (nonatomic,copy) NSString *passWorldString;
@property (nonatomic,assign) BOOL showSwitchStatus;

@end

@implementation AddAccoutBookViewController
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
            
            
            NSLog(@"scrollEnabled=====No");
            self.myScrollView.scrollEnabled =NO;
        };
        bbNavigation.panEndFailedBlock = ^{
            NSLog(@"scrollEnabled=====Yes");
            self.myScrollView.scrollEnabled =YES;
        };
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"";
    self.view.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    [self creatScrollView];
    [self creatSubViews];
}
-(void)creatScrollView{
    
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0,iphoneX||iphoneXR||iphoneXSM?84:64,self.view.width,0)];
    headView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:headView];
    
    self.myScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0,headView.bottom, self.view.width,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88+34:64))];
    self.myScrollView.delegate =self;
    self.myScrollView.backgroundColor =[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00];
    self.myScrollView.contentSize =CGSizeMake(self.view.width, SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88+34-1:64-1));
    [self.view addSubview:self.myScrollView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=11.0) {
        
        self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    UITapGestureRecognizer *oneHiddenTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenKeyBord:)];
    oneHiddenTap.numberOfTapsRequired =1;
    oneHiddenTap.numberOfTouchesRequired =1;
    [self.myScrollView addGestureRecognizer:oneHiddenTap];
}
-(void)hiddenKeyBord:(UITapGestureRecognizer *)oneTap{

    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}
-(void)creatSubViews{

    NSArray *accountArray =[[CardDataFMDB shareSqlite]queryAccountBookList:@""];
    
    UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(0,30*HEIGHTRATIO-0.5, self.view.width, 0.5)];
    line1.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line1];
    
    UIView *backView1 =[[UIView alloc]initWithFrame:CGRectMake(0,30*HEIGHTRATIO,self.view.width,100*HEIGHTRATIO)];
    backView1.backgroundColor =[UIColor whiteColor];
    [self.myScrollView addSubview:backView1];
    
    self.nameTextField =[[UITextField alloc]initWithFrame:CGRectMake(30*WIDTHRATIO,30*HEIGHTRATIO,self.view.width-30*WIDTHRATIO,100*HEIGHTRATIO)];
    self.nameTextField.placeholder =@"账本名称";
    self.nameTextField.text =[NSString stringWithFormat:@"账本-%d",(int)accountArray.count+1];
    self.nameTextField.font =[UIFont systemFontOfSize:15];
    [self.myScrollView addSubview:self.nameTextField];
    
    UIImageView *line2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,130*HEIGHTRATIO, self.view.width, 0.5)];
    line2.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line2];
    
    
    UIView *backView2 =[[UIView alloc]initWithFrame:CGRectMake(0,line2.bottom+30*HEIGHTRATIO,self.view.width,100*HEIGHTRATIO*2+1)];
    backView2.backgroundColor =[UIColor whiteColor];
    [self.myScrollView addSubview:backView2];
    
    UIImageView *line3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,line2.bottom+30*HEIGHTRATIO, self.view.width, 0.5)];
    line3.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line3];
    
    UILabel *consumeTLabel =[[UILabel alloc]initWithFrame:CGRectMake(30*WIDTHRATIO,line3.bottom,self.view.width,100*HEIGHTRATIO)];
    consumeTLabel.text =@"支出按钮是否显示";
    consumeTLabel.font =[UIFont systemFontOfSize:15];
    consumeTLabel.textColor =[UIColor blackColor];
    [self.myScrollView addSubview:consumeTLabel];
    
    self.consumeSwitch =[[UISwitch alloc]initWithFrame:CGRectZero];
    [self.consumeSwitch addTarget:self action:@selector(consumeSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self.myScrollView addSubview:self.consumeSwitch];
    [self.consumeSwitch setOn:YES];
    self.consumeSwitch.frame =CGRectMake(self.view.width-self.consumeSwitch.width-30*WIDTHRATIO,line3.bottom+(100*HEIGHTRATIO-self.consumeSwitch.height)/2,self.consumeSwitch.width,self.consumeSwitch.height);
    
    UIImageView *line4 = [[UIImageView alloc] initWithFrame:CGRectMake(30*WIDTHRATIO,consumeTLabel.bottom, self.view.width, 0.5)];
    line4.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line4];
    
    UILabel *incomeTLabel =[[UILabel alloc]initWithFrame:CGRectMake(30*WIDTHRATIO,line4.bottom,self.view.width,100*HEIGHTRATIO)];
    incomeTLabel.text =@"收入按钮是否显示";
    incomeTLabel.font =[UIFont systemFontOfSize:15];
    incomeTLabel.textColor =[UIColor blackColor];
    [self.myScrollView addSubview:incomeTLabel];
    
    self.incomeSwitch =[[UISwitch alloc]initWithFrame:CGRectZero];
    [self.incomeSwitch addTarget:self action:@selector(incomeSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self.myScrollView addSubview:self.incomeSwitch];
    [self.incomeSwitch setOn:YES];
    self.incomeSwitch.frame =CGRectMake(self.view.width-self.incomeSwitch.width-30*WIDTHRATIO,line4.bottom+(100*HEIGHTRATIO-self.incomeSwitch.height)/2,self.incomeSwitch.width,self.incomeSwitch.height);
    
    UIImageView *line5 = [[UIImageView alloc] initWithFrame:CGRectMake(0,incomeTLabel.bottom, self.view.width, 0.5)];
    line5.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line5];
    
    UIImageView *line6 = [[UIImageView alloc] initWithFrame:CGRectMake(0,line5.bottom+30*HEIGHTRATIO, self.view.width, 0.5)];
    line6.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line6];
    
    UIView *backView3 =[[UIView alloc]initWithFrame:CGRectMake(0,line6.bottom,self.view.width,100*HEIGHTRATIO*3+1.5)];
    backView3.backgroundColor =[UIColor whiteColor];
    [self.myScrollView addSubview:backView3];
    
    UILabel *secretTLabel =[[UILabel alloc]initWithFrame:CGRectMake(30*WIDTHRATIO,line6.bottom,self.view.width,100*HEIGHTRATIO)];
    secretTLabel.text =@"是否打开私密账本";
    secretTLabel.font =[UIFont systemFontOfSize:15];
    secretTLabel.textColor =[UIColor blackColor];
    [self.myScrollView addSubview:secretTLabel];
    
    self.secretSwitch =[[UISwitch alloc]initWithFrame:CGRectZero];
    [self.secretSwitch addTarget:self action:@selector(secretSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self.myScrollView addSubview:self.secretSwitch];
    self.secretSwitch.frame =CGRectMake(self.view.width-self.secretSwitch.width-30*WIDTHRATIO,line6.bottom+(100*HEIGHTRATIO-self.secretSwitch.height)/2,self.secretSwitch.width,self.secretSwitch.height);
    
    UIImageView *line7 = [[UIImageView alloc] initWithFrame:CGRectMake(30*WIDTHRATIO,secretTLabel.bottom, self.view.width, 0.5)];
    line7.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line7];
    
    self.modifyTLabel =[[UILabel alloc]initWithFrame:CGRectMake(30*WIDTHRATIO,line7.bottom,self.view.width,100*HEIGHTRATIO)];
    self.modifyTLabel.text =@"修改手势密码";
    self.modifyTLabel.font =[UIFont systemFontOfSize:15];
    self.modifyTLabel.textColor =[UIColor blackColor];
    [self.myScrollView addSubview:self.modifyTLabel];

    UIImage *image =[UIImage imageNamed:@"icon-right-n"];
    self.modifyImageView =[[UIImageView alloc]initWithFrame:CGRectMake(self.view.width-30*WIDTHRATIO-image.size.width,line7.bottom+ (100*HEIGHTRATIO-image.size.width)/2,image.size.width,image.size.width)];
    self.modifyImageView.image =image;
    [self.myScrollView addSubview:self.modifyImageView];
    
    UIButton *topButton =[[UIButton alloc]initWithFrame:CGRectMake(0,line7.bottom,self.view.width,100*HEIGHTRATIO)];
    [topButton addTarget:self action:@selector(modifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:topButton];
    
    UIImageView *line8 = [[UIImageView alloc] initWithFrame:CGRectMake(30*WIDTHRATIO,self.modifyTLabel.bottom,self.view.width, 0.5)];
    line8.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line8];
    
    self.showTLabel =[[UILabel alloc]initWithFrame:CGRectMake(30*WIDTHRATIO,line8.bottom,self.view.width,100*HEIGHTRATIO)];
    self.showTLabel.text =@"是否在大账本中显示";
    self.showTLabel.font =[UIFont systemFontOfSize:15];
    self.showTLabel.textColor =[UIColor blackColor];
    [self.myScrollView addSubview:self.showTLabel];
    
    self.showSwitch =[[UISwitch alloc]initWithFrame:CGRectZero];
    [self.showSwitch addTarget:self action:@selector(showSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self.myScrollView addSubview:self.showSwitch];
    self.showSwitch.frame =CGRectMake(self.view.width-self.showSwitch.width-30*WIDTHRATIO,line8.bottom+(100*HEIGHTRATIO-self.showSwitch.height)/2,self.showSwitch.width,self.showSwitch.height);
    
    UIImageView *line9 = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.showTLabel.bottom,self.view.width, 0.5)];
    line9.image = [JVCCreatImage creatImageFromColors:@[UIColorFromRGB(0xe3e3e7),UIColorFromRGB(0xe3e3e7)] ByGradientType:leftToRight withFrame:CGRectMake(0,0, self.view.width, 0.5)];
    [self.myScrollView addSubview:line9];
    
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake((self.myScrollView.width-200)/2,line9.bottom+30*HEIGHTRATIO,200,40)];
    saveButton.backgroundColor =[UIColor whiteColor];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAccountDetail:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    saveButton.layer.cornerRadius =3.0;
    saveButton.clipsToBounds =YES;
    [self.myScrollView addSubview:saveButton];
    [self changeListStatus];
    [self.showSwitch setOn:YES];
}
-(void)consumeSwitchChange:(UISwitch *)consumeSwitch{

}
-(void)incomeSwitchChange:(UISwitch *)incomeSwitch{

}
-(void)secretSwitchChange:(UISwitch *)secretSwitch{
    
    if (secretSwitch.isOn) {
        //弹出设置相应的手势密码。
        GestureViewController *gestureVC =[[GestureViewController alloc] init];
        gestureVC.passWordDelegate =self;
        gestureVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:gestureVC animated:YES completion:nil];
    }else{
        //判断确定是否要关闭手势密码，如果选择确认，直接弹出手势密码输入密码完成操作。
        GestureViewController *gestureVC =[[GestureViewController alloc] init];
        gestureVC.passWordDelegate =self;
        gestureVC.oldPassword =self.passWorldString;
        gestureVC.isChangePassWord =NO;
        gestureVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:gestureVC animated:YES completion:nil];
    }
}
-(void)showSwitchChange:(UISwitch *)showSwitch{

    if (self.secretSwitch.selected) {
        //点击也没有效果
        [self.secretSwitch setOn:YES];
    }else{
        showSwitch.selected =!showSwitch.selected;
    }
}
-(void)modifyButtonClick:(UIButton *)button{

    if (self.secretSwitch.isOn) {
        
        GestureViewController *gestureVC =[[GestureViewController alloc] init];
        gestureVC.passWordDelegate =self;
        gestureVC.oldPassword =self.passWorldString;
        gestureVC.isChangePassWord =YES;
        gestureVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        [self presentViewController:gestureVC animated:YES completion:nil];
    }else{
        //点击也没有效果
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if ([self.nameTextField isFirstResponder]) {
        
        [self.nameTextField resignFirstResponder];
    }
}
#pragma mark-password修改后的代理返回
-(void)comeBackPasswordType:(int)passWordType withPassWord:(NSString *)passWordString{
    
    if (passWordType==1) {
    
        //两边输入密码后，成功返回。手势密码开启成功
        self.passWorldString =passWordString;
        [self changeListStatus];
        self.showSwitchStatus =self.showSwitch.isOn;
    }else if(passWordType==2){
        //修改密码成功回调
        self.passWorldString =passWordString;
    }else if(passWordType==0){
        //验证密码成功后回调 关闭手势密码
        [self.secretSwitch setOn:self.secretSwitch.isOn];
        [self changeListStatus];
    }else if (passWordType==3){
        //什么都没做返回了
        [self.secretSwitch setOn:!self.secretSwitch.isOn];
    }else if (passWordType==4){
        NSLog(@"修改密码中途退出什么都没有做");
    }
    
}
//改变修改手势密码和是否显示在大账本中的状态
-(void)changeListStatus{
    
    if (self.secretSwitch.isOn) {
        
        self.modifyTLabel.textColor =[UIColor blackColor];
        self.showTLabel.textColor =[UIColor grayColor];
        [self.showSwitch setOn:NO];
        self.showSwitch.enabled =NO;
        
    }else{
        
        self.modifyTLabel.textColor =[UIColor grayColor];
        self.showTLabel.textColor =[UIColor blackColor];
        self.showSwitch.enabled =YES;
        [self.showSwitch setOn:self.showSwitchStatus];
    }
}
-(void)saveAccountDetail:(UIButton *)button{

    if ([self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""] <=0) {
        //账本名称不能为空
        self.nameTextField.text =@"";
        [[JVCAlertHelper shareAlertHelper]alertToastMainThreadOnWindow:@"账本名称不能为空"];
        return;
    }
    for (AccountBookModel *model in self.allAccountBookArray) {
        if ([model.accountBookName isEqualToString:self.nameTextField.text]) {
            
            [[JVCAlertHelper shareAlertHelper]alertToastMainThreadOnWindow:@"账本名称已经存在，请重新编辑"];
            return;
        }
    }
    if (!self.consumeSwitch.isOn&&!self.incomeSwitch.isOn) {

        [[JVCAlertHelper shareAlertHelper]alertToastMainThreadOnWindow:@"支出和收入至少有一个按钮显示出来"];
        return;
    }
    /*
     ,accountBookName TEXT,secretString TEXT,isConsume TEXT,isRepay TEXT,isSecret TEXT,isShowSwitch TEXT,time TEXT
     */
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDictionary *paramDic =@{@"accountBookName":self.nameTextField.text,@"secretString":self.passWorldString.length>0?self.passWorldString:@"",@"isConsume":self.consumeSwitch.isOn?@"1":@"0",@"isRepay":self.incomeSwitch.isOn?@"1":@"0",@"isSecret":self.secretSwitch.isOn?@"1":@"0",@"isShowSwitch":self.showSwitch.isOn?@"1":@"0",@"time":[dateFormatter stringFromDate:[NSDate date]]};
    [[CardDataFMDB shareSqlite]addRecordToAccountBook:paramDic];
    if (self.callBackDelegate && [self.callBackDelegate respondsToSelector:@selector(addAccountBookFinishBack)]) {
        
        [self.callBackDelegate addAccountBookFinishBack];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
