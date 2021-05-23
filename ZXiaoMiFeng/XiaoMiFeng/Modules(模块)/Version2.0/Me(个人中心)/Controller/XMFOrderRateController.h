//
//  XMFOrderRateController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    soonComment,//立即评价
    addComment,//追加评价
} orderRateType;


@class XMFMyOrdersListModel;


@interface XMFOrderRateController : XMFBaseViewController

-(instancetype)initWithListModel:(XMFMyOrdersListModel *)listModel orderRateType:(orderRateType)type;

/** 提交评价的block */
@property (nonatomic, copy) void (^submitCommentBlock)(orderRateType type);

@end

NS_ASSUME_NONNULL_END
