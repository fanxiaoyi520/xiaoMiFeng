//
//  XMFGoodsInvalidCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellGoodsModel,XMFMyCollectionSonModel,XMFHomeGoodsCellModel;

@interface XMFGoodsInvalidCell : UITableViewCell

/** 购物车商品列表无效商品model */
@property (nonatomic, strong) XMFShoppingCartCellGoodsModel *cartInvalidModel;

/** 收藏商品列表无效商品model */
//@property (nonatomic, strong) XMFMyCollectionSonModel *collectionInvalidModel;

/** 收藏商品列表无效商品model */
@property (nonatomic, strong) XMFHomeGoodsCellModel *collectionInvalidModel;

/** cell的row */
@property (nonatomic, assign) NSInteger cellRow;

/** 失效的数量 */
@property (nonatomic, assign) NSInteger invalidCount;


@end

NS_ASSUME_NONNULL_END
