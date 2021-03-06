//
//  XMFShoppingCartGoodModel.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/4/24.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
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
 
 shipmentRegion=0 ε½εθͺθ₯εε
 shipmentRegion=1 ζ΅·ε€θͺθ₯εε
 shipmentRegion=11 ζ΅·ε€ε₯Άη²δΈεΊ
 
 */

@property (nonatomic, copy) NSString *shipmentRegion;



@end

/**
 
 {
   "id": 4706,
   "userId": 32355,
   "goodsId": 1181019,
   "goodsSn": "201810170681225",
   "goodsName": "γζ΅θ―εεεΏε  γ300ζ Ήε¨ζ£ηΎ½δΈη»ζ±ζθ―",
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
