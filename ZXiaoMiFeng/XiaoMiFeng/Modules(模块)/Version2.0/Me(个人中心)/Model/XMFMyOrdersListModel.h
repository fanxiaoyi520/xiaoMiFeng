//
//  XMFMyOrdersListModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMFOrderRateController.h"//è¯ä»·é¡µé¢å¯¼å¥ç»æä½


NS_ASSUME_NONNULL_BEGIN


@interface XMFMyOrdersListRefundInfoDtoModel: NSObject

/** éæ¬¾éé¢ */
@property (nonatomic, copy) NSString *amount;
/** è®¢åä¸»é®ID */
@property (nonatomic, copy) NSString *keyId;
/** èç³»çµè¯ */
@property (nonatomic, copy) NSString *mobile;
/** è®¢åID */
@property (nonatomic, copy) NSString *orderId;
/** å¾ç */
@property (nonatomic, strong) NSArray *picUrls;
/** éæ¬¾åå  */
@property (nonatomic, copy) NSString *reason;
/** è¯è®ºç±»åï¼1ï¼å¤æãéæï¼2ï¼ä¸æ³è¦ï¼3ï¼å¶ä»ï¼ */
@property (nonatomic, copy) NSString *type;
/** ç¨æ·ID */
@property (nonatomic, copy) NSString *userId;

@end


@interface XMFMyOrdersListHandleOptionModel : NSObject

/** è¿½å è¯è®ºæä½ */
@property (nonatomic, assign) BOOL appendComment;
/** åæ¶æä½ */
@property (nonatomic, assign) BOOL cancel;
/** åæ¶éæ¬¾ */
@property (nonatomic, assign) BOOL cancelRefund;
/** è¯è®ºæä½ */
@property (nonatomic, assign) BOOL comment;
/** ç¡®è®¤æ¶è´§æä½ */
@property (nonatomic, assign) BOOL confirm;
/** å é¤æä½ */
@property (nonatomic, assign) BOOL orderDelete;
/** å»¶é¿æ¶è´§ */
@property (nonatomic, assign) BOOL extendConfirm;
/** æ¯ä»æä½ */
@property (nonatomic, assign) BOOL pay;
/** æ¥çç©æµ */
@property (nonatomic, assign) BOOL queryTrack;
/** åæ¬¡è´­ä¹° */
@property (nonatomic, assign) BOOL rebuy;
/** ç³è¯·éæ¬¾ */
@property (nonatomic, assign) BOOL refund;
/** æéåè´§ */
@property (nonatomic, assign) BOOL remind;
/** ä¿®æ¹æ¶è´§å°å */
@property (nonatomic, assign) BOOL updateAddress;



@end





@interface XMFMyOrdersListGoodsListModel : NSObject
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
/** äº§åID */
@property (nonatomic, copy) NSString *productId;

/** ååid */
@property (nonatomic, copy) NSString * goodsId;

/** ä¾åºååç§° */
@property (nonatomic, copy) NSString *supplierName;

/** ç¨å·ç±»å 1-èèå½é-bc 2-èèæµ·æ·-cc */
@property (nonatomic, copy) NSString *orderType;

//ä»¥ä¸ä¸ºè¯è®ºåè¡¨çmodelçå±æ§


/** è¯ä»·åå®¹ */
@property (nonatomic, copy) NSString *content;

/** æææ°é */
@property (nonatomic, assign) NSInteger star;

/** éä¸­çå¾ç */
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedPhotos;

/** éä¸­çå¾çæ°æ® */
@property (nonatomic, strong) NSMutableArray *selectedPhotosAssets;

/** ä¸ä¼ çå¾çé¾æ¥ */
@property (nonatomic, strong) NSMutableArray *picUrlsArr;

/** å­æ° */
@property (nonatomic, assign) NSInteger wordsCountNum;

/** è¯è®ºç±»å */
@property (nonatomic, assign) orderRateType rateType;


@end






@interface XMFMyOrdersListModel : NSObject

/** å®ä»éé¢ */
@property (nonatomic, copy) NSString * actualPrice;
/** è®¢ååå»ºæ¶é´ */
@property (nonatomic, copy) NSString * addTime;
/** æ¶è´§å°å */
@property (nonatomic, copy) NSString * address;

/** æ£è´§ç¶æ 1å¾æ£è´§ 2å·²æ£è´§ */
@property (nonatomic, copy) NSString *allocateCargoStatus;

