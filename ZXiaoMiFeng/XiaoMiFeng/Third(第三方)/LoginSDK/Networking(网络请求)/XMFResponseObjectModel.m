//
//  XMFResponseObjectModel.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/7.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFResponseObjectModel.h"

@implementation XMFResponseObjectModel


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
                DLog(@"%@", dictionary);
                //防止后台直接返回null的处理
                self.code = XMFNetworkingReturnCodeFailure;
            }
        }
        else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            [self setModelValue:responseObject];
        }
        else {
            DLog(@"服务器返回数据格式错误！");
            DLog(@"%@", responseObject);
           
        }
    }
    
    return self;
}

- (void)setModelValue:(NSDictionary *)dictionary {
   
    self.code = [[dictionary notNullObjectForKey:@"code"] integerValue];
    
    self.message = [dictionary notNullObjectForKey:@"message"];
    
    self.data = [dictionary notNullObjectForKey:@"data"];
    
    DLog(@"%@", self);
}


- (NSString *)description {
    NSMutableString *string = [NSMutableString string];
    if (self.url) {
        
        [string appendFormat:@"\n响应数据response:\n\n请求地址URL:%@", self.url];
    }
    [string appendFormat:@"\n\n错误码errno:%ld", self.code];
   
    [string appendFormat:@"\n\n错误语errmsg:%@", self.message];
   
    [string appendFormat:@"\n\n数据data:%@\n", self.data];
   
    return string;
}




@end
