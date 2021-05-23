//
//  XMFAddressManager.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "XMFAddressModel.h"
//#import "XMFBRAddressModel.h"
#import "BRAddressModel.h"



NS_ASSUME_NONNULL_BEGIN

@class XMFAddressManager;

#define AddressManager [XMFAddressManager shareManager]

#define AddressInModel [XMFAddressManager shareManager].addressModel


@interface XMFAddressManager : NSObject

// 单例
+ (instancetype)shareManager;

//地址模型
@property (nonatomic, strong) BRAddressModel *addressModel;

//@property (nonatomic, strong) XMFBRAddressModel *addressModel;


// 存储地址数组数据
- (void)updateAddressInfo:(id)addressInfo;


//清除地址数组
-(void)removeAddressInfo;


//是否存在地址数组信息
-(BOOL)isContainsAddressInfo;


//获取省级名称
-(NSString *)getProvinceName:(NSString *)provinceCode;


//获取省级名称
-(NSString *)getCityName:(NSString *)cityCode;


//获取区级名称
-(NSString *)getAreaName:(NSString *)areaCode;


@end

NS_ASSUME_NONNULL_END
