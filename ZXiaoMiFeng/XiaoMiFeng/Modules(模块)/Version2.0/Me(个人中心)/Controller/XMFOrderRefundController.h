//
//  XMFOrderRefundController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/11.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel;


@interface XMFOrderRefundController : XMFBaseViewController

-(instancetype)initWithListModel:(XMFMyOrdersListModel *)listModel;

/** éæ¬¾çblock */
@property (nonatomic, copy) void (^orderRefundBlock)(void);


@end

NS_ASSUME_NONNULL_END