/** èªå¨ç¡®è®¤æ¶è´§æ¶é´ */
@property (nonatomic, copy) NSString * autoConfirmTime;
/** çº¸ç®±æ¡ç  */
@property (nonatomic, copy) NSString * cartonBoxBarCode;
/** æ¶è´§äºº */
@property (nonatomic, copy) NSString * consignee;

/** å¶ä»ä¼æ  */
@property (nonatomic, copy) NSString * couponPrice;

/** ååä¼æ  */
@property (nonatomic, copy) NSString *otherDiscount;

/** è¿è´¹ */
@property (nonatomic, copy) NSString * freightPrice;
/** è®¢ååååè¡¨ */
@property (nonatomic, strong) NSArray<XMFMyOrdersListGoodsListModel *> * goodsList;
/** ååæ»éé¢ */
@property (nonatomic, copy) NSString * goodsPrice;
/** æé®ç¶æ */
//@property (nonatomic, strong) XMFMyOrdersListHandleOptionModel * handleOption;
@property (nonatomic, strong) NSMutableDictionary * handleOption;
/** ä¹°å®¶çè¨ */
@property (nonatomic, copy) NSString * keyId;
/** è®¢åä¸»é®ID */
@property (nonatomic, copy) NSString * leavingMessage;
/** èç³»çµè¯ */
@property (nonatomic, copy) NSString * mobile;
/** è®¢åç¼å· */
@property (nonatomic, copy) NSString * orderSn;
/** è®¢åç¶æï¼101: 'æªä»æ¬¾â,102: 'ç¨æ·åæ¶â,103: 'ç³»ç»åæ¶â,109: 'ä»æ¬¾å¤±è´¥â,201: 'å·²ä»æ¬¾â, 202: 'ç³è¯·éæ¬¾â, 203: 'å·²éæ¬¾â, 204: 'å·²ä»æ¬¾ï¼éæ¬¾å¤±è´¥ï¼â, 209: 'éæ¬¾ä¸­â,301: 'å·²åè´§â,401: 'ç¨æ·æ¶è´§â, 402: âç³»ç»æ¶è´§â 409: 'å¾è¯ä»·âï¼ */
@property (nonatomic, copy) NSString * orderStatus;

/** éæ¬¾ä¿¡æ¯ */
@property (nonatomic, strong) XMFMyOrdersListRefundInfoDtoModel * refundInfoDto;
/** åå°æç»éæ¬¾åå  */
@property (nonatomic, copy) NSString * remark;
/** åè´§å¿«éå¬ */
@property (nonatomic, copy) NSString * shipChannel;
/** ç©æµè¿åç¼å·;9å¼å¤´+12ä½æ°å­ */
@property (nonatomic, copy) NSString * shipSn;
/** åè´§å¼å§æ¶é´ */
@property (nonatomic, copy) NSString * shipTime;
/** ç¨è´¹ */
@property (nonatomic, copy) NSString * taxPrice;
/** äº¤æç±»å 1-å¿«æ·ï¼2-å¾®ä¿¡ï¼3-æ¯ä»å®,4-æµ·å¤SDK */
@property (nonatomic, copy) NSString * transferId;

/** æ¯å¦å·²ç­¾æ¶ */
@property (nonatomic, copy) NSString *receipt;

/** è®¢åæ¥æº */
@property (nonatomic, copy) NSString * orderSources;

/** è®¢åç±»å 1âbc 2âcc */
@property (nonatomic, copy) NSString *orderType;

/** è®¢åæ¯å¦ç¼ºè´§ */
@property (nonatomic, copy) NSString *outOfStock;

/** æ¯å¦æ¯åå²è®¢åéè¦è¡¥åèº«ä»½è¯ */
@property (nonatomic, assign) BOOL oldFlag;

/** ä»åºID */
@property (nonatomic, copy) NSString *warehouseId;

/** ä»åºåç§° */
@property (nonatomic, copy) NSString *warehouseName;

/** äººå·¥å å¥ï¼æ¯å¦åçº§è¿å°å */
@property (nonatomic, assign) BOOL isUpdateAddress;

/** é²ä¼ªè¢è¢å· */
@property (nonatomic, strong) NSArray *freeTaxBarCode;


@end

NS_ASSUME_NONNULL_END
