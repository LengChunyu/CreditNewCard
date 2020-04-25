//
//  JVAlertView.m
//  JVAlertView
//
//  Created by Joey on 15/12/31.
//  Copyright © 2015年 Joey. All rights reserved.
//

#import "JVAlertView.h"
#import "JVCCreatImage.h"
const static CGFloat titleDefaultHeight = 25.0;
const static CGFloat bottomHeight = 46;
const static CGFloat buttonHeight = 32.0;
const static CGFloat buttonWidth = 100.0;
const static CGFloat itemDefaultHeight = 38.0;
const static CGFloat padding = 10.0f;
const static CGFloat paddingMid = 15.0f;

static const long defaultMsgColor = 0xa6a6a6;
static const long defaultTitleColor = 0x13CEA7;
static const CGFloat defaultMsgSize = 15.0;
static const CGFloat defaultTitleSize = 18.0;
static const  float Demon_textMaxSize = 20.0f;



#define KEYBOARD_HEIGHT 80
#define PREDICTION_BAR_HEIGHT 40

#define headImageWidth  74
#define headImageheight 64

@interface JVAlertView()<UITextFieldDelegate>

@property (nonatomic,strong)UIView *backgroundView;
//标题
@property (nonatomic,strong)UILabel *titleLable;
//头像
@property (nonatomic,strong)UIImageView *titleImgNormal;
@property (nonatomic,strong)UIImageView *titleImgLong;
//内容
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIView *contentBg;
//用户自定义内容
@property (nonatomic,strong)UIView *customView;
//按钮区域
@property (nonatomic,strong)UIView *bottomView;
//Message布局
@property (nonatomic,strong)UILabel *messageLable;
//文本框布局
@property (nonatomic,strong)UITextField *editTextField;
//用户名文本框布局
@property (nonatomic,strong)UITextField *userTextField;
//密码文本框布局
@property (nonatomic,strong)UITextField *pwdTextField;

//取消按钮
@property (nonatomic,strong)JVAlertButton *buttonCancel;
//添加按钮
@property (nonatomic,strong)JVAlertButton *buttonOther;

//
@property (nonatomic,assign)BOOL keyboardIsVisible;

@property (nonatomic,strong)UIWindow *alertWindow;

@property (nonatomic,assign) CGFloat titleImgHeight;
@property (nonatomic,assign) CGFloat contentHeight;
@property (nonatomic,assign) CGFloat contentWidth;
@property (nonatomic,assign) CGFloat customHeight;
@property (nonatomic,assign) CGFloat paddingTop;
@property (nonatomic,assign) CGFloat messageHeight;
@property (nonatomic,assign) CGFloat editHeight;
@property (nonatomic,assign) CGFloat titleHeight;

@property (nonatomic,assign) int headType;
@property (nonatomic,assign)BOOL hasAddObservers;



@end

@implementation JVAlertView
@synthesize titleImgHeight,contentHeight,contentWidth,customHeight,paddingTop,messageHeight,editHeight,titleHeight;
- (id)init{
   self =  [super init];
    self.frame = [UIScreen mainScreen].bounds;
    if (self) {
        
        [self setUpDefault];
        [self addObservers];
        self.userInteractionEnabled = YES;
        self.userEditEnable = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAlertView) name:@"removeAlertView" object:nil];
    }
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeAlertInterFaceOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    return self;
}

/** 组件间的调用 */
- (void)initWithData:(NSDictionary *)dic {
    
    [[self initWithCustomStyle:[dic[@"customStyle"] integerValue] headType:[dic[@"headType"] intValue] Title:[dic[@"title"] isEqualToString:@""]?nil:dic[@"title"] custom:dic[@"custom"] delegate:nil cancelTitle:[dic[@"cancelTitle"] isEqualToString:@""]?nil:dic[@"cancelTitle"] otherTitle:[dic[@"otherTitle"] isEqualToString:@""]?nil:dic[@"otherTitle"]] show:dic[@"viewController"]];
}

- (void)initWithBlock:(ClickedButtonAtIndex)clickedButtonAtIndex {
    
    self.clickedButtonAtIndex = clickedButtonAtIndex;
}

