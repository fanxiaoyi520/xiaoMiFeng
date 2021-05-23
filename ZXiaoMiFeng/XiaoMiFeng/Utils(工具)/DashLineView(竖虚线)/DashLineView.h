//
//  DashLineView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/17.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DashLineView : UIView{
    
    NSInteger _lineLength;
    NSInteger _lineSpacing;
    UIColor *_lineColor;
    CGFloat _height;
}

- (instancetype)initWithFrame:(CGRect)frame withLineLength:(NSInteger)lineLength withLineSpacing:(NSInteger)lineSpacing withLineColor:(UIColor *)lineColor;

@end

NS_ASSUME_NONNULL_END
