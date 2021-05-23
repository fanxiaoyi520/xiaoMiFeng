//
//  XMFCommonPicPopView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/28.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFCommonPicPopView;

@protocol XMFCommonPicPopViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFCommonPicPopViewDidClick:(XMFCommonPicPopView *)popView button:(UIButton *)button;

@required//必须实现的方法

@end


@interface XMFCommonPicPopView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *tipsImgView;


@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@property (nonatomic, weak) id<XMFCommonPicPopViewDelegate> delegate;

/** 按钮点击block */
@property (nonatomic, copy) void (^popViewBtnsClickBlock)(UIButton *button);

-(void)show;

-(void)hide;


@end

NS_ASSUME_NONNULL_END
