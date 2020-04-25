//
//  GestureViewController.h
//  Gesture
//
//  Created by 袁斌 on 15/11/7.
//  Copyright © 2015年 yinbanke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GestureView.h"
#import "AccountBookModel.h"
@protocol PasswordSetBack <NSObject>
-(void)comeBackPasswordType:(int)passWordType withPassWord:(NSString *)passWordString;
@end
@interface GestureViewController : BaseViewController

-(instancetype)initWithCaseMode:(CaseMode)caseMode;
@property (nonatomic,assign) BOOL isFormer;
@property (nonatomic,assign) BOOL resetPassword;
@property (nonatomic,assign) BOOL isChangePwd;
@property (nonatomic,assign) BOOL isClosePwd;
@property (nonatomic,assign) BOOL isShowAgin;

@property (nonatomic,assign) BOOL isChangePassWord;
@property (nonatomic,copy) NSString *oldPassword;
@property (nonatomic,assign) BOOL isHideDelete;     //是否需要隐藏删除按钮
@property (nonatomic,strong) AccountBookModel *bookModel;//账本的model
@property (nonatomic,weak) id<PasswordSetBack> passWordDelegate;
@property (nonatomic,copy) void(^billPopBlock)(void);
@end
