//
//  XMFHomeSearchView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/13.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeSearchView;

@protocol XMFHomeSearchViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFHomeHeaderViewDidClick:(XMFHomeSearchView *)searchView button:(UIButton *)button;

@required//必须实现的方法

@end

@interface XMFHomeSearchView : UIView

@property (nonatomic, weak) id<XMFHomeSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
