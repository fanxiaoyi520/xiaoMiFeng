//
//  XMFOrderConfirmController.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/30.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMFOrderConfirmController : XMFBaseViewController

-(instancetype)initWithCartId:(NSString *)cartId;

//ๆฏไป็block
@property (nonatomic, copy) void (^cartPayBlock)(void);


@end

NS_ASSUME_NONNULL_END
