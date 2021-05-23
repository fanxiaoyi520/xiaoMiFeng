//
//  XMFOrderCheckedGoodsListModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/28.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFOrderCheckedGoodsListModel : NSObject

@property (nonatomic, copy) NSString * actualPrice;
@property (nonatomic, copy) NSString * checked;
@property (nonatomic, copy) NSString * deleted;
@property (nonatomic, copy) NSString * flagTax;
@property (nonatomic, copy) NSString * freeShipping;
@property (nonatomic, copy) NSString * freightPrice;
@property (nonatomic, copy) NSString * goodsId;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, copy) NSString * goodsSn;
@property (nonatomic, copy) NSString * goodsTotalPrice;
@property (nonatomic, copy) NSString * checkedGoodsId;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * orderTotalPrice;
@property (nonatomic, copy) NSString * picUrl;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, copy) NSString * shipmentRegion;
@property (nonatomic, strong) NSArray * specifications;
@property (nonatomic, copy) NSString * tariffPrice;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * version;


@end

NS_ASSUME_NONNULL_END
