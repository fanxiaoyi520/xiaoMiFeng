//
//  XMFGoodsDetailValueListModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGoodsDetailValueListModel : NSObject

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *deleted;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic, copy) NSString *valueListId;

@property (nonatomic, copy) NSString *picUrl;

@property (nonatomic, copy) NSString *specification;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, copy) NSString *version;


@end

/**
 
 {
 addTime = "2019-12-27 11:57:11";
 deleted = 0;
 goodsId = 1182349;
 id = 2921;
 picUrl = "";
 specification = "规格";
 value = "标准";
 version = 0;
 }
 
 */

NS_ASSUME_NONNULL_END
