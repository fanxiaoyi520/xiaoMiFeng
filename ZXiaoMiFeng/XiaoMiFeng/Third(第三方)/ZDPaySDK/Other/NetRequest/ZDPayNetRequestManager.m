//
//  ZDPayNetRequestManager.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayNetRequestManager.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_OrderSureViewController.h"
typedef void (^ZDPayCompletioBlock)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^ZDPaySuccessBlock)(NSDictionary *data);
typedef void (^ZDPayFailureBlock)(NSError *error);

@implementation ZDPayNetRequestManager
+ (instancetype)sharedSingleton {
    static ZDPayNetRequestManager *_payNetRequestManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _payNetRequestManager = [[ZDPayNetRequestManager alloc] init];
    });
    return _payNetRequestManager;
}

- (void)zd_netRequestVC:(ZDPayRootViewController *)requestVC
                 Params:(id)params
             postUrlStr:(NSString *)urlStr
                suscess:(void (^)(id _Nullable responseObject))suscess {
    NSParameterAssert(params);
    NSParameterAssert(urlStr);
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setDictionary:params];
    NSArray *array = param.allKeys;
    if (![array containsObject:@"languageType"]) {
        [param setValue:[[ZDPay_OrderSureModel sharedSingleten] getModelData].language forKey:@"languageType"];
    }

    NSString *signData = [self encodedSendingBody:param];
    NSString *s = [self encryptSendingBody:param];
    NSString *encryptData = [[EncryptAndDecryptTool sharedSingleton] AESEncryptWithString:s andKey:[[ZDPay_OrderSureModel sharedSingleten] getModelData].AES_Key];
    NSDictionary *paramsDic = @{
        @"signData":signData,
        @"service":[[ZDPay_OrderSureModel sharedSingleten] getModelData].service_d,
        @"encryptData":encryptData,
        @"merId":[[ZDPay_OrderSureModel sharedSingleten] getModelData].merId,
        @"sdkVersion":@"1.0.0",
        @"version":[[ZDPay_OrderSureModel sharedSingleten] getModelData].version
    };
    
    [requestVC.activityIndicator startAnimating];
    requestVC.view.userInteractionEnabled = NO;
    [ZDPayNetRequestManager postWithUrlString:urlStr parameters:paramsDic success:^(NSDictionary *responseObject) {
        if (responseObject != nil) {
            [requestVC.activityIndicator stopAnimating];
            requestVC.view.userInteractionEnabled = YES;
            NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];

            if ([code isEqualToString:@"200"]) {
                NSDictionary *dic = [self getDicFromResponseObject:responseObject];
                suscess(dic);
            } else {
                NSDictionary *dic = [self getDicFromResponseObject:responseObject];
                suscess(dic);
                
                if (![[responseObject objectForKey:@"code"] isEqualToString:@"79"] || ![urlStr containsString:@"/pay-gateway/pay/payment"]) {
                    [requestVC showMessage:[responseObject objectForKey:@"message"] target:self];
                    return;
                }
                
                if ([urlStr containsString:@"/pay-gateway/pay/payment"]) {
                    //密码错误
                    if ([[responseObject objectForKey:@"code"] isEqualToString:@"400"]) {
                        [requestVC showMessage:[responseObject objectForKey:@"message"] target:nil];
                        return;
                    }
                    
                    /**
                    30交易失败，请尝试使用其他银联卡付款或联系95516
                    37超过最大查询数量或操作太频繁
                    33交易金额超过限额
                    63卡状态不正确
                    64卡余额不足
                    */
                    if ([[responseObject objectForKey:@"code"] isEqualToString:@"64"]
                        || [[responseObject objectForKey:@"code"] isEqualToString:@"30"]
                        || [[responseObject objectForKey:@"code"] isEqualToString:@"37"]
                        || [[responseObject objectForKey:@"code"] isEqualToString:@"33"]
                        || [[responseObject objectForKey:@"code"] isEqualToString:@"63"]) {
                        [requestVC showMessage:[responseObject objectForKey:@"message"] target:nil];
                        return;
                    }
                    
                    ZDPay_OrderSureViewController *vc = (ZDPay_OrderSureViewController *)requestVC;
                    //收到 03 04  05 的话，直接送给商户端，由商户主动发起交易状态查询
                    if ([[responseObject objectForKey:@"code"] isEqualToString:@"03"]
                        || [[responseObject objectForKey:@"code"] isEqualToString:@"04"]
                        || [[responseObject objectForKey:@"code"] isEqualToString:@"05"]) {
                        NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"5000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付失败"];
                        [mutableDic setValue:[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode forKey:@"paymentMethod"];          
                        vc.completionBlock(mutableDic);
                        return;
                    }
                    
                    NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:[responseObject objectForKey:@"data"] withMessage:@"服务器错误"];
                    vc.completionBlock(mutableDic);
                }
            }
        } else {
            NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:@"" withMessage:@"服务器内部错误"];
            ZDPay_OrderSureViewController *vc = (ZDPay_OrderSureViewController *)requestVC;
            vc.completionBlock(mutableDic);
        }
    } failure:^(NSError *error) {
        [requestVC.activityIndicator stopAnimating];
        requestVC.view.userInteractionEnabled = YES;
        if (error) {
            NSString *responseData = error.userInfo[NSLocalizedDescriptionKey];
            if (![urlStr containsString:@"/pay-gateway/pay/payment"]) {
                [requestVC showMessage:responseData target:nil];
            } else {
                NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:responseData withMessage:@"支付失败"];
                [mutableDic setValue:[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode forKey:@"paymentMethod"];
                ZDPay_OrderSureViewController *vc = (ZDPay_OrderSureViewController *)requestVC;
                vc.completionBlock(mutableDic);
            }
        }
    }];
}

