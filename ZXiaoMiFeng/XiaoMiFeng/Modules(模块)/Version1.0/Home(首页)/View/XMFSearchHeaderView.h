//
//  XMFSearchHeaderView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class XMFSearchHeaderView;

@protocol XMFSearchHeaderViewDelegate <NSObject>

@optional//选择实现的方法

- (void)searchWithStr :(NSString *)text;

-(void)buttonsOnXMFSearchHeaderView:(XMFSearchHeaderView *)headerView button:(UIButton *)button;


@end

@interface XMFSearchHeaderView : UIView

@property(nonatomic,copy)NSString *AJPlaceholder;

@property(nonatomic,strong)UIColor *AJCursorColor;

@property(nonatomic,weak) id<XMFSearchHeaderViewDelegate> XMFSearchHeaderViewDelegate;

/*! 输入框 */
@property(nonatomic,strong)UITextField *textField;

//是否隐藏占位label
- (void)isHiddenLabel:(UITextField *)textField;


@end

NS_ASSUME_NONNULL_END
