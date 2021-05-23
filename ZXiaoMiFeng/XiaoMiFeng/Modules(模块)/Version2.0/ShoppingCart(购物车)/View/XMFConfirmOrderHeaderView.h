//
//  XMFConfirmOrderHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class XMFConfirmOrderHeaderView,XMFConfirmOrderModel,XMFMyDeliveryAddressModel;

@protocol XMFConfirmOrderHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)tapGestureOnXMFConfirmOrderHeaderViewDidTap:(XMFConfirmOrderHeaderView *)headerView tapView:(UIView *)tapView;


@required//必须实现的方法

@end

@interface XMFConfirmOrderHeaderView : UIView

@property (nonatomic, weak) id<XMFConfirmOrderHeaderViewDelegate> delegate;

/** 确认订单model */
@property (nonatomic, strong) XMFConfirmOrderModel *orderModel;

/** 地址model */
@property (nonatomic, strong) XMFMyDeliveryAddressModel *addressModel;

@end

NS_ASSUME_NONNULL_END
