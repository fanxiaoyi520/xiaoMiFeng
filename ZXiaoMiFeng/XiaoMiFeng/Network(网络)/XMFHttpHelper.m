//
//  XMFHttpHelper.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHttpHelper.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Reachability.h"


static XMFHttpHelper *instance = nil;

//在.m文件中添加
@interface  XMFHttpHelper()

@end

@implementation XMFHttpHelper

//单例创建方法
+(XMFHttpHelper *)sharedManager{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[XMFHttpHelper alloc]initWithServer:nil];
    });
    
    return instance;;
    
    
}

//初始化方法
- (id)initWithServer:(NSString *)server{
    self = [super init];
    if (self) {
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:server]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];//后台返回字符串用这个
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", @"application/html", nil];
        manager.requestSerializer.timeoutInterval = 10;
        
     
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [securityPolicy setValidatesDomainName:NO];
        [securityPolicy setAllowInvalidCertificates:YES];
       
        
        /*
        //无条件的信任服务器上的证书
        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
        // 客户端是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        // 是否在证书域字段中验证域名
        securityPolicy.validatesDomainName = NO;
        */
        
        [manager setSecurityPolicy:securityPolicy];
        // 设置不使用cookie
        AFHTTPRequestSerializer *myHTTPRequestSerializer = manager.requestSerializer;
        manager.requestSerializer = myHTTPRequestSerializer;
        [myHTTPRequestSerializer setHTTPShouldHandleCookies:NO];
        
        // 显示左上角菊花
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [AFNetworkActivityIndicatorManager sharedManager].activationDelay = 0.0;

        self.manager = manager;
    }
    return self;
}

/**
  取消当前页面所有请求
 */
+ (void)cancelAllNetworkAciton
{
    [[XMFHttpHelper sharedManager].manager.operationQueue.operations enumerateObjectsUsingBlock:^(__kindof NSOperation * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    
    [[XMFHttpHelper sharedManager].manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
}

/**
  取消某一个请求
 */
+ (void)cancelRequestWithPath:(NSString *)path {
    [[XMFHttpHelper sharedManager].manager.tasks enumerateObjectsUsingBlock:^(NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *url = [obj.currentRequest.URL absoluteString];
        NSRange range = [url rangeOfString:path];
        if (range.location != NSNotFound) {
            DLog(@"cancelled request : %@", path);
            [obj cancel];
        }
    }];
}
/**
检查网络状态
 */
+ (BOOL)checkNetStatus {
    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    return YES;
}


#pragma mark - ——————— GET请求 ————————

-(NSURLSessionTask *)XMFSendGETRequestMethod:(NSString *)URLString parameters:(NSDictionary *)parameters success:(RequestSuccessManyParmsBlock)success failure:(RequestFailureManyParmsBlock)failure{
    
    if (![XMFHttpHelper checkNetStatus]) {
        if(failure){
            failure([NSError errorWithDomain:@"当前网络不可用,请检查网络设置" code:4041 userInfo:nil],nil);
        }
        return nil;
    }
    
    NSURLSessionTask *operation = [self.manager GET:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject,task);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error,task);

        
    }];
    

    /*
    NSURLSessionTask *operation = [self.manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        success(responseObject,task);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error,task);
        
    }];*/
    
    
  

    /*
    NSURLSessionTask *operation =  [self.manager GET:URLString parameters:parameters progress:nil
                                                 success:^(NSURLSessionTask *operation, id responseObject) {
                                                     NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                                                     success(dict,operation);
                                                 }
                                                 failure:^(NSURLSessionTask *operation, NSError *error) {
                                                     failure(error,operation);
                                                    
        
                                                 }];
     
     */
       return operation;
    
    
    
    
}


#pragma mark - ——————— POST请求 ————————

-(NSURLSessionTask *)XMFSendPOSTRequestMethod:(NSString *)URLString parameters:(NSDictionary *)parameters success:(RequestSuccessManyParmsBlock)success failure:(RequestFailureManyParmsBlock)failure{
    
    
    if (![XMFHttpHelper checkNetStatus]) {
        if(failure){
            failure([NSError errorWithDomain:@"当前网络不可用,请检查网络设置" code:4041 userInfo:nil],nil);
        }
        return nil;
    }
    
    

    NSURLSessionTask *operation = [self.manager POST:URLString parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject,task);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error,task);
        
        //请求超时
        if (error.code == 1001) {
            
            
            [MBProgressHUD showTitleToView:kAppWindow contentStyle:NHHUDContentDefaultStyle title:XMFLI(@"请求超时，请重试") afterDelay:XMFDISSMISSDELAYTIME];
            
        }else{
            
            [MBProgressHUD showError:error.localizedDescription toView:kAppWindow];
        }
        
    }];
    
    
    /*
    NSURLSessionTask *operation = [self.manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
              
        success(responseObject,task);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error,task);
        
        //请求超时
        if (error.code == 1001) {
                
            
            [MBProgressHUD showTitleToView:kAppWindow contentStyle:NHHUDContentDefaultStyle title:XMFLI(@"请求超时，请重试") afterDelay:XMFDISSMISSDELAYTIME];
                  
        }else{
                  
                  //            [SVProgressHUD showErrorWithStatus:error.localizedDescription dismissDelay:ZFDISSMISSDELAYTIME];
     }
        
    }];*/
    
    
    return operation;
    
}



@end
