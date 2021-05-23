//
//  XMFOrdersLogisticsModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFOrdersLogisticsTracksModel : NSObject

@property (nonatomic, copy) NSString * context;
@property (nonatomic, copy) NSString * dateOnly;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, copy) NSString * timeOnly;


@end

@interface XMFOrdersLogisticsModel : NSObject

@property (nonatomic, copy) NSString *logisticsDesc;
@property (nonatomic, copy) NSString * result;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, strong) NSArray<XMFOrdersLogisticsTracksModel *> * tracks;

//加入收货地址
/** 收货地址 */
@property (nonatomic, copy) NSString * address;

@end

NS_ASSUME_NONNULL_END
