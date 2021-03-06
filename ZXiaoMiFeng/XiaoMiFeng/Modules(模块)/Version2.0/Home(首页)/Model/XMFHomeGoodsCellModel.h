//
//  XMFHomeGoodsCellModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/31.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFHomeGoodsCellModel : NSObject

/** è´­ç©è½¦æ°é */
@property (nonatomic, copy) NSString * cartNum;
/** ä¸æä»·æ ¼ */
@property (nonatomic, copy) NSString * counterPrice;
/** ååid */
@property (nonatomic, copy) NSString * goodsId;
/** åååç§° */
@property (nonatomic, copy) NSString * goodsName;
/** ç¨è´¹ */
@property (nonatomic, copy) NSString * incomeTax;

/** æ¯å¦ç»ååå */
@property (nonatomic, assign) BOOL isGroupGoods;

/** ååå¾ç */
@property (nonatomic, copy) NSString * picUrl;

/** äº§åid */
@property (nonatomic, copy) NSString *productId;

/** VIPå°äº«ççååå¾ç */
@property (nonatomic, copy) NSString *simplifyPicUrl;

/** é¶å®ä»·æ ¼ */
@property (nonatomic, copy) NSString * retailPrice;

/** éé */
@property (nonatomic, copy) NSString * salesNum;


/** ååæ¾ç¤ºç¶æ 0-å¤±æ 3-ä¸æ¶ 4-ä¸æ¶ 6-ç¼ºè´§ */
@property (nonatomic, copy) NSString *shelveStatus;


/** æ¯å¦åç¨ 0-å¦ 1-æ¯ */
@property (nonatomic, copy) NSString * taxFlag;

/** æ¯å¦åé® 0-å¦ 1-æ¯ */
@property (nonatomic, copy) NSString * freeShipping;

/** ç¨å·ç±»å 1-èèå½é-bc 2-èèæµ·æ·-cc */
@property (nonatomic, copy) NSString *taxType;


/** ååæ¯å¦éä¸­ */
@property (nonatomic, assign) BOOL isSelected;

/** åºå­ */
@property (nonatomic, copy) NSString *stock;


@end

NS_ASSUME_NONNULL_END
