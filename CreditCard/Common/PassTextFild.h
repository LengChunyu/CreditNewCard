//
//  PassTextFild.h
//  VisionField
//
//  Created by lcy on 19-3-31.
//  Copyright (c) 2019年 lcy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassTextFieldViewDelegate <NSObject>
-(void)passTextFieldSearch:(NSString *)searchString;
@end

@interface PassTextFild : UITextField
{
    UIView *keyBoardView;
    UIButton *pressButtonCapital;
    UIImageView *bacDaXieImage;
}
@property(nonatomic,strong)UIView *otherKeyBoardView;
@property(nonatomic,weak)id<PassTextFieldViewDelegate>delegate;
-(void)finishButtonClick;
@end
