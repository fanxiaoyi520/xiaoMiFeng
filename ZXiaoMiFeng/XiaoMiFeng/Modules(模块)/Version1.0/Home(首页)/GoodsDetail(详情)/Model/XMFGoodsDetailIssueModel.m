//
//  XMFGoodsDetailIssueModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailIssueModel.h"

@implementation XMFGoodsDetailIssueModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"issueId":@"id",
             
             };
}


@end
