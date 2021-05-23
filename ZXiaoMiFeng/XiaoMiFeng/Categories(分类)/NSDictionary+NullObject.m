//
//  NSDictionary+NullObject.m
//  XzfPos
//
//  Created by wd on 2018/1/4.
//  Copyright © 2018年 ideasforHK. All rights reserved.
//

#import "NSDictionary+NullObject.h"

@implementation NSDictionary (NullObject)

-(id)notNullObjectForKey:(NSString *)key{
    @try {
        id str = [self objectForKey:key];
        
        if ([str isKindOfClass:[NSNull class]] || str == NULL ||
            [self isKindOfClass:[NSNull class]] ||
            ([str isKindOfClass:[NSString class]] && [str isEqualToString:@"null"])) {
//            return nil;
            return @"";
        }
        else{
//            if ([str isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = [self objectForKey:key];
//                if (dic[@"code"]) {
//                    return str;
//                }
//                return nil;
//            }
            return str;
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

// 返回判空后的字符串
- (NSString *)stringWithKey:(NSString *)key {
    return [NSString stringWithFormat:@"%@",[self notNullObjectForKey:key]];
}

// 返回判空后的整形
- (NSInteger)integerWithKey:(NSString *)key {
    return [[self notNullObjectForKey:key] integerValue];
}

// 返回判空后的浮点型
- (CGFloat)floatWithKey:(NSString *)key {
    return [[self notNullObjectForKey:key] floatValue];
}

- (CGFloat)doubleWithKey:(NSString *)key {
    return [[self notNullObjectForKey:key] doubleValue];
}

// 返回判空后的BOOL
- (BOOL)boolWithKey:(NSString *)key {
    return [[self notNullObjectForKey:key] boolValue];
}

@end
