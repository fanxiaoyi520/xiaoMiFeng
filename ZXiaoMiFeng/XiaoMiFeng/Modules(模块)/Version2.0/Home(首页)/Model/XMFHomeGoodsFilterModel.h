//
//  XMFHomeGoodsFilterModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface XMFHomeGoodsFilterSonModel : NSObject

@property (nonatomic, copy) NSString *standard;

/** 记录标签是否被选中 */
@property (nonatomic , assign) BOOL tagSeleted;

/** 最小价格 */
@property (nonatomic , copy) NSString *minPrice;

/** 最大价格 */
@property (nonatomic , copy) NSString *maxPrice;


@end


@interface XMFHomeGoodsFilterModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsFilterSonModel *> *standardArr;

/** 是否是多选  NO 单选 YES 多选 */
@property (nonatomic , assign) BOOL isMultipleSelect;



@end

NS_ASSUME_NONNULL_END
