//
//  XMFUserHttpHelper.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFUserHttpHelper.h"
#import "NSString+NetworkParameters.h"


static XMFUserHttpHelper *instance = nil;

//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFUserHttpHelper()

@end

@implementation XMFUserHttpHelper

//åå»ºåä¾
+(XMFUserHttpHelper *)sharedManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
       
        instance = [[XMFUserHttpHelper alloc]initWithServer:XMF_BASE_URL];
        
    });
    
    return instance;
    
}


#pragma mark - âââââââ GETè¯·æ± ââââââââ
-(void)XMFUserSendGETRequestMethod:(NSString *)URLString parameters:(NSDictionary * _Nullable)parameters success:(XMFRequestSuccessManyParmsBlock)success failure:(RequestFailureManyParmsBlock)failure{
    
    //æ¥å£æ¼æ¥
       NSString *url = [NSString stringWithFormat:@"%@%@", XMF_BASE_URL, URLString];
    
//    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    //è®¾ç½®è¯·æ±å¤´
    [super.manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
    
    
    [super  XMFSendGETRequestMethod:url parameters:parameters success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation) {
        
        //dataè½¬json
        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //è§£æè¿åæ°æ®ä¸ºç»ä¸æ ¼å¼
        XMFResponseModel *responseModel = [[XMFResponseModel alloc] initWithResponseObject:responseObject url:url];
        
        success(responseDic,operation,responseModel);
        
        //å½éè¯¯ç ä¸º401çæ¶åè¡¨ç¤ºç»å½å¤±æ
        if (responseModel.code == 401) {
            
            [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:kAppWindow.rootViewController];
            
            [UserInfoManager removeUserInfo];
            
            //éåºç»å½åééç¥
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, nil);
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        failure(error,operation);
        
        DLog(@"error.codeå¤±è´¥éè¯¯ç :%zd",error.code);
        
        //è¯·æ±è¶æ¶

        NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
        
        if ([errorCode isEqualToString:@"-1001"] || [errorCode isEqualToString:@"-1011"]) {
            
//            [MBProgressHUD showError:XMFLI(@"è¯·æ±è¶æ¶ï¼ç¨ååè¯") toView:kAppWindow];
        }
        
        //localizedDescriptionè¡¨ç¤ºéè¯¯åå æè¿°
//        [MBProgressHUD showError:error.localizedDescription toView:kAppWindow];
        
    }];
    
    
}


#pragma mark - âââââââ POSTè¯·æ± ââââââââ

-(void)XMFUserSendPOSTRequestMethod:(NSString *)URLString parameters:(NSDictionary * _Nullable)parameters success:(XMFRequestSuccessManyParmsBlock)success failure:(RequestFailureManyParmsBlock)failure{
    
    
    //æ¥å£æ¼æ¥
    NSString *url = [NSString stringWithFormat:@"%@%@", XMF_BASE_URL, URLString];
    
    //è®¾ç½®è¯·æ±å¤´
    [super.manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
    
    [super XMFSendPOSTRequestMethod:url parameters:parameters success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation) {
        
        //dataè½¬json
        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //è§£æè¿åæ°æ®ä¸ºç»ä¸æ ¼å¼
        XMFResponseModel *responseModel = [[XMFResponseModel alloc] initWithResponseObject:responseObject url:url];
        
        success(responseDic,operation,responseModel);
        
        //å½éè¯¯ç ä¸º401çæ¶åè¡¨ç¤ºç»å½å¤±æ
        if (responseModel.code == 401) {
                   
            [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:kAppWindow.rootViewController];
                   
            [UserInfoManager removeUserInfo];
            
            //éåºç»å½åééç¥
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, nil);
                   
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
         failure(error,operation);

        //è¯·æ±è¶æ¶
        
        NSString *errorCode = [NSString stringWithFormat:@"%zd",error.code];
        
        if ([errorCode isEqualToString:@"-1001"] || [errorCode isEqualToString:@"-1011"]) {
            
//            [MBProgressHUD showError:XMFLI(@"è¯·æ±è¶æ¶ï¼ç¨ååè¯") toView:kAppWindow];
        }
        
    }];
    
    
    
}


@end
