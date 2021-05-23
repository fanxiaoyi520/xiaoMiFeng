//
//  XMFGoodsHTMLDetailController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDatailModel;
@class XMFGoodsRecommendModel;


@interface XMFGoodsHTMLDetailController : XMFBaseViewController

-(instancetype)initWith:(XMFGoodsDatailModel *)detailModel recommendData:(NSMutableArray<XMFGoodsRecommendModel *> *)dataArr;

//猜你喜欢点击商品
@property (nonatomic, copy) void (^goodsDidTapBlock)(XMFGoodsRecommendModel *model);


@end

NS_ASSUME_NONNULL_END