#pragma mark init
/**
 * 普通样式的
 */
- (id)initWithTitle:(NSString *)title headType:(int)headType
                     message:(NSString *)message
                    delegate:(id<JVAlertViewDelegate>)delegate
                 cancelTitle:(NSString *)cancel
                  otherTitle:(NSString *)otherTitle;
{
    return  [self initWithStyle:JVAlertViewStyleDefault headType:headType custom:nil title:title message:message placeHolder:nil userPlaceHolder:nil pwdPlaceHolder:nil delegate:delegate cancelTitle:cancel otherTitle:otherTitle];
}

/**
 *错误提示
 */
- (id)initWithErrorTitle:(NSString *)title headType:(int)headType
                 message:(NSString *)message
                delegate:(id<JVAlertViewDelegate>)delegate
             cancelTitle:(NSString *)cancel
              otherTitle:(NSString *)otherTitle{
     return  [self initWithStyle:JVAlertViewStyleError headType:headType custom:nil title:title message:message placeHolder:nil userPlaceHolder:nil pwdPlaceHolder:nil delegate:delegate cancelTitle:cancel otherTitle:otherTitle];
}

/**
 * 只有一个输入框
 */
- (id)initWithEdit:(NSString *)title headType:(int)headType
            placeHolder:(NSString *)holder
               delegate:(id<JVAlertViewDelegate>)delegate
            cancelTitle:(NSString *)cancel
             otherTitle:(NSString *)otherTitle{
    return  [self initWithStyle:JVAlertViewStyleEdit headType:headType custom:nil title:title message:nil placeHolder:holder userPlaceHolder:nil pwdPlaceHolder:nil delegate:delegate cancelTitle:cancel otherTitle:otherTitle];
}
/**
 *  自定义样式的
 *  hearType:如果是4,则表示"蓝色"+"关闭"
 */
- (id)initWithCustomStyle:(JVAlertViewStyle)style headType:(int)headType
                    Title:(NSString *)title
                   custom:(UIView*)custom
                 delegate:(id<JVAlertViewDelegate>)delegate
              cancelTitle:(NSString *)cancel
               otherTitle:(NSString *)otherTitle{
    return [self initWithStyle:style headType:headType custom:custom title:title message:nil placeHolder:nil userPlaceHolder:nil pwdPlaceHolder:nil delegate:delegate cancelTitle:cancel otherTitle:otherTitle];
}

///**
// *  自定义不存在按钮样式的
// */
//- (id)initWithCustomStyle:(JVAlertViewStyle)style headType:(int)headType
//                    Title:(NSString *)title
//                   custom:(UIView*)custom
//                 delegate:(id<JVAlertViewDelegate>)delegate{
//    return [self initWithStyle:style headType:headType custom:custom title:title message:nil placeHolder:nil userPlaceHolder:nil pwdPlaceHolder:nil delegate:delegate cancelTitle:nil otherTitle:nil];
//}


/**
 * 账号密码格式的
 */
- (id)initWithLoginAndPassword:(NSString *)title headType:(int)headType
                       message:(NSString *)message
                    userPlaceHolder:(NSString *)userholder
                     pwdPlaceHolder:(NSString *)pwdholder
                           delegate:(id<JVAlertViewDelegate>)delegate
                        cancelTitle:(NSString *)cancel
                         otherTitle:(NSString *)otherTitle;
{
    return  [self initWithStyle:JVAlertViewStyleLoginAndPassword headType:headType custom:nil title:title message:message placeHolder:nil userPlaceHolder:userholder pwdPlaceHolder:pwdholder delegate:delegate cancelTitle:cancel otherTitle:otherTitle];
}

