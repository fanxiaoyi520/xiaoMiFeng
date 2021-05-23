//
//  XMFHomeGoodsDetailModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/1.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsDetailModel.h"
#import "XMFGoodsCommentModel.h"//评论列表的model


@implementation XMFHomeGoodsDetailPurchaseInstructionsModel

@end

/*
@implementation XMFHomeGoodsDetailGoodsCommentsModel

//属性名称替换或者映射:前面为定义的名称，后面为服务器返回需要映射的名称
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"commentId":@"id",
             
             
             };
}

@end
 */

@implementation XMFHomeGoodsDetailGoodsAttributesModel

@end

@implementation XMFHomeGoodsDetailGallerysModel

@end

@implementation XMFHomeGoodsDetailModel


//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"gallerys" : [XMFHomeGoodsDetailGallerysModel class],
        @"goodsAttributes" : [XMFHomeGoodsDetailGoodsAttributesModel class],
        @"goodsComments" : [XMFGoodsCommentModel class],
        @"purchaseInstructions" : [XMFHomeGoodsDetailPurchaseInstructionsModel class],
             
             };
}

@end
