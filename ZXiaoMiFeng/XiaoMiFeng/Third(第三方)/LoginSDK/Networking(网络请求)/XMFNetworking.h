//
//  XMFNetworking.h
//  thirdLgoin
//
//  Created by πε°θθπ on 2020/6/26.
//  Copyright Β© 2020 ε°θθ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFResponseObjectModel;


typedef void (^NetSuccessBlock)(id responseObject , XMFResponseObjectModel *responseObjectModel);

typedef void (^NetFailureBlock)(NSString *error);

@interface XMFNetworking : NSObject

//εηGETη½η»θ―·ζ±
+ (void)GETWithURL:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure;

//εηPOSTη½η»θ―·ζ±
+ (void)POSTWithURL:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure;


//εηPOSTη½η»θ―·ζ±εε«ε¬ε±εζ°ηζΉζ³
+ (void)POSTWithURLContainParams:(NSString *)url Params:(NSDictionary *)params success:(NetSuccessBlock)success failure:(NetFailureBlock)failure;



@end

NS_ASSUME_NONNULL_END
