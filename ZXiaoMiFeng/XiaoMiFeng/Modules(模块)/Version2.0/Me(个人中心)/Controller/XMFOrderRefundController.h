//
//  XMFOrderRefundController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel;


@interface XMFOrderRefundController : XMFBaseViewController

-(instancetype)initWithListModel:(XMFMyOrdersListModel *)listModel;

/** 退款的block */
@property (nonatomic, copy) void (^orderRefundBlock)(void);


@end

NS_ASSUME_NONNULL_END
