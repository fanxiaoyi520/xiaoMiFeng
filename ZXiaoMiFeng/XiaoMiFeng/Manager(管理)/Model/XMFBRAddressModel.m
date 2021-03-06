//
//  XMFBRAddressModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/7.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBRAddressModel.h"

@implementation XMFBRAreaModel

//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"index":@"id"
             
             };
}

@end


@implementation XMFBRCityModel

//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"arealist" : [XMFBRAreaModel class],
            
             
             };
}



//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"arealist":@"childs",
             
             @"index":@"id"
             
             };
}


@end



@implementation XMFBRProvinceModel

//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"citylist" : [XMFBRCityModel class],
            
             
             };
}



//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"citylist":@"childs",
             @"index":@"id"
             
             };
}


@end



@implementation XMFBRAddressModel


//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
             @"provincelist" : [XMFBRProvinceModel class],
            
             
             };
}

//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"provincelist":@"data",
        
             };
}



@end
