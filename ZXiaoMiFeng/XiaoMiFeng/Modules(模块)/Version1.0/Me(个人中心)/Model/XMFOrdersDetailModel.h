//
//  XMFOrdersDetailModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/18.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMFOrdersCellModel.h"


NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCellHandleOptionModel;



//订单其它信息model
@interface XMFOrdersDetailOrderInfoModel : NSObject


@property (nonatomic, copy) NSString * actualPrice;
@property (nonatomic, copy) NSString * addTime;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * allocateCargoStatus;
@property (nonatomic, copy) NSString * confirmTime;
@property (nonatomic, copy) NSString * consignee;
@property (nonatomic, copy) NSString * couponPrice;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, copy) NSString * freightPrice;
@property (nonatomic, copy) NSString * freightReportStatus;
@property (nonatomic, copy) NSString * goodsPrice;
@property (nonatomic, strong) XMFOrdersCellHandleOptionModel * handleOption;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * integralPrice;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * orderPrice;
@property (nonatomic, copy) NSString * orderReportStatus;
@property (nonatomic, copy) NSString * orderSn;
@property (nonatomic, copy) NSString * orderStatus;
@property (nonatomic, copy) NSString * orderStatusText;
@property (nonatomic, copy) NSString * remark;//缺货说明
@property (nonatomic, copy) NSString * payMobile;
@property (nonatomic, copy) NSString * payReportStatus;
@property (nonatomic, copy) NSString * payTime;
@property (nonatomic, copy) NSString * realupStatus;
@property (nonatomic, copy) NSString * receiverAdCode;
@property (nonatomic, copy) NSString * receiverPersonCard;
@property (nonatomic, copy) NSString * receiverPostalCode;
@property (nonatomic, copy) NSString * recvMerSn;
@property (nonatomic, copy) NSString * shipChannel;
@property (nonatomic, copy) NSString * shipSn;
@property (nonatomic, copy) NSString * shipTime;
@property (nonatomic, copy) NSString * shipmentRegion;
@property (nonatomic, copy) NSString * taxPrice;
@property (nonatomic, copy) NSString * theThirdOrderNo;
@property (nonatomic, copy) NSString * transferId;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * valuationFee;
@property (nonatomic, copy) NSString * version;
@property (nonatomic, copy) NSString * webOrderId;

//免税袋条码
@property (nonatomic, copy) NSString *freeTaxBarCode;


@end


//订单商品model
@interface XMFOrdersDetailOrderGoodsModel : NSObject

@property (nonatomic, copy) NSString * addTime;
@property (nonatomic, assign) BOOL commentStatus;
@property (nonatomic, copy) NSString * country;
@property (nonatomic, assign) BOOL deleted;
@property (nonatomic, copy) NSString * flagTax;
@property (nonatomic, copy) NSString * freeShipping;
@property (nonatomic, copy) NSString * goodsId;
@property (nonatomic, copy) NSString * goodsName;
@property (nonatomic, copy) NSString * goodsSn;
@property (nonatomic, strong) NSArray * goodsSpecificationValues;
@property (nonatomic, copy) NSString * orderGoodsId;
@property (nonatomic, copy) NSString * incomeTax;
@property (nonatomic, copy) NSString * number;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * picUrl;
@property (nonatomic, copy) NSString * postage;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, copy) NSString * retailPrice;
@property (nonatomic, strong) NSArray * specifications;
@property (nonatomic, copy) NSString * supplierId;
@property (nonatomic, copy) NSString * supplyPrice;
@property (nonatomic, copy) NSString * unit;
@property (nonatomic, copy) NSString * version;



@end


//订单model
@interface XMFOrdersDetailModel : NSObject

@property (nonatomic, strong) NSArray<XMFOrdersDetailOrderGoodsModel *> * orderGoods;


@property (nonatomic, strong) XMFOrdersDetailOrderInfoModel * orderInfo;


//人工加入:订单状态
@property (nonatomic, assign) ordersStatusType statusType;


@end

NS_ASSUME_NONNULL_END
