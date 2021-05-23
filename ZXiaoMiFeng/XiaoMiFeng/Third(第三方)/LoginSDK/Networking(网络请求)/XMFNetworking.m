//
//  XMFNetworking.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/26.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFNetworking.h"
//#import "XMFURLString.h"//接口地址宏定义
#import "NSString+NetworkParameters.h"//网络请求参数处理
#import "NSString+MD5.h"//MD5加密


NSString *const ResponseErrorKey = @"com.alamofire.serialization.response.error.response";
NSInteger const Interval = 30;


//在.m文件中添加
@interface  XMFNetworking()



@end

@implementation XMFNetworking

//原生GET网络请求
+(void)GETWithURL:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure{
    //完整URL
    NSString *urlString = [NSString string];
    if (params) {
        //参数拼接url
        NSString *paramStr = [self dealWithParam:params];
        urlString = [url stringByAppendingString:paramStr];
    }else{
        urlString = url;
    }
    //对URL中的中文进行转码
    NSString *pathStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:pathStr]];
    
    request.timeoutInterval = Interval;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                //解析返回数据为统一格式
                XMFResponseObjectModel *responseModel = [[XMFResponseObjectModel alloc] initWithResponseObject:data url:pathStr];
                
                success(dict,responseModel);
                
            }else{
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                    failure(ResponseStr);
                    
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                    failure(ErrorCode);
                }
            }

        });
    }];
    
    [task resume];
}


//原生POST网络请求
+(void)POSTWithURL:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure{
    
    //完整的接口地址
    NSString *URLAbsoluteString = [NSString stringWithFormat:@"%@%@", XMF_PREFIX_URL, url];
    

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLAbsoluteString]];
    [request setHTTPMethod:@"POST"];
    
   //设置本次请求的数据请求格式
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //把字典中的参数进行拼接
//    NSString *body = [self dealWithParam:params];
//    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    //把参数放到请求体内
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    //设置请求体
    [request setHTTPBody:bodyData];
    //设置本次请求的数据请求格式
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    

    // 设置本次请求请求体的长度(因为服务器会根据你这个设定的长度去解析你的请求体中的参数内容)
    [request setValue:[NSString stringWithFormat:@"%ld", bodyData.length] forHTTPHeaderField:@"Content-Length"];
    //设置请求最长时间
    request.timeoutInterval = Interval;
    
    //设置请求头
    [request setValue:UserInfoModel.token forHTTPHeaderField:@"X-Member-Token"];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //需要放在主线程里面执行，要不然会内存泄漏
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (data) {
                //利用iOS自带原生JSON解析data数据 保存为Dictionary
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                //解析返回数据为统一格式
                XMFResponseObjectModel *responseModel = [[XMFResponseObjectModel alloc] initWithResponseObject:data url:URLAbsoluteString];
                
                success(dict,responseModel);
                
                
            }else{
                NSHTTPURLResponse *httpResponse = error.userInfo[ResponseErrorKey];
                
                if (httpResponse.statusCode != 0) {
                    
                    NSString *ResponseStr = [self showErrorInfoWithStatusCode:httpResponse.statusCode];
                    failure(ResponseStr);
                    
                } else {
                    NSString *ErrorCode = [self showErrorInfoWithStatusCode:error.code];
                    failure(ErrorCode);
                    
                    //提示报错信息
                    [kAppWindow makeToastOnCenter:ErrorCode];
                }
            }
 
            
        });
        
    
    }];
    [task resume];
}


//原生POST网络请求包含公共参数的方法
+ (void)POSTWithURLContainParams:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure{
    

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    //获取时间戳
    [dict setValue:[DateUtils getNowTimeTimestamp] forKey:@"timestamp"];
    
    //平台编码
    [dict setValue:[CommonManager getPlatformCode] forKey:@"platformCode"];
    
    [dict setObject:[self md5StrWithDict:dict key:[CommonManager getMD5Key]] forKey:@"signature"];
    
    [self POSTWithURL:url Params:dict success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        success(responseObject,responseObjectModel);
        
    } failure:^(NSString * _Nonnull error) {
        
        failure(error);
        
    }];

    
    
}

#pragma mark -- 拼接参数
+ (NSString *)dealWithParam:(NSDictionary *)param
{
    NSArray *allkeys = [param allKeys];
//    NSMutableString *result = [NSMutableString string];
    NSMutableString *result = [NSMutableString stringWithString:XMF_PREFIX_URL];

    
    for (NSString *key in allkeys) {
        NSString *string = [NSString stringWithFormat:@"%@=%@&", key, param[key]];
        [result appendString:string];
    }
    return result;
}

#pragma mark  获取失败的code和提示语
+ (NSString *)showErrorInfoWithStatusCode:(NSInteger)statusCode{
    
    NSString *message = nil;
    switch (statusCode) {
        case 401: {
        
        }
            break;
            
        case 500: {
            message = @"服务器异常！";
        }
            break;
            
        case -1001: {
            message = @"网络请求超时，请稍后重试！";
        }
            break;
            
        case -1002: {
            message = @"不支持的URL！";
        }
            break;
            
        case -1003: {
            message = @"未能找到指定的服务器！";
        }
            break;
            
        case -1004: {
            message = @"服务器连接失败！";
        }
            break;
            
        case -1005: {
            message = @"连接丢失，请稍后重试！";
        }
            break;
            
        case -1009: {
            message = @"互联网连接似乎是离线！";
        }
            break;
            
        case -1012: {
            message = @"操作无法完成！";
        }
            break;
            
        default: {
            message = @"网络请求发生未知错误，请稍后再试！";
        }
            break;
    }
    return message;
    
}


#pragma mark - ——————— MD5加密 ————————
+(NSString *)md5StrWithDict:(NSDictionary *)parameters key:(NSString *)key{
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *plainText = [NSString getSanwingNetworkParam:dict];
    
//    NSString *md5BeforeStr = [NSString stringWithFormat:@"%@&%@", plainText, key];
    
    NSString *md5Str = [[[NSString stringWithFormat:@"%@&%@", plainText, key] MD5String] uppercaseString];
    return md5Str;
}

@end
