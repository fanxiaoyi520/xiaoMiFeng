//
//  XMFMyDeliveryAddressModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFMyDeliveryAddressModel : NSObject

/** 地址详情 */
@property (nonatomic, copy) NSString * address;
/** 区ID */
@property (nonatomic, copy) NSString * areaId;
/** 市ID */
@property (nonatomic, copy) NSString * cityId;
/** 收货地址ID */
@property (nonatomic, copy) NSString * addressId;
/** 默认标志 0否1是 */
@property (nonatomic, copy) NSString * isDefault;
/** 手机号吗 */
@property (nonatomic, copy) NSString * mobile;
/** 收货人名 */
@property (nonatomic, copy) NSString * name;
/** 身份证号 */
@property (nonatomic, copy) NSString * personCard;
/** 邮政编码 */
@property (nonatomic, copy) NSString * postalCode;
/** 省ID */
@property (nonatomic, copy) NSString * provinceId;
/** 用户ID */
@property (nonatomic, copy) NSString * userId;
/** 用户名 */
@property (nonatomic, copy) NSString * userName;

/** 地址详情 */
@property (nonatomic, copy) NSString *detailAddress;

/** 是否已认证 */
@property (nonatomic, assign) BOOL verified;

/** 不可用标记（缺货地址标记；true=不可用，false=可用的） */
@property (nonatomic, assign) BOOL unusable;

@end

NS_ASSUME_NONNULL_END
