//
//  XMFHomeGoodsPropertyModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



/** 商品货品信息展示对象 */
@interface  XMFHomeGoodsPropertyProductsModel: NSObject

@property (nonatomic, copy) NSString * counterPrice;
@property (nonatomic, copy) NSString * freeShipping;
@property (nonatomic, copy) NSString * incomeTax;
@property (nonatomic, copy) NSString * limitBuyNum;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, strong) NSArray * specifications;
@property (nonatomic, copy) NSString * stock;
@property (nonatomic, copy) NSString * taxFlag;
@property (nonatomic, copy) NSString * url;

@end




/** 商品规格值对象 */
@interface XMFHomeGoodsPropertySpecificationsValuesModel : NSObject

@property (nonatomic, copy) NSString * checked;
@property (nonatomic, copy) NSString * specificationId;
@property (nonatomic, copy) NSString * value;

@end




/** 商品规格展示对象 */
@interface XMFHomeGoodsPropertySpecificationsModel : NSObject

@property (nonatomic, strong) NSArray<XMFHomeGoodsPropertySpecificationsValuesModel *> * goodsSpecificationValues;
@property (nonatomic, copy) NSString * name;


@end



/** 商品货品以及规格相关信息 */
@interface XMFHomeGoodsPropertyModel : NSObject

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, strong) NSArray<XMFHomeGoodsPropertyProductsModel *> * goodsProducts;
@property (nonatomic, strong) NSArray<XMFHomeGoodsPropertySpecificationsModel *> * goodsSpecifications;

/** 人工加入：商品名称 */
@property (nonatomic, copy) NSString *goodsName;

@end

NS_ASSUME_NONNULL_END
