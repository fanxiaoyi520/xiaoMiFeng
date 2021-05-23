//
//  XMFOrderConfirmModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//@class XMFShopCartDetailModel;

@class XMFOrderCheckedGoodsListModel;


//地址的model
@interface  XMFCheckedaddressModel: NSObject

@property (nonatomic, copy) NSString * addTime;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, strong) NSString * areaId;
@property (nonatomic, strong) NSString * cityId;
@property (nonatomic, strong) NSString * deleted;
@property (nonatomic, strong) NSString * addressId;
@property (nonatomic, strong) NSString * isDefault;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * personCard;
@property (nonatomic, copy) NSString * postalCode;
@property (nonatomic, strong) NSString * provinceId;
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * version;

@end


@interface XMFOrderConfirmModel : NSObject

@property (nonatomic, strong) NSString * actualPrice;
@property (nonatomic, strong) NSString * addressId;
@property (nonatomic, strong) XMFCheckedaddressModel  * checkedAddress;
@property (nonatomic, strong) NSString * checkedCoupon;
@property (nonatomic, strong) NSArray<XMFOrderCheckedGoodsListModel *> * checkedGoodsList;
@property (nonatomic, strong) NSString * couponId;
@property (nonatomic, copy) NSString * couponList;
@property (nonatomic, strong) NSString * couponPrice;
@property (nonatomic, strong) NSString * freightPrice;
@property (nonatomic, strong) NSString * goodsTotalPrice;
@property (nonatomic, strong) NSString * orderTotalPrice;
@property (nonatomic, strong) NSString * tariffPrice;


@end

/**
 
 {
     "actualPrice":3114.64,
     "orderTotalPrice":3114.64,
     "couponId":0,
     "goodsTotalPrice":3057.4,
     "addressId":0,
     "checkedCoupon":0,
     "checkedAddress":{
         "id":0
     },
     "tariffPrice":27.24,
     "couponList":"",
     "couponPrice":0,
     "freightPrice":30,
     "checkedGoodsList":[
         {
             "shipmentRegion":1,
             "productId":3225,
             "goodsId":1181188,
             "goodsSn":"2019013101809111",
             "specifications":[
                 "256/6.5寸"
             ],
             "userId":32355,
             "version":0,
             "number":3,
             "picUrl":"https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/kxya6d1evu8mkkxh9efp.jpg",
             "flagTax":0,
             "deleted":false,
             "freeShipping":0,
             "price":99.8,
             "checked":true,
             "id":4753,
             "goodsName":"PICASSO毕加索 PS-988珍珠白金夹铱金笔"
         },
        
     ]
 }
 
 
 */

NS_ASSUME_NONNULL_END
