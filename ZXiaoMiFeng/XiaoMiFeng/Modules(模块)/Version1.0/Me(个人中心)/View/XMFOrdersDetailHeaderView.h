//
//  XMFOrdersDetailHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/15.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFOrdersDetailModel;

@class XMFOrdersDetailOrderInfoModel;

@class XMFOrdersCellModel;

@class XMFOrdersDetailHeaderView;

@protocol XMFOrdersDetailHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)viewOnXMFOrdersDetailHeaderViewDidTap:(XMFOrdersDetailHeaderView *)headerView;

@required//必须实现的方法

@end

@interface XMFOrdersDetailHeaderView : UIView

//详情model
@property (nonatomic, strong) XMFOrdersDetailModel *detailModel;

//订单信息model
@property (nonatomic, strong) XMFOrdersDetailOrderInfoModel *infoModel;

//订单列表model
//@property (nonatomic, strong) XMFOrdersCellModel *ordersCellModel;

//本地进行修改后的model
@property (nonatomic, strong) XMFOrdersCellModel *modifyOrdersCellModel;

@property (nonatomic, weak) id<XMFOrdersDetailHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *countdownLB;

@end

NS_ASSUME_NONNULL_END
