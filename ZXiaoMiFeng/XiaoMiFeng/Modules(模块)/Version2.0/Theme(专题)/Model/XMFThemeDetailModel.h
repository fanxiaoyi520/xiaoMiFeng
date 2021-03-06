//
//  XMFThemeDetailModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/7.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XMFThemeDetailListModel : NSObject

/** è´­ç©è½¦æ°é */
@property (nonatomic, copy) NSString * cartNum;
/** ä¸æä»·æ ¼ */
@property (nonatomic, copy) NSString * counterPrice;
/** æ¯å¦åé® */
@property (nonatomic, copy) NSString * freeShipping;
/** ååid */
@property (nonatomic, copy) NSString * goodsId;
/** åååç§° */
@property (nonatomic, copy) NSString * goodsName;
/** ç¨è´¹ */
@property (nonatomic, copy) NSString * incomeTax;
/** ååå¾ç */
@property (nonatomic, copy) NSString * picUrl;
/** é¶å®ä»·æ ¼ */
@property (nonatomic, copy) NSString * retailPrice;
/** éé */
@property (nonatomic, copy) NSString * salesNum;
/** æ¯å¦åç¨ */
@property (nonatomic, copy) NSString * taxFlag;

/** æ¯å¦ç»ååå */
@property (nonatomic, assign) BOOL isGroupGoods;

/** åºå­ */
@property (nonatomic, copy) NSString *stock;

/** äº§åid */
@property (nonatomic, copy) NSString *productId;

@end


@interface XMFThemeDetailModel : NSObject

/** ä¸»é¢é¢è² */
@property (nonatomic, copy) NSString * backgroundColor;

/** ä¸»é¢èæ¯å¾ç */
@property (nonatomic, copy) NSString * backgroundPic;

/** ä¸»é¢åç§° */
@property (nonatomic, copy) NSString *topicName;

@property (nonatomic, strong) NSArray<XMFThemeDetailListModel *> * goodsList;

@end

NS_ASSUME_NONNULL_END
