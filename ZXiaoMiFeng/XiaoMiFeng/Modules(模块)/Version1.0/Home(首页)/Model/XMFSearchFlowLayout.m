//
//  XMFSearchFlowLayout.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSearchFlowLayout.h"

@implementation XMFSearchFlowLayout

- (instancetype)init{
    if (self = [super init]) {
        self.minimumLineSpacing = 5;
        self.minimumInteritemSpacing = 5;
        self.maximumInteritemSpacing = 5;
        
        
        
#warning 如果collection的cell初始位置不准确 修改这里 因为项目是以tabbar作为rootViewController 这里是导航控制器
        /*! 边距 */
        self.sectionInset = UIEdgeInsetsMake(0 , 0, 0, 0);
        
        
        
        
    }
    return self;
}
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //使用系统帮我们计算好的结果。
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    //第0个cell没有上一个cell，所以从1开始
    for(int i = 1; i < [attributes count]; ++i) {
        //这里 UICollectionViewLayoutAttributes 的排列总是按照 indexPath的顺序来的。
        UICollectionViewLayoutAttributes *curAttr = attributes[i];
        UICollectionViewLayoutAttributes *preAttr = attributes[i-1];
        
        NSInteger origin = CGRectGetMaxX(preAttr.frame);
        //根据  maximumInteritemSpacing 计算出的新的 x 位置
        CGFloat targetX = origin + _maximumInteritemSpacing;
        // 只有系统计算的间距大于  maximumInteritemSpacing 时才进行调整
        if (CGRectGetMinX(curAttr.frame) > targetX) {
            // 换行时不用调整
            if (targetX + CGRectGetWidth(curAttr.frame) < self.collectionViewContentSize.width) {
                CGRect frame = curAttr.frame;
                frame.origin.x = targetX;
                curAttr.frame = frame;
            }
        }
    }
    return attributes;
}


@end
