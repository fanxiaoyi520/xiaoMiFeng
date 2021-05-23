//
//  XMFHomeHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/16.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeHeaderView;

@protocol XMFHomeHeaderViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomeHeaderViewDidClick:(XMFHomeHeaderView *)headerView button:(UIButton *)button;


@required//必须实现的方法

@end

@interface XMFHomeHeaderView : UIView

@property (nonatomic, weak) id<XMFHomeHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
