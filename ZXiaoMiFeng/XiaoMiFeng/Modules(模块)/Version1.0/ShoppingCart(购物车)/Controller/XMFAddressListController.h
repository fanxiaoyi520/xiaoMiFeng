//
//  XMFAddressListController.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/5/6.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    
    jumpFromMineVcToAddressList = 1,
    jumpFromOrderConfirmVcToAddressList,
    
    
} jumpToAddressListType;


@class XMFAddressListModel;

@interface XMFAddressListController : XMFBaseViewController


-(instancetype)initWithJumpType:(jumpToAddressListType)jumpType;


//ε°ειζ©Block
@property (nonatomic, copy) void (^selectedAddressBlock)(XMFAddressListModel *addressListModel);

//ε°εεηδΊζΉε
@property (nonatomic, copy) void (^addressHasChangedBlock)(void);


@end

NS_ASSUME_NONNULL_END
