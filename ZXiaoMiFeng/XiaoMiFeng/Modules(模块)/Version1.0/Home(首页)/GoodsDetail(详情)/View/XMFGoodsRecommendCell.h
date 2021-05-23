//
//  XMFGoodsRecommendCell.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsRecommendModel;
@class XMFGoodsRecommendCell;

@protocol XMFGoodsRecommendCellDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFGoodsRecommendCellDidClick:(XMFGoodsRecommendCell *)cell button:(UIButton *)button;

@required//必须实现的方法

@end




@interface XMFGoodsRecommendCell : UICollectionViewCell

@property (nonatomic, weak) id<XMFGoodsRecommendCellDelegate> delegate;


//商品详情里面的为你推荐
@property (nonatomic, strong) XMFGoodsRecommendModel *model;

//个人中心里面的我的足迹
@property (nonatomic, strong) XMFGoodsRecommendModel *footprintModel;

//个人中心里面的我的收藏
@property (nonatomic, strong) XMFGoodsRecommendModel *collectionModel;

@end

NS_ASSUME_NONNULL_END