- (id)initWithStyle:(JVAlertViewStyle)style headType:(int)headType
                custom:(UIView *)custom
                   title:(NSString *)title
                 message:(NSString *)message
             placeHolder:(NSString *)holder
         userPlaceHolder:(NSString *)userholder
          pwdPlaceHolder:(NSString *)pwdholder
                delegate:(id<JVAlertViewDelegate>)delegate
             cancelTitle:(NSString *)cancel
              otherTitle:(NSString *)otherTitle{
    self =  [self init];
    self.style = style;
    self.delegate = delegate;
    self.title = title;
    self.message = message;
    [self resetDemon:title message:message custom:custom headType:(int)headType];
    [self createAlertView:headType];
    [self setUpView:style message:message custom:custom cancelTitle:cancel otherTitle:otherTitle headType:headType];
    _editTextField.placeholder = holder;
    _userTextField.placeholder = userholder;
    _pwdTextField.placeholder = pwdholder;
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title view:(UIView *)view buttonType:(int)buttonType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        UIImageView *headImageView=[[UIImageView alloc]initWithFrame:CGRectMake((frame.size.width-headImageWidth)/2, 7, headImageWidth, headImageheight)];
        headImageView.image=[UIImage imageNamed:@"Alert_head"];
        [self addSubview:headImageView];
        UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, headImageheight, frame.size.width, frame.size.height-headImageheight)];
        backView.backgroundColor=[UIColor whiteColor];
        backView.layer.cornerRadius=10;
        [self addSubview:backView];
        //标题
        UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, frame.size.width-20, 20)];
        titleLabel.text=title;
        //        titleLabel.textColor= UIColorFromRGB(Color_mainGreen);
        titleLabel.textColor = [UIColor greenColor];
        titleLabel.font = [UIFont systemFontOfSize:Demon_textMaxSize];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        [backView addSubview:titleLabel];
        
        //中间view
        view.frame=CGRectMake(10, titleLabel.bottom+10, frame.size.width-20, backView.height-90);
        [backView addSubview:view];
        if (buttonType==XWAlertButtonType_Know) {
            UIButton *cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            cancleBtn.frame=CGRectMake(10, backView.height-10-30, frame.size.width-20, 30);
            cancleBtn.layer.cornerRadius=5;
            cancleBtn.layer.borderColor=[[UIColor colorWithRed:40.0/255.0 green:192.0/255.0 blue:153.0/255.0 alpha:1] CGColor];
            cancleBtn.layer.borderWidth=1;
            [cancleBtn setTitle:@"确定" forState:UIControlStateNormal];
            [cancleBtn setTitleColor:[UIColor colorWithRed:40.0/255.0 green:192.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
            [cancleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cancleBtn.tag=101;
            [backView addSubview:cancleBtn];
        }else if (buttonType==XWAlertButtonType_sureAndCancle){
            UIButton *cancleBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            cancleBtn.frame=CGRectMake(40,backView.height-30-10, 80, 30);
            cancleBtn.layer.cornerRadius=5;
            cancleBtn.layer.borderColor=[[UIColor colorWithRed:40.0/255.0 green:192.0/255.0 blue:153.0/255.0 alpha:1] CGColor];
            cancleBtn.layer.borderWidth=1;
            [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
            [cancleBtn setTitleColor:[UIColor colorWithRed:40.0/255.0 green:192.0/255.0 blue:153.0/255.0 alpha:1] forState:UIControlStateNormal];
            [cancleBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            cancleBtn.tag=101;
            [backView addSubview:cancleBtn];
            UIButton *sureBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            sureBtn.frame=CGRectMake(frame.size.width-30-80, cancleBtn.origin.y, 80, 30);
            sureBtn.layer.cornerRadius=5;
            sureBtn.backgroundColor=[UIColor colorWithRed:40.0/255.0 green:192.0/255.0 blue:153.0/255.0 alpha:1];
            [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            [sureBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            sureBtn.tag=102;
            [backView addSubview:sureBtn];
        }
        
    }
    self.backgroundColor =[UIColor redColor];
    return self;
}
//底部取消和确定按钮的点击事件
-(void)btnClicked:(UIButton *)button{
    if (button.tag!=101) {
        [self.target performSelector:self.action];
    }
    [self.superview removeFromSuperview];
}



- (void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"liujingtao__layoutSubviews==%s,%@",__func__,self.frame);
//    self.frame = [UIScreen mainScreen].bounds;
//    if (_backgroundView) {
//        _backgroundView.frame = [UIScreen mainScreen].bounds;
//        _contentView.center = CGPointMake(_backgroundView.center.x, _backgroundView.center.y - titleHeight/2);
//    }
}

/**
 * 初始化尺寸
 */
- (void)setUpDefault{
    self.msgColor = UIColorFromRGB(defaultMsgColor);
    self.titleColor = UIColorFromRGB(defaultTitleColor);
    
    _keyboardIsVisible = NO;
    
}

/**
 *创建AlertView
 */
-(void)createAlertView:(int)headType{
    
    self.headType = headType;
//    背景
    _backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    _backgroundView.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    _backgroundView.userInteractionEnabled = YES;

    [self addSubview:_backgroundView];
    
//  内容
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, contentWidth, contentHeight)];
    _contentView.center = CGPointMake(_backgroundView.center.x, _backgroundView.center.y - titleHeight/2);
    _contentView.userInteractionEnabled = YES;
    
    [_backgroundView addSubview:_contentView];
    
//    内容背景框
    _contentBg = [[UIView alloc]initWithFrame:CGRectMake(0,0, contentWidth, contentHeight)];
    _contentBg.layer.backgroundColor = [UIColor whiteColor].CGColor;
    _contentBg.layer.cornerRadius = 5.0f;
    _contentBg.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    _contentBg.layer.shadowOffset = CGSizeMake(1, 1);
    _contentBg.layer.shadowOpacity = 0.8;
    _contentBg.layer.shadowRadius = 15.0f;
    _contentBg.userInteractionEnabled = YES;

    [_contentView addSubview:_contentBg];
    
//   标题头像正常
    UIImage *imgNormal = [UIImage imageNamed:@"title_popup_01"];
    
    if (headType==headTypeNone) {
        
        _titleImgNormal = nil;
        
    }else if(headType==0){
    
        _titleImgNormal = [[UIImageView alloc]initWithImage:imgNormal];
        _titleImgNormal.frame = CGRectMake((contentWidth-imgNormal.size.width)/2, -8, imgNormal.size.width, imgNormal.size.height);
        
        [_contentBg addSubview:_titleImgNormal];
    
    }else if(headType==2||headType==3){
        
        _titleImgLong.hidden = YES;
    }else {
        //   标题头像长
        UIImage *imgLong = [UIImage imageNamed:@"title_popup_02"];
        _titleImgLong = [[UIImageView alloc]initWithImage:imgLong];
        _titleImgLong.frame = CGRectMake((contentWidth-imgLong.size.width)/2, -8, imgLong.size.width, imgLong.size.height);
        [_contentBg addSubview:_titleImgLong];
        //    
    }
// 标题
    _titleLable = [[UILabel alloc]initWithFrame:CGRectMake((contentWidth-imgNormal.size.width)/2, -8, imgNormal.size.width, imgNormal.size.height)];
    _titleLable.textColor = [UIColor whiteColor];
    _titleLable.font = [UIFont systemFontOfSize:defaultMsgSize];
    _titleLable.text = self.title;
    _titleLable.adjustsFontSizeToFitWidth=YES;
    _titleLable.textAlignment = NSTextAlignmentCenter;
    [_contentBg addSubview:_titleLable];

    //  自定义内容区

    if(headType==2||headType==3){
        
        _customView = [[UIView alloc]initWithFrame:CGRectMake(0,0, contentWidth, customHeight)];
    }else{
    
        _customView = [[UIView alloc]initWithFrame:CGRectMake(0,30, contentWidth, customHeight)];
    
    }
    [_contentBg addSubview:_customView];
    
    _messageLable = [[UILabel alloc]initWithFrame:CGRectMake(paddingMid, padding, _customView.width-2*paddingMid, messageHeight)];
    _messageLable.textAlignment = NSTextAlignmentCenter;
    _messageLable.textColor = self.msgColor;
    _messageLable.numberOfLines = 0;
    _messageLable.font = [UIFont systemFontOfSize:defaultMsgSize];
    [_customView addSubview:_messageLable];
//   按钮区域
    if (self.style !=JVAlertViewStyleNobtn) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,  contentHeight-bottomHeight, contentWidth, bottomHeight)];
        _bottomView.userInteractionEnabled = YES;
        [_contentBg addSubview:_bottomView];

    }
    
}

