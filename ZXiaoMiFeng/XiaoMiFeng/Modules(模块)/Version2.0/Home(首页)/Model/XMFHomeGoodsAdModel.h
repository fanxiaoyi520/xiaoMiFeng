//
//  XMFHomeGoodsAdModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/4.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFHomeGoodsAdModel : NSObject

/** ä¸»é®id */
@property (nonatomic, copy) NSString * adId;

/** æå¹¿åçååé¡µé¢æèæ´»å¨é¡µé¢é¾æ¥å°å */
@property (nonatomic, copy) NSString * link;
/** å¹¿åæ é¢ */

@property (nonatomic, copy) NSString * name;
/** æåºå· */

@property (nonatomic, copy) NSString * sort;
/** ä¸»é¢id */

@property (nonatomic, copy) NSString * topicId;
/** ä¸»é¢åç§° */

@property (nonatomic, copy) NSString * topicName;
/** å¹¿åå®£ä¼ å¾ç */

@property (nonatomic, copy) NSString * url;

@end

NS_ASSUME_NONNULL_END
