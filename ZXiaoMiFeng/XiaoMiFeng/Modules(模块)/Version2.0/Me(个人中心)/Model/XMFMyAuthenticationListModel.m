//
//  XMFMyAuthenticationListModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyAuthenticationListModel.h"

@implementation XMFMyAuthenticationListModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"authenId":@"id",
             
             
             };
}

@end
