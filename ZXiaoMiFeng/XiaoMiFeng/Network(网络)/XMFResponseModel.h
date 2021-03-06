//
//  XMFResponseModel.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/4/22.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XMFHttpReturnCode) {
    XMFHttpReturnCodeSuccess = 200,//ζε
    XMFHttpReturnCodeFailure = 01,//ε€±θ΄₯
    XMFHttpReturnServerError = 406,//ζε‘ε¨εΌεΈΈζ₯ι
    XMFHttpReturnRestrictedArea = 801,//εΊειεΆεθ΄§ηηΆζ
};

@interface XMFResponseModel : NSObject

@property (nonatomic, assign) NSInteger kerrno;

@property (nonatomic, strong) NSString *kerrmsg;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) NSString *url;

//2.0ηζ¬
@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

- (id)initWithResponseObject:(id)responseObject url:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
