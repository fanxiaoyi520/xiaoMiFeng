//
//  XMFMyCollectionModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/7.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class XMFHomeGoodsCellModel;



@interface XMFMyCollectionSonModel : NSObject

/** æ¶èæ¶é´ */
@property (nonatomic, copy) NSString * collectAddTime;
/** æ¶èID */
@property (nonatomic, copy) NSString * collectId;
/** ä¸æä»·æ ¼ */
@property (nonatomic, copy) NSString * goodsCounterPrice;
/** ååID */
@property (nonatomic, copy) NSString * goodsId;
/** åååç§° */
@property (nonatomic, copy) NSString * goodsName;
/** ååå¾ç */
@property (nonatomic, copy) NSString * goodsPicUrl;
/** å®éä»·æ ¼ */
@property (nonatomic, copy) NSString * goodsRetailPrice;
/** ååéé */
@property (nonatomic, copy) NSString * goodsSalesNum;
/** æ¯å¦åé®ï¼0=å¦ï¼1=æ¯ï¼ */
@property (nonatomic, copy) NSString * goodsShipFlag;
/** æ¯å¦åç¨ï¼0=å¦ï¼1=æ¯ï¼ */
@property (nonatomic, copy) NSString * goodsTaxFlag;

/** ååæ¯å¦éä¸­ */
@property (nonatomic, assign) BOOL isSelected;

/** å¤±æç±»å(0=æªå¤±æï¼1=ç¼ºè´§ï¼2=ä¸æ¶) */
@property (nonatomic, copy) NSString *invalidType;


@end



@interface XMFMyCollectionModel : NSObject

/** æææ¶èåè¡¨ */
//@property (nonatomic, strong) NSArray<XMFMyCollectionSonModel *> * enabledList;

@property (nonatomic, strong) NSArray<XMFHomeGoodsCellModel *> * enabledList;


/** æ ææ¶èåè¡¨æ¶èæ¶é´ */
//@property (nonatomic, strong) NSArray<XMFMyCollectionSonModel *> * invalidList;

@property (nonatomic, strong) NSArray<XMFHomeGoodsCellModel *> * invalidList;



@end

NS_ASSUME_NONNULL_END
