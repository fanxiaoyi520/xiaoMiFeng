//
//  XMFGoodsDeletedPageView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/12/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsCellModel,XMFGoodsDeletedPageView,XMFHomeAllGoodsCell;


@protocol XMFGoodsDeletedPageViewDelegate<NSObject>

@optional//选择实现的方法

/** 返回按钮被点击 */
-(void)buttonsOnXMFGoodsDeletedPageViewDidClick:(XMFGoodsDeletedPageView *)pageView button:(UIButton *)button;

/** 页面上的cell被点击 */
-(void)cellOnXMFGoodsDeletedPageViewDidSelected:(XMFGoodsDeletedPageView *)pageView model:(XMFHomeGoodsCellModel *)model;


/** 页面上cell的加入购物车按钮被点击 */
-(void)addBtnOnCellDidClick:(XMFGoodsDeletedPageView *)pageView cell:(XMFHomeAllGoodsCell *)goodsCell button:(UIButton *)button indexPath:(NSIndexPath *)selectedIndexPath;



@required//必须实现的方法

@end


@interface XMFGoodsDeletedPageView : UIView


@property (nonatomic, weak) id<XMFGoodsDeletedPageViewDelegate> delegate;

-(void)showOnView:(UIView *)view;

-(void)hide;


/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsCellModel *> *dataSourceArr;

@end

NS_ASSUME_NONNULL_END
