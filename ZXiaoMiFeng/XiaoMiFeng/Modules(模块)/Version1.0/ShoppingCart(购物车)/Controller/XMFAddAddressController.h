//
//  XMFAddAddressController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    editAddress = 1,
    addAddress,
    
} addAddressType;

/*
struct HWTitleInfo {
    NSInteger length;
    NSInteger number;
};

typedef struct HWTitleInfo HWTitleInfo;
 */

@interface XMFAddAddressController : XMFBaseViewController


-(instancetype)initWithType:(addAddressType)type addressId:(NSString * _Nullable)addressIdStr;

//操作Block
@property (nonatomic, copy) void (^addAddressBlock)(void);


@end

NS_ASSUME_NONNULL_END
