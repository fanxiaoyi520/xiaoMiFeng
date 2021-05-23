//
//  XMFConfirmOrderController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    fromGoodsDetailVc,
    fromShoppingCartVc,
} confirmOrderType;

@class XMFConfirmOrderModel;


@interface XMFConfirmOrderController : XMFBaseViewController

-(instancetype)initWithCartId:(NSArray *)cartIdsArr listArr:(NSArray *_Nullable)listArr confirmOrderModel:(XMFConfirmOrderModel *_Nullable)confirmOrderModel confirmOrderType:(confirmOrderType)fromType;


/** 库存不足的block */
@property (nonatomic, copy) void (^goodsStockoutBlock)(void);



@end

NS_ASSUME_NONNULL_END
