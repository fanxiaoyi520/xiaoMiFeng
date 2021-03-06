//
//  XMFOrdersCommentController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/19.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCellModel;


@interface XMFOrdersCommentController : XMFBaseViewController


-(instancetype)initWithModel:(XMFOrdersCellModel *)ordersModel;


//è¯è®ºæåçblock
@property (nonatomic, copy) void (^addCommentSuccessBlock)(void);


@end

NS_ASSUME_NONNULL_END
