//
//  XMFGoodsDetailSpecificationListModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/27.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFGoodsDetailSpecificationListModel.h"
#import "XMFGoodsDetailValueListModel.h"


@implementation XMFGoodsDetailSpecificationListModel

//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"valueList" : [XMFGoodsDetailValueListModel class],
            
             
             };
}


@end
