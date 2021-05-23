//
//  XMFOverseaShoppingController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/20.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellModel;

@interface XMFOverseaShoppingController : XMFBaseViewController

/** 蜜蜂海淘的block */
@property (nonatomic, copy) void (^overseaShoppingBlock)(XMFShoppingCartCellModel *_Nullable overseaModel);


@end

NS_ASSUME_NONNULL_END
