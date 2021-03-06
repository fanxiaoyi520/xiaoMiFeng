//
//  XMFGoodsInvalidCell.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/8/31.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartCellGoodsModel,XMFMyCollectionSonModel,XMFHomeGoodsCellModel;

@interface XMFGoodsInvalidCell : UITableViewCell

/** θ΄­η©θ½¦εεεθ‘¨ζ ζεεmodel */
@property (nonatomic, strong) XMFShoppingCartCellGoodsModel *cartInvalidModel;

/** ζΆθεεεθ‘¨ζ ζεεmodel */
//@property (nonatomic, strong) XMFMyCollectionSonModel *collectionInvalidModel;

/** ζΆθεεεθ‘¨ζ ζεεmodel */
@property (nonatomic, strong) XMFHomeGoodsCellModel *collectionInvalidModel;

/** cellηrow */
@property (nonatomic, assign) NSInteger cellRow;

/** ε€±ζηζ°ι */
@property (nonatomic, assign) NSInteger invalidCount;


@end

NS_ASSUME_NONNULL_END
