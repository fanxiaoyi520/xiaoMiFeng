//
//  XMFUserHttpHelper.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFUserHttpHelper.h"
#import "NSString+NetworkParameters.h"


static XMFUserHttpHelper *instance = nil;

//在.m文件中添加
@interface  XMFUserHttpHelper()

@end

@implementation XMFUserHttpHelper

//创建单例
+(XMFUserHttpHelper *)sharedManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
       
        instance = [[XMFUserHttpHelper alloc]initWithServer:XMF_BASE_URL];
        
    });
    
    return instance;
    
}


#pragma mark - ——————— GET请求 ————————
-(void)XMFUserSendGETRequestMethod:(NSString *)URLString parameters:(NSDictionary * _Nullable)parameters success:(XMFRequestSuccessManyParmsBlock)success failure:(RequestFailureManyParmsBlock)failure{
    
    //接口拼接
       NSString *url = [NSString stringWithFormat:@"%@%@", XMF_BASE_URL, URLString];
    
//    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    //设置请求头
    [super.manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
    
    
    [super  XMFSendGETRequestMethod:url parameters:parameters success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation) {
        
        //data转json
        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //解析返回数据为统一格式
        XMFResponseModel *responseModel = [[XMFResponseModel alloc] initWithResponseObject:responseObject url:url];
        
        success(responseDic,operation,responseModel);
        
        //当错误码为401的时候表示登录失效
        if (responseModel.code == 401) {
            
            [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:kAppWindow.rootViewController];
            
            [UserInfoManager removeUserInfo];
            
            //退出登录发送通知
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, nil);
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        failure(error,operation);
        
        DLog(@"error.code失败错误码:%zd",error.code);
        
        //请求超时

        NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
        
        if ([errorCode isEqualToString:@"-1001"] || [errorCode isEqualToString:@"-1011"]) {
            
//            [MBProgressHUD showError:XMFLI(@"请求超时，稍后再试") toView:kAppWindow];
        }
        
        //localizedDescription表示错误原因描述
//        [MBProgressHUD showError:error.localizedDescription toView:kAppWindow];
        
    }];
    
    
}


#pragma mark - ——————— POST请求 ————————

-(void)XMFUserSendPOSTRequestMethod:(NSString *)URLString parameters:(NSDictionary * _Nullable)parameters success:(XMFRequestSuccessManyParmsBlock)success failure:(RequestFailureManyParmsBlock)failure{
    
    
    //接口拼接
    NSString *url = [NSString stringWithFormat:@"%@%@", XMF_BASE_URL, URLString];
    
    //设置请求头
    [super.manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
    
    [super XMFSendPOSTRequestMethod:url parameters:parameters success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation) {
        
        //data转json
        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //解析返回数据为统一格式
        XMFResponseModel *responseModel = [[XMFResponseModel alloc] initWithResponseObject:responseObject url:url];
        
        success(responseDic,operation,responseModel);
        
        //当错误码为401的时候表示登录失效
        if (responseModel.code == 401) {
                   
            [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:kAppWindow.rootViewController];
                   
            [UserInfoManager removeUserInfo];
            
            //退出登录发送通知
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, nil);
                   
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
         failure(error,operation);

        //请求超时
        
        NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
        
        if ([errorCode isEqualToString:@"-1001"] || [errorCode isEqualToString:@"-1011"]) {
            
//            [MBProgressHUD showError:XMFLI(@"请求超时，稍后再试") toView:kAppWindow];
        }
        
    }];
    
    
    
}


@end
