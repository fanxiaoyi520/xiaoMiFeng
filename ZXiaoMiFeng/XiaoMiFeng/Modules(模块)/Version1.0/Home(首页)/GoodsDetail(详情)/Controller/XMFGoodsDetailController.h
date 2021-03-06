//
//  XMFGoodsDetailController.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/5/8.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsDetailController : XMFBaseViewController

@property (nonatomic, copy) NSString *goodsIdStr;


/// εζΆζζΆθεεηblock
@property (nonatomic, copy) void (^goodsCollectAddOrDeleteBlock)(NSString *goodsIdStr, BOOL isCollection);

@end

NS_ASSUME_NONNULL_END
