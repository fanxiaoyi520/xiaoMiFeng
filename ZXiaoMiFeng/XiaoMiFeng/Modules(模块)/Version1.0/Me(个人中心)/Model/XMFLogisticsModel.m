//
//  XMFLogisticsModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/19.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFLogisticsModel.h"

@implementation XMFLogisticsTracksModel



@end

@implementation XMFLogisticsModel

//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
//è¿åä¸ä¸ª Dictï¼å° Model å±æ§åå¯¹æ å°å° JSON ç Keyã
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"tracksDescription":@"description",
             
             
             };
}


//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"tracks" : [XMFLogisticsTracksModel class],
             
             };
}

@end
