//
//  XMFHttpHelper.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "XMFResponseModel.h"//返回数据归类


NS_ASSUME_NONNULL_BEGIN

//成功返回多个参数
typedef void(^RequestSuccessManyParmsBlock)(id responseObject, NSURLSessionDataTask *operation);

//成功返回多个参数并数据归类
typedef void(^XMFRequestSuccessManyParmsBlock)(id responseObject, NSURLSessionDataTask *operation,XMFResponseModel *responseObjectModel);

//失败返回多个参数
typedef void(^RequestFailureManyParmsBlock)(NSError *error, NSURLSessionDataTask * _Nullable operation);



typedef void(^RequestSuccessManyParmsBlock)(id responseObject, NSURLSessionDataTask *operation);



@class AFHTTPSessionManager;

@interface XMFHttpHelper : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (XMFHttpHelper *)sharedManager;

/**
 初始化服务器

 @param server 服务器地址
 @return 服务器对象
 */
- (id)initWithServer:(NSString * _Nullable)server;

/**
 取消当前页面所有的网络请求
 */
+ (void)cancelAllNetworkAciton;

/**
 取消某一个请求
 
 @param path 请求方法名
 */
+ (void)cancelRequestWithPath:(NSString *)path;


/**
 检查网络状态

 @return 是否联网
 */
+ (BOOL)checkNetStatus;



/**
 发送get请求
 
 @param URLString 请求url或者方法名
 @param parameters 请求参数
 @param success 请求成功
 @param failure 请求失败
 @return 请求实例
 */
- (NSURLSessionTask *)XMFSendGETRequestMethod:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(RequestSuccessManyParmsBlock)success
                       failure:(RequestFailureManyParmsBlock)failure;

/**
 
 
 发送post请求
 
 @param URLString 请求url或者方法名
 @param parameters 请求参数
 @param success 请求成功
 @param failure 请求失败
 @return 请求实例
 */
- (NSURLSessionTask *)XMFSendPOSTRequestMethod:(NSString *)URLString parameters:(NSDictionary *)parameters success:(RequestSuccessManyParmsBlock)success failure:(RequestFailureManyParmsBlock)failure;


@end

NS_ASSUME_NONNULL_END
