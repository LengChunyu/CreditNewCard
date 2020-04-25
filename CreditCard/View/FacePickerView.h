//
//  FacePickerView.h
//  CloudSEENew
//
//  Created by liujingtao on 2019/11/9.
//  Copyright © 2019 liujingtao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FacePickerDelegate<NSObject>
-(void)facePickerCallBackSelectIndex:(int)index withPickerView:(UIView *)selfView;
@end
@interface FacePickerView : UIView
-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)sourceArray withSelectIndex:(int)selectIndex;
@property (nonatomic,weak) id<FacePickerDelegate> faceDelegate;
-(void)setSelectIndex:(int)selectIndex;
@property (nonatomic,assign) int pickerIndex;
@property (nonatomic,assign) int pickerViewType;
@end

