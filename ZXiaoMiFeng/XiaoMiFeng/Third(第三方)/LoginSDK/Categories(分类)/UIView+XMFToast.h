//
//  UIView+XMFToast.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/7.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (XMFToast)

/**
 提示框自定义方法
 
 默认显示时间为：自己设定
 
 默认显示位置为：居中
 
 */
- (void)makeToastOnCenter:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
