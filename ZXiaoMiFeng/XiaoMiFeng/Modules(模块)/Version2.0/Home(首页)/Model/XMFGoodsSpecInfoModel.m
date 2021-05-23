//
//  XMFGoodsSpecInfoModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/11/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsSpecInfoModel.h"

//第五层
@implementation XMFGoodsSpecInfoSpecValuesModel



@end



//第四层
@implementation XMFGoodsSpecInfoFastFindNodeValuesModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"values" : [XMFGoodsSpecInfoSpecValuesModel class],
       
             };
}



@end




//第三层
@implementation XMFGoodsSpecInfoFastFindNodeModel


//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"fastFindNode" : [XMFGoodsSpecInfoFastFindNodeValuesModel class],
       
             };
}


@end



//第二层
@implementation XMFGoodsSpecInfoSpecsModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"specValues" : [XMFGoodsSpecInfoFastFindNodeModel class],
       
             };
}

@end



//第一层
@implementation XMFGoodsSpecInfoModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"specs" : [XMFGoodsSpecInfoSpecsModel class],
       
             };
}

@end