/**
 *设置布局
 */
- (void)setUpView:(JVAlertViewStyle) style
          message:(NSString *)message
           custom:(UIView *)custom
      cancelTitle:(NSString *)cancel
       otherTitle:(NSString *)other headType:(int)headType{
    
    _cancelButtonIndex = -1;
//    设置内容显示
    switch (self.style) {
        case JVAlertViewStyleDefault:
        case JVAlertViewStyleTime:
        case JVAlertViewStyleError:{
            {
                if (message) {
                    _messageLable.text = message;
                }
                [_pwdTextField removeFromSuperview];
                [_userTextField removeFromSuperview];
                [_editTextField removeFromSuperview];
            }
        }
        break;
        case JVAlertViewStyleEdit:
        {
            if (message) {
                _messageLable.text = message;
            }
            [_editTextField becomeFirstResponder];
            [_pwdTextField removeFromSuperview];
            [_userTextField removeFromSuperview];
        }
            break;
        case JVAlertViewStyleLoginAndPassword:{
            if (message) {
                _messageLable.text = message;
            }
            [_editTextField removeFromSuperview];

        }
            break;
        case JVAlertViewStyleNobtn:{
            for (UIView *view in [_customView subviews]) {
                [view  removeFromSuperview];
            }
            if (custom) {
                custom.frame = CGRectMake(0,0, custom.frame.size.width, custom.frame.size.height);
                [_customView addSubview:custom];
            
            }
//            [_bottomView removeFromSuperview];
        }
            break;
        case  JVAlertViewStyleCustom:
            for (UIView *view in [_customView subviews]) {
                [view  removeFromSuperview];
            }
            if (custom) {
                custom.frame = CGRectMake(0,0, custom.frame.size.width, custom.frame.size.height);
                [_customView addSubview:custom];
                //   按钮区域
                _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, contentHeight-bottomHeight, contentWidth, bottomHeight)];
                _bottomView.userInteractionEnabled = YES;
                [_contentBg addSubview:_bottomView];
            }
            break;
        default:
            break;
    }
