//
//  XMFThemeDetailModel.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/7.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFThemeDetailModel.h"


@implementation XMFThemeDetailListModel



@end

@implementation XMFThemeDetailModel


//è®¾ç½®æä¸ªå±æ§ä¸ºmodelç±»å
+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             
        @"goodsList" : [XMFThemeDetailListModel class],
      
             
             };
}



@end
