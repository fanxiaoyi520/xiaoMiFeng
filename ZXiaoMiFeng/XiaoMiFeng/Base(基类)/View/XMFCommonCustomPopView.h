//
//  XMFCommonCustomPopView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/11/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFCommonCustomPopView;


@protocol XMFCommonCustomPopViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFCommonCustomPopViewDidClick:(XMFCommonCustomPopView *)popView button:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFCommonCustomPopView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

/** 代理属性 */
@property (nonatomic, weak) id<XMFCommonCustomPopViewDelegate> delegate;

/** 按钮点击block */
@property (nonatomic, copy) void (^commonCustomPopViewBtnsClickBlock)(XMFCommonCustomPopView *popView,UIButton *button);

-(void)show;

-(void)hide;

@end

NS_ASSUME_NONNULL_END
