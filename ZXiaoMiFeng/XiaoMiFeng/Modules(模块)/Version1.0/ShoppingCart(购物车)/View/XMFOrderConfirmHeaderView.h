//
//  XMFOrderConfirmHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrderConfirmModel;

@class XMFOrderConfirmHeaderView;

@class XMFAddressListModel;

@protocol XMFOrderConfirmHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)tapGestureOnXMFOrderConfirmHeaderViewDidTap:(XMFOrderConfirmHeaderView *)headerView;

@required//必须实现的方法

@end

@interface XMFOrderConfirmHeaderView : UIView

@property (nonatomic, strong) XMFOrderConfirmModel *headerModel;

//地址列表的model
@property (nonatomic, strong) XMFAddressListModel *addressListModel;

@property (nonatomic, weak) id<XMFOrderConfirmHeaderViewDelegate> delegate;

//详细地址
@property (weak, nonatomic) IBOutlet UILabel *addressLB;

@end

NS_ASSUME_NONNULL_END