//   设置按钮区
    if (cancel) {
        
        _buttonCancel = [JVAlertButton buttonWithType:(UIButtonTypeCustom)];
        if (headType==-1&&!other) {
            
            [_buttonCancel setButtonStyle:JVAlertButtonStylePositive];
        }else{
          
            [_buttonCancel setButtonStyle:JVAlertButtonStyleDefault];
        }
        [_buttonCancel setTitle:cancel forState:UIControlStateNormal];
        _buttonCancel.titleLabel.font =[UIFont systemFontOfSize:16];
        [_buttonCancel setFrame:CGRectMake(0, 0, self.contentView.width/2, bottomHeight)];
        [_buttonCancel addTarget:self action:@selector(alertButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        if(headType==3||headType==4||headType==5){//headType==4时,代表只有一个确定按钮,并且是蓝色的长标题
            [_buttonCancel setTitleColor:UIColorFromRGB(0x2c9efe) forState:UIControlStateNormal];
            
        }
        _cancelButtonIndex = 0;
    }
    if (other) {
        _buttonOther = [JVAlertButton buttonWithType:(UIButtonTypeCustom)];
        [_buttonOther setButtonStyle:JVAlertButtonStylePositive];
        [_buttonOther setTitle:other forState:UIControlStateNormal];
        _buttonOther.titleLabel.font =[UIFont systemFontOfSize:16];
       
        [_buttonOther setFrame:CGRectMake(self.contentView.width/2, 0, self.contentView.width/2, bottomHeight)];
        [_buttonOther addTarget:self action:@selector(alertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (other && cancel) {
        [self.bottomView addSubview:_buttonCancel];
        [self.bottomView addSubview:_buttonOther];
    }else if (cancel){
        [_buttonCancel setFrame:CGRectMake(2*paddingMid, 0, _contentView.width - 4*paddingMid, bottomHeight)];
        [self.bottomView addSubview:_buttonCancel];
    }else{
        [_buttonOther setFrame:CGRectMake(2*paddingMid, 0, _contentView.width - 4*paddingMid, bottomHeight)];
        [self.bottomView addSubview:_buttonOther];
    }
    //分割线
    UIImageView *line = [self creatLineWithFrame:CGRectMake(0,0,contentWidth, 0.5) backgroundColor:UIColorFromRGB(0xd8d8de)];
    [_bottomView addSubview:line];
    if(_buttonOther){
        
        UIImageView *lineOther = [self creatLineWithFrame:CGRectMake(contentWidth/2-0.25, 0, 0.5, bottomHeight) backgroundColor:UIColorFromRGB(0xd8d8de)];
         [_bottomView addSubview:lineOther];
    }
}
- (void)resetDemon:(NSString *)title message:(NSString *)message custom:(UIView *)custom headType:(int)headType{
    //   内容宽度
    contentWidth = 280;
    
    //    标题图像高度
    UIImage *imgNormal = [UIImage imageNamed:@"title_popup_01"];
    titleImgHeight = imgNormal.size.height-8;
    UIImage *imgLong = [UIImage imageNamed:@"title_popup_02"];
    _titleImgLong = [[UIImageView alloc]initWithImage:imgLong];
    
    if (self.style == JVAlertViewStyleError) {
        paddingTop = imgLong.size.height - titleImgHeight + 15;
    }
    else
        paddingTop = 0;

//   计算标题高度
    if (title) {
        titleHeight = titleDefaultHeight;
    }
//    计算message高度
    if (message) {
        CGSize sizeMsg = [message sizeWithFont:[UIFont systemFontOfSize:defaultMsgSize] constrainedToSize:CGSizeMake(contentWidth-2*paddingMid, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        messageHeight = sizeMsg.height;
    }
    else{
        messageHeight = 0;
    }
//根据计算结果重新设置显示区的尺寸
    switch (self.style) {
        case JVAlertViewStyleEdit:
            editHeight = itemDefaultHeight;
            break;
        case JVAlertViewStyleLoginAndPassword:
            editHeight = itemDefaultHeight *2;
            break;
        default:
            editHeight = 0;
            break;
    }
    if (messageHeight) {
        customHeight += padding+messageHeight;
    }
    if (editHeight) {
        customHeight += editHeight+padding;
    }
    //   内容高度
    if (custom) {
        customHeight += custom.height;
    }
    
    if(headType==2||headType==3){
    
        titleImgHeight =0;
    }
    
    
    if (self.style !=JVAlertViewStyleNobtn) {
         contentHeight = titleImgHeight + paddingTop + customHeight + bottomHeight;
    }else{
         contentHeight = titleImgHeight + paddingTop + customHeight;
    }
    
   
}

- (void)addObservers
{
    if (!self.hasAddObservers) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide) name:JVAlertViewHideNotification object:nil];
    }
    self.hasAddObservers = YES;
}

- (void)removeObservers
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JVAlertViewHideNotification object:nil];
    self.hasAddObservers = NO;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"removeAlertView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JVAlertViewHideNotification object:nil];
}

#pragma mark show and miss
- (void)show:(UIViewController *)viewController
{
   [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"keyboardShow"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.isOnShowing) {
        return;
    }
  

    [self addObservers];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    //---------------------------------------------------------------------------------------------------------------------------------------------
    UIWindow *window;
    if ([delegate respondsToSelector:@selector(window)])
        window = [delegate performSelector:@selector(window)];
    else window = [[UIApplication sharedApplication] keyWindow];
    self.alertWindow =window;
    self.frame=[UIScreen mainScreen].bounds;
    [self.alertWindow addSubview:self];
    if(CGAffineTransformEqualToTransform(window.transform,CGAffineTransformIdentity)){
        
        _backgroundView.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    }else {
        
        _backgroundView.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0].CGColor;
    }
    UITapGestureRecognizer *oneTapha =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTapxixi:)];
    oneTapha.numberOfTapsRequired =1;
    oneTapha.numberOfTouchesRequired =1;
    [_backgroundView addGestureRecognizer:oneTapha];
