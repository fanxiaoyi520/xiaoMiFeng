//
//  XMFResponseObjectModel.h
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/7.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, XMFNetworkingReturnCode) {
    XMFNetworkingReturnCodeSuccess = 200,//成功
    XMFNetworkingReturnCodeFailure = 01,//失败
};

@interface XMFResponseObjectModel : NSObject


@property (nonatomic, assign) NSInteger code;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, strong) NSString *url;

- (id)initWithResponseObject:(id)responseObject url:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
