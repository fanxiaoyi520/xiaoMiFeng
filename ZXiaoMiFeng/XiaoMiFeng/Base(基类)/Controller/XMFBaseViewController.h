//
//  XMFBaseViewController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+XMFImageTitlePosition.h"//按钮文字图片位置设置
#import "XMFAreaCodeModel.h"//区号model
#import "SYGifImageView.h"//UIImageView的GIF播放



NS_ASSUME_NONNULL_BEGIN

//第三方用户信息字段宏定义
#define ThirdAuthType @"thirdAuthType"
#define UserAvatar   @"userAvatar"

//第三方应用级授权代码（例：微信公众号openid代码）
#define ThirdOpenId  @"thirdOpenId"
//第三方应用级主体标识（例：微信公众号的appid代码）
#define ThirdAppId   @"thirdAppId"
//第三方全局级授权代码（例：支付宝的userid代码）
#define ThirdGlobalId   @"thirdGlobalId"
//第三方平台级授权代码（例：微信公众号的unionid代码）
#define ThirdUnionId   @"thirdUnionId"
//第三方平台级主体标识（例：微信开放平台的appid代码）
#define ThirdZoneId   @"thirdZoneId"



/*
微信：WECHAT
脸书：FACEBOOK
谷歌：GOOGLE
*/

#define WECHAT @"WECHAT"
#define FACEBOOK @"FACEBOOK"
#define GOOGLE @"GOOGLE"
#define APPLE @"APPLE"


@class MMWebView;

@interface XMFBaseViewController : UIViewController

@property(nonatomic, strong) UIView *topBgView;//顶部背景图

/** 导航栏下面的横线,子类可自定义是否隐藏 */
@property (nonatomic, weak) UIImageView *navBarHairlineImageView;

/** 子页，有返回按钮 */
@property(nonatomic, copy) NSString *naviTitle;

/** 首页，无返回按钮 */
@property(nonatomic, copy) NSString *homeNaviTitle;

/** 子页，无返回按钮 */
@property(nonatomic, copy) NSString *noneBackNaviTitle;

/** 子页，有返回按钮 主题颜色 */
@property(nonatomic, copy) NSString *themeNaviTitle;

/** 自定义导航栏的背景颜色 */
@property (nonatomic, strong) UIColor *topBgViewbgColor;

/** 右边按钮 */
@property (nonatomic, strong) UIButton *rightBtn;


// 推出下一个控制器
- (void)pushViewController:(UIViewController *)vc;

- (void)addRightItemWithTitle:(NSString *)title action:(SEL)selector;

- (void)addRightItemWithTitle:(NSString *)title action:(SEL)selector titleColor:(UIColor *)titleColor;

- (void)addRightItemWithImage:(NSString *)imageName action:(SEL)selector;

//右边添加带颜色的文字和图片按钮，并且带文字图片排列位置
- (void)addRightItemWithTitle:(NSString *)title action:(SEL)selector titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont image:(NSString *)imageName imageTitleStyle:(XMFButtonEdgeInsetsStyle)style;

//右边添加不同状态对应不同文字的按钮
- (void)addRightItemWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle action:(SEL)selector titleColor:(UIColor *)titleColor;

- (void)popAction;


//获取国家或地区代码
-(void)getCountryRegionQuery;

/** 加载菊花 */
@property (nonatomic ,strong)UIActivityIndicatorView *activityIndicator;

/** 加载动画view */
@property (nonatomic, strong) UIView *loadingView;

/** GIF加载动画 */
@property (nonatomic, strong) SYGifImageView *GIFImageView;

/** 显示GIF加载动画 */
-(void)showGIFImageView;

/** 隐藏GIF加载动画 */
-(void)hideGIFImageView;


@end

NS_ASSUME_NONNULL_END
