//
//  XMFGoodsDatailModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/27.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFGoodsDatailModel.h"
#import "XMFGoodsDatailInfoModel.h"
#import "XMFGoodsDetailSpecificationListModel.h"
#import "XMFGoodsDatailProductListModel.h"
#import "XMFGoodsDetailIssueModel.h"//è´­ä¹°è¯´æ
#import "XMFGoodsDetailAttributeModel.h"//åååæ°


@implementation XMFGoodsDatailModel

//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
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
