//
//  XMFResponseModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFResponseModel.h"

@implementation XMFResponseModel

- (id)initWithResponseObject:(id)responseObject url:(NSString *)url {
    self = [super init];
    if (self) {
        self.url = url;
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSMutableDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([dictionary isKindOfClass:[NSDictionary class]]) {
                
                [self setModelValue:dictionary];
                
            }else {
                DLog(@"服务器返回数据json解析失败！");
                DLog(@"服务器返回数据:%@", dictionary);
                //防止后台直接返回null的处理
                self.kerrno = XMFHttpReturnCodeFailure;
                self.code = XMFHttpReturnCodeFailure;
            }
        }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            [self setModelValue:responseObject];
            
        }else {
            DLog(@"服务器返回数据格式错误！");
            DLog(@"返回数据格式:%@", responseObject);
           
        }
    }
    
    return self;
}

- (void)setModelValue:(NSDictionary *)dictionary {
    self.kerrno = [[dictionary notNullObjectForKey:@"errno"] integerValue];
    /*
     
     后台约定78是专指登录失效使用：
     
    returnCode:78
    returnMsg:登录已失效！
     */
    
    /*
    if (self.returnCode == 78) {
        
        [XLAlertController acWithMessage:@"登錄已失效,請重新登錄" confirmBtnTitle:@"確定" confirmAction:^(UIAlertAction *action) {
            
            //登录失败
            [[NSNotificationCenter defaultCenter] postNotificationName:DWQ_NOTIFY_LoginState_Change object:@NO userInfo:nil];
        }];
        
    }*/
    
    self.kerrmsg = [dictionary notNullObjectForKey:@"errmsg"];
    
    self.data = [dictionary notNullObjectForKey:@"data"];
    
    self.code = [[dictionary notNullObjectForKey:@"code"] integerValue];
    
    self.message = [dictionary notNullObjectForKey:@"message"];
    
    DLog(@"%@", self);
}


- (NSString *)description {
    
    NSMutableString *string = [NSMutableString string];
    if (self.url) {
        
        [string appendFormat:@"\n响应数据response:\n\n请求地址URL:%@", self.url];
    }
    
    
    [string appendFormat:@"\n1.0版本错误码errno:%ld", self.kerrno];
   
    [string appendFormat:@"\n1.0版本错误语errmsg:%@", self.kerrmsg];
    
    [string appendFormat:@"\n2.0版本错误码code:%zd", self.code];
   
    [string appendFormat:@"\n2.0版本错误语message:%@", self.message];
    
    [string appendFormat:@"\n数据data:%@\n", self.data];
   
    return string;
}


@end
