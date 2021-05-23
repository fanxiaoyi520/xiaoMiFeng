//
//  UIView+Visibility.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/17.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Visibility)

- (BOOL)visible;
- (void)setVisible:(BOOL)visible;
- (void)setVisible:(BOOL)visible animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
