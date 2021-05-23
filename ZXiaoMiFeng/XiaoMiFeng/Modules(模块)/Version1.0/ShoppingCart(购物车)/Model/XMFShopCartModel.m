//
//  XMFShopCartModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/29.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShopCartModel.h"

//最里面层的model
@implementation XMFShopCartDetailModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"cartId":@"id",
             
             @"isChoose":@"checked"
             
             };
}


@end


//中间层的model
@implementation XMFShopCartMiddleModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"cartMiddleList" : [XMFShopCartDetailModel class],
             
             };
}


-(NSMutableArray *)recordCdModelSelected{
    
    if (_recordCdModelSelected == nil) {
        _recordCdModelSelected = [[NSMutableArray alloc] init];
    }
    return _recordCdModelSelected;
    
}

@end


//最外层的model
@implementation XMFShopCartModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"cartNewList":[XMFShopCartMiddleModel class],
             @"cartList":[XMFShopCartDetailModel class],
             
             };
}



-(NSMutableArray *)recordArr{
    
    if (_recordArr == nil) {
        _recordArr = [[NSMutableArray alloc] init];
    }
    return _recordArr;
    
}


@end
