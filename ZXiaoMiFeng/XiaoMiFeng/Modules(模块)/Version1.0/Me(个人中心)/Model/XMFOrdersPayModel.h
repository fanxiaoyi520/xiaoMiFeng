//
//  XMFOrdersPayModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//弹框的数据model
@interface XMFOrdersPayPopupModel : NSObject

@property (nonatomic, copy) NSString *isPopup;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *massage;

@end


@interface XMFOrdersPayModel : NSObject

@property (nonatomic, copy) NSString * aesKey;
@property (nonatomic, copy) NSString * appName;
@property (nonatomic, copy) NSString * applyId;
@property (nonatomic, copy) NSString * countryCode;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * language;
@property (nonatomic, copy) NSString * mcc;
@property (nonatomic, copy) NSString * md5;
@property (nonatomic, copy) NSString * merId;
@property (nonatomic, copy) NSString * merName;
@property (nonatomic, copy) NSString * notifyUrl;
@property (nonatomic, copy) NSString * orderNo;
@property (nonatomic, copy) NSString * partnerid;
@property (nonatomic, copy) NSString * referUrl;
@property (nonatomic, copy) NSString * registerCountryCode;
@property (nonatomic, copy) NSString * registerMobile;
@property (nonatomic, copy) NSString * reqReserved;
@property (nonatomic, copy) NSString * subAppid;
@property (nonatomic, copy) NSString * subject;
@property (nonatomic, copy) NSString * timeExpire;
@property (nonatomic, copy) NSString * transTime;
@property (nonatomic, copy) NSString * txnAmt;
@property (nonatomic, copy) NSString * txnCurr;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * version;

@property (nonatomic, strong) XMFOrdersPayPopupModel *popup;


@end

NS_ASSUME_NONNULL_END
