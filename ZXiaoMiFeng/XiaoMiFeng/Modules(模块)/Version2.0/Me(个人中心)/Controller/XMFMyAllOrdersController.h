//
//  XMFMyAllOrdersController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/28.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    fromPengingDefault,//é»è®¤ï¼å¨é¨
    fromPendingPay,//å¾ä»æ¬¾
    fromPendingDelivery,//å¾åè´§
    fromPendingReceipt,//å¾æ¶è´§
    fromPendingRebuy,//å·²å®æï¼å¾éä¹°ï¼
    fromCancelPay,//æ¥èªåæ¶ä»æ¬¾
    fromPaySuccess,//æ¥èªä»æ¬¾æå
} myAllOrdersJumpFromType;


@interface XMFMyAllOrdersController : XMFBaseViewController

-(instancetype)initWithFromType:(myAllOrdersJumpFromType)fromType;

/** è¿åçblock */
@property (nonatomic, copy) void (^myAllOrdersBackBlock)(void);


@end

NS_ASSUME_NONNULL_END
