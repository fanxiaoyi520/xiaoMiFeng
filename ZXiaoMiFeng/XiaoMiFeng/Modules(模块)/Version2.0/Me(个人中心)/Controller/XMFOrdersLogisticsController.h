//
//  XMFOrdersLogisticsController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel;

@interface XMFOrdersLogisticsController : XMFBaseViewController

-(instancetype)initWithOrderListModel:(XMFMyOrdersListModel *)listModel;


@end

NS_ASSUME_NONNULL_END
