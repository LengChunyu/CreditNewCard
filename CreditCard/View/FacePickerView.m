//
//  FacePickerView.m
//  CloudSEENew
//
//  Created by liujingtao on 2019/11/9.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import "FacePickerView.h"
@interface FacePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) NSArray *sourceArray;
@property (nonatomic,strong) UIPickerView *pickView;
@end
@implementation FacePickerView

-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)sourceArray withSelectIndex:(int)selectIndex{
    
    if (self =[super initWithFrame:frame]) {
    
        self.pickerIndex =selectIndex;
        self.sourceArray =sourceArray;
        self.pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40,frame.size.width,frame.size.height-40)];
        self.pickView.backgroundColor = [UIColor whiteColor];
        self.pickView.delegate = self;
        self.pickView.dataSource = self;
        [self.pickView selectRow:selectIndex inComponent:0 animated:NO];
        [self addSubview:self.pickView];
    }
    return self;
}
-(void)setSelectIndex:(int)selectIndex{
    self.pickerIndex = selectIndex;
    [self.pickView selectRow:selectIndex inComponent:0 animated:NO];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.sourceArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 35;
}
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return  pickerView.width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (!view) {
        
        view = [[UIView alloc] init];
    }
    
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, pickerView.width,35)];
    
    if (self.pickerIndex == row) {
        
        text.textColor = UIColorFromRGB(0x393943);
        text.font = [UIFont systemFontOfSize:15];
    } else {
        
        text.textColor = UIColorFromRGB(0xb9b9c3);
        text.font = [UIFont systemFontOfSize:14];
    }
    text.textAlignment = NSTextAlignmentCenter;
    
    NSString *content;
    if (self.pickerViewType==0) {
        
        content = [NSString stringWithFormat:@"每个月%@号",self.sourceArray[row]];
    }else{
        
        content = [NSString stringWithFormat:@"间隔%@天",self.sourceArray[row]];
    }
    text.text =content;
    [view addSubview:text];
    
    [pickerView.subviews objectAtIndex:1].backgroundColor = [UIColor clearColor];
    [pickerView.subviews objectAtIndex:2].backgroundColor = [UIColor clearColor];
    
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    self.pickerIndex =(int)row;
    [pickerView reloadAllComponents];
    if (self.faceDelegate && [self.faceDelegate respondsToSelector:@selector(facePickerCallBackSelectIndex:withPickerView:)]) {
        
        [self.faceDelegate facePickerCallBackSelectIndex:(int)row withPickerView:self];
    }
    
}
@end
