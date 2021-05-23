//
//  XMFOrdersCommentUploadModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFOrdersCommentUploadModel : NSObject

@property (nonatomic, copy) NSString *orderGoodsId;

@property (nonatomic, copy) NSString *star;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *valueId;

@property (nonatomic, strong) NSMutableArray *picUrls;

@end

/**
 
 {
     "orderGoodsId":3555,
     "star":"4",
     "content":"123444",
     "type":"0",
     "valueId":2146,
     "picUrls":[
         "https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/6lnt8dxa54j9rah9chg9fubw6nql.png"
     ]
 }
 
 
 */

NS_ASSUME_NONNULL_END
