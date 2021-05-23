//
//  XMFBRAddressModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BRAddressModel.h"


NS_ASSUME_NONNULL_BEGIN

/// 区
@interface XMFBRAreaModel : BRAreaModel


@end


/// 市
@interface XMFBRCityModel : BRCityModel


@end



/// 省
@interface XMFBRProvinceModel : BRProvinceModel



@end



@interface XMFBRAddressModel : NSObject

/** 省级数组 */
@property (nullable, nonatomic, copy) NSArray<XMFBRProvinceModel *> *provincelist;

/** 省级数组 */
@property (nullable, nonatomic, copy) NSArray<BRProvinceModel *> *brProvincelist;

@end

NS_ASSUME_NONNULL_END
