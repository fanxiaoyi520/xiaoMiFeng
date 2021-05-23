//
//  UILabel+AlignmentLeftAndRight.h
//  ZFDaYaNews
//
//  Created by 小蜜蜂 on 2019/11/15.
//  Copyright © 2019 Jellyfish. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (AlignmentLeftAndRight)

//两端对齐

- (void)textAlignmentLeftAndRight;

//指定Label以最后的冒号对齐的width两端对齐

- (void)textAlignmentLeftAndRightWith:(CGFloat)labelWidth;


@end

NS_ASSUME_NONNULL_END
