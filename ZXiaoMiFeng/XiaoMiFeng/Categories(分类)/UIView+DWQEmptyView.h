//
//  UIView+DWQEmptyView.h
//  DWQEmptyView
//
//  Created by 杜文全 on 16/9/9.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DWQErrorPageView , DWQBlankPageView , XMFServerErrorPageView , XMFLoadingPageView;
@interface UIView (DWQEmptyView)
//DWQErrorPageView
@property (nonatomic,strong) DWQErrorPageView * errorPageView;
- (void)configReloadAction:(void(^)(void))block;
- (void)showErrorPageView;
//带contentViewY的方法
- (void)showErrorPageViewWithY:(CGFloat)contentViewY;
- (void)hideErrorPageView;

//DWQBlankPageView
@property (nonatomic,strong) DWQBlankPageView* blankPageView;
- (void)showBlankPageView;
- (void)hideBlankPageView;

//XMFServerErrorPageView 服务器报错
@property (nonatomic,strong) XMFServerErrorPageView* serverErrorPageView;
- (void)configServerErrorReloadAction:(void(^)(void))block;
- (void)showServerErrorPageView;

//带contentViewY的方法
-(void)showServerErrorPageViewWithY:(CGFloat)contentViewY;
- (void)hideServerErrorPageView;


//XMFLoadingPageView 加载动画
@property (nonatomic,strong) XMFLoadingPageView* loadingPageView;
- (void)showLoadingPageView;
- (void)hideLoadingPageView;



@end

#pragma mark --- DWQErrorPageView
@interface DWQErrorPageView : UIView
@property (nonatomic,copy) void(^didClickReloadBlock)(void);
@end

#pragma mark --- DWQBlankPageView
@interface DWQBlankPageView : UIView

@end



#pragma mark --- XMFServerErrorPageView
@interface XMFServerErrorPageView : UIView

/** 点击刷新 */
@property (nonatomic, copy) void (^serverErrorClickReloadBlock)(void);

@end


#pragma mark --- XMFLoadingPageView
@interface XMFLoadingPageView : UIView


@end



 
