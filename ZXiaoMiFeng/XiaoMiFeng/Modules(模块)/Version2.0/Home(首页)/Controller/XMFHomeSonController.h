//
//  XMFHomeSonController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    allGoodsType = 1,
    partGoodsType,
    doctorType,
} flowLayoutType;

@class XMFHomeGoodsClassifyModel;


@interface XMFHomeSonController : XMFBaseViewController

-(instancetype)initWithFlowLayoutType:(flowLayoutType)type classifyModel:(XMFHomeGoodsClassifyModel * _Nullable)classifyModel selectedTagDic:(NSMutableDictionary *)selectedTagDic;

/** 刷新block */
@property (nonatomic, copy) void (^refreshBlock)(void);

@end

NS_ASSUME_NONNULL_END
