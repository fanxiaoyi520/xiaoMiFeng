//
//  XMFHomeGoodsAdModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFHomeGoodsAdModel : NSObject

/** 主键id */
@property (nonatomic, copy) NSString * adId;

/** 所广告的商品页面或者活动页面链接地址 */
@property (nonatomic, copy) NSString * link;
/** 广告标题 */

@property (nonatomic, copy) NSString * name;
/** 排序号 */

@property (nonatomic, copy) NSString * sort;
/** 主题id */

@property (nonatomic, copy) NSString * topicId;
/** 主题名称 */

@property (nonatomic, copy) NSString * topicName;
/** 广告宣传图片 */

@property (nonatomic, copy) NSString * url;

@end

NS_ASSUME_NONNULL_END
