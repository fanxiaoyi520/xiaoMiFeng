//
//  XMFMyOrdersListHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel,XMFMyOrdersListHeaderView;

@protocol XMFMyOrdersListHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFMyOrdersListHeaderViewDidClick:(XMFMyOrdersListHeaderView *)headerView button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFMyOrdersListHeaderView : UIView

@property (nonatomic, strong) XMFMyOrdersListModel *listModel;

@property (nonatomic, weak) id<XMFMyOrdersListHeaderViewDelegate> delegate;

/** 组别 */
@property (nonatomic, assign) NSInteger headerViewSection;


@end

NS_ASSUME_NONNULL_END
