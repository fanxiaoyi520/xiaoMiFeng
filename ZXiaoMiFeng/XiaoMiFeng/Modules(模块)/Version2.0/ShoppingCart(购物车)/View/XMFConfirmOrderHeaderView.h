//
//  XMFConfirmOrderHeaderView.h
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/2.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class XMFConfirmOrderHeaderView,XMFConfirmOrderModel,XMFMyDeliveryAddressModel;

@protocol XMFConfirmOrderHeaderViewDelegate<NSObject>

@optional//éæ©å®ç°çæ¹æ³

-(void)tapGestureOnXMFConfirmOrderHeaderViewDidTap:(XMFConfirmOrderHeaderView *)headerView tapView:(UIView *)tapView;


@required//å¿é¡»å®ç°çæ¹æ³

@end

@interface XMFConfirmOrderHeaderView : UIView

@property (nonatomic, weak) id<XMFConfirmOrderHeaderViewDelegate> delegate;

/** ç¡®è®¤è®¢åmodel */
@property (nonatomic, strong) XMFConfirmOrderModel *orderModel;

/** å°åmodel */
@property (nonatomic, strong) XMFMyDeliveryAddressModel *addressModel;

@end

NS_ASSUME_NONNULL_END
