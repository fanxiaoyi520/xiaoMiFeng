//
//  XMFUserHttpHelper.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFHttpHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMFUserHttpHelper : XMFHttpHelper

/**
 ç¨æ·ç³»ç»ç½ç»è¯·æ±åä¾
 
 @return ç¨æ·ç½ç»åä¾
 */
+ (XMFUserHttpHelper *)sharedManager;


//GETè¯·æ±
-(void)XMFUserSendGETRequestMethod:(NSString *)URLString
parameters:(NSDictionary * _Nullable)parameters
   success:(XMFRequestSuccessManyParmsBlock)success
   failure:(RequestFailureManyParmsBlock)failure;

//POSTè¯·æ±
-(void)XMFUserSendPOSTRequestMethod:(NSString *)URLString
parameters:(NSDictionary * _Nullable)parameters
   success:(XMFRequestSuccessManyParmsBlock)success
   failure:(RequestFailureManyParmsBlock)failure;



@end

NS_ASSUME_NONNULL_END
