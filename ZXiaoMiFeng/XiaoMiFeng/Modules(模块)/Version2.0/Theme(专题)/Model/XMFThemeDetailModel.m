//
//  XMFThemeDetailModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFThemeDetailModel.h"


@implementation XMFThemeDetailListModel



@end

@implementation XMFThemeDetailModel


//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"goodsList" : [XMFThemeDetailListModel class],
      
             
             };
}



@end
