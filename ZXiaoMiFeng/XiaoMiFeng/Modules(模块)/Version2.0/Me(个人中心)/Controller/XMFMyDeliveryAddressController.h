//
//  XMFMyDeliveryAddressController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    fromConfirmOrderVc,//æ¥èªè®¢åç¡®è®¤
    fromMeVc,//æ¥èªä¸ªäººä¸­å¿
 
} myDeliveryAddressJumpFromType;

@class XMFMyDeliveryAddressModel;

@interface XMFMyDeliveryAddressController : XMFBaseViewController

/** èªå®ä¹åå»ºæ¹æ³ */
-(instancetype)initWithJumpFromType:(myDeliveryAddressJumpFromType)fromType;


/** å°åéæ©Block */
@property (nonatomic, copy) void (^selectedAddressBlock)(XMFMyDeliveryAddressModel *addressModel);

/** å°ååçäºæ¹å */
@property (nonatomic, copy) void (^addressHasChangedBlock)(void);



@end

NS_ASSUME_NONNULL_END
