//
//  XMFInternationalShoppingController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2021/1/20.
//  Copyright Â© 2021 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellModel;

@interface XMFInternationalShoppingController : XMFBaseViewController

/** èèæµ·æ·çblock */
@property (nonatomic, copy) void (^internationalShoppingBlock)(XMFShoppingCartCellModel *_Nullable internationalModel);



@end

NS_ASSUME_NONNULL_END
