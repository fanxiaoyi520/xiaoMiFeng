//
//  XMFMyOrdersDetailHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel,XMFOrdersLogisticsModel,XMFMyOrdersDetailHeaderView;

@protocol XMFMyOrdersDetailHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)viewsOnXMFGoodsDetailHeaderViewDidTap:(XMFMyOrdersDetailHeaderView *)headerView tapView:(UIView *)tapView;

@required//必须实现的方法

@end


@interface XMFMyOrdersDetailHeaderView : UIView

@property (nonatomic, strong) XMFMyOrdersListModel *detailModel;

/** 物流数据model */
@property (nonatomic, strong) XMFOrdersLogisticsModel *logisticsModel;


@property (nonatomic, weak) id<XMFMyOrdersDetailHeaderViewDelegate> delegate;

/** 订单状态提示 */
@property (weak, nonatomic) IBOutlet UILabel *orderTipsLB;

@end

NS_ASSUME_NONNULL_END
