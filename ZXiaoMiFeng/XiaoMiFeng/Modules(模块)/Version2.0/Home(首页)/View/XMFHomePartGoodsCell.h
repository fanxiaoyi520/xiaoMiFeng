//
//  XMFHomePartGoodsCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsCellModel,XMFHomePartGoodsCell,XMFThemeDetailListModel;

//@class XMFHomePartGoodsCell;

@protocol XMFHomePartGoodsCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomePartGoodsCellDidClick:(XMFHomePartGoodsCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFHomePartGoodsCell : UICollectionViewCell

@property (nonatomic, assign) NSInteger cellItem;

@property (nonatomic, strong) XMFHomeGoodsCellModel *model;

/** 专题详情列表model */
@property (nonatomic, strong) XMFThemeDetailListModel *themeListModel;

@property (nonatomic, weak) id<XMFHomePartGoodsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
