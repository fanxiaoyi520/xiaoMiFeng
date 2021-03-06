//
//  XMFAreaCodeModel.m
//  thirdLgoin
//
//  Created by đĺ°ččđ on 2020/7/8.
//  Copyright ÂŠ 2020 ĺ°čč. All rights reserved.
//

#import "XMFAreaCodeModel.h"

@implementation XMFAreaCodeModel

//éĺćšćł
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super init]) {
        
        self.countryName =  [aDecoder decodeObjectForKey:@"countryName"];
        
        self.phoneCode =  [aDecoder decodeObjectForKey:@"phoneCode"];
        
        self.domainAbbr =  [aDecoder decodeObjectForKey:@"domainAbbr"];
        
    }
    
    return self;
    
    
}


//éĺćšćł
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.countryName forKey:@"countryName"];
    
    
    [aCoder encodeObject:self.phoneCode forKey:@"phoneCode"];
    
    
    [aCoder encodeObject:self.domainAbbr forKey:@"domainAbbr"];
    
    
}


@end
