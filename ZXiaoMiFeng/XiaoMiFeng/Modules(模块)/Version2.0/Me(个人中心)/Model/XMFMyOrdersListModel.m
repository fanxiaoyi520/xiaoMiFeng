//
//  XMFMyOrdersListModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFMyOrdersListModel.h"


@implementation XMFMyOrdersListRefundInfoDtoModel

//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
//è¿åä¸ä¸ª Dictï¼å° Model å±æ§åå¯¹æ å°å° JSON ç Keyã
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


@end




@implementation XMFMyOrdersListHandleOptionModel

//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
//è¿åä¸ä¸ª Dictï¼å° Model å±æ§åå¯¹æ å°å° JSON ç Keyã
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"orderDelete":@"delete",
             
             
             };
}


@end




@implementation XMFMyOrdersListGoodsListModel

//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
//è¿åä¸ä¸ª Dictï¼å° Model å±æ§åå¯¹æ å°å° JSON ç Keyã
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


//æå è½½
-(NSMutableArray *)picUrlsArr{
    
    if (_picUrlsArr == nil) {
        _picUrlsArr = [[NSMutableArray alloc] init];
    }
    return _picUrlsArr;
}

@end



@implementation XMFMyOrdersListModel

//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
        
        @"goodsList" : [XMFMyOrdersListGoodsListModel class],
        
//        @"handleOption" : [XMFMyOrdersListHandleOptionModel class],
        
        @"refundInfoDto":[XMFMyOrdersListRefundInfoDtoModel class]
        
    };
}


//å±æ§åç§°æ¿æ¢æèæ å°:åé¢ä¸ºå®ä¹çåç§°ï¼åé¢ä¸ºæå¡å¨è¿åéè¦æ å°çåç§°
//è¿åä¸ä¸ª Dictï¼å° Model å±æ§åå¯¹æ å°å° JSON ç Keyã
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
        
             @"keyId":@"id",
             
             
             };
}


@end
