//
//  XMFConfirmOrderModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFConfirmOrderModel.h"



@implementation XMFConfirmOrderGoodsListModel



@end




@implementation XMFConfirmOrderChildOrderListModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        
        @"goodsList" : [XMFConfirmOrderGoodsListModel class],
        
    };
}


@end




@implementation XMFConfirmOrderModel


//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        
        @"childOrderList" : [XMFConfirmOrderChildOrderListModel class],
        
    };
}


@end
