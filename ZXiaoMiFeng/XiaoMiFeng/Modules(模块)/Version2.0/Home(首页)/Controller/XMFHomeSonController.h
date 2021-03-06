//
//  XMFHomeSonController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/12.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
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

/** å·æ°block */
@property (nonatomic, copy) void (^refreshBlock)(void);

@end

NS_ASSUME_NONNULL_END
