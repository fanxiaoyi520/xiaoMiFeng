//
//  XMFHomeSonViewController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/16.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//获取购物车商品列表的方式
typedef enum : NSUInteger {
    refreshData = 1,
    updateCart,
} getCartIndexType;


@class XMFGoodsClassifyModel;

@interface XMFHomeSonViewController : XMFBaseViewController

//顶部的view显示与否
@property (nonatomic, copy) void (^headerViewShowBlock)(BOOL isShow);

//刷新block
@property (nonatomic, copy) void (^refreshBlock)(void);


-(instancetype)initWithClassifyModel:(XMFGoodsClassifyModel *)model;

@end

NS_ASSUME_NONNULL_END
