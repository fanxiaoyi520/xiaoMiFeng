//
//  XMFMyCollectionCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyCollectionSonModel,XMFMyCollectionCell,XMFHomeGoodsCellModel;


@protocol XMFMyCollectionCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFMyCollectionCellDidClick:(XMFMyCollectionCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFMyCollectionCell : UITableViewCell


@property (nonatomic, assign) BOOL isSelected;

//@property (nonatomic, strong) XMFMyCollectionSonModel *sonModel;

@property (nonatomic, weak) id<XMFMyCollectionCellDelegate> delegate;

/** 2.1收藏model */
@property (nonatomic, strong) XMFHomeGoodsCellModel *goodsModel;

@end

NS_ASSUME_NONNULL_END
