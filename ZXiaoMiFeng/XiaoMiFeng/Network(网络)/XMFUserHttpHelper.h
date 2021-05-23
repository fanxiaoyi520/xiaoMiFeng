//
//  XMFUserHttpHelper.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHttpHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMFUserHttpHelper : XMFHttpHelper

/**
 用户系统网络请求单例
 
 @return 用户网络单例
 */
+ (XMFUserHttpHelper *)sharedManager;


//GET请求
-(void)XMFUserSendGETRequestMethod:(NSString *)URLString
parameters:(NSDictionary * _Nullable)parameters
   success:(XMFRequestSuccessManyParmsBlock)success
   failure:(RequestFailureManyParmsBlock)failure;

//POST请求
-(void)XMFUserSendPOSTRequestMethod:(NSString *)URLString
parameters:(NSDictionary * _Nullable)parameters
   success:(XMFRequestSuccessManyParmsBlock)success
   failure:(RequestFailureManyParmsBlock)failure;



@end

NS_ASSUME_NONNULL_END
