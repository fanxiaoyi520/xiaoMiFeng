//
//  UIView+XMFToast.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/7.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "UIView+XMFToast.h"
#import "UIView+Toast.h"

@implementation UIView (XMFToast)


/**
提示框自定义方法

默认显示时间为：自己设定

默认显示位置为：居中

*/
- (void)makeToastOnCenter:(NSString *)message{
    
    [self makeToast:message duration:1.f position:CSToastPositionCenter];
    
    
}

@end
