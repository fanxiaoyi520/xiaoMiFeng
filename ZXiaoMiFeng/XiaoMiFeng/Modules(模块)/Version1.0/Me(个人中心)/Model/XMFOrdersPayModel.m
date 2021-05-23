//
//  XMFOrdersPayModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersPayModel.h"

@implementation XMFOrdersPayPopupModel



@end


@implementation XMFOrdersPayModel


//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"popup" : [XMFOrdersPayPopupModel class],
             
             };
}




@end
