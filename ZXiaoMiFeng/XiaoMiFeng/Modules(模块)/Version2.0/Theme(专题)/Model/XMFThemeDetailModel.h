//
//  XMFThemeDetailModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XMFThemeDetailListModel : NSObject

/** 购物车数量 */
@property (nonatomic, copy) NSString * cartNum;
/** 专柜价格 */
@property (nonatomic, copy) NSString * counterPrice;
/** 是否包邮 */
@property (nonatomic, copy) NSString * freeShipping;
/** 商品id */
@property (nonatomic, copy) NSString * goodsId;
/** 商品名称 */
@property (nonatomic, copy) NSString * goodsName;
/** 税费 */
@property (nonatomic, copy) NSString * incomeTax;
/** 商品图片 */
@property (nonatomic, copy) NSString * picUrl;
/** 零售价格 */
@property (nonatomic, copy) NSString * retailPrice;
/** 销量 */
@property (nonatomic, copy) NSString * salesNum;
/** 是否包税 */
@property (nonatomic, copy) NSString * taxFlag;

/** 是否组合商品 */
@property (nonatomic, assign) BOOL isGroupGoods;

/** 库存 */
@property (nonatomic, copy) NSString *stock;

/** 产品id */
@property (nonatomic, copy) NSString *productId;

@end


@interface XMFThemeDetailModel : NSObject

/** 主题颜色 */
@property (nonatomic, copy) NSString * backgroundColor;

/** 主题背景图片 */
@property (nonatomic, copy) NSString * backgroundPic;

/** 主题名称 */
@property (nonatomic, copy) NSString *topicName;

@property (nonatomic, strong) NSArray<XMFThemeDetailListModel *> * goodsList;

@end

NS_ASSUME_NONNULL_END
