//
//  XMFConfirmOrderController.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/2.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
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


/** εΊε­δΈθΆ³ηblock */
@property (nonatomic, copy) void (^goodsStockoutBlock)(void);



@end

NS_ASSUME_NONNULL_END
