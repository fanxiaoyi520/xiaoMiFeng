//
//  XMFGoodsDetailHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDatailModel;

@class XMFGoodsDatailProductListModel;

@class XMFGoodsDetailHeaderView;

@protocol XMFGoodsDetailHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)viewsOnXMFGoodsDetailHeaderViewDidTap:(XMFGoodsDetailHeaderView *)headerView view:(UIView *)view;

-(void)buttonsOnXMFGoodsDetailHeaderViewDidClick:(XMFGoodsDetailHeaderView *)headerView button:(UIButton *)button;

//图片选择
-(void)imageViewOnXMFGoodsDetailHeaderView:(XMFGoodsDetailHeaderView *)headerView didSelectItemAtIndex:(NSInteger)index;


@required//必须实现的方法

@end

@interface XMFGoodsDetailHeaderView : UIView

@property (nonatomic, strong) XMFGoodsDatailModel *detailModel;

@property (nonatomic, weak) id<XMFGoodsDetailHeaderViewDelegate> delegate;

//商品规格
@property (weak, nonatomic) IBOutlet UILabel *goodsTypeLB;

//税费
@property (weak, nonatomic) IBOutlet UILabel *goodsTaxsLB;


//商品信息
@property (nonatomic, strong) XMFGoodsDatailProductListModel *productListModel;

@end

NS_ASSUME_NONNULL_END