//    [self slideInToCenter ];
//    if ([self.delegate respondsToSelector:@selector(show)]) {
//        [self.delegate show];
//    }
    self.isOnShowing = YES;
//    UIInterfaceOrientation kScreenDuration=[[NSUserDefaults standardUserDefaults] integerForKey:@"UIInterfaceOrientation"];
//    if (![NSThread isMainThread]) {
//        gcd_async_main(^{
//            [self changeAlertInterFaceOrientation];
//        });
//    }else{
//        [self changeAlertInterFaceOrientation];
//    }
}
-(void)oneTapxixi:(UITapGestureRecognizer *)oneTap{
    
    
}
-(void)changeAlertInterFaceOrientation{
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window;
    if ([delegate respondsToSelector:@selector(window)]){
        window = [delegate performSelector:@selector(window)];
        if (window==nil) {
            window = [[UIApplication sharedApplication] keyWindow];
        }
    }
    else window = [[UIApplication sharedApplication] keyWindow];
    
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    CGRect frame=[UIScreen mainScreen].bounds;
    if (sataus==UIInterfaceOrientationLandscapeLeft||sataus==UIInterfaceOrientationLandscapeRight) {
        
        if (sataus==UIInterfaceOrientationLandscapeLeft) {

            self.alertWindow.transform = CGAffineTransformRotate(window.transform, -M_PI/2);

        }else{

            self.alertWindow.transform = CGAffineTransformRotate(window.transform, M_PI/2);
        }
        self.alertWindow.frame=CGRectMake(0,0,window.height,window.width);
        self.frame=CGRectMake(0,0, frame.size.width>frame.size.height?frame.size.width:frame.size.height, frame.size.width<frame.size.height?frame.size.width:frame.size.height);
        _backgroundView.frame=CGRectMake(0, 0, window.width, window.height);
        
    }else{
        self.alertWindow.frame=CGRectMake(0, 0, window.width, window.height);
        self.alertWindow.transform = CGAffineTransformRotate(window.transform, 0);
        _backgroundView .frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    _contentView.frame = CGRectMake((_backgroundView.width-contentWidth)/2, (_backgroundView.height-contentHeight)/2, contentWidth, contentHeight);
    
   
    
}
#pragma mark - 获取当前屏幕的控制器
- (void)showMessage:(UIViewController *)viewController;
{
    
    if (self.isOnShowing) {
        return;
    }


    [self addObservers];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    UIWindow *window;
    //---------------------------------------------------------------------------------------------------------------------------------------------
    if ([delegate respondsToSelector:@selector(window)])
        window = [delegate performSelector:@selector(window)];
    else window = [[UIApplication sharedApplication] keyWindow];
    UIView *backView = [[UIView alloc] initWithFrame:viewController.view.window.bounds];
    [viewController.view.window addSubview:backView];
    backView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:self];
    if(CGAffineTransformEqualToTransform(window.transform,CGAffineTransformIdentity)){
        _backgroundView.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    }
    else {
        _backgroundView.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0].CGColor;
    }
    self.isOnShowing = YES;
}

