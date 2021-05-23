//
//  XMFMyAllOrdersController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/28.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    fromPengingDefault,//默认，全部
    fromPendingPay,//待付款
    fromPendingDelivery,//待发货
    fromPendingReceipt,//待收货
    fromPendingRebuy,//已完成（待重买）
    fromCancelPay,//来自取消付款
    fromPaySuccess,//来自付款成功
} myAllOrdersJumpFromType;


@interface XMFMyAllOrdersController : XMFBaseViewController

-(instancetype)initWithFromType:(myAllOrdersJumpFromType)fromType;

/** 返回的block */
@property (nonatomic, copy) void (^myAllOrdersBackBlock)(void);


@end

NS_ASSUME_NONNULL_END
