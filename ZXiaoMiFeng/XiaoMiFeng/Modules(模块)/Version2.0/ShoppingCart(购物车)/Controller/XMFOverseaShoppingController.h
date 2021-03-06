//
//  XMFOverseaShoppingController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2021/1/20.
//  Copyright Â© 2021 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellModel;

@interface XMFOverseaShoppingController : XMFBaseViewController

/** èèæµ·æ·çblock */
@property (nonatomic, copy) void (^overseaShoppingBlock)(XMFShoppingCartCellModel *_Nullable overseaModel);


@end

NS_ASSUME_NONNULL_END