- (void)hide{
    if (!self.isOnShowing) {
        return;
    }
    [self fadeFromCenter ];
    if ([self.delegate respondsToSelector:@selector(dissMiss)]) {
        [self.delegate dissMiss];
    }
    self.isOnShowing = NO;
    [self removeObservers];
}

- (void)fadeFromCenter
{
    if(!self.contentView) return;
    //From Frame
    self.contentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                  CGAffineTransformMakeScale(1.0f, 1.0f));
    self.contentView.alpha = 1.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = 0;
        
        //To Frame
        self.contentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        self.contentView.alpha = 0.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.contentView.center = _backgroundView.center;
            [self removeFromSuperview];
        }];
    }];
}
- (void)slideInToCenter
{
    //From Frame
    self.contentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                  CGAffineTransformMakeScale(0.1f, 0.1f));
    self.contentView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.backgroundView.alpha = 1;
        
        //To Frame
        self.contentView.transform = CGAffineTransformConcat(CGAffineTransformIdentity,
                                                      CGAffineTransformMakeScale(1.0f, 1.0f));
        self.contentView.alpha = 1.0f;
    } completion:^(BOOL completed) {
        [UIView animateWithDuration:0.2f animations:^{
            self.contentView.center = _backgroundView.center;
        }];
    }];
}
#pragma mark property
- (NSString *)userName{
    if (_userTextField) {
        return _userTextField.text;
    }
    return nil;
}
- (NSString *)password{
    if (_pwdTextField) {
        return _pwdTextField.text;
    }
    return nil;
}
- (NSString *)editText{
    if (_editTextField) {
        return _editTextField.text;
    }
    return nil;
}
- (void)setUserName:(NSString *)userName{
    
    if (_userTextField) {
        
        _userTextField.text = userName;
    }
   
}
- (void)setPassword:(NSString *)password{
    if (_pwdTextField) {
        _pwdTextField.text = password;
    }
}

