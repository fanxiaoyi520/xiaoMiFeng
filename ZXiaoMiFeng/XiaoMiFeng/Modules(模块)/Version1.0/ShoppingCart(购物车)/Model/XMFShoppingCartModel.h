//
//  XMFShoppingCartModel.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/4/24.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFShoppingCartGoodModel;

@class XMFShoppingCartTotalModel;

@interface XMFShoppingCartModel : NSObject

@property (nonatomic, strong) XMFShoppingCartTotalModel *cartTotal;

@property (nonatomic, strong) NSArray<XMFShoppingCartGoodModel *> *cartList;


@end

/**
 

 "cartTotal": {
   "goodsCount": 5,
   "checkedGoodsCount": 5,
   "goodsAmount": 965.78,
   "checkedGoodsAmount": 965.78
 },
 "cartList": [
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
 
 ]
 
 
 */

NS_ASSUME_NONNULL_END
