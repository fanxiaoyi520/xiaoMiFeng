//
//  XMFHomeGoodsClassifyModel.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/7.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFHomeGoodsClassifyModel : NSObject

/** åç±»ä¸»é®id */
@property (nonatomic, copy) NSString *classifyId;

/** å¾æ  */
@property (nonatomic, copy) NSString *icon;

/** åç±»åç§° */
@property (nonatomic, copy) NSString *name;

/** ç±»å 0-åååç±» 1-è·³è½¬é¾æ¥ */
@property (nonatomic, copy) NSString *type;

/** è·³è½¬å°å */
@property (nonatomic, copy) NSString *url;



@end

NS_ASSUME_NONNULL_END
