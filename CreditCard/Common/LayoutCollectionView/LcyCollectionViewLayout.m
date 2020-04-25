//
//  LcyCollectionViewLayout.m
//  ShiLi
//
//  Created by liujingtao on 2019/3/28.
//  Copyright © 2019年 开发. All rights reserved.
//

#import "LcyCollectionViewLayout.h"

@interface LcyCollectionViewLayout ()

@property (assign, nonatomic) CGFloat currentY;   //当前Y值
@property (assign, nonatomic) CGFloat currentX;   //当前X值
@property (copy, nonatomic) WidthBlock widthComputeBlock;   //外包的宽度Block
@property (strong, nonatomic) NSMutableArray * attrubutesArray;   //所有元素

@end
@implementation LcyCollectionViewLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    //初始化首个item位置
    _currentY = _sectionInsets.top;
    _currentX = _sectionInsets.left;
    _attrubutesArray = [NSMutableArray array];
    for (int i=0;i<self.sourceMuArray.count;i++) {
       
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [_attrubutesArray addObject:attributes];
    }
}
//- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//
//    UICollectionViewLayoutAttributes * temp;
//    if (kind ==UICollectionElementKindSectionHeader) {
//
//        UICollectionViewLayoutAttributes * temp = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
//        temp.frame =CGRectMake(_currentX,_currentY,SCREEN_WIDTH,60);
//        _currentY =_currentY+60;
//        return temp;
//    }
//    return temp;
//}
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat contentWidth = self.collectionView.frame.size.width - _sectionInsets.left - _sectionInsets.right;
    UICollectionViewLayoutAttributes * temp = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat itemW = 0;
    if (_widthComputeBlock) {
        
        itemW = self.widthComputeBlock(indexPath, _itemHeight,_currentY,_currentX);
        if (itemW > contentWidth) {
            
            itemW = contentWidth;
        }
    }
    CGRect frame;
    frame.size = CGSizeMake(itemW, _itemHeight);
    
    //检查坐标
    if (_currentX + frame.size.width > contentWidth+_sectionInsets.left) {
        _currentX = _sectionInsets.left;
        _currentY += (_itemHeight + _lineSpace);
    }
    //设置坐标
    frame.origin = CGPointMake(_currentX, _currentY);
    temp.frame = frame;
    //偏移当前坐标
    _currentX += frame.size.width + _itemSpace;
    return temp;
}
- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(1,_currentY + _itemHeight + _sectionInsets.bottom);
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return _attrubutesArray;
}
/**
 配置item的宽度
 */
- (void)configItemWidth:(CGFloat (^)(NSIndexPath * indexPath, CGFloat height,CGFloat currentY,CGFloat currentX))widthBlock{
    
    self.widthComputeBlock = widthBlock;
}
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return NO;
//}
@end
