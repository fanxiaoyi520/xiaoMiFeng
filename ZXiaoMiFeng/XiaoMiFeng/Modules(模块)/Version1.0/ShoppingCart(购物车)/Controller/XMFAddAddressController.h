//
//  XMFAddAddressController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/6.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
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

//æä½Block
@property (nonatomic, copy) void (^addAddressBlock)(void);


@end

NS_ASSUME_NONNULL_END
