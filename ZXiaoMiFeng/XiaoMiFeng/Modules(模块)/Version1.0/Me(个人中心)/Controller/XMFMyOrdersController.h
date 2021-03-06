//
//  XMFMyOrdersController.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/5/14.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
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

//ζ₯θͺδΊεͺι
@property (nonatomic, assign) myOrdersJumpFromType fromType;

@end

NS_ASSUME_NONNULL_END
