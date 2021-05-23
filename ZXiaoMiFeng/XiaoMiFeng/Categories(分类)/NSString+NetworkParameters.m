//
//  NSString+NetworkParameters.m
//  Agent
//
//  Created by ideasforHK on 2018/9/17.
//  Copyright © 2018年 ideasforHK. All rights reserved.
//

#import "NSString+NetworkParameters.h"

@implementation NSString (NetworkParameters)

// 对需要进行签名的字段进行拼接（并进行ASCII排序）
+(NSString *) getSanwingNetworkParam:(NSDictionary *) paramDic{
    NSString *result = [NSString string];
    BOOL first = YES;
    
    // 字符串数组排序
    NSArray *paramKey = [paramDic allKeys];
    
    NSStringCompareOptions comparisonOptions = NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSComparator sort = ^(NSString *obj1, NSString *obj2){
        NSRange range = NSMakeRange(0, obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    NSArray *paramKeySorted = [paramKey sortedArrayUsingComparator:sort];
    
    for(int i = 0; i < paramKeySorted.count; i++){
        if(!first){
            result = [result stringByAppendingString:@"&"];
        }
        first = NO;
        
        result = [result stringByAppendingString: paramKeySorted[i]];
        result = [result stringByAppendingString: @"="];
        NSString *value = [paramDic objectForKey: paramKeySorted[i]];
        if(value != nil && ![value isEqualToString:@""]){
            result = [result stringByAppendingString:value];
        }
    }
    
    return result;
}

//字典转JSON
+(NSString *)convertJSONWithDic:(NSDictionary *)dic {
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        return @"字典转JSON出错";
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}



@end
