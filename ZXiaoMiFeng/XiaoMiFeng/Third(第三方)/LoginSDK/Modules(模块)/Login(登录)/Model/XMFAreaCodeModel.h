//
//  XMFAreaCodeModel.h
//  thirdLgoin
//
//  Created by πε°θθπ on 2020/7/8.
//  Copyright Β© 2020 ε°θθ. All rights reserved.
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
    countryName = "δΈ­ε½ε°ζΉΎ";
    domainAbbr = TW;
    phoneCode = 886;
}
 */

NS_ASSUME_NONNULL_END
