//
//  XMFMyOrdersPopView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFMyOrdersPopView;

@protocol XMFMyOrdersPopViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFMyOrdersPopViewDidClick:(XMFMyOrdersPopView *)popView button:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFMyOrdersPopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


-(void)show;

-(void)hide;


@property (nonatomic, weak) id<XMFMyOrdersPopViewDelegate> delegate;

/** 按钮点击block */
@property (nonatomic, copy) void (^popViewBtnsClickBlock)(UIButton *button);

@end

NS_ASSUME_NONNULL_END
