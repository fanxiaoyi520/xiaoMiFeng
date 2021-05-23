//
//  XMFMyDeliveryAddressController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    fromConfirmOrderVc,//来自订单确认
    fromMeVc,//来自个人中心
 
} myDeliveryAddressJumpFromType;

@class XMFMyDeliveryAddressModel;

@interface XMFMyDeliveryAddressController : XMFBaseViewController

/** 自定义创建方法 */
-(instancetype)initWithJumpFromType:(myDeliveryAddressJumpFromType)fromType;


/** 地址选择Block */
@property (nonatomic, copy) void (^selectedAddressBlock)(XMFMyDeliveryAddressModel *addressModel);

/** 地址发生了改变 */
@property (nonatomic, copy) void (^addressHasChangedBlock)(void);



@end

NS_ASSUME_NONNULL_END
