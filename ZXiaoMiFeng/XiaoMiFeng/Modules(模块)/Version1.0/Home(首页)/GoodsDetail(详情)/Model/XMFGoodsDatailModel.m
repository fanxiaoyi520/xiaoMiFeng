//
//  XMFGoodsDatailModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDatailModel.h"
#import "XMFGoodsDatailInfoModel.h"
#import "XMFGoodsDetailSpecificationListModel.h"
#import "XMFGoodsDatailProductListModel.h"
#import "XMFGoodsDetailIssueModel.h"//购买说明
#import "XMFGoodsDetailAttributeModel.h"//商品参数


@implementation XMFGoodsDatailModel

//设置某个属性为model类型
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"specificationList" : [XMFGoodsDetailSpecificationListModel class],
             
             @"info":[XMFGoodsDatailInfoModel class],
             
             @"productList":[XMFGoodsDatailProductListModel class],
             
             @"issue":[XMFGoodsDetailIssueModel class],
             
             @"attribute":[XMFGoodsDetailAttributeModel class]
            
             
             };
}



-(NSMutableArray *)galleryURLArr{
    
    if (_galleryURLArr == nil) {
        _galleryURLArr = [[NSMutableArray alloc] init];
    }
    return _galleryURLArr;
    
    
}

@end
