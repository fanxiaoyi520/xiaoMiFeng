//
//  XMFShoppingCartCellModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingCartCellModel.h"


@implementation XMFShoppingCartCellGoodsModel


//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


@end


/** 中间层model */
@implementation XMFShoppingCartCellGoodsInfoModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"cartGoodsRespVos" : [XMFShoppingCartCellGoodsModel class],

             };
}



@end



/** 最外层model */
@implementation XMFShoppingCartCellModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        
        @"invalidBcGoods" : [XMFShoppingCartCellGoodsModel class],
             
        @"invalidCcGoods" : [XMFShoppingCartCellGoodsModel class],
       
        @"bcGoodsInfos" : [XMFShoppingCartCellGoodsInfoModel class],
        
        @"ccGoodsInfos" : [XMFShoppingCartCellGoodsInfoModel class],
      
             
             };
}

@end
