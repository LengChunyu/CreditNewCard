//
//  GestureViewController.m
//  Gesture
//
//  Created by 袁斌 on 15/11/7.
//  Copyright © 2015年 yinbanke. All rights reserved.
//

#import "GestureViewController.h"
#import "PasswordButton.h"
#import "PasswordAccount.h"
//#import "XWDatabaseHelper.h"
//#import "GestureSettingViewController.h"
#import "JVAlertView.h"

#define LOCALANGER(A) NSLocalizedString(A, nil)

@interface GestureViewController ()<caseDelegate,JVAlertViewDelegate>
{
    NSMutableArray *buttonArray;
    GestureView *tentacleView;
    CaseMode _style;
    int inputCnt;
    UILabel *oneInfoLable;
    NSString *oneInfoLableSave;
}
@property (nonatomic,copy) NSString *firstPassword;
@property (nonatomic,copy) NSString *secondPassword;
@end

@implementation GestureViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSettingNotice" object:nil];
    
}
-(instancetype)initWithCaseMode:(CaseMode)caseMode
{
    if (self = [super init]) {
        _style = caseMode;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    inputCnt = 0;
    [self makeTop];
    [self makeUI];
}
-(void)makeTop
{
    //添加设备按钮
    UIButton *closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame=CGRectMake(self.view.width-65,iphoneX||iphoneXR||iphoneXSM?44:20,55, 35);
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setTitle:@"删除" forState:UIControlStateNormal];
    [closeBtn setTitleColor:UIColorFromRGB(0x6e7276) forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:closeBtn];
    if (self.isHideDelete) {
        
//        closeBtn.hidden =YES;
        UILabel *accoutNameLabel =[[UILabel alloc]initWithFrame:CGRectMake((self.view.width-100)/2,iphoneX||iphoneXR||iphoneXSM?44:20,100,50)];
        accoutNameLabel.textColor =[UIColor orangeColor];
        accoutNameLabel.text =self.bookModel.accountBookName;
        accoutNameLabel.textAlignment =NSTextAlignmentCenter;
        accoutNameLabel.numberOfLines =0;
        [self.view addSubview:accoutNameLabel];
    }
    
    oneInfoLable = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.width,20)];
    oneInfoLable.textAlignment = NSTextAlignmentCenter;
    oneInfoLable.numberOfLines = 0;
    oneInfoLable.lineBreakMode = NSLineBreakByCharWrapping;
    oneInfoLable.font = [UIFont systemFontOfSize:14];
    oneInfoLable.textColor = UIColorFromRGB(0x6e7276);
    if (self.oldPassword.length<=0) {
       
        oneInfoLable.text =@"设置手势密码";
    }else{
        
        if (self.isChangePassWord) {
            
            oneInfoLable.text =@"请输入旧手势密码";
        }else{
            
            oneInfoLable.text =@"请输入手势密码";
        }
    }
    [self.view addSubview:oneInfoLable];
    oneInfoLableSave = oneInfoLable.text;
}
- (void)closeClick{
    //手势密码修改成功
    if (self.passWordDelegate&&[self.passWordDelegate respondsToSelector:@selector(comeBackPasswordType:withPassWord:)]) {
        if (self.isChangePassWord) {
            
            [self.passWordDelegate comeBackPasswordType:4 withPassWord:nil];
        }else{
            
            [self.passWordDelegate comeBackPasswordType:3 withPassWord:nil];
        }
        
    }
    if (self.billPopBlock) {
        
        self.billPopBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//- (void)alertView:(JVAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex editText:(NSString *)editText selectIndex:(int)selectIndex time:(NSString *)time value:(int)value{
//
//    [alertView hide];
//
//    if(buttonIndex == 0){
//
//        if([editText isEqualToString:kkPassword]){
//
//            [PasswordAccount deletePassword];
//            [PasswordAccount needPasswordIsOn:NO];
//            [[JVCAlertHelper shareAlertHelper]alertToastMainThreadOnWindow:LOCALANGER(@"operation_success")];
//            [self.navigationController popViewControllerAnimated:NO];
//
//        }else{
//
//            [[JVCAlertHelper shareAlertHelper]alertToastMainThreadOnWindow:LOCALANGER(@"PWDError")];
//        }
//    }
//}
-(void)makeUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    buttonArray = [[NSMutableArray alloc]initWithCapacity:0];
    CGRect frame = self.view.frame;
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width/2-310*WIDTHRATIO, iphoneX||iphoneXR||iphoneXSM?(frame.size.height-560*WIDTHRATIO)/2+44:(frame.size.height-560*WIDTHRATIO)/2+32, 620*WIDTHRATIO, 560*WIDTHRATIO)];
    if(iphone5){
        
        view.frame = CGRectMake(frame.size.width/2-160,(frame.size.height-280)/2+32, 320, 280);
    }
    if(iphone4||ipad){
        
        view.frame = CGRectMake(320/2-160,(480-280)/2+32, 320, 280);
    }
    for (int i=0; i<9; i++) {
        NSInteger row = i/3;
        NSInteger col = i%3;
        NSInteger distance = view.width/3;
        NSInteger size = distance/1.5;
        NSInteger margin = size/4;
        
        UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,50,50)];
        [view addSubview:imageView];
        imageView.image =[UIImage imageNamed:@"icon-area-n"];
        
        PasswordButton *gesturePasswordButton = [[PasswordButton alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance, size, size)];
        [gesturePasswordButton setTag:i];
        [view addSubview:gesturePasswordButton];
        [buttonArray addObject:gesturePasswordButton];
        imageView.center =gesturePasswordButton.center;
    }
    frame.origin.y=0;
    [self.view addSubview:view];
    tentacleView = [[GestureView alloc] initWithFrame:view.frame];
    tentacleView.style = _style;
    [tentacleView setButtonArray:buttonArray];
    tentacleView.caseDelegate = self;
    [self.view addSubview:tentacleView];
    oneInfoLable.frame =CGRectMake(oneInfoLable.frame.origin.x,view.top-100*HEIGHTRATIO,oneInfoLable.frame.size.width, oneInfoLable.frame.size.height);
}
- (void)btnClick{

    self.view.userInteractionEnabled = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoLogin" object:nil];

}
/*
 1.请绘制手势密码
 2.再次绘图案进行确认
 3.密码不一致，请重新绘制
 */
