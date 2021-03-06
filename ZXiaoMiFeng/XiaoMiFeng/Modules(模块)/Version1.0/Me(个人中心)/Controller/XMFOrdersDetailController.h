//
//  XMFOrdersDetailController.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/18.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersCellModel;

@interface XMFOrdersDetailController : XMFBaseViewController


-(instancetype)initWithModel:(XMFOrdersCellModel *)ordersModel;

//่ฎขๅ่ฏฆๆ้กตๆไฝblock
@property (nonatomic, copy) void (^ordersDetailSuccessBlock)(NSInteger buttonTag);


@end

NS_ASSUME_NONNULL_END
