//
//  XMFOrderRateController.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/12.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    soonComment,//η«ε³θ―δ»·
    addComment,//θΏ½ε θ―δ»·
} orderRateType;


@class XMFMyOrdersListModel;


@interface XMFOrderRateController : XMFBaseViewController

-(instancetype)initWithListModel:(XMFMyOrdersListModel *)listModel orderRateType:(orderRateType)type;

/** ζδΊ€θ―δ»·ηblock */
@property (nonatomic, copy) void (^submitCommentBlock)(orderRateType type);

@end

NS_ASSUME_NONNULL_END
