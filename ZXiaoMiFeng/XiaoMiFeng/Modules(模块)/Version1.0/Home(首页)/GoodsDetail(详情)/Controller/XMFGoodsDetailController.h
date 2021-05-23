//
//  XMFGoodsDetailController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsDetailController : XMFBaseViewController

@property (nonatomic, copy) NSString *goodsIdStr;


/// 取消或收藏商品的block
@property (nonatomic, copy) void (^goodsCollectAddOrDeleteBlock)(NSString *goodsIdStr, BOOL isCollection);

@end

NS_ASSUME_NONNULL_END
