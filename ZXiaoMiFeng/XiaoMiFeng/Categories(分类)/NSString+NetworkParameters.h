//
//  NSString+NetworkParameters.h
//  Agent
//
//  Created by ideasforHK on 2018/9/17.
//  Copyright © 2018年 ideasforHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NetworkParameters)

+ (NSString *)getSanwingNetworkParam:(NSDictionary *)paramDic;

//字典转JSON
+(NSString *)convertJSONWithDic:(NSDictionary *)dic;


@end
