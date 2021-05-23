//
//  XMFMyCollectionModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyCollectionModel.h"
#import "XMFHomeGoodsCellModel.h"//首页商品model



@implementation XMFMyCollectionSonModel


@end

@implementation XMFMyCollectionModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"enabledList" : [XMFHomeGoodsCellModel class],
        @"invalidList" : [XMFHomeGoodsCellModel class],
             
             };
}


@end
