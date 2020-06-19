//
//  PassTextFild.m
//  VisionField
//
//  Created by lcy on 19-3-31.
//  Copyright (c) 2019年 lcy. All rights reserved.
//

#import "PassTextFild.h"
#import <AudioToolbox/AudioToolbox.h>
@interface PassTextFild ()


@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UILabel *textLabel;
@end
@implementation PassTextFild
@synthesize otherKeyBoardView=_otherKeyBoardView;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadBegin];
    }
    return self;
}

-(void)loadBegin
{
    int keyBoardHeight =0;
    if (iphone4||iphone5||iPhone6||iphoneX||iphoneXS||iphoneXR) {
        
        keyBoardHeight =216;
    }else{
        keyBoardHeight =226;
    }
    int keyBoardY =0;
    if (iphoneXSM||iphoneXR||iphoneX) {
        
        keyBoardY =[UIScreen mainScreen].bounds.size.height-34-keyBoardHeight;
        self.keyBoardBackView =[[UIView alloc]initWithFrame:CGRectMake(0, keyBoardY,[UIScreen mainScreen].bounds.size.width,keyBoardHeight+34)];
        self.keyBoardBackView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgs.png"]];
        
    }else{
        
        keyBoardY =[UIScreen mainScreen].bounds.size.height-keyBoardHeight;
        self.keyBoardBackView =[[UIView alloc]initWithFrame:CGRectMake(0, keyBoardY,[UIScreen mainScreen].bounds.size.width,keyBoardHeight)];
        self.keyBoardBackView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgs.png"]];
    }
//    self.textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width-6, 35)];
//    self.textLabel.text =@"0.00";
//    self.textLabel.font =[UIFont systemFontOfSize:18];
//    self.textLabel.textColor =[UIColor blackColor];
//    self.textLabel.textAlignment =NSTextAlignmentRight;
//    [self.keyBoardBackView addSubview:self.textLabel];
    
    keyBoardView =[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,keyBoardHeight)];
    [self.keyBoardBackView addSubview:keyBoardView];
    for (int i=0; i<10; i++)
    {
        UIButton *pressButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [pressButton setBackgroundImage:[UIImage imageNamed:@"anniu1.png"] forState:UIControlStateNormal];
        [pressButton setBackgroundImage:[UIImage imageNamed:@"anniu1_select.png"] forState:UIControlStateHighlighted];
        pressButton.tag =i+1;
        pressButton.frame =[self frameForSettingButtonUnderImage:i];
        [pressButton addTarget:self action:@selector(goPress:) forControlEvents:UIControlEventTouchUpInside];
        [pressButton addTarget:self action:@selector(commonDownClick:) forControlEvents:UIControlEventTouchDown];
        [keyBoardView addSubview:pressButton];
        
        UILabel *descripSecLabel =[[UILabel alloc] init];
        descripSecLabel.frame =pressButton.frame;
        descripSecLabel.backgroundColor =[UIColor clearColor];
        descripSecLabel.textAlignment =NSTextAlignmentCenter;
        descripSecLabel.font =[UIFont fontWithName:@"STHeitiSC-Light" size:18*FIT_X];
        descripSecLabel.text =[NSString stringWithFormat:@"%d",i+1];
        if (i==9) {
            descripSecLabel.text =@"0";
        }
        [keyBoardView addSubview:descripSecLabel];
    }
    CGFloat everyHeight =(keyBoardView.bounds.size.height-4*4)/4.0;
    CGFloat everyWidth  =everyHeight*1.5;
    if (iphone5||iphone4) {
        
        everyWidth  =everyHeight*1.4;
    }else{
        everyWidth  =everyHeight*1.5;
    }
    CGFloat width =everyWidth*3+4*3;
    //删除
    UIButton *pressButtondelete =[UIButton buttonWithType:UIButtonTypeCustom];
    pressButtondelete.frame =CGRectMake(keyBoardView.bounds.size.width-width+everyWidth*2+4*2,everyHeight*3+4*4,everyWidth,everyHeight);
    [pressButtondelete setImage:[UIImage imageNamed:@"shanchu"] forState:UIControlStateNormal];
    [pressButtondelete setImage:[UIImage imageNamed:@"shanchu_p"] forState:UIControlStateHighlighted];
    [pressButtondelete addTarget:self action:@selector(deleteTextField) forControlEvents:UIControlEventTouchDown];
    UILongPressGestureRecognizer *longGR=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteLongPress:)];
    [pressButtondelete addGestureRecognizer:longGR];
    [keyBoardView addSubview:pressButtondelete];
    
    //点
    UIButton *spotButton =[UIButton buttonWithType:UIButtonTypeCustom];
    spotButton.frame =CGRectMake(keyBoardView.bounds.size.width-width,everyHeight*3+4*4,everyWidth,everyHeight);
    spotButton.tag =1000+3;
    [spotButton addTarget:self action:@selector(goPressOtherButtons:) forControlEvents:UIControlEventTouchUpInside];
    [spotButton addTarget:self action:@selector(commonDownClick:) forControlEvents:UIControlEventTouchDown];
    [spotButton setImage:[UIImage imageNamed:@"dian_n"] forState:UIControlStateNormal];
    [spotButton setImage:[UIImage imageNamed:@"dian_p"] forState:UIControlStateHighlighted];
    [keyBoardView addSubview:spotButton];
    
    UIButton *subButton =[UIButton buttonWithType:UIButtonTypeCustom];
    subButton.tag =1000+1;
    [subButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.00]] forState:UIControlStateNormal];
    [subButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.86 alpha:1.00]] forState:UIControlStateHighlighted];
    [subButton addTarget:self action:@selector(goPressOtherButtons:) forControlEvents:UIControlEventTouchUpInside];
    [subButton addTarget:self action:@selector(commonDownClick:) forControlEvents:UIControlEventTouchDown];
    subButton.frame =CGRectMake(4,4,[UIScreen mainScreen].bounds.size.width-width-4*2,everyHeight);
    subButton.layer.cornerRadius =5;
    subButton.clipsToBounds =YES;
    [keyBoardView addSubview:subButton];
    
    UILabel *descripSecLabel =[[UILabel alloc] init];
    descripSecLabel.frame =subButton.frame;
    descripSecLabel.backgroundColor =[UIColor clearColor];
    descripSecLabel.textAlignment =NSTextAlignmentCenter;
    descripSecLabel.font =[UIFont fontWithName:@"STHeitiSC-Light" size:18];
    descripSecLabel.text =[NSString stringWithFormat:@"-"];
    [keyBoardView addSubview:descripSecLabel];
    
    UIButton *sumButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sumButton.frame =CGRectMake(4,4*2+everyHeight,[UIScreen mainScreen].bounds.size.width-width-4*2,everyHeight);
    [sumButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.00]] forState:UIControlStateNormal];
    [sumButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.86 alpha:1.00]] forState:UIControlStateHighlighted];
    sumButton.tag =1000+2;
    [sumButton addTarget:self action:@selector(goPressOtherButtons:) forControlEvents:UIControlEventTouchUpInside];
    [sumButton addTarget:self action:@selector(commonDownClick:) forControlEvents:UIControlEventTouchDown];
    sumButton.layer.cornerRadius =5;
    sumButton.clipsToBounds =YES;
    [keyBoardView addSubview:sumButton];
    
    UILabel *descripSecLabel1 =[[UILabel alloc] init];
    descripSecLabel1.frame =sumButton.frame;
    descripSecLabel1.backgroundColor =[UIColor clearColor];
    descripSecLabel1.textAlignment =NSTextAlignmentCenter;
    descripSecLabel1.font =[UIFont fontWithName:@"STHeitiSC-Light" size:18];
    descripSecLabel1.text =[NSString stringWithFormat:@"+"];
    [keyBoardView addSubview:descripSecLabel1];
    
    UIButton *sureButton =[UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame =CGRectMake(4,4*3+everyHeight*2,[UIScreen mainScreen].bounds.size.width-width-4*2,everyHeight*2);
    [sureButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.00]] forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.86 alpha:1.00]] forState:UIControlStateHighlighted];
    sureButton.tag =1000+4;
    [sureButton addTarget:self action:@selector(goPressOtherButtons:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton addTarget:self action:@selector(commonDownClick:) forControlEvents:UIControlEventTouchDown];
    sureButton.layer.cornerRadius =5;
    sureButton.clipsToBounds =YES;
    [keyBoardView addSubview:sureButton];
    
    UILabel *descripSecLabel2 =[[UILabel alloc] init];
    descripSecLabel2.tag =1000+5;
    descripSecLabel2.frame =sureButton.frame;
    descripSecLabel2.backgroundColor =[UIColor clearColor];
    descripSecLabel2.textAlignment =NSTextAlignmentCenter;
    descripSecLabel2.font =[UIFont fontWithName:@"STHeitiSC-Light" size:18];
    descripSecLabel2.text =[NSString stringWithFormat:@"完成"];
    [keyBoardView addSubview:descripSecLabel2];
    self.inputView = [[UIView alloc]initWithFrame:CGRectZero];
//    self.inputView =self.keyBoardBackView;
}
-(void)commonDownClick:(UIButton *)btn{
    
    AudioServicesPlaySystemSound(1104);
}
-(void)goPress:(UIButton *)btn{
    
    NSInteger number = btn.tag;
    if (number==10) {
        
        number =0;
    }
    if ([self.text isEqualToString:@"0"]||[self.text isEqualToString:@"0.00"]||[self.text isEqualToString:@"-0"]||[self.text isEqualToString:@"-0.00"]) {
        
        self.text =[NSString stringWithFormat:@"%ld",number];
        [self searchAllTextField];
        return;
    }
    if ([self.text containsString:@"."]) {
        //小数点后保留两位
        NSArray *pointArray =[self.text componentsSeparatedByString:@"."];
        if (pointArray.count>0) {
            NSString *lastString =pointArray.lastObject;
            if (lastString.length==2&&![lastString hasSuffix:@"+"]&&![lastString hasSuffix:@"-"]){
                
                return;
            }
        }
    }
    //单个数小数点前最对输入8位
    if (![self.text containsString:@"+"]&&![self.text containsString:@"."]&&![self.text containsString:@"-"]) {
        if (self.text.length>=8) {
           
            return;
        }
    }else{
        if ([self.text containsString:@"+"]) {
            
            NSArray *sumArray =[self.text componentsSeparatedByString:@"+"];
            NSString *lastStrig =sumArray.lastObject;
            if (lastStrig.length>=8||[lastStrig isEqualToString:@"0"]) {
                
                return;
            }
        }else if ([self.text containsString:@"-"]){
            
            NSArray *subArray =[self.text componentsSeparatedByString:@"-"];
            NSString *subLastS =subArray.lastObject;
            if (subLastS.length>=8||[subLastS isEqualToString:@"0"]) {
                return;
            }
        }
    }
    if (([self.text containsString:@"-"]&&[self.text hasSuffix:@"-"])||([self.text containsString:@"+"]&&[self.text hasSuffix:@"+"])) {
        
        UILabel *finishL =[keyBoardView viewWithTag:1005];
        finishL.text =@"=";
    }
    NSMutableString* mutableString = [[NSMutableString alloc] initWithFormat:@"%@%ld", self.text,number];
    self.text = mutableString;
    [self searchAllTextField];
}

