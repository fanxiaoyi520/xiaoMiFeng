//
//  XMFMyOrdersListCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListGoodsListModel;

@interface XMFMyOrdersListCell : UITableViewCell

/** 我的订单列表model */
@property (nonatomic, strong) XMFMyOrdersListGoodsListModel *goodsListModel;

/** 订单详情商品model */
@property (nonatomic, strong) XMFMyOrdersListGoodsListModel *detailGoodsModel;

@end

NS_ASSUME_NONNULL_END
