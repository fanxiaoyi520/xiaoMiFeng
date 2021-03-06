//
//  XMFShoppingCartCellModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/3.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** ååçmodel */

@interface XMFShoppingCartCellGoodsModel : NSObject
/** è´­ç©è½¦ä¸­ååæ¯å¦éæ©ç¶æ */
@property (nonatomic, copy) NSString * checked;
/** ä¸æä»·æ ¼ï¼åä»· */
@property (nonatomic, copy) NSString * counterPrice;
/** æ¯å¦åé® */
@property (nonatomic, copy) NSString * freeShipping;
/** ååid */
@property (nonatomic, copy) NSString * goodsId;
/** åååç§° */
@property (nonatomic, copy) NSString * goodsName;
/** ååç¶æ 0-å¤±æ 3-ä¸æ¶ 4-ä¸æ¶ 6-ç¼ºè´§ */
@property (nonatomic, copy) NSString * goodsStatus;
/** ä¸»é®id */
@property (nonatomic, copy) NSString * keyId;
/** ç¨è´¹ */
@property (nonatomic, copy) NSString * incomeTax;
/** ååè´§åçæ°é */
@property (nonatomic, copy) NSString * number;
/** ååå¾ç */
@property (nonatomic, copy) NSString * picUrl;
/** è¿è´¹ */
@property (nonatomic, copy) NSString * postage;
/** è´§åid */
@property (nonatomic, copy) NSString * productId;
/** ä»·æ ¼,å®éä»·æ ¼ */
@property (nonatomic, copy) NSString * retailPrice;
/** 0-å½åèªè¥åå 1-æµ·å¤èªè¥åå 11-æµ·å¤å¥¶ç²ä¸åº */
@property (nonatomic, copy) NSString * shipmentRegion;
/** ååè§æ ¼ */
@property (nonatomic, strong) NSArray * specifications;
/** æ¯å¦åç¨ */
@property (nonatomic, copy) NSString * taxFlag;


/** éè´­æ°é */
@property (nonatomic, copy) NSString *limitBuyNum;
/** ç¨å·ç±»å 1-èèå½é-bc 2-èèæµ·æ·-cc */
@property (nonatomic, copy) NSString *taxType;

/** ååè´§ååºå­æ°é */
@property (nonatomic, copy) NSString *stock;


@end



/** ä¸­é´å±çmodel */
@interface XMFShoppingCartCellGoodsInfoModel : NSObject

/** è´­ç©è½¦ååæ°ç» */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsModel *> *cartGoodsRespVos;

/** ä»åºid */
@property (nonatomic, copy) NSString *warehouseId;

/** ä»åºåç§° */
@property (nonatomic, copy) NSString *warehouseName;

/** æ¯å¦éä¸­ */
@property (nonatomic, assign) BOOL isSelected;

/** æ¯å¦æå  */
@property (nonatomic, assign) BOOL isfolded;



@end


/** æå¤å±çmodel */

@interface XMFShoppingCartCellModel : NSObject

/** ååæ°é */
@property (nonatomic, assign) NSString * goodsNum;

/** èèå½é-bcçå¤±æåå */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsModel *> * invalidBcGoods;

/** èèæµ·æ·-ccçå¤±æåå */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsModel *> * invalidCcGoods;


/** èèå½é-bcçéé¢æ»é¢ */
@property (nonatomic, copy) NSString *bcAmount;

/** èèæµ·æ·-ccçéé¢æ»é¢ */
@property (nonatomic, copy) NSString *ccAmount;


/** èèå½é-bc */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsInfoModel *> * bcGoodsInfos;

/** èèæµ·æ·-cc */
@property (nonatomic, strong) NSArray<XMFShoppingCartCellGoodsInfoModel *> * ccGoodsInfos;



@end

NS_ASSUME_NONNULL_END
