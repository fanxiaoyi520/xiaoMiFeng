//
//  XMFShoppingCartModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/24.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFShoppingCartModel.h"
#import "XMFShoppingCartTotalModel.h"
#import "XMFShoppingCartGoodModel.h"


@implementation XMFShoppingCartModel


//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"cartList" : [XMFShoppingCartGoodModel class],
             
             };
}


@end