- (void)setEditText:(NSString *)editText{
    if (_editTextField) {
       _editTextField.text = editText;
    }
}

- (void)setUserEditEnable:(BOOL)userEditEnable{
    if (_userTextField) {
        _userTextField.enabled = userEditEnable;
        _userEditEnable = userEditEnable;
    }
}

- (void)setTitle:(NSString *)title{
    _title = title;
    if (_titleLable) {
        _titleLable.text = title;
    }
}

- (void)setMessage:(NSString *)message{
    _message = message;
    if (_messageLable) {
        _messageLable.text = message;
    }
    
}
- (nullable NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == self.cancelButtonIndex) {
        if (self.buttonCancel) {
            return self.buttonCancel.titleLabel.text;
        }
        return nil;
    }
    else {
        if (self.buttonOther) {
            return self.buttonOther.titleLabel.text;
        }
        return nil;
    }
}
#pragma mark 按钮点击事件

- (IBAction)alertButtonClick:(id)sender{
    [self endEditing:YES];
    if (sender == _buttonCancel) {
        
        [self hide];
        
        if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
            [self.delegate alertView:self clickedButtonAtIndex:0];
            [self.superview removeFromSuperview];
        }
        
        //组件化间传值
        if (self.clickedButtonAtIndex) {
            
            self.clickedButtonAtIndex(0);
        }
        [self.superview removeFromSuperview];
        
        [self hide];
    }
    if (sender == _buttonOther) {
        if(!self.clickHidden){
        
            [self hide];
        }
        if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
            [self.delegate alertView:self clickedButtonAtIndex:1];
        }
        if (!_clickHidden) {
         [self.superview removeFromSuperview];
            [self hide];
        }
        
       
        return;
    }
}
#pragma mark 监听键盘事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"keyboardShow"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    if(_keyboardIsVisible) return;
    if(!self.contentView) return;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.contentView.frame;
        f.origin.y -= KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT;
        self.contentView.frame = f;
    }];
    _keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"keyboardShow"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    if(!_keyboardIsVisible) return;
    if(!self.contentView) return;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect f = self.contentView.frame;
        f.origin.y += KEYBOARD_HEIGHT + PREDICTION_BAR_HEIGHT;
        self.contentView.frame = f;
    }];
    _keyboardIsVisible = NO;
}
//- (void)keyboardDidHide:(NSNotification *)notification
//{
//    
//    beginOrientation
//    
//}
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userTextField) {
        [_pwdTextField becomeFirstResponder];
    }
    else{
        [self endEditing:YES];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"keyboardShow"];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if(self.headType!=3 && self.headType!=1 && (self.headType!=headTypeNone)&& self.headType!=5){
        beginOrientation
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"keyboardShow"];
         [[NSUserDefaults standardUserDefaults] synchronize];
        [self hide];
        [self.superview removeFromSuperview];
        
    }
    
}

-(void)removeAlertView{
    if (self) {
        beginOrientation
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"keyboardShow"];
         [[NSUserDefaults standardUserDefaults] synchronize];
        [self hide];
        [self.superview removeFromSuperview];
        
    }
}
-(UIImageView *)creatLineWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor{
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:frame];
    line.image = [JVCCreatImage creatImageFromColors:@[backgroundColor,backgroundColor] ByGradientType:leftToRight withFrame:frame];
    return line;
    
}
@end
