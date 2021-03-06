//
//  XMFMyOrdersDetailController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/10.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel;

@interface XMFMyOrdersDetailController : XMFBaseViewController

-(instancetype)initWithOrderId:(NSString *)orderId;

/** æä½çblock */
@property (nonatomic, copy) void (^myOrdersDetailBlock)(XMFMyOrdersListModel *listModel);

@end

NS_ASSUME_NONNULL_END
