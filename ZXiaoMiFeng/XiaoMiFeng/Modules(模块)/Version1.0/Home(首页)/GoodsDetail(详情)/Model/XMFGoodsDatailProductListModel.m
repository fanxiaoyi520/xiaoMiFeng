//
//  XMFGoodsDatailProductListModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDatailProductListModel.h"

@implementation XMFGoodsDatailProductListModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"productId":@"id",
             
             };
}


@end
