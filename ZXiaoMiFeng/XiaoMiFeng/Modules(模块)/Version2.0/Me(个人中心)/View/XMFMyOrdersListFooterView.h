//
//  XMFMyOrdersListFooterView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersListModel,XMFMyOrdersListFooterCell,XMFMyOrdersListFooterView;

@protocol XMFMyOrdersListFooterViewDelegate<NSObject>

@optional//选择实现的方法

//view上的cell被点击
-(void)cellOnXMFMyOrdersListFooterViewDidSelected:(XMFMyOrdersListFooterView *)footerView cell:(XMFMyOrdersListFooterCell *)cell;


//view上的按钮被点击
-(void)buttonsOnXMFMyOrdersListFooterViewDidClick:(XMFMyOrdersListFooterView *)footerView button:(UIButton *)button;


@required//必须实现的方法

@end

@interface XMFMyOrdersListFooterView : UIView

/** 组别 */
@property (nonatomic, assign) NSInteger footerViewSection;

@property (nonatomic, strong) XMFMyOrdersListModel *listModel;

@property (nonatomic, weak) id<XMFMyOrdersListFooterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
