//
//  XMFUserModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/23.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFUserModel.h"

@implementation XMFUserModel


/*
//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"userInfo" : [XMFUserInfoModel class],
            
             
             };
}
*/



//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"avatarUrl":@"userAvatar",
             
             };
}

@end