-(void)goPressOtherButtons:(UIButton *)btn
{
    if (btn.tag==1001) {
        //减号
        if (self.text.length<=0||[self.text hasSuffix:@"."]||[self.text hasSuffix:@"-"]) {
            
            return;
        }
        if ([self.text hasSuffix:@"+"]) {
            
            self.text =[self.text stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
            [self searchAllTextField];
            return;
        }
        if ([self.text containsString:@"+"]) {
            
            //将之前的计算算完再加
            NSArray *textArray =[self.text componentsSeparatedByString:@"+"];
            double sum =0;
            int maxChang =0;
            for (NSString *item in textArray) {
                
                double itemF;
                if ([item containsString:@"."]) {
                    NSArray *pointArray =[item componentsSeparatedByString:@"."];
                    NSString *pointString =pointArray[1];
                    if (pointString.length>maxChang&&![pointString isEqualToString:@"0"]&&![pointString isEqualToString:@"00"]) {
                        
                        maxChang =(int)pointString.length;
                    }
                    itemF=[item doubleValue];
                }else{
                    itemF=[item doubleValue];
                }
                sum+=itemF;
            }
            if (maxChang==1) {
                
                self.text =[NSString stringWithFormat:@"%0.1f",sum];
                if ([self.text hasSuffix:@".0"]) {
                    self.text =[self.text substringToIndex:self.text.length-2];
                }
            }else if(maxChang==2){
                
                self.text =[NSString stringWithFormat:@"%0.2f",sum];
                if ([self.text hasSuffix:@".00"]) {
                    self.text =[self.text substringToIndex:self.text.length-3];
                }else if([self.text hasSuffix:@"0"]){
                    self.text =[self.text substringToIndex:self.text.length-1];
                }
            }else{
                
                self.text =[NSString stringWithFormat:@"%ld",(long)sum];
            }
            self.text =[self.text stringByAppendingString:@"-"];
            UILabel *finishL =[keyBoardView viewWithTag:1005];
            finishL.text =@"完成";
            [self searchAllTextField];
            return;
        }
        if ([self.text containsString:@"-"]) {
            
            NSArray *textArray =[self.text componentsSeparatedByString:@"-"];
            if ([self.text hasPrefix:@"-"]&&textArray.count<=2) {
                
                self.text =[self.text stringByAppendingString:@"-"];
            }else{
                double firstValue =0;
                int maxChang =0;
                for (int i=0;i<textArray.count;i++) {
                    NSString *item =textArray[i];
                    double itemF;
                    if ([item containsString:@"."]) {
                        NSArray *pointArray =[item componentsSeparatedByString:@"."];
                        NSString *pointString =pointArray[1];
                        if (pointString.length>maxChang&&![pointString isEqualToString:@"0"]&&![pointString isEqualToString:@"00"]) {
                            
                            maxChang =(int)pointString.length;
                        }
                        itemF=[item doubleValue];
                    }else{
                        itemF=[item doubleValue];
                    }
                    if (i==0) {
                        
                        firstValue =itemF;
                    }else{
                        firstValue=firstValue-itemF;
                    }
                }
                if (maxChang==1) {
                    
                    self.text =[NSString stringWithFormat:@"%0.1f",firstValue];
                    if ([self.text hasSuffix:@".0"]) {
                        self.text =[self.text substringToIndex:self.text.length-2];
                    }
                }else if(maxChang==2){
                    
                    self.text =[NSString stringWithFormat:@"%0.2f",firstValue];
                    if ([self.text hasSuffix:@".00"]) {
                        self.text =[self.text substringToIndex:self.text.length-3];
                    }else if([self.text hasSuffix:@"0"]){
                        self.text =[self.text substringToIndex:self.text.length-1];
                    }
                }else{
                    
                    self.text =[NSString stringWithFormat:@"%ld",(long)firstValue];
                }
                self.text =[self.text stringByAppendingString:@"-"];
            }
            UILabel *finishL =[keyBoardView viewWithTag:1005];
            finishL.text =@"完成";
            [self searchAllTextField];
            return;
        }
        self.text =[self.text stringByAppendingString:@"-"];
        [self searchAllTextField];
    }else if (btn.tag==1002) {
        //加号
        if (self.text.length<=0||[self.text hasSuffix:@"."]||[self.text hasSuffix:@"+"]) {
            
            return;
        }
        if ([self.text hasSuffix:@"-"]) {
            
            self.text =[self.text stringByReplacingOccurrencesOfString:@"-" withString:@"+"];
            [self searchAllTextField];
            return;
        }
        if ([self.text containsString:@"+"]) {
            
            //将之前的计算算完再加
            NSArray *textArray =[self.text componentsSeparatedByString:@"+"];
            double sum =0;
            int maxChang =0;
            for (NSString *item in textArray) {
                
                double itemF;
                if ([item containsString:@"."]) {
                    NSArray *pointArray =[item componentsSeparatedByString:@"."];
                    NSString *pointString =pointArray[1];
                    if (pointString.length>maxChang&&![pointString isEqualToString:@"0"]&&![pointString isEqualToString:@"00"]) {
                        
                        maxChang =(int)pointString.length;
                    }
                    itemF=[item doubleValue];
                }else{
                    itemF=[item doubleValue];
                }
                sum+=itemF;
            }
            if (maxChang==1) {
               
                self.text =[NSString stringWithFormat:@"%0.1f",sum];
                if ([self.text hasSuffix:@".0"]) {
                    self.text =[self.text substringToIndex:self.text.length-2];
                }
            }else if(maxChang==2){
                
                self.text =[NSString stringWithFormat:@"%0.2f",sum];
                if ([self.text hasSuffix:@".00"]) {
                    self.text =[self.text substringToIndex:self.text.length-3];
                }else if([self.text hasSuffix:@"0"]){
                    self.text =[self.text substringToIndex:self.text.length-1];
                }
            }else{
                
                self.text =[NSString stringWithFormat:@"%ld",(long)sum];
            }
            self.text =[self.text stringByAppendingString:@"+"];
            UILabel *finishL =[keyBoardView viewWithTag:1005];
            finishL.text =@"完成";
            [self searchAllTextField];
            return;
        }
        if ([self.text containsString:@"-"]) {
            //将之前的计算算完再加
            NSArray *textArray =[self.text componentsSeparatedByString:@"-"];
            if ([self.text hasPrefix:@"-"]&&textArray.count<=2) {
                
                self.text =[self.text stringByAppendingString:@"+"];
            }else{
                double firstValue =0;
                int maxChang =0;
                for (int i=0;i<textArray.count;i++) {
                    NSString *item =textArray[i];
                    double itemF;
                    if ([item containsString:@"."]) {
                        NSArray *pointArray =[item componentsSeparatedByString:@"."];
                        NSString *pointString =pointArray[1];
                        if (pointString.length>maxChang&&![pointString isEqualToString:@"0"]&&![pointString isEqualToString:@"00"]) {
                            
                            maxChang =(int)pointString.length;
                        }
                        itemF=[item doubleValue];
                    }else{
                        itemF=[item doubleValue];
                    }
                    if (i==0) {
                        
                        firstValue =itemF;
                    }else{
                        firstValue=firstValue-itemF;
                    }
                }
                if (maxChang==1) {
                    
                    self.text =[NSString stringWithFormat:@"%0.1f",firstValue];
                    if ([self.text hasSuffix:@".0"]) {
                        self.text =[self.text substringToIndex:self.text.length-2];
                    }
                }else if(maxChang==2){
                    
                    self.text =[NSString stringWithFormat:@"%0.2f",firstValue];
                    if ([self.text hasSuffix:@".00"]) {
                        self.text =[self.text substringToIndex:self.text.length-3];
                    }else if ([self.text hasSuffix:@"0"]){
                        self.text =[self.text substringToIndex:self.text.length-1];
                    }
                }else{
                    
                    self.text =[NSString stringWithFormat:@"%ld",(long)firstValue];
                }
                self.text =[self.text stringByAppendingString:@"+"];
            }
            UILabel *finishL =[keyBoardView viewWithTag:1005];
            finishL.text =@"完成";
            [self searchAllTextField];
            return;
        }
        self.text =[self.text stringByAppendingString:@"+"];
        [self searchAllTextField];
    }else if (btn.tag==1003){
        
        if (self.text.length>0) {
            NSString *lastString =[self.text substringFromIndex:self.text.length-1];
            //最后一个字符是否是数字
            if ([self isPureInt:lastString]) {
                if ([self.text containsString:@"."]) {
                  
                    NSArray *pointArray =[self.text componentsSeparatedByString:@"."];
                    if (pointArray.count>=3) {
                       
                        return;
                    }else{
                        if (pointArray.count==2) {
                            
                            NSString *twoString =pointArray[1];
                            if ([self isPureInt:twoString]) {
                                return;
                            }else{
                               
                                self.text =[self.text stringByAppendingString:@"."];
                            }
                        }else{
                            return;
                        }
                    }
                }else{
                    
                    self.text =[self.text stringByAppendingString:@"."];
                }
            }
        }
        [self searchAllTextField];
    }else if(btn.tag==1004){
        
        [self finishButtonClick];
        return;
    }
}
-(BOOL)judgeFinishString{
    UILabel *finishL =[keyBoardView viewWithTag:1005];
    if ([finishL.text isEqualToString:@"="]) {
        return YES;
    }
    return NO;
}
-(void)finishButtonClick{
    
    UILabel *finishL =[keyBoardView viewWithTag:1005];
    if ([finishL.text isEqualToString:@"="]) {
        NSString *allString =@"";
        if ([self.text hasSuffix:@"."]) {
            
            allString =[self.text substringToIndex:self.text.length-1];
        }else{
            allString =self.text;
        }
        if ([allString containsString:@"+"]) {
            
            //将之前的计算算完再加
            NSArray *textArray =[allString componentsSeparatedByString:@"+"];
            double sum =0;
            int maxChang =0;
            for (NSString *item in textArray) {
                
                double itemF;
                if ([item containsString:@"."]) {
                    NSArray *pointArray =[item componentsSeparatedByString:@"."];
                    NSString *pointString =pointArray[1];
                    if (pointString.length>maxChang&&![pointString isEqualToString:@"0"]&&![pointString isEqualToString:@"00"]) {
                        
                        maxChang =(int)pointString.length;
                    }
                    itemF=[item doubleValue];
                }else{
                    itemF=[item doubleValue];
                }
                sum+=itemF;
            }
            if (maxChang==1) {
                
                self.text =[NSString stringWithFormat:@"%0.1f",sum];
                if ([self.text hasSuffix:@".0"]) {
                    self.text =[self.text substringToIndex:self.text.length-2];
                }
            }else if(maxChang==2){
                
                self.text =[NSString stringWithFormat:@"%0.2f",sum];
                if ([self.text hasSuffix:@".00"]) {
                    self.text =[self.text substringToIndex:self.text.length-3];
                }else if([self.text hasSuffix:@"0"]){
                    self.text =[self.text substringToIndex:self.text.length-1];
                }
            }else{
                
                self.text =[NSString stringWithFormat:@"%ld",(long)sum];
            }
            finishL.text =@"完成";
            [self searchAllTextField];
            return;
        }
        if ([allString containsString:@"-"]) {
            //将之前的计算算完再加
            NSArray *textArray =[allString componentsSeparatedByString:@"-"];
            if ([allString hasPrefix:@"-"]&&textArray.count<=2) {
                
                self.text =allString;
            }else{
                double firstValue =0;
                int maxChang =0;
                for (int i=0;i<textArray.count;i++) {
                    NSString *item =textArray[i];
                    double itemF;
                    if ([item containsString:@"."]) {
                        NSArray *pointArray =[item componentsSeparatedByString:@"."];
                        NSString *pointString =pointArray[1];
                        if (pointString.length>maxChang&&![pointString isEqualToString:@"0"]&&![pointString isEqualToString:@"00"]) {
                            
                            maxChang =(int)pointString.length;
                        }
                        itemF=[item doubleValue];
                    }else{
                        itemF=[item doubleValue];
                    }
                    if (i==0) {
                        
                        firstValue =itemF;
                    }else{
                        firstValue=firstValue-itemF;
                    }
                }
                if (maxChang==1) {
                    
                    self.text =[NSString stringWithFormat:@"%0.1f",firstValue];
                    if ([self.text hasSuffix:@".0"]) {
                        self.text =[self.text substringToIndex:self.text.length-2];
                    }
                }else if(maxChang==2){
                    
                    self.text =[NSString stringWithFormat:@"%0.2f",firstValue];
                    if ([self.text hasSuffix:@".00"]) {
                        self.text =[self.text substringToIndex:self.text.length-3];
                    }else if ([self.text hasSuffix:@"0"]){
                        self.text =[self.text substringToIndex:self.text.length-1];
                    }
                }else{
                    
                    self.text =[NSString stringWithFormat:@"%ld",(long)firstValue];
                }
            }
            finishL.text =@"完成";
            [self searchAllTextField];
            return;
        }
    }else{
        //隐藏掉键盘
        NSString *string =@"";
        if ([self.text hasSuffix:@"-"]||[self.text hasSuffix:@"."]||[self.text hasSuffix:@"+"]) {
            
            string =[self.text substringToIndex:self.text.length-1];
        }else{
            
            string =self.text;
        }
        if ([string isEqualToString:@"-0"]||[string isEqualToString:@"-0.0"]||[string isEqualToString:@"-0.00"]||[string isEqualToString:@"0"]||[string isEqualToString:@"0.0"]||[string isEqualToString:@"0.00"]) {
            if ([string isEqualToString:@"0.00"]) {

                self.text =string;
                [self changeInputView];
                [self resignFirstResponder];
                [self searchAllTextField];
                return;
            }
        }
        if([string hasSuffix:@".00"]) {
            
            string =[string substringToIndex:string.length-3];
        }else if([string hasSuffix:@".0"]){
            
            string =[string substringToIndex:string.length-2];
        }
        self.text =string;

        [self changeInputView];
        [self resignFirstResponder];
        [self searchAllTextField];
    }
}
-(void)changeInputView{
    UIWindow *window = [[[UIApplication sharedApplication]delegate]window];
    if (self.keyBoardBackView.superview == window) {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.keyBoardBackView.frame = CGRectMake(0, self.keyBoardBackView.bottom+self.keyBoardBackView.height, self.keyBoardBackView.width, self.keyBoardBackView.height);
        } completion:^(BOOL finished) {
            
            [self.keyBoardBackView removeFromSuperview];
            self.inputView = self.keyBoardBackView;
        }];
    }
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
//删除一位
-(void)deleteTextField
{
    AudioServicesPlaySystemSound(1104);
    NSMutableString* mutableString = [[NSMutableString alloc] initWithFormat:@"%@", self.text];
    if ([mutableString length] > 0) {
        NSRange tmpRange;
        tmpRange.location = [mutableString length] - 1;
        tmpRange.length = 1;
        [mutableString deleteCharactersInRange:tmpRange];
    }
    self.text = mutableString;
    if ([self.text isEqualToString:@"0"]||self.text.length<=0||[self.text isEqualToString:@"-"]) {
        
        self.text =@"0";
    }
    if (([self.text containsString:@"-"]&&[self.text hasSuffix:@"-"])||([self.text containsString:@"+"]&&[self.text hasSuffix:@"+"])) {
        
        UILabel *finishL =[keyBoardView viewWithTag:1005];
        finishL.text =@"完成";
    }
    [self searchAllTextField];
}
-(void)deleteLongPress:(UILongPressGestureRecognizer *)longTouch{
    
    if (longTouch.state==UIGestureRecognizerStateBegan) {

        [self.timer invalidate];
        self.timer =nil;
        self.timer =[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(deleteProgress:) userInfo:nil repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
        
    } else if (longTouch.state == UIGestureRecognizerStateEnded) {
        
        [self.timer invalidate];
        self.timer =nil;
    }
    
}
-(void)deleteProgress:(NSTimer *)timePlay{
    
    AudioServicesPlaySystemSound(1104);
    NSMutableString* mutableString = [[NSMutableString alloc] initWithFormat:@"%@", self.text];
    if ([mutableString length] > 0) {
        NSRange tmpRange;
        tmpRange.location = [mutableString length] - 1;
        tmpRange.length = 1;
        [mutableString deleteCharactersInRange:tmpRange];
    }
    self.text = mutableString;
    if ([self.text isEqualToString:@"0"]||self.text.length<=0||[self.text isEqualToString:@"-"]) {
        
        self.text =@"0";
    }
    if (([self.text containsString:@"-"]&&[self.text hasSuffix:@"-"])||([self.text containsString:@"+"]&&[self.text hasSuffix:@"+"])) {
        
        UILabel *finishL =[keyBoardView viewWithTag:1005];
        finishL.text =@"完成";
    }
    [self searchAllTextField];
}
//清除
-(void)clearAllTextField
{
    self.text =@"";
}

//搜索
-(void)searchAllTextField
{
//    self.textLabel.text =self.text;
    if (self.delegate) {
    
        [self.delegate passTextFieldSearch:self.text];
    }
}
//alertView 自动消失；
- (void)removeAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:[alertView cancelButtonIndex] animated:YES];
    [alertView removeFromSuperview];
}
//隐藏
-(void)goReturn
{
    [self changeInputView];
    [self resignFirstResponder];
}
-(CGRect)frameForSettingButtonUnderImage:(NSInteger)index
{
    CGFloat everyHeight =(keyBoardView.bounds.size.height-4*5)/4.0;
    CGFloat everyWidth;
    if (iphone4||iphone5) {
        
        everyWidth  =everyHeight*1.4;
    }else{
       
        everyWidth  =everyHeight*1.5;
    }
    CGFloat width =everyWidth*3+4*3;
    CGFloat x;
    CGFloat y;
    if(index%3==0)
    {
        x =keyBoardView.bounds.size.width-width;
        y =everyHeight*index/3 +index/3*4+4;
    }
    else if (index%3==1)
    {
        x =keyBoardView.bounds.size.width-width+everyWidth+4;
        y =everyHeight*(index/3) +index/3*4+4;
    }
    else
    {
        x =keyBoardView.bounds.size.width-width+(everyWidth+4)*2;
        y =everyHeight*(index/3) +index/3*4+4;
    }

    if (index==9)
    {
        return CGRectMake(keyBoardView.bounds.size.width-width+everyWidth+4,everyHeight*(index/3)+index/3*4+4,everyWidth,everyHeight);
    }
    return CGRectMake(x,y,everyWidth,everyHeight);
}
-(UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
