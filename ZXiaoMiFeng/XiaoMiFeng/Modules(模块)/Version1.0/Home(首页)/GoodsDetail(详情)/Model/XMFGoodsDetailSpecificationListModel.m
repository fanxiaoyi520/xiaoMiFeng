//
//  XMFGoodsDetailSpecificationListModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailSpecificationListModel.h"
#import "XMFGoodsDetailValueListModel.h"


@implementation XMFGoodsDetailSpecificationListModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"valueList" : [XMFGoodsDetailValueListModel class],
            
             
             };
}


@end
