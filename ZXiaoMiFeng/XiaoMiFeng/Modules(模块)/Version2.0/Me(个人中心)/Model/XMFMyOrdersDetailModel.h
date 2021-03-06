//
//  XMFMyOrdersDetailModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/10.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListGoodsListModel;


@interface XMFMyOrdersDetailGoodsListModel : NSObject
/** è¯è®ºç¶æ 0:ä¸å¯è¯è®º 1å¯ä»¥è¯è®º 2å¯ä»¥è¿½å è¯è®º */
@property (nonatomic, copy) NSString * commentStatus;
/** åååç§° */
@property (nonatomic, copy) NSString * goodsName;
/** ä¸»é®id */
@property (nonatomic, copy) NSString * keyId;
/** ååç¨è´¹ */
@property (nonatomic, copy) NSString * incomeTax;
/** è´­ä¹°æ°é */
@property (nonatomic, copy) NSString * number;
/** ååå¾ç */
@property (nonatomic, copy) NSString * picUrl;
/** ååå®ä»· */
@property (nonatomic, copy) NSString * price;
/** ç¼ºè´§è¯´æ */
@property (nonatomic, copy) NSString * remark;
/** ååè§æ ¼ */
@property (nonatomic, strong) NSArray * specifications;
/** æ¯å¦ç¼ºè´§ */
@property (nonatomic, copy) NSString * status;



@end



@interface XMFMyOrdersDetailModel : NSObject

/** å®ä»éé¢ */
@property (nonatomic, copy) NSString * actualPrice;
/** è®¢ååå»ºæ¶é´ */
@property (nonatomic, copy) NSString * addTime;
/** æ¶è´§å°å */
@property (nonatomic, copy) NSString * address;
/** èªå¨ç¡®è®¤æ¶è´§æ¶é´ */
@property (nonatomic, copy) NSString * autoConfirmTime;
/** çº¸ç®±æ¡ç  */
@property (nonatomic, copy) NSString * cartonBoxBarCode;
/** æ¶è´§äºº */
@property (nonatomic, copy) NSString * consignee;
/** å¶ä»ä¼æ  */
@property (nonatomic, copy) NSString * couponPrice;
/** è¿è´¹ */
@property (nonatomic, copy) NSString * freightPrice;
/** è®¢ååååè¡¨ */
@property (nonatomic, strong) NSArray<XMFMyOrdersListGoodsListModel *> * goodsList;
/** ååæ»éé¢ */
@property (nonatomic, copy) NSString * goodsPrice;
/** æä½çå­å¸ */
@property (nonatomic, strong) NSMutableDictionary * handleOption;
/** è®¢åä¸»é®ID */
@property (nonatomic, copy) NSString * keyId;
/** ä¹°å®¶çè¨ */
@property (nonatomic, copy) NSString * leavingMessage;
/** èç³»çµè¯ */
@property (nonatomic, copy) NSString * mobile;
/** è®¢åç¼å· */
@property (nonatomic, copy) NSString * orderSn;
/** è®¢åç¶æï¼101: 'æªä»æ¬¾â,102: 'ç¨æ·åæ¶â,103: 'ç³»ç»åæ¶â,109: 'ä»æ¬¾å¤±è´¥â,201: 'å·²ä»æ¬¾â, 202: 'ç³è¯·éæ¬¾â, 203: 'å·²éæ¬¾â, 204: 'å·²ä»æ¬¾ï¼éæ¬¾å¤±è´¥ï¼â, 209: 'éæ¬¾ä¸­â,301: 'å·²åè´§â,401: 'ç¨æ·æ¶è´§â, 402: âç³»ç»æ¶è´§â 409: 'å¾è¯ä»·âï¼ */
@property (nonatomic, copy) NSString * orderStatus;
/** éæ¬¾ä¿¡æ¯ */
@property (nonatomic, copy) NSString * refundInfoDto;
/** åå°æç»éæ¬¾åå  */
@property (nonatomic, copy) NSString * remark;
/** åè´§å¿«éå¬å¸ */
@property (nonatomic, copy) NSString * shipChannel;
/** ç©æµè¿åç¼å·;9å¼å¤´+12ä½æ°å­ */
@property (nonatomic, copy) NSString * shipSn;
/** åè´§å¼å§æ¶é´ */
@property (nonatomic, copy) NSString * shipTime;
/** ç¨è´¹ */
@property (nonatomic, copy) NSString * taxPrice;
/** äº¤æç±»å 1:é¶è 2:å¾®ä¿¡ 3:æ¯ä»å® 4:H5æ¯ä» 5:Apple Pay  6:é¶èäºéªä»  7ï¼é¶èäºç»´ç  8ï¼å¾®ä¿¡H5 9:æ¯ä»å®H5 10:æªç¥ */
@property (nonatomic, copy) NSString * transferId;

/** æ¯å¦å·²ç­¾æ¶ */
@property (nonatomic, copy) NSString *receipt;

/** è®¢åæ¥æºï¼ä¸´æ¶èªå·±å çï¼ */
@property (nonatomic, copy) NSString * orderSource;

@end

NS_ASSUME_NONNULL_END
