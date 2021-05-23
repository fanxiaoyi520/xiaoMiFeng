//
//  XMFSelectGoodsTypeCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsPropertySpecificationsValuesModel;

@class XMFSelectGoodsTypeCell;

@class XMFGoodsSpecInfoSpecValuesModel;

@class XMFGoodsSpecInfoFastFindNodeModel;

@protocol XMFSelectGoodsTypeCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFSelectGoodsTypeCellDidClick:(XMFSelectGoodsTypeCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFSelectGoodsTypeCell : UICollectionViewCell

@property (nonatomic, strong) UIButton *standardBtn;

@property (nonatomic, weak) id<XMFSelectGoodsTypeCellDelegate> delegate;

/** 商品规格 */
@property (nonatomic, strong) XMFHomeGoodsPropertySpecificationsValuesModel *specivaluewsModel;

/** 2.1商品规格 */
@property (nonatomic, strong) XMFGoodsSpecInfoSpecValuesModel *specValuesModel;

/** 2.1规格名称 */
@property (nonatomic, strong) XMFGoodsSpecInfoFastFindNodeModel *fastFindNodeModel;

@end

NS_ASSUME_NONNULL_END
