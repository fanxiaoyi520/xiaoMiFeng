//
//  XMFHomeGoodsDetailModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/1.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsCommentModel;

//里层model类型四
@interface  XMFHomeGoodsDetailPurchaseInstructionsModel : NSObject

@property (nonatomic, copy) NSString * answer;
@property (nonatomic, copy) NSString * question;

@end

/*
//里层model类型三
@interface  XMFHomeGoodsDetailGoodsCommentsModel : NSObject

@property (nonatomic, copy) NSString *addTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *commentId;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSArray *picUrls;


@end

*/

//里层model类型二
@interface  XMFHomeGoodsDetailGoodsAttributesModel : NSObject


@property (nonatomic, copy) NSString *attributeName;

@property (nonatomic, copy) NSString *attributeValue;



@end

//里层model类型一
@interface  XMFHomeGoodsDetailGallerysModel : NSObject

@property (nonatomic, copy) NSString * image;


@end


//最外层model
@interface XMFHomeGoodsDetailModel : NSObject

/** 是否收藏 */
@property (nonatomic, copy) NSString * collected;
/** 评价数量 */
@property (nonatomic, copy) NSString * commentCount;
/** 专柜价格 */
@property (nonatomic, copy) NSString * counterPrice;
/** 产地 */
@property (nonatomic, copy) NSString * country;
/** 产地图标 */
@property (nonatomic, copy) NSString * countryIcon;
/** 商品详情 */
@property (nonatomic, copy) NSString * detail;
/** 是否包邮 */
@property (nonatomic, copy) NSString * freeShipping;
/** 商品轮播图 */
@property (nonatomic, strong) NSArray<XMFHomeGoodsDetailGallerysModel *> * gallerys;
/** 商品参数 */
@property (nonatomic, strong) NSArray<XMFHomeGoodsDetailGoodsAttributesModel *> * goodsAttributes;
/** 评论列表 */
@property (nonatomic, strong) NSArray<XMFGoodsCommentModel *> * goodsComments;
/** 商品id */
@property (nonatomic, copy) NSString * goodsId;
/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;
/** 购买说明 */
@property (nonatomic, strong) NSArray<XMFHomeGoodsDetailPurchaseInstructionsModel *> * purchaseInstructions;
/** 零售价 */
@property (nonatomic, copy) NSString * retailPrice;
/** 销量 */
@property (nonatomic, copy) NSString * salesNum;
/** 分享二维码 */
@property (nonatomic, copy) NSString * shareUrl;
/** 是否包税 */
@property (nonatomic, copy) NSString * taxFlag;
/** 商品主图 */
@property (nonatomic, copy) NSString *picUrl;
/** 商品状态 0-失效 3-上架 4-下架 6-缺货 */
@property (nonatomic, copy) NSString *goodsStatus;

/** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
@property (nonatomic, copy) NSString *taxType;

/** 税金 */
@property (nonatomic, copy) NSString *incomeTax;

/** 运费 */
@property (nonatomic, copy) NSString *postage;

/** 是否组合商品 */
@property (nonatomic, assign) BOOL isGroupGoods;

/** 产品id */
@property (nonatomic, copy) NSString *productId;

/** 库存 */
@property (nonatomic, copy) NSString *stock;

/** 供应商名称 */
@property (nonatomic, copy) NSString *supplierName;

/** 仓库名称 */
@property (nonatomic, copy) NSString *warehouseName;


@end

NS_ASSUME_NONNULL_END
