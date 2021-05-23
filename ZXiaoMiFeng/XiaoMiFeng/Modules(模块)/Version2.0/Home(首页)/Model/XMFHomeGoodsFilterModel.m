//
//  XMFHomeGoodsFilterModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsFilterModel.h"

@implementation XMFHomeGoodsFilterSonModel


@end


@implementation XMFHomeGoodsFilterModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"standardArr" : [XMFHomeGoodsFilterSonModel class],
       
             };
}


@end
