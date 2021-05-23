//
//  XMFGoodsSpecInfoModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/11/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//第五层
//规格具体的值
@interface XMFGoodsSpecInfoSpecValuesModel : NSObject

/** 是否生效 */
@property (nonatomic, assign) BOOL enable;

/** 规格值 */
@property (nonatomic, copy) NSString *specValue;

/** 人工加入：是否选中 */
@property (nonatomic, assign) BOOL isSelected;


@end


//第四层
@interface XMFGoodsSpecInfoFastFindNodeValuesModel : NSObject

@property (nonatomic, copy) NSString *specName;

@property (nonatomic, strong) NSArray<XMFGoodsSpecInfoSpecValuesModel *> *values;

@end


//第三层
@interface XMFGoodsSpecInfoFastFindNodeModel : NSObject


@property (nonatomic, copy) NSString *value;


@property (nonatomic, strong) NSArray<XMFGoodsSpecInfoFastFindNodeValuesModel *> *fastFindNode;


@end



//第二层
//规格
@interface  XMFGoodsSpecInfoSpecsModel : NSObject

/** 规格名称 */
@property (nonatomic, copy) NSString *specName;


@property (nonatomic, strong) NSArray<XMFGoodsSpecInfoFastFindNodeModel*> *specValues;


@end



//第一层

@interface XMFGoodsSpecInfoModel : NSObject

/** 规格信息对应商品id字典 */
@property (nonatomic, strong) NSDictionary *specInfoToGoodsId;

/** 规格相关信息数组 */
@property (nonatomic, strong) NSArray<XMFGoodsSpecInfoSpecsModel *> *specs;


/** 人工加入：商品名称 */
@property (nonatomic, copy) NSString *goodsName;

/** 商品id */
@property (nonatomic, copy) NSString *goodsId;


@end

NS_ASSUME_NONNULL_END