- (UIImage *)changeHeadIcon{
    
//    UIImage *userHeadIcon=[[UIImage alloc]initWithContentsOfFile:[[XWDatabaseHelper sqliteEngine]queryRecords:@"headImagePath" FromUserInfo:kkUserName]];
//
//    NSLog(@"%@",[[XWDatabaseHelper sqliteEngine]queryRecords:@"headImagePath" FromUserInfo:kkUserName]);
//
//    if(userHeadIcon){
//
//        return userHeadIcon;
//
//    }else{
//
//        return [UIImage imageNamed:@"icon-center-headImage_large"];
//    }
    return nil;
    
}

#pragma mark - setTouchBeginDelegate
-(BOOL)verification:(NSString *)result
{
    if(result.length<4){
        
        [self errorInputLabel];
        return NO;
    }
    if (self.oldPassword.length<=0) {
        
        //重新录制新的手势密码
        if (self.firstPassword.length<=0) {
            
            self.firstPassword =result;
            oneInfoLable.text =@"再次确认手势密码";
            return YES;
        }else{
         
            if ([self.firstPassword isEqualToString:result]) {
                //手势密码开启成功
                if (self.passWordDelegate&&[self.passWordDelegate respondsToSelector:@selector(comeBackPasswordType:withPassWord:)]) {
                    
                    [self.passWordDelegate comeBackPasswordType:1 withPassWord:result];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                return YES;
            }else{
                //两次手势密码不同，请重新输入。
                self.firstPassword =@"";
                oneInfoLable.text =@"两次手势密码不同，请重新输入";
                oneInfoLable.textColor =[UIColor redColor];
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    
                    oneInfoLable.text = oneInfoLableSave;
                    oneInfoLable.textColor = UIColorFromRGB(0x6e7276);
                });
                return NO;
            }
        }
    }else{
        if (self.isChangePassWord) {
            //修改手势密码
            if (self.firstPassword.length<=0) {
                
                if ([self.oldPassword isEqualToString:result]) {
                    
                    self.firstPassword =result;
                    oneInfoLable.text =@"请输入新的手势密码";
                    return YES;
                }else{
                    
                    oneInfoLable.text =@"旧手势密码不对，请重新输入";
                    oneInfoLable.textColor =[UIColor redColor];
                    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
                    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                        
                        oneInfoLable.text = oneInfoLableSave;
                        oneInfoLable.textColor = UIColorFromRGB(0x6e7276);
                    });
                    return NO;
                }
                
            }else{
                
                if (self.secondPassword.length<=0) {
                    
                    self.secondPassword =result;
                    oneInfoLable.text =@"再次确认手势密码";
                    return YES;
                }else{
                    
                    if ([self.secondPassword isEqualToString:result]) {
                        //手势密码修改成功
                        if (self.passWordDelegate&&[self.passWordDelegate respondsToSelector:@selector(comeBackPasswordType:withPassWord:)]) {
                            
                            [self.passWordDelegate comeBackPasswordType:2 withPassWord:result];
                        }
                        [self dismissViewControllerAnimated:YES completion:nil];
                        return YES;
                    }else{
                        //两次手势密码不同，请重新输入。
                        self.firstPassword =@"";
                        oneInfoLable.text =@"两次手势密码不同，请重新输入";
                        oneInfoLable.textColor =[UIColor redColor];
                        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
                        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                            
                            oneInfoLable.text = oneInfoLableSave;
                            oneInfoLable.textColor = UIColorFromRGB(0x6e7276);
                        });
                        return NO;
                    }
                    
                }
            }
        }else{
            
            //验证手势密码
            if ([self.oldPassword isEqualToString:result]) {
                //密码验证通过
                if (self.passWordDelegate&&[self.passWordDelegate respondsToSelector:@selector(comeBackPasswordType:withPassWord:)]) {
                    
                    [self.passWordDelegate comeBackPasswordType:0 withPassWord:result];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
                return YES;
            }else{
                //验证密码输入失败
                return NO;
            }
        }
    }
}
-(void)pop
{
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSettingNotice" object:nil];
//    for (UIViewController *VC in self.navigationController.viewControllers) {
//
//        if([VC isKindOfClass:[GestureSettingViewController class]]){
//
//            [self.navigationController popToViewController:VC animated:YES];
//        }
//    }
}

