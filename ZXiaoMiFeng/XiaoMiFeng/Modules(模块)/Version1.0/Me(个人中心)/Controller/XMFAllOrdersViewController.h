//
//  XMFAllOrdersViewController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//说明：下面的顺序和赋值不能改变，因为与订单cell的orderStatusType是对应的

typedef enum : NSUInteger {
    allOrders,//全部
    pendingPayOrders,//待付款
    pendingDeliveryOrders,//待发货
    pendingReceiptOrders,//待收货
    pendingCommentOrders//待评价
    
} ordersShowType;

@interface XMFAllOrdersViewController : XMFBaseViewController

-(instancetype)initWithOrdersShowType:(ordersShowType)showType;

@end

NS_ASSUME_NONNULL_END
