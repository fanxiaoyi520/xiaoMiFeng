//
//  XMFHttpHelper.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "XMFResponseModel.h"//è¿åæ°æ®å½ç±»


NS_ASSUME_NONNULL_BEGIN

//æåè¿åå¤ä¸ªåæ°
typedef void(^RequestSuccessManyParmsBlock)(id responseObject, NSURLSessionDataTask *operation);

//æåè¿åå¤ä¸ªåæ°å¹¶æ°æ®å½ç±»
typedef void(^XMFRequestSuccessManyParmsBlock)(id responseObject, NSURLSessionDataTask *operation,XMFResponseModel *responseObjectModel);

//å¤±è´¥è¿åå¤ä¸ªåæ°
typedef void(^RequestFailureManyParmsBlock)(NSError *error, NSURLSessionDataTask * _Nullable operation);



typedef void(^RequestSuccessManyParmsBlock)(id responseObject, NSURLSessionDataTask *operation);



@class AFHTTPSessionManager;

@interface XMFHttpHelper : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (XMFHttpHelper *)sharedManager;

/**
 åå§åæå¡å¨

 @param server æå¡å¨å°å
 @return æå¡å¨å¯¹è±¡
 */
- (id)initWithServer:(NSString * _Nullable)server;

/**
 åæ¶å½åé¡µé¢ææçç½ç»è¯·æ±
 */
+ (void)cancelAllNetworkAciton;

/**
 åæ¶æä¸ä¸ªè¯·æ±
 
 @param path è¯·æ±æ¹æ³å
 */
+ (void)cancelRequestWithPath:(NSString *)path;


/**
 æ£æ¥ç½ç»ç¶æ

 @return æ¯å¦èç½
 */
+ (BOOL)checkNetStatus;



/**
 åégetè¯·æ±
 
 @param URLString è¯·æ±urlæèæ¹æ³å
 @param parameters è¯·æ±åæ°
 @param success è¯·æ±æå
 @param failure è¯·æ±å¤±è´¥
 @return è¯·æ±å®ä¾
 */
- (NSURLSessionTask *)XMFSendGETRequestMethod:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(RequestSuccessManyParmsBlock)success
                       failure:(RequestFailureManyParmsBlock)failure;

/**
 
 
 åépostè¯·æ±
 
 @param URLString è¯·æ±urlæèæ¹æ³å
 @param parameters è¯·æ±åæ°
 @param success è¯·æ±æå
 @param failure è¯·æ±å¤±è´¥
 @return è¯·æ±å®ä¾
 */
- (NSURLSessionTask *)XMFSendPOSTRequestMethod:(NSString *)URLString parameters:(NSDictionary *)parameters success:(RequestSuccessManyParmsBlock)success failure:(RequestFailureManyParmsBlock)failure;


@end

NS_ASSUME_NONNULL_END