-(BOOL)resetPassword:(NSString *)result
{
    if(result.length<4){
        
        [self errorInputLabel];
        
        //[tentacleView enterArgin];
        return NO;
    }
    
    [PasswordAccount setPassword:result];
    GestureViewController *ges = [[GestureViewController alloc] initWithCaseMode:VerifyMode];
    ges.isFormer = NO;
    ges.resetPassword = YES;
    ges.isShowAgin = YES;
    ges.isChangePwd = self.isChangePwd;
    [self.navigationController pushViewController:ges animated:YES];
    
    return YES;
}
-(void)errorInputLabel{

    oneInfoLable.text = @"最少连接4个点";
    oneInfoLable.textColor = [UIColor redColor];
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        
        oneInfoLable.text = oneInfoLableSave;
        oneInfoLable.textColor = UIColorFromRGB(0x6e7276);
    });
    
}
- (void)showErrAnimation{
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{

        oneInfoLable.text = oneInfoLableSave;
        oneInfoLable.textColor = UIColorFromRGB(0x6e7276);
        
    });
//    [UIView animateWithDuration:0.1f animations:^{
//
//        oneInfoLable.left = oneInfoLable.left-10;
//
//    } completion:^(BOOL completed) {
//        [UIView animateWithDuration:0.2f animations:^{
//
//            oneInfoLable.left = oneInfoLable.left+20;
//
//        } completion:^(BOOL completed) {
//            [UIView animateWithDuration:0.1f animations:^{
//
//                oneInfoLable.left = oneInfoLable.left-10;
//
//            } completion:^(BOOL completed) {
//                [UIView animateWithDuration:0.1f animations:^{
//
//                    oneInfoLable.left = oneInfoLable.left-10;
//
//                } completion:^(BOOL completed) {
//                    [UIView animateWithDuration:0.2f animations:^{
//
//                        oneInfoLable.left = oneInfoLable.left+20;
//
//                    } completion:^(BOOL completed) {
//                        [UIView animateWithDuration:0.1f animations:^{
//
//                            oneInfoLable.left = oneInfoLable.left-10;
//
//                        } completion:^(BOOL completed) {
//
//                        }];
//                    }];
//                }];
//            }];
//        }];
//    }];
    
}
-(void)errorLable
{
    
    oneInfoLable.textColor = [UIColor redColor];
    
    if(_style==VerifyMode){
        
        if(self.resetPassword){
            
            oneInfoLable.text = LOCALANGER(@"tips_gesture_record_retry");
            
        }else{
        
            if(inputCnt>5){
            
//                [SVProgressHUD showInfoWithStatus:LOCALANGER(@"tips_gesture_fail_toomuch_1")];
                self.view.userInteractionEnabled = NO;
                [self performSelector:@selector(pop) withObject:self afterDelay:_isClosePwd?3:10];
                
            }
            
            oneInfoLable.text = LOCALANGER(@"tips_gesture_reset_error");
            
        }
    
    
    }else{
    
        oneInfoLable.text = LOCALANGER(@"tips_gesture_record_retry");

    }
    
    [self showErrAnimation];
}

-(void)errorLoginLable
{
    
    oneInfoLable.text = [NSString stringWithFormat:LOCALANGER(@"tips_gesture_count_error"),5-inputCnt];
    oneInfoLable.textColor = [UIColor redColor];
    
    if(inputCnt==5){
    
        [PasswordAccount deletePassword];
        [PasswordAccount needPasswordIsOn:NO];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"UserLoginStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
//        [SVProgressHUD showInfoWithStatus:LOCALANGER(@"tips_gesture_fail_toomuch")];
        self.view.userInteractionEnabled = NO;
        [self performSelector:@selector(btnClick) withObject:self afterDelay:4];

    }
    [self showErrAnimation];

}


-(void)succesLable
{
    oneInfoLable.text = LOCALANGER(@"tips_gesture_match_ok");
    oneInfoLable.textColor = [UIColor blackColor];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"手势密码界面已经销毁");
}
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
