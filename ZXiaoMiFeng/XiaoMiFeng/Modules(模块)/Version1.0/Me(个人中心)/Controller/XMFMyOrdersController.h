//
//  XMFMyOrdersController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    myOrdersJumpFromHomeVc = 1,
    myOrdersJumpFromCancelPay,
    myOrdersJumpFromPaySuccess,
} myOrdersJumpFromType;

@interface XMFMyOrdersController : XMFBaseViewController

-(instancetype)initWithMyOrdersJumpFromType:(myOrdersJumpFromType)type;

//来自于哪里
@property (nonatomic, assign) myOrdersJumpFromType fromType;

@end

NS_ASSUME_NONNULL_END
