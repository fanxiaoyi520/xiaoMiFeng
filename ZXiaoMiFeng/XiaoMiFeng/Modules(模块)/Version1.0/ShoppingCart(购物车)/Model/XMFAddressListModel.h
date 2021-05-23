//
//  XMFAddressListModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFAddressListModel : NSObject

@property (nonatomic, copy) NSString *isDefault;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *postalCode;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *addressId;

@property (nonatomic, copy) NSString *cityId;

@property (nonatomic, copy) NSString *provinceId;

@property (nonatomic, copy) NSString *personCard;



@end

/**
 
 {
     "isDefault":false,
     "areaId":110114,
     "address":"123456",
     "postalCode":"123456",
     "name":"小蜜蜂",
     "mobile":"18825257966",
     "id":2318,
     "cityId":110100,
     "provinceId":110000,
     "personCard":"110101199003076392"
 },
 
 */

NS_ASSUME_NONNULL_END
