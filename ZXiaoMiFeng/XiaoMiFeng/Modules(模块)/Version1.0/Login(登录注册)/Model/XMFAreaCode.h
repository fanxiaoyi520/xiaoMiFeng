//
//  XMFAreaCode.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/23.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFAreaCode : NSObject

@property (nonatomic, copy) NSString *areaCode;

@property (nonatomic, copy) NSString *continent;

@property (nonatomic, copy) NSString *country;

@property (nonatomic, copy) NSString *codeId;

@end

/**
 
 {
     areaCode = "+30";
     continent = "欧洲";
     country = "希腊";
     id = 56;
 }
 
 */

NS_ASSUME_NONNULL_END
