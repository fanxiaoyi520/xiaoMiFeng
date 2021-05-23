//
//  XMFShoppingCartModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingCartModel.h"
#import "XMFShoppingCartTotalModel.h"
#import "XMFShoppingCartGoodModel.h"


@implementation XMFShoppingCartModel


//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"cartList" : [XMFShoppingCartGoodModel class],
             
             };
}


@end
