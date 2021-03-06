//
//  XMFAddressManager.h
//  XiaoMiFeng
//
//  Created by đĺ°ččđ on 2020/5/7.
//  Copyright ÂŠ 2020 đĺ°ččđ. All rights reserved.
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

// ĺäž
+ (instancetype)shareManager;

//ĺ°ĺć¨Ąĺ
@property (nonatomic, strong) BRAddressModel *addressModel;

//@property (nonatomic, strong) XMFBRAddressModel *addressModel;


// ĺ­ĺ¨ĺ°ĺć°çťć°ćŽ
- (void)updateAddressInfo:(id)addressInfo;


//ć¸é¤ĺ°ĺć°çť
-(void)removeAddressInfo;


//ćŻĺŚĺ­ĺ¨ĺ°ĺć°çťäżĄćŻ
-(BOOL)isContainsAddressInfo;


//čˇĺççş§ĺç§°
-(NSString *)getProvinceName:(NSString *)provinceCode;


//čˇĺççş§ĺç§°
-(NSString *)getCityName:(NSString *)cityCode;


//čˇĺĺşçş§ĺç§°
-(NSString *)getAreaName:(NSString *)areaCode;


@end

NS_ASSUME_NONNULL_END
