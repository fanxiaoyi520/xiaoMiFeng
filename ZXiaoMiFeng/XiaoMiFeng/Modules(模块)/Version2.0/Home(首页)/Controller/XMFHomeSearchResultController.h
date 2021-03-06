//
//  XMFHomeSearchResultController.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/4.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//ๆ็ดขๆฅๆบ
typedef enum : NSUInteger {
    fromSearchVc,
    fromThemeItem,
} searchFromType;

@class XMFHomeGoodsClassifyModel;

@interface XMFHomeSearchResultController : XMFBaseViewController

-(instancetype)initWithKeyword:(NSString * _Nullable)keyword classifyModel:(XMFHomeGoodsClassifyModel * _Nullable)classifyModel searchFromType:(searchFromType)fromType;



@end

NS_ASSUME_NONNULL_END
