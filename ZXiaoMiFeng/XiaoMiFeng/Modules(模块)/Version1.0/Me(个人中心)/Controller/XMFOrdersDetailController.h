//
//  XMFOrdersDetailController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/18.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCellModel;

@interface XMFOrdersDetailController : XMFBaseViewController


-(instancetype)initWithModel:(XMFOrdersCellModel *)ordersModel;

//订单详情页操作block
@property (nonatomic, copy) void (^ordersDetailSuccessBlock)(NSInteger buttonTag);


@end

NS_ASSUME_NONNULL_END
