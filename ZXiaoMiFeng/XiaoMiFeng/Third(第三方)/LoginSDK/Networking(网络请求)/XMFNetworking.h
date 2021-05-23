//
//  XMFNetworking.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/26.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFResponseObjectModel;


typedef void (^NetSuccessBlock)(id responseObject , XMFResponseObjectModel *responseObjectModel);

typedef void (^NetFailureBlock)(NSString *error);

@interface XMFNetworking : NSObject

//原生GET网络请求
+ (void)GETWithURL:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure;

//原生POST网络请求
+ (void)POSTWithURL:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure;


//原生POST网络请求包含公共参数的方法
+ (void)POSTWithURLContainParams:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure;



@end

NS_ASSUME_NONNULL_END
