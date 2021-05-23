//
//  XMFGoodsShareView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeGoodsDetailModel;

@class XMFGoodsShareView;

@protocol XMFGoodsShareViewDelegate<NSObject>

@optional//选择实现的方法

-(void)buttonsOnXMFGoodsShareViewDidClick:(XMFGoodsShareView *)shareView button:(UIButton *)button;

-(void)viewsOnXMFGoodsShareViewDidLongPress:(XMFGoodsShareView *)shareView;

@required//必须实现的方法

@end


@interface XMFGoodsShareView : UIView

-(void)show;

-(void)hide;

@property (nonatomic, weak) id<XMFGoodsShareViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;

/** 截图部分的view */
@property (weak, nonatomic) IBOutlet UIView *screenshotBgView;

/** 提示语的文字 */
@property (nonatomic, copy) NSString *tipsStr;


@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;


@end

NS_ASSUME_NONNULL_END
