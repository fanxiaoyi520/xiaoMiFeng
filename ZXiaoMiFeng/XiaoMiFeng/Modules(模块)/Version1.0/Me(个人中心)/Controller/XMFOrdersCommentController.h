//
//  XMFOrdersCommentController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCellModel;


@interface XMFOrdersCommentController : XMFBaseViewController


-(instancetype)initWithModel:(XMFOrdersCellModel *)ordersModel;


//评论成功的block
@property (nonatomic, copy) void (^addCommentSuccessBlock)(void);


@end

NS_ASSUME_NONNULL_END
