//
//  XMFMyCollectionModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class XMFHomeGoodsCellModel;



@interface XMFMyCollectionSonModel : NSObject

/** 收藏时间 */
@property (nonatomic, copy) NSString * collectAddTime;
/** 收藏ID */
@property (nonatomic, copy) NSString * collectId;
/** 专柜价格 */
@property (nonatomic, copy) NSString * goodsCounterPrice;
/** 商品ID */
@property (nonatomic, copy) NSString * goodsId;
/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;
/** 商品图片 */
@property (nonatomic, copy) NSString * goodsPicUrl;
/** 实际价格 */
@property (nonatomic, copy) NSString * goodsRetailPrice;
/** 商品销量 */
@property (nonatomic, copy) NSString * goodsSalesNum;
/** 是否包邮（0=否；1=是） */
@property (nonatomic, copy) NSString * goodsShipFlag;
/** 是否包税（0=否；1=是） */
@property (nonatomic, copy) NSString * goodsTaxFlag;

/** 商品是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** 失效类型(0=未失效；1=缺货；2=下架) */
@property (nonatomic, copy) NSString *invalidType;


@end



@interface XMFMyCollectionModel : NSObject

/** 有效收藏列表 */
//@property (nonatomic, strong) NSArray<XMFMyCollectionSonModel *> * enabledList;

@property (nonatomic, strong) NSArray<XMFHomeGoodsCellModel *> * enabledList;


/** 无效收藏列表收藏时间 */
//@property (nonatomic, strong) NSArray<XMFMyCollectionSonModel *> * invalidList;

@property (nonatomic, strong) NSArray<XMFHomeGoodsCellModel *> * invalidList;



@end

NS_ASSUME_NONNULL_END
