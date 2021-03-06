//
//  XMFOrdersLogisticsModel.h
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/11.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
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

//ε ε₯ζΆθ΄§ε°ε
/** ζΆθ΄§ε°ε */
@property (nonatomic, copy) NSString * address;

@end

NS_ASSUME_NONNULL_END
