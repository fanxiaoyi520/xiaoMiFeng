//
//  XMFHomeSonViewController.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/16.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//è·åè´­ç©è½¦åååè¡¨çæ¹å¼
typedef enum : NSUInteger {
    refreshData = 1,
    updateCart,
} getCartIndexType;


@class XMFGoodsClassifyModel;

@interface XMFHomeSonViewController : XMFBaseViewController

//é¡¶é¨çviewæ¾ç¤ºä¸å¦
@property (nonatomic, copy) void (^headerViewShowBlock)(BOOL isShow);

//å·æ°block
@property (nonatomic, copy) void (^refreshBlock)(void);


-(instancetype)initWithClassifyModel:(XMFGoodsClassifyModel *)model;

@end

NS_ASSUME_NONNULL_END
