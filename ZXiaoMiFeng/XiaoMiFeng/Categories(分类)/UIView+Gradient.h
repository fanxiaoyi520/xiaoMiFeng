//
//  UIView+Gradient.h
//  AZCategory
//
//  Created by Alfred Zhang on 2017/6/29.
//  Copyright © 2017年 Alfred Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIViewGradientType) {
    UIViewGradientTypeTopToBottom = 0,//从上到小
    UIViewGradientTypeLeftToRight = 1,//从左到右
    UIViewGradientTypeUpleftToLowright = 2,//左上到右下
    UIViewGradientTypeUprightToLowleft = 3,//右上到左下
};

@interface UIView (Gradient)

/* The array of CGColorRef objects defining the color of each gradient
 * stop. Defaults to nil. Animatable. */
//渐变色颜色数组

@property(nullable, copy) NSArray *colors;

/* An optional array of NSNumber objects defining the location of each
 * gradient stop as a value in the range [0,1]. The values must be
 * monotonically increasing. If a nil array is given, the stops are
 * assumed to spread uniformly across the [0,1] range. When rendered,
 * the colors are mapped to the output colorspace before being
 * interpolated. Defaults to nil. Animatable. */

//渐变色分割点
@property(nullable, copy) NSArray<NSNumber *> *locations;

/* The start and end points of the gradient when drawn into the layer's
 * coordinate space. The start point corresponds to the first gradient
 * stop, the end point to the last gradient stop. Both points are
 * defined in a unit coordinate space that is then mapped to the
 * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
 * corner of the layer, [1,1] is the top-right corner.) The default values
 * are [.5,0] and [.5,1] respectively. Both are animatable. */

/*
 
 从上往下：开始 - CGPointMake(0.0, 0.0) , 结束 - CGPointMake(0.0, 1.0)
 从左往右：开始 - CGPointMake(0.0, 0.0) , 结束 - CGPointMake(1.0, 0.0)
 从左上往右下：开始 - CGPointMake(0.0, 0.0) , 结束 - CGPointMake(1.0, 1.0)
 从右上往左下：开始 - CGPointMake(1.0, 0.0) , 结束 - CGPointMake(0.0, 1.0)
 
 */


//开始位置（0，0）（1，1）
@property CGPoint startPoint;

//结束位置
@property CGPoint endPoint;



+ (UIView *_Nullable)gradientViewWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors locations:(NSArray<NSNumber *> *_Nullable)locations startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;


//设置渐变色的背景颜色
- (void)setGradientBackgroundWithColors:(NSArray<UIColor *> *_Nullable)colors gradientType:(UIViewGradientType)gradientType;

@end
