//
//  XMFPlatformInfoModel.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFPlatformInfoModel.h"

@implementation XMFPlatformInfoModel

//重写方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.accessTime =  [aDecoder decodeObjectForKey:@"accessTime"];
        
        self.enableAlipay =  [aDecoder decodeObjectForKey:@"enableAlipay"];
        
        self.enableApple =  [aDecoder decodeObjectForKey:@"enableApple"];
        
        
        self.enableFacebook =  [aDecoder decodeObjectForKey:@"enableFacebook"];
        
        self.enableGoogle =  [aDecoder decodeObjectForKey:@"enableGoogle"];
        
        self.enableInstagram =  [aDecoder decodeObjectForKey:@"enableInstagram"];
        
        self.enableLine =  [aDecoder decodeObjectForKey:@"enableLine"];
        
        self.enableQq =  [aDecoder decodeObjectForKey:@"enableQq"];
        
        self.enableTiktok =  [aDecoder decodeObjectForKey:@"enableTiktok"];
        
        self.enableTwitter =  [aDecoder decodeObjectForKey:@"enableTwitter"];
        
        self.enableWechat =  [aDecoder decodeObjectForKey:@"enableWechat"];
        
        self.enableWeibo =  [aDecoder decodeObjectForKey:@"enableWeibo"];
        
        self.enableWhatsapp =  [aDecoder decodeObjectForKey:@"enableWhatsapp"];
        
        self.logoAlign =  [aDecoder decodeObjectForKey:@"logoAlign"];
        
        self.logoUrl =  [aDecoder decodeObjectForKey:@"logoUrl"];
        
        self.platformCode =  [aDecoder decodeObjectForKey:@"platformCode"];
        
        self.platformName =  [aDecoder decodeObjectForKey:@"platformName"];
        
        
        
        
    }
    
    return self;
    
    
}


//重写方法
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.accessTime forKey:@"accessTime"];
    
    
    [aCoder encodeObject:self.enableAlipay forKey:@"enableAlipay"];
    
    
    [aCoder encodeObject:self.enableApple forKey:@"enableApple"];
    
    
    [aCoder encodeObject:self.enableFacebook forKey:@"enableFacebook"];
    
    
    [aCoder encodeObject:self.enableGoogle forKey:@"enableGoogle"];
    
    
    [aCoder encodeObject:self.enableInstagram forKey:@"enableInstagram"];
    
    [aCoder encodeObject:self.enableLine forKey:@"enableLine"];
    
    
    [aCoder encodeObject:self.enableQq forKey:@"enableQq"];
    
    
    [aCoder encodeObject:self.enableTiktok forKey:@"enableTiktok"];
    
    [aCoder encodeObject:self.enableTwitter forKey:@"enableTwitter"];
    
    
    [aCoder encodeObject:self.enableWechat forKey:@"enableWechat"];
    
    
    [aCoder encodeObject:self.enableWeibo forKey:@"enableWeibo"];
    
    [aCoder encodeObject:self.enableWhatsapp forKey:@"enableWhatsapp"];
    
    
    [aCoder encodeObject:self.logoAlign forKey:@"logoAlign"];
    
    
    [aCoder encodeObject:self.logoUrl forKey:@"logoUrl"];
    
    [aCoder encodeObject:self.platformCode forKey:@"platformCode"];
    
    [aCoder encodeObject:self.platformName forKey:@"platformName"];
    
    
}



@end
