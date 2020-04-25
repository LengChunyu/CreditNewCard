//
//  LcyCollectionViewLayout.h
//  ShiLi
//
//  Created by liujingtao on 2019/3/28.
//  Copyright © 2019年 开发. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef CGFloat(^WidthBlock)(NSIndexPath *indexPath,CGFloat height,CGFloat currentY,CGFloat currentX);
@interface LcyCollectionViewLayout : UICollectionViewLayout
@property (assign, nonatomic) CGFloat itemHeight;
@property (assign, nonatomic) CGFloat itemSpace;
@property (assign, nonatomic) CGFloat lineSpace;
@property (assign, nonatomic) UIEdgeInsets sectionInsets;
@property (nonatomic,strong) NSMutableArray *sourceMuArray;


/**
 配置item的宽度
 */
- (void)configItemWidth:(CGFloat (^)(NSIndexPath * indexPath, CGFloat height,CGFloat currentY,CGFloat currentX))widthBlock;
@end


