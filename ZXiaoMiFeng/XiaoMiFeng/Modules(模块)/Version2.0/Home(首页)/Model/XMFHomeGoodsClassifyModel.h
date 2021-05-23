//
//  XMFHomeGoodsClassifyModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFHomeGoodsClassifyModel : NSObject

/** 分类主键id */
@property (nonatomic, copy) NSString *classifyId;

/** 图标 */
@property (nonatomic, copy) NSString *icon;

/** 分类名称 */
@property (nonatomic, copy) NSString *name;

/** 类型 0-商品分类 1-跳转链接 */
@property (nonatomic, copy) NSString *type;

/** 跳转地址 */
@property (nonatomic, copy) NSString *url;



@end

NS_ASSUME_NONNULL_END
