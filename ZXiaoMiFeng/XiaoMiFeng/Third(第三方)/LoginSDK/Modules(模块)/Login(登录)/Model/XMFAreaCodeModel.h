//
//  XMFAreaCodeModel.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/8.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFAreaCodeModel : NSObject<NSCoding>


@property (nonatomic, copy) NSString *countryName;

@property (nonatomic, copy) NSString *domainAbbr;

@property (nonatomic, copy) NSString *phoneCode;



@end

/*
{
    countryName = "中国台湾";
    domainAbbr = TW;
    phoneCode = 886;
}
 */

NS_ASSUME_NONNULL_END
