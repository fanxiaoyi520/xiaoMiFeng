//
//  XMFConfirmOrderModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/8.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XMFConfirmOrderGoodsListModel : NSObject

/** åååç§° */
@property (nonatomic, copy) NSString * goodsName;
/** ç¨è´¹ */
@property (nonatomic, copy) NSString * incomeTax;
/** ç¨ååè´§åçæ°éè´¹ */
@property (nonatomic, copy) NSString * number;
/** ååå¾ç */
@property (nonatomic, copy) NSString * picUrl;
/** ä»·æ ¼ */
@property (nonatomic, copy) NSString * price;
/** ååè§æ ¼ */
@property (nonatomic, strong) NSArray * specifications;
/** æ¯å¦åç¨ */
@property (nonatomic, copy) NSString * taxFlag;
/** åååä½ */
@property (nonatomic, copy) NSString * unit;
/** æ¯å¦åé® */
@property (nonatomic, copy) NSString * freeShipping;

/** ä¾åºååç§° */
@property (nonatomic, copy) NSString *supplierName;

/** ç¨å·ç±»å 1-èèå½é-bc 2-èèæµ·æ·-cc */
@property (nonatomic, copy) NSString *orderType;

@end


@interface XMFConfirmOrderChildOrderListModel : NSObject

/** è®¢ååååè¡¨ */
@property (nonatomic, strong) NSArray<XMFConfirmOrderGoodsListModel *> * goodsList;

/** è®¢åç¼å· */
@property (nonatomic, copy) NSString * orderSn;

/** è®¢åè¿è´¹ */
@property (nonatomic, copy) NSString * postagePrice;

/** è®¢åç±»å 1âbc 2âcc */
@property (nonatomic, copy) NSString *orderType;

/** ä»åºåç§° */
@property (nonatomic, copy) NSString *warehouseName;

@end



@interface XMFConfirmOrderModel : NSObject

/** è´­ç©è½¦ID */
@property (nonatomic, strong) NSArray * cartIds;
/** å­è®¢åä¿¡æ¯ */
@property (nonatomic, strong) NSArray<XMFConfirmOrderChildOrderListModel *> * childOrderList;
/** ååæ°é */
@property (nonatomic, copy) NSString * goodsCount;
/** ååæ»éé¢ */
@property (nonatomic, copy) NSString * goodsTotalPrice;
/** æ¯å¦æå */
@property (nonatomic, copy) NSString * isSplit;
/** ç¶çº§è®¢åç¼å· */
@property (nonatomic, copy) NSString * orderSn;
/** æ»è¿è´¹ */
@property (nonatomic, copy) NSString * postageTotalPrice;
/** å¶ä»ä¼æ  */
@property (nonatomic, copy) NSString * reducePrice;

/** ååä¼æ  */
@property (nonatomic, copy) NSString *otherDiscount;

/** æ»ç¨è´¹ */
@property (nonatomic, copy) NSString * taxTotalPrice;
/** æ»éé¢ */
@property (nonatomic, copy) NSString * totalPrice;


@end

NS_ASSUME_NONNULL_END
