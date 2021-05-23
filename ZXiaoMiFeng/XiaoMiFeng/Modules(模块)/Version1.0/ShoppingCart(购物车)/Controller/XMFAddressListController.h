//
//  XMFAddressListController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
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


//地址选择Block
@property (nonatomic, copy) void (^selectedAddressBlock)(XMFAddressListModel *addressListModel);

//地址发生了改变
@property (nonatomic, copy) void (^addressHasChangedBlock)(void);


@end

NS_ASSUME_NONNULL_END
