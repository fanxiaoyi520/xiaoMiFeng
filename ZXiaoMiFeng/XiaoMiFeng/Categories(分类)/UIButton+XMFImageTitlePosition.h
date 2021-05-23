//
//  UIButton+XMFImageTitlePosition.h
//  advertisingCattle
//
//  Created by 小蜜蜂 on 2018/4/28.
//  Copyright © 2018年 xiaomifeng. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,XMFButtonEdgeInsetsStyle) {
    XMFButtonEdgeInsetsStyleTop, // image在上，label在下
    XMFButtonEdgeInsetsStyleLeft, // image在左，label在右
    XMFButtonEdgeInsetsStyleBottom, // image在下，label在上
    XMFButtonEdgeInsetsStyleRight // image在右，label在左
    
};


@interface UIButton (XMFImageTitlePosition)



/**
 设置button的titleLabel和imageView的布局样式，及间距

 @param style titleLabel和imageView的布局样式
 @param space titleLabel和imageView的间距
 */
-(void)layoutButtonWithEdgeInsetsStyle:(XMFButtonEdgeInsetsStyle)style  imageTitleSpace:(CGFloat)space;

@end
