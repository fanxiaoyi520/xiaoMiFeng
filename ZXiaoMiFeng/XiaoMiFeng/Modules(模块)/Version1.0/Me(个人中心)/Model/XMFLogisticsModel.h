//
//  XMFLogisticsModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFLogisticsTracksModel : NSObject

@property (nonatomic, copy) NSString *context;

@property (nonatomic, copy) NSString *time;

@end

@interface XMFLogisticsModel : NSObject

@property (nonatomic, copy) NSString *result;

@property (nonatomic, copy) NSString *status;


@property (nonatomic, copy) NSString *tracksDescription;

@property (nonatomic, strong) NSArray<XMFLogisticsTracksModel *> *tracks;

@end

/**
 
 "result":0,
        "status":4,
        "description":"已签收",
        "tracks"
 
 */

NS_ASSUME_NONNULL_END
