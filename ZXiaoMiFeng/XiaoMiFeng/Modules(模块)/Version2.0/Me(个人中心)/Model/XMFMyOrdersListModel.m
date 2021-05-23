//
//  XMFMyOrdersListModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersListModel.h"


@implementation XMFMyOrdersListRefundInfoDtoModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


@end




@implementation XMFMyOrdersListHandleOptionModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"orderDelete":@"delete",
             
             
             };
}


@end




@implementation XMFMyOrdersListGoodsListModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


//懒加载
-(NSMutableArray *)picUrlsArr{
    
    if (_picUrlsArr == nil) {
        _picUrlsArr = [[NSMutableArray alloc] init];
    }
    return _picUrlsArr;
}

@end



@implementation XMFMyOrdersListModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        
        @"goodsList" : [XMFMyOrdersListGoodsListModel class],
        
//        @"handleOption" : [XMFMyOrdersListHandleOptionModel class],
        
        @"refundInfoDto":[XMFMyOrdersListRefundInfoDtoModel class]
        
    };
}


//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


@end
