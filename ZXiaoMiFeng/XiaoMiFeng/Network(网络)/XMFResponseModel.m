//
//  XMFResponseModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/22.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
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
                DLog(@"æå¡å¨è¿åæ°æ®jsonè§£æå¤±è´¥ï¼");
                DLog(@"æå¡å¨è¿åæ°æ®:%@", dictionary);
                //é²æ­¢åå°ç´æ¥è¿ånullçå¤ç
                self.kerrno = XMFHttpReturnCodeFailure;
                self.code = XMFHttpReturnCodeFailure;
            }
        }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            [self setModelValue:responseObject];
            
        }else {
            DLog(@"æå¡å¨è¿åæ°æ®æ ¼å¼éè¯¯ï¼");
            DLog(@"è¿åæ°æ®æ ¼å¼:%@", responseObject);
           
        }
    }
    
    return self;
}

- (void)setModelValue:(NSDictionary *)dictionary {
    self.kerrno = [[dictionary notNullObjectForKey:@"errno"] integerValue];
    /*
     
     åå°çº¦å®78æ¯ä¸æç»å½å¤±æä½¿ç¨ï¼
     
    returnCode:78
    returnMsg:ç»å½å·²å¤±æï¼
     */
    
    /*
    if (self.returnCode == 78) {
        
        [XLAlertController acWithMessage:@"ç»éå·²å¤±æ,è«éæ°ç»é" confirmBtnTitle:@"ç¢ºå®" confirmAction:^(UIAlertAction *action) {
            
            //ç»å½å¤±è´¥
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
        
        [string appendFormat:@"\nååºæ°æ®response:\n\nè¯·æ±å°åURL:%@", self.url];
    }
    
    
    [string appendFormat:@"\n1.0çæ¬éè¯¯ç errno:%ld", self.kerrno];
   
    [string appendFormat:@"\n1.0çæ¬éè¯¯è¯­errmsg:%@", self.kerrmsg];
    
    [string appendFormat:@"\n2.0çæ¬éè¯¯ç code:%zd", self.code];
   
    [string appendFormat:@"\n2.0çæ¬éè¯¯è¯­message:%@", self.message];
    
    [string appendFormat:@"\næ°æ®data:%@\n", self.data];
   
    return string;
}


@end
