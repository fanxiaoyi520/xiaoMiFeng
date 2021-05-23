//
//  XMFShoppingSplitOrdersModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/27.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFShoppingSplitOrdersGoodsModel : NSObject

@property (nonatomic, copy) NSString * cartId;
@property (nonatomic, copy) NSString * goodsId;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * productId;
/**
 *  商品图片
 */
@property (nonatomic, copy) NSString * url;



@end



@interface XMFShoppingSplitOrdersModel : NSObject


@property (nonatomic, strong) NSArray<XMFShoppingSplitOrdersGoodsModel *> * ordersGoods;

@end

NS_ASSUME_NONNULL_END
