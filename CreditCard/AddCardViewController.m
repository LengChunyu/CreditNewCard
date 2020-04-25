//
//  AddCardViewController.m
//  CreditCard
//
//  Created by liujingtao on 2019/1/27.
//  Copyright © 2019年 liujingtao. All rights reserved.
//

#import "AddCardViewController.h"
#import <objc/runtime.h>
#import "NoPasteTextField.h"
#import "FacePickerView.h"
@interface AddCardViewController ()<UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
@property (nonatomic,assign) int selectIndex;
@property (nonatomic,assign) CGFloat textFieldHeight;
@property (nonatomic,strong)UIScrollView *myScrollView;
@property (nonatomic,assign) CGPoint offsetPoint;
@property (nonatomic,strong) NSArray *nameArray;

@property (nonatomic,strong) UIView *firstView;
@property (nonatomic,strong) UIView *secondView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *secondLastLineView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) NoPasteTextField *dayTextField;
@property (nonatomic,strong) UIView *lastBottomLine;
@property (nonatomic,strong) UILabel *explainLabel;
@property (nonatomic,strong) FacePickerView *firstPickerView;
@property (nonatomic,strong) FacePickerView *secondPickerView;
@property (nonatomic,strong) NSArray *dataSourceArray;
@end

@implementation AddCardViewController
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
    self.view.backgroundColor =[UIColor whiteColor];
    self.dataSourceArray =[[CardDataFMDB shareSqlite]queryRecordsFromCardInfoCardNumber];
    [self newCreatSubViews];
}
-(void)newCreatSubViews{
    
    self.myScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,iphoneX||iphoneXR||iphoneXSM?88:64,self.view.bounds.size.width,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88+34:64))];
    self.myScrollView.delegate =self;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.contentSize =CGSizeMake(self.view.bounds.size.width,SCREEN_HEIGHT-(iphoneX||iphoneXR||iphoneXSM?88+34:64)+1);
    self.myScrollView.backgroundColor =[UIColor colorWithRed:0.96 green:0.96 blue:0.98 alpha:1.00];
    [self.view addSubview:self.myScrollView];
    
    UITapGestureRecognizer *oneTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap:)];
    oneTap.numberOfTapsRequired =1;
    oneTap.numberOfTouchesRequired =1;
    [self.myScrollView addGestureRecognizer:oneTap];
    
    self.firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 30*HEIGHTRATIO, self.view.width, 0)];
    self.firstView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:self.firstView];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    [self.firstView addSubview:lineView];
    //判断卡号和银行卡名称是否都存在
    NSArray *firstNameArray = @[@"银行名称",@"银行卡号",@"账单日期"];
    NSArray *ploaceArray = @[@"请输入银行名称",@"请准确的输入银行卡号",@"请输入账单日"];
    NSArray *editArray;
    if (self.isEdit) {
        editArray = @[self.cardInfoModel.bankStyle,self.cardInfoModel.bankNumber,self.cardInfoModel.billDate];
    }
    for (int i=0;i<firstNameArray.count; i++) {
        
        NSString *nameS = firstNameArray[i];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*WIDTHRATIO, lineView.bottom+i*40.5,0,40)];
        nameLabel.text = nameS;
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.firstView addSubview:nameLabel];
        [nameLabel sizeToFit];
        nameLabel.frame = CGRectMake(30*WIDTHRATIO,lineView.bottom+i*40.5, nameLabel.width,40);
        
        NoPasteTextField *textField = [[NoPasteTextField alloc]initWithFrame:CGRectMake(nameLabel.right+30*WIDTHRATIO, nameLabel.top, self.view.width-nameLabel.right-30*WIDTHRATIO, 40)];
        textField.tag = 200+i;
        textField.font = [UIFont systemFontOfSize:15];
        Ivar ivar1 = class_getInstanceVariable([UITextField class], "_placeholderLabel");
        UILabel *placeholderLabel = object_getIvar(textField, ivar1);
        placeholderLabel.font = [UIFont systemFontOfSize:15];
        
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
        if (i==0) {
            
            textField.keyboardType =UIKeyboardTypeDefault;
            textField.rightView = [self textFieldRightViewTag:i];
        }else{
            
            if (i==2) {
                
                textField.inputView = [self selectDateView:0];
            }else{
                
                textField.rightView = [self textFieldRightViewTag:i];
                textField.keyboardType = UIKeyboardTypeDecimalPad;
            }
        }
        textField.placeholder = ploaceArray[i];
        textField.delegate = self;
        [self.firstView addSubview:textField];
        if (self.isEdit&&(i==1)) {

            textField.textColor = [UIColor colorWithHue:0.67 saturation:0.03 brightness:0.81 alpha:1.00];
        }
        UIView *bottomLine = [[UIView alloc]init];
        bottomLine.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
        [self.firstView addSubview:bottomLine];
        if (i==firstNameArray.count-1) {
            
            bottomLine.frame = CGRectMake(0, textField.bottom, self.view.width, 0.5);
            self.firstView.frame = CGRectMake(0,30*HEIGHTRATIO, self.view.width, bottomLine.bottom);
        }else{
            
            bottomLine.frame = CGRectMake(30*WIDTHRATIO, textField.bottom, self.view.width-30*WIDTHRATIO, 0.5);
        }
        if (self.isEdit) {
            textField.text = editArray[i];
        }
    }
    
    self.secondView = [[UIView alloc]initWithFrame:CGRectMake(0, self.firstView.bottom+30*HEIGHTRATIO, self.view.width, 0)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self.myScrollView addSubview:self.secondView];
    
    UIView *secondLineView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.view.width, 0.5)];
    secondLineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    [self.secondView addSubview:secondLineView];
    
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*WIDTHRATIO, secondLineView.bottom,0,40)];
    typeLabel.text = @"选择方式";
    typeLabel.textColor = [UIColor blackColor];
    typeLabel.textAlignment = NSTextAlignmentLeft;
    [self.secondView addSubview:typeLabel];
    [typeLabel sizeToFit];
    typeLabel.frame = CGRectMake(30*WIDTHRATIO,secondLineView.bottom, typeLabel.width,40);
    
    UIImage *markImage = [UIImage imageNamed:@"mine_arrows"];
    UIImageView *markImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-5-markImage.size.width, (40-markImage.size.height)/2, markImage.size.width, markImage.size.height)];
    markImageView.image = markImage;
    [self.secondView addSubview:markImageView];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeLabel.right+30*WIDTHRATIO,typeLabel.top, self.view.width-typeLabel.right-30*WIDTHRATIO-10-markImage.size.width, 40)];
    self.contentLabel.textColor = [UIColor colorWithHue:0.67 saturation:0.03 brightness:0.81 alpha:1.00];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.text = @"还款日期/间隔天数";
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self.secondView addSubview:self.contentLabel];
    
    UIButton *typeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, typeLabel.top, self.view.width, 40)];
    [typeButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.secondView addSubview:typeButton];
    
    self.secondLastLineView = [[UIView alloc]initWithFrame:CGRectMake(0,typeButton.bottom,self.view.width, 0.5)];
    self.secondLastLineView.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    [self.secondView addSubview:self.secondLastLineView];
    self.secondView.frame = CGRectMake(0,self.secondView.top, self.secondView.width, self.secondLastLineView.bottom);
    
    self.explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(30*WIDTHRATIO, self.secondView.bottom+8, self.view.width-30*WIDTHRATIO, 0)];
    self.explainLabel.textColor = [UIColor colorWithHue:0.67 saturation:0.03 brightness:0.81 alpha:1.00];
    self.explainLabel.font = [UIFont systemFontOfSize:12];
    self.explainLabel.numberOfLines = 0;
    self.explainLabel.textAlignment = NSTextAlignmentLeft;
    self.explainLabel.text = @"注：通常还款日确定有两种方式：一、固定的还款日期。二、账单日后固定几天后为还款日(一般19或者20天)。两种方式根据个人情况任选一种即可。";
    [self.myScrollView addSubview:self.explainLabel];
    [self.explainLabel sizeToFit];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30*WIDTHRATIO, self.secondLastLineView.bottom,0,40)];
    self.titleLabel.text = @"间隔天数";
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.secondView addSubview:self.titleLabel];
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(30*WIDTHRATIO,self.titleLabel.top, self.titleLabel.width,40);
    
    self.dayTextField = [[NoPasteTextField alloc]initWithFrame:CGRectMake(self.titleLabel.right+30*WIDTHRATIO, self.titleLabel.top, self.view.width-self.titleLabel.right-30*WIDTHRATIO, 40)];
    self.dayTextField.tag = 203;
    self.dayTextField.delegate = self;
    self.dayTextField.font = [UIFont systemFontOfSize:15];
    self.dayTextField.inputView = [self selectDateView:1];
    Ivar ivar1 = class_getInstanceVariable([UITextField class], "_placeholderLabel");
    UILabel *placeholderLabel = object_getIvar(self.dayTextField, ivar1);
    placeholderLabel.font = [UIFont systemFontOfSize:15];
    self.dayTextField.keyboardType = UIKeyboardTypeDecimalPad;
    self.dayTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    [self.secondView addSubview:self.dayTextField];
     
    self.lastBottomLine = [[UIView alloc]init];
    self.lastBottomLine.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    [self.secondView addSubview:self.lastBottomLine];
    
    UIButton *addButton =[[UIButton alloc]initWithFrame:CGRectMake(30*WIDTHRATIO,self.secondView.bottom+40+self.explainLabel.height+(self.myScrollView.height-self.secondView.bottom-40-self.explainLabel.height)/2-25, self.view.width-60*WIDTHRATIO, 50)];
    [addButton addTarget:self action:@selector(rightItemButton:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.layer.cornerRadius = 5;
    addButton.clipsToBounds = YES;
    addButton.backgroundColor = [UIColor colorWithHue:0.59 saturation:0.73 brightness:0.98 alpha:1.00];
    [self.myScrollView addSubview:addButton];
    if (self.isEdit) {
        
        if ([self.cardInfoModel.dueDate intValue]==0) {

            [self changeDueDateType:1];
            self.dayTextField.text = self.cardInfoModel.dueDateDay;
        }else{
            
            [self changeDueDateType:0];
            self.dayTextField.text = self.cardInfoModel.dueDate;
        }
    }else{
     
        self.titleLabel.hidden = YES;
        self.dayTextField.hidden = YES;
        self.lastBottomLine.hidden = YES;
    }
       
}
//textField右侧的删除视图
-(UIView *)textFieldRightViewTag:(int)index{
    
    UIButton *clearButton = [[UIButton alloc]initWithFrame:CGRectMake(0,5, 30, 30)];
    clearButton.tag = 100+index;
    [clearButton addTarget:self action:@selector(clearButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [clearButton setImage:[UIImage imageNamed:@"com_qingkong_normal"] forState:UIControlStateNormal];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 35, 40)];
    [rightView addSubview:clearButton];
    return rightView;
}
-(UIView *)selectDateView:(int)tag{
    
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
    FacePickerView *facePickerView =[[FacePickerView alloc]initWithFrame:CGRectMake(0,0,self.view.width,keyBoardHeight) withArray:commonArray withSelectIndex:4];
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
    if (tag==0) {
        
        self.firstPickerView = facePickerView;
    }else{
        
        self.secondPickerView = facePickerView;
    }
    return facePickerView;
}
-(void)sureButtonClick:(UIButton *)button{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (button.tag == 400) {
        UITextField *firstTextField = [self.firstView viewWithTag:200+2];
        firstTextField.text = [NSString stringWithFormat:@"%d",self.firstPickerView.pickerIndex+1];
    }else if (button.tag == 401){
        self.dayTextField.text = [NSString stringWithFormat:@"%d",self.secondPickerView.pickerIndex+1];
    }
}
-(void)clearButtonClick:(UIButton *)button{
    
    if (button.tag==103) {
        
        UITextField *textField = (UITextField *)[self.secondView viewWithTag:200+button.tag-100];
        textField.text = @"";
    }else{
        
        UITextField *textField = (UITextField *)[self.firstView viewWithTag:200+button.tag-100];
        textField.text = @"";
    }
    
}
-(void)typeButtonClick:(UIButton *)button{
    
    UIAlertController *sheetController = [UIAlertController alertControllerWithTitle:@"方式" message:@"还款日的填写方式" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"还款日期" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeDueDateType:0];
    }];
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"间隔天数" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self changeDueDateType:1];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sheetController addAction:firstAction];
    [sheetController addAction:secondAction];
    [sheetController addAction:cancelAction];
    [self presentViewController:sheetController animated:YES completion:nil];
}
-(void)changeDueDateType:(int)type{
    
    if (type==0) {
        
        self.titleLabel.hidden = NO;
        self.dayTextField.hidden = NO;
        self.lastBottomLine.hidden = NO;
        self.secondLastLineView.frame = CGRectMake(30*WIDTHRATIO,self.secondLastLineView.top, self.view.width-30*WIDTHRATIO, self.secondLastLineView.height);
        self.titleLabel.text = @"还款日期";
        self.dayTextField.placeholder = @"请填写还款日期";
        self.dayTextField.text = @"";
        self.lastBottomLine.frame = CGRectMake(0, self.dayTextField.bottom,self.view.width, 0.5);
        self.secondView.frame = CGRectMake(0, self.secondView.top, self.view.width, self.lastBottomLine.bottom);
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.text = @"还款日期";
        self.secondPickerView.pickerViewType = 0;
        CGRect explainRect = self.explainLabel.frame;
        explainRect.origin = CGPointMake(30*WIDTHRATIO, self.secondView.bottom+8);
        self.explainLabel.frame = explainRect;
    }else{
        
        self.titleLabel.hidden = NO;
        self.dayTextField.hidden = NO;
        self.lastBottomLine.hidden = NO;
        self.secondLastLineView.frame = CGRectMake(30*WIDTHRATIO,self.secondLastLineView.top, self.view.width-30*WIDTHRATIO, self.secondLastLineView.height);
        self.titleLabel.text = @"间隔天数";
        self.dayTextField.placeholder = @"请填写间隔天数";
        self.dayTextField.text = @"";
        self.lastBottomLine.frame = CGRectMake(0, self.dayTextField.bottom,self.view.width, 0.5);
        self.secondView.frame = CGRectMake(0, self.secondView.top, self.view.width, self.lastBottomLine.bottom);
        self.contentLabel.textColor = [UIColor blackColor];
        self.contentLabel.text = @"间隔天数";
        self.secondPickerView.pickerViewType = 1;
        CGRect explainRect = self.explainLabel.frame;
        explainRect.origin = CGPointMake(30*WIDTHRATIO, self.secondView.bottom+8);
        self.explainLabel.frame = explainRect;
    }
}
- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = [UIColor grayColor];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextTextField)];
    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(prevTextField)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[prevButton, space,nextButton];
    return toolbar;
}
-(void)nextTextField{
    
    for (int i=0;i<self.nameArray.count; i++) {
        
        UITextField *textField =[self.myScrollView viewWithTag:100+i];
        if (textField.isFirstResponder) {
            
            UITextField *textFieldNext =[self.myScrollView viewWithTag:100+i+1];
            if (textFieldNext) {
                if (!textFieldNext.enabled) {
                    for (int j=i+2;j<self.nameArray.count; j++) {
                        UITextField *textFieldNNext =[self.myScrollView viewWithTag:100+j];
                        if (textFieldNNext.enabled) {
                            
                            [textFieldNNext becomeFirstResponder];
                            return;
                        }
                    }
                }
                [textFieldNext becomeFirstResponder];
            }
            return;
        }
    }
    
}
-(void)prevTextField{
    
    for (int i=0;i<self.nameArray.count; i++) {
        
        UITextField *textField =[self.myScrollView viewWithTag:100+i];
        if (textField.isFirstResponder) {
            
            UITextField *textFieldNext =[self.myScrollView viewWithTag:100+i-1];
            if (textFieldNext) {
    
                if (!textFieldNext.enabled) {
                    for (int j=i-2;j>=0; j--) {
                        UITextField *textFieldNNext =[self.myScrollView viewWithTag:100+j];
                        if (textFieldNNext.enabled) {
                            
                            [textFieldNNext becomeFirstResponder];
                            return;
                        }
                    }
                }
                [textFieldNext becomeFirstResponder];
            }
            return;
        }
    }
}
-(void)rightItemButton:(UIButton *)button{

    UITextField *cardNameF =[self.firstView viewWithTag:200];
    UITextField *bankNumberF =[self.firstView viewWithTag:201];
    UITextField *billDateF =[self.firstView viewWithTag:202];
    if (cardNameF.text.length<=0) {
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"信用卡名称不能为空"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        return;
    }
    if (bankNumberF.text.length<=0||[bankNumberF.text stringByReplacingOccurrencesOfString:@" " withString:@""].length<=0) {
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"卡号不能为空"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        bankNumberF.text = @"";
        return;
    }
    if ([bankNumberF.text containsString:@"."]) {
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"卡号中不能有逗号"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        return;
    }
    if (!self.isEdit) {
        //判断当前是否已经有这个账号了
        for (CardInfoModel *model in self.dataSourceArray) {
            if ([model.bankNumber isEqualToString:bankNumberF.text]) {
                
                UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"此卡号已存在，请勿重复添加"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
                [alertView show];
                return;
            }
        }
    }
    if (billDateF.text.length<=0) {
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"账单日不能为空"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        return;
    }
    if ([billDateF.text containsString:@"."]) {
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"账单日中不能带小数点"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        return;
    }
    if ([billDateF.text intValue]>31) {
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"账单日不能大于31"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        return;
    }
    if ([self.contentLabel.text isEqualToString:@"还款日期/间隔天数"]) {
        
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"选择方式需要选一下"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alertView show];
        return;
    }
    if ([self.contentLabel.text isEqualToString:@"还款日期"]) {
        
        if (self.dayTextField.text.length<=0) {
            
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"还款日不能为空"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
            return;
        }
        if ([self.dayTextField.text containsString:@"."]) {
            
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"还款日中不能带小数点"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
            return;
        }
        if ([self.dayTextField.text intValue]>31) {
            
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"还款日不能大于31"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
            return;
        }
        
    }
    
    if ([self.contentLabel.text isEqualToString:@"间隔天数"]) {
        
        if (self.dayTextField.text.length<=0) {
            
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"间隔天数不能为空"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
            return;
        }
        if ([self.dayTextField.text containsString:@"."]) {
            
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"还款日期中不能带小数点"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
            return;
        }
        if ([self.dayTextField.text intValue]>31) {
            
            UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"间隔天数不能大于31"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
            [alertView show];
            return;
        }
    }
    if (self.isEdit) {
        
        NSDictionary *cardInfoDic =@{@"bankStyle":cardNameF.text,@"bankNumber":bankNumberF.text,@"billDate":billDateF.text,@"dueDate":[self.contentLabel.text isEqualToString:@"还款日期"]?self.dayTextField.text:@"0",@"dueDateDay":[self.contentLabel.text isEqualToString:@"还款日期"]?@"0":self.dayTextField.text,@"isOpenDueNotice":@"0",@"isOpenBillNotice":@"0",@"dueNoticeDate":@"0",@"billNoticeDate":@"0"};
        [[CardDataFMDB shareSqlite]updateCardInfo:cardInfoDic];
    }else{
       
        NSDictionary *cardInfoDic =@{@"bankStyle":cardNameF.text,@"bankNumber":bankNumberF.text,@"billDate":billDateF.text,@"dueDate":[self.contentLabel.text isEqualToString:@"还款日期"]?self.dayTextField.text:@"0",@"dueDateDay":[self.contentLabel.text isEqualToString:@"还款日期"]?@"0":self.dayTextField.text,@"isOpenDueNotice":@"0",@"isOpenBillNotice":@"0",@"dueNoticeDate":@"0",@"billNoticeDate":@"0"};
        [[CardDataFMDB shareSqlite]addRecordToCardInfoTable:cardInfoDic];
    }
    if (self.RefreshTableViewBlock) {

        self.RefreshTableViewBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)oneTap:(UITapGestureRecognizer *)oneTap{
    
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.selectIndex =(int)textField.tag-100;
    if (textField.tag==202) {
        //账单日
        [self.firstPickerView setSelectIndex:textField.text.length<=0?0:[textField.text intValue]-1];
    }else if (textField == self.dayTextField){
        if ([self.contentLabel.text isEqualToString:@"还款日期"]) {
            
            [self.secondPickerView setSelectIndex:textField.text.length<=0?0:[textField.text intValue]-1];
        }else{
            [self.secondPickerView setSelectIndex:textField.text.length<=0?19:[textField.text intValue]-1];
        }
    }else if (textField.tag==201){
        if (self.isEdit) {
            
            return NO;
        }
    }
    return YES;
}
-(void)dealloc{
    
    NSLog(@"dealloc");
}
@end
