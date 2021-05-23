//
//  XMFHomeGoodsCellModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFHomeGoodsCellModel : NSObject

/** 购物车数量 */
@property (nonatomic, copy) NSString * cartNum;
/** 专柜价格 */
@property (nonatomic, copy) NSString * counterPrice;
/** 商品id */
@property (nonatomic, copy) NSString * goodsId;
/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;
/** 税费 */
@property (nonatomic, copy) NSString * incomeTax;

/** 是否组合商品 */
@property (nonatomic, assign) BOOL isGroupGoods;

/** 商品图片 */
@property (nonatomic, copy) NSString * picUrl;

/** 产品id */
@property (nonatomic, copy) NSString *productId;

/** VIP尊享版的商品图片 */
@property (nonatomic, copy) NSString *simplifyPicUrl;

/** 零售价格 */
@property (nonatomic, copy) NSString * retailPrice;

/** 销量 */
@property (nonatomic, copy) NSString * salesNum;


/** 商品显示状态 0-失效 3-上架 4-下架 6-缺货 */
@property (nonatomic, copy) NSString *shelveStatus;


/** 是否包税 0-否 1-是 */
@property (nonatomic, copy) NSString * taxFlag;

/** 是否包邮 0-否 1-是 */
@property (nonatomic, copy) NSString * freeShipping;

/** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
@property (nonatomic, copy) NSString *taxType;


/** 商品是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 库存 */
@property (nonatomic, copy) NSString *stock;


@end

NS_ASSUME_NONNULL_END
