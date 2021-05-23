//
//  XMFHomeSearchResultController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//搜索来源
typedef enum : NSUInteger {
    fromSearchVc,
    fromThemeItem,
} searchFromType;

@class XMFHomeGoodsClassifyModel;

@interface XMFHomeSearchResultController : XMFBaseViewController

-(instancetype)initWithKeyword:(NSString * _Nullable)keyword classifyModel:(XMFHomeGoodsClassifyModel * _Nullable)classifyModel searchFromType:(searchFromType)fromType;



@end

NS_ASSUME_NONNULL_END
