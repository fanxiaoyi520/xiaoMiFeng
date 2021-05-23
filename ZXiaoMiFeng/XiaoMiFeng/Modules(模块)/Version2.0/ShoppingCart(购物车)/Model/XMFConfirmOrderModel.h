//
//  XMFConfirmOrderModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XMFConfirmOrderGoodsListModel : NSObject

/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;
/** 税费 */
@property (nonatomic, copy) NSString * incomeTax;
/** 税商品货品的数量费 */
@property (nonatomic, copy) NSString * number;
/** 商品图片 */
@property (nonatomic, copy) NSString * picUrl;
/** 价格 */
@property (nonatomic, copy) NSString * price;
/** 商品规格 */
@property (nonatomic, strong) NSArray * specifications;
/** 是否包税 */
@property (nonatomic, copy) NSString * taxFlag;
/** 商品单位 */
@property (nonatomic, copy) NSString * unit;
/** 是否包邮 */
@property (nonatomic, copy) NSString * freeShipping;

/** 供应商名称 */
@property (nonatomic, copy) NSString *supplierName;

/** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
@property (nonatomic, copy) NSString *orderType;

@end


@interface XMFConfirmOrderChildOrderListModel : NSObject

/** 订单商品列表 */
@property (nonatomic, strong) NSArray<XMFConfirmOrderGoodsListModel *> * goodsList;

/** 订单编号 */
@property (nonatomic, copy) NSString * orderSn;

/** 订单运费 */
@property (nonatomic, copy) NSString * postagePrice;

/** 订单类型 1–bc 2–cc */
@property (nonatomic, copy) NSString *orderType;

/** 仓库名称 */
@property (nonatomic, copy) NSString *warehouseName;

@end



@interface XMFConfirmOrderModel : NSObject

/** 购物车ID */
@property (nonatomic, strong) NSArray * cartIds;
/** 子订单信息 */
@property (nonatomic, strong) NSArray<XMFConfirmOrderChildOrderListModel *> * childOrderList;
/** 商品数量 */
@property (nonatomic, copy) NSString * goodsCount;
/** 商品总金额 */
@property (nonatomic, copy) NSString * goodsTotalPrice;
/** 是否拆单 */
@property (nonatomic, copy) NSString * isSplit;
/** 父级订单编号 */
@property (nonatomic, copy) NSString * orderSn;
/** 总运费 */
@property (nonatomic, copy) NSString * postageTotalPrice;
/** 其他优惠 */
@property (nonatomic, copy) NSString * reducePrice;

/** 商城优惠 */
@property (nonatomic, copy) NSString *otherDiscount;

/** 总税费 */
@property (nonatomic, copy) NSString * taxTotalPrice;
/** 总金额 */
@property (nonatomic, copy) NSString * totalPrice;


@end

NS_ASSUME_NONNULL_END
