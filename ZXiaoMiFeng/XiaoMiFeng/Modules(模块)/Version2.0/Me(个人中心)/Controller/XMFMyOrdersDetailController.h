//
//  XMFMyOrdersDetailController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel;

@interface XMFMyOrdersDetailController : XMFBaseViewController

-(instancetype)initWithOrderId:(NSString *)orderId;

/** 操作的block */
@property (nonatomic, copy) void (^myOrdersDetailBlock)(XMFMyOrdersListModel *listModel);

@end

NS_ASSUME_NONNULL_END
