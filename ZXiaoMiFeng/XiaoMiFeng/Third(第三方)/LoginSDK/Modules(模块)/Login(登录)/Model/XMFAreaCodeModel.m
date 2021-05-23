//
//  XMFAreaCodeModel.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/8.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFAreaCodeModel.h"

@implementation XMFAreaCodeModel

//重写方法
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.countryName =  [aDecoder decodeObjectForKey:@"countryName"];
        
        self.phoneCode =  [aDecoder decodeObjectForKey:@"phoneCode"];
        
        self.domainAbbr =  [aDecoder decodeObjectForKey:@"domainAbbr"];
        
    }
    
    return self;
    
    
}


//重写方法
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.countryName forKey:@"countryName"];
    
    
    [aCoder encodeObject:self.phoneCode forKey:@"phoneCode"];
    
    
    [aCoder encodeObject:self.domainAbbr forKey:@"domainAbbr"];
    
    
}


@end
