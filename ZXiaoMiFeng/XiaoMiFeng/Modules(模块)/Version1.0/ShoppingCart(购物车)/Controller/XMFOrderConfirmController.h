//
//  XMFOrderConfirmController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMFOrderConfirmController : XMFBaseViewController

-(instancetype)initWithCartId:(NSString *)cartId;

//支付的block
@property (nonatomic, copy) void (^cartPayBlock)(void);


@end

NS_ASSUME_NONNULL_END
