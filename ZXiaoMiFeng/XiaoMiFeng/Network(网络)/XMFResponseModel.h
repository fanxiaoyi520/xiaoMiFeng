//
//  XMFResponseModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XMFHttpReturnCode) {
    XMFHttpReturnCodeSuccess = 200,//成功
    XMFHttpReturnCodeFailure = 01,//失败
    XMFHttpReturnServerError = 406,//服务器异常报错
    XMFHttpReturnRestrictedArea = 801,//区域限制发货的状态
};

@interface XMFResponseModel : NSObject

@property (nonatomic, assign) NSInteger kerrno;

@property (nonatomic, strong) NSString *kerrmsg;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) NSString *url;

//2.0版本
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

- (id)initWithResponseObject:(id)responseObject url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