//返回字典
- (NSDictionary *)getDicFromResponseObject:(id)responseObject {
    NSString *code = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
    NSString *data = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
    NSString *encryptData = [[EncryptAndDecryptTool sharedSingleton] AESDecryptWithString:data andKey:[[ZDPay_OrderSureModel sharedSingleten] getModelData].AES_Key];
    NSDictionary *dics = nil;
    if ([self dictionaryWithJsonString:encryptData]) {
        dics = [self dictionaryWithJsonString:encryptData];
    } else {
        dics = @{};
    }
    NSDictionary *dic = @{
        @"code":code,
        @"data":dics,
        @"message":[responseObject objectForKey:@"message"],
    };
    return dic;
}

//JSON字符串转化为字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 对字符串/数组/字典的加密 ----以上修改之后可直接上传返回的字符串
 */
- (NSString*)encryptSendingBody:(id)params{
    NSString * dataStr;
    if ([params isKindOfClass:[NSString class]]) {
        dataStr = params;
    }else{
        NSError*error;
        NSData * data =  [NSJSONSerialization dataWithJSONObject:params
                                                         options:0
                                                           error:&error];
        dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    return dataStr;
}

- (NSString*)encodedSendingBody:(id)params{
    NSString * dataStr;
    if ([params isKindOfClass:[NSString class]]) {
        dataStr = params;
    }else{
        NSError*error;
        NSData * data =  [NSJSONSerialization dataWithJSONObject:params
                                                         options:0
                                                           error:&error];
        dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }

    //aes签名
    NSString *encryptStr = [[EncryptAndDecryptTool sharedSingleton] AESEncryptWithString:dataStr andKey:[[ZDPay_OrderSureModel sharedSingleten] getModelData].AES_Key];
    //加签 将所有参与签名的参数名按照字母ASCII码从小到大顺序排序，拼接成”paramName1=value1&paramName2=value2”
    NSDictionary *paramsDic = @{
        @"encryptData":encryptStr,
        @"service":[[ZDPay_OrderSureModel sharedSingleten] getModelData].service_d,
        @"merId":[[ZDPay_OrderSureModel sharedSingleten] getModelData].merId,
        @"sdkVersion":@"1.0.0",
        @"version":[[ZDPay_OrderSureModel sharedSingleten] getModelData].version,
    };
    NSArray *dicAarray = paramsDic.allKeys;
    NSStringCompareOptions comparisonOptions =NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range =NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    NSArray *resultArray2 = [dicAarray sortedArrayUsingComparator:sort];
    NSString *printStr = @"";
    for(int i = 0; i < [resultArray2 count]; i++){
        printStr = [printStr stringByAppendingFormat:@"%@=%@&",resultArray2[i], [paramsDic objectForKey:[resultArray2 objectAtIndex:i]]];
    }
    
    printStr = [printStr stringByAppendingFormat:@"key=%@",[[ZDPay_OrderSureModel sharedSingleten] getModelData].md5_salt];
    NSString *md532 = [[EncryptAndDecryptTool sharedSingleton] md5_32:printStr upperCase:NO];
    return  md532;
}

#pragma mark - 系统自带请求
//POST请求 使用NSMutableURLRequest可以加入请求头
+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(ZDPaySuccessBlock)successBlock failure:(ZDPayFailureBlock)failureBlock
{
    //NSURL *nsurl = [NSURL URLWithString:url];
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:nsurl];
    //如果想要设置网络超时的时间的话，可以使用下面的方法：
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    //设置请求类型
    request.HTTPMethod = @"POST";
    //将需要的信息放入请求头 随便定义了几个
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //把参数放到请求体内
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
    //设置请求体
    [request setHTTPBody:jsonData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) { //请求失败
                failureBlock(error);
            } else {  //请求成功
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                successBlock(dic);
            }
        });
    }];
    [dataTask resume];  //开始请求
}

@end
