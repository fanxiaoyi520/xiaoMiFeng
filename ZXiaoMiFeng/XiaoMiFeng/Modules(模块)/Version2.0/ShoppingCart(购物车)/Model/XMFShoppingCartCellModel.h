//
//  XMFShoppingCartCellModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** 商品的model */

@interface XMFShoppingCartCellGoodsModel : NSObject
/** 购物车中商品是否选择状态 */
@property (nonatomic, copy) NSString * checked;
/** 专柜价格，原价 */
@property (nonatomic, copy) NSString * counterPrice;
/** 是否包邮 */
@property (nonatomic, copy) NSString * freeShipping;
/** 商品id */
@property (nonatomic, copy) NSString * goodsId;
/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;
/** 商品状态 0-失效 3-上架 4-下架 6-缺货 */
@property (nonatomic, copy) NSString * goodsStatus;
/** 主键id */
@property (nonatomic, copy) NSString * keyId;
/** 税费 */
@property (nonatomic, copy) NSString * incomeTax;
/** 商品货品的数量 */
@property (nonatomic, copy) NSString * number;
/** 商品图片 */
@property (nonatomic, copy) NSString * picUrl;
/** 运费 */
@property (nonatomic, copy) NSString * postage;
/** 货品id */
@property (nonatomic, copy) NSString * productId;
/** 价格,实际价格 */
@property (nonatomic, copy) NSString * retailPrice;
/** 0-国内自营商品 1-海外自营商品 11-海外奶粉专区 */
@property (nonatomic, copy) NSString * shipmentRegion;
/** 商品规格 */
@property (nonatomic, strong) NSArray * specifications;
/** 是否包税 */
@property (nonatomic, copy) NSString * taxFlag;


/** 限购数量 */
@property (nonatomic, copy) NSString *limitBuyNum;
/** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
@property (nonatomic, copy) NSString *taxType;

/** 商品货品库存数量 */
@property (nonatomic, copy) NSString *stock;


@end



/** 中间层的model */
@interface XMFShoppingCartCellGoodsInfoModel : NSObject

/** 购物车商品数组 */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsModel *> *cartGoodsRespVos;

/** 仓库id */
@property (nonatomic, copy) NSString *warehouseId;

/** 仓库名称 */
@property (nonatomic, copy) NSString *warehouseName;

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 是否折叠 */
@property (nonatomic, assign) BOOL isfolded;



@end


/** 最外层的model */

@interface XMFShoppingCartCellModel : NSObject

/** 商品数量 */
@property (nonatomic, assign) NSString * goodsNum;

/** 蜜蜂国际-bc的失效商品 */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsModel *> * invalidBcGoods;

/** 蜜蜂海淘-cc的失效商品 */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsModel *> * invalidCcGoods;


/** 蜜蜂国际-bc的金额总额 */
@property (nonatomic, copy) NSString *bcAmount;

/** 蜜蜂海淘-cc的金额总额 */
@property (nonatomic, copy) NSString *ccAmount;


/** 蜜蜂国际-bc */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsInfoModel *> * bcGoodsInfos;

/** 蜜蜂海淘-cc */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsInfoModel *> * ccGoodsInfos;



@end

NS_ASSUME_NONNULL_END
