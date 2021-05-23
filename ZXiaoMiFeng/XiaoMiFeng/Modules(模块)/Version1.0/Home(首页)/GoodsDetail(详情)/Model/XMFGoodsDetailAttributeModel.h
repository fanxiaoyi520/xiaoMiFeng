//
//  XMFGoodsDetailAttributeModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsDetailAttributeModel : NSObject

@property (nonatomic, copy) NSString *attributeId;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *attribute;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *version;

@end

/**
 
 {
     "id":1428,
     "goodsId":1181019,
     "attribute":"大小",
     "value":"40CM",
     "addTime":"2020-04-27 16:33:14",
     "deleted":false,
     "version":0
 }
 
 */

NS_ASSUME_NONNULL_END
