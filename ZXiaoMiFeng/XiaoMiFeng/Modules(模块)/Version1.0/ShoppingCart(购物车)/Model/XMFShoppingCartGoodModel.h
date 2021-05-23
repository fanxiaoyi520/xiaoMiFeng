//
//  XMFShoppingCartGoodModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFShoppingCartGoodModel : NSObject

@property (nonatomic, copy) NSString *cartId;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *goodsSn;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, copy) NSString *number;

@property (nonatomic, strong) NSArray *specifications;

@property (nonatomic, copy) NSString *checked;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *version;

/**
 
 shipmentRegion=0 国内自营商品
 shipmentRegion=1 海外自营商品
 shipmentRegion=11 海外奶粉专区
 
 */

@property (nonatomic, copy) NSString *shipmentRegion;



@end

/**
 
 {
   "id": 4706,
   "userId": 32355,
   "goodsId": 1181019,
   "goodsSn": "201810170681225",
   "goodsName": "【测试商品勿删 】300根全棉羽丝绒抱枕芯",
   "productId": 2146,
   "price": 99.99,
   "number": 2,
   "specifications": [
     "200*150"
   ],
   "checked": true,
   "picUrl": "https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/n89mkecwd33jwy8hq0av.jpg",
   "deleted": false,
   "version": 0,
   "shipmentRegion": 1
 }
 
 
 */

NS_ASSUME_NONNULL_END
