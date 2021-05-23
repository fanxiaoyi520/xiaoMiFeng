//
//  UIView+DWQEmptyView.m
//  DWQEmptyView
//
//  Created by 杜文全 on 16/9/9.
//  Copyright © 2016年 com.iOSDeveloper.duwenquan. All rights reserved.
//

#import "UIView+DWQEmptyView.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "SYGifImageView.h"//UIImageView的GIF播放


//屏幕高
#define LSCREENH [UIScreen mainScreen].bounds.size.height
///屏幕宽
#define LSCREENW [UIScreen mainScreen].bounds.size.width
@interface UIView ()

@property (nonatomic,copy) void(^reloadAction)(void);

@end


@implementation UIView (DWQEmptyView)
- (void)setReloadAction:(void (^)(void))reloadAction{
    objc_setAssociatedObject(self, @selector(reloadAction), reloadAction, OBJC_ASSOCIATION_COPY);
}
- (void (^)(void))reloadAction{
    return objc_getAssociatedObject(self, _cmd);
}


#pragma mark - ———————弱网： DWQErrorPageView ————————

- (void)setErrorPageView:(DWQErrorPageView *)errorPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(errorPageView))];
    objc_setAssociatedObject(self, @selector(errorPageView), errorPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(errorPageView))];
}
- (DWQErrorPageView *)errorPageView{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)configReloadAction:(void (^)(void))block{
    self.reloadAction = block;
    if (self.errorPageView && self.reloadAction) {
        self.errorPageView.didClickReloadBlock = self.reloadAction;
    }
}

- (void)showErrorPageView{
    
    if (!self.errorPageView) {
        
        CGRect viewFrame = self.bounds;
        
//        viewFrame.origin.y = kTopHeight;
        
        self.errorPageView = [[DWQErrorPageView alloc]initWithFrame:viewFrame];
        
        if (self.reloadAction) {
            self.errorPageView.didClickReloadBlock = self.reloadAction;
        }
    }
    [self addSubview:self.errorPageView];
    [self bringSubviewToFront:self.errorPageView];
}

//带contentViewY的方法
- (void)showErrorPageViewWithY:(CGFloat)contentViewY{
    
    if (!self.errorPageView) {
        
        CGRect viewFrame = self.bounds;
        
        viewFrame.origin.y = contentViewY;
        
        self.errorPageView = [[DWQErrorPageView alloc]initWithFrame:viewFrame];
        
        if (self.reloadAction) {
            self.errorPageView.didClickReloadBlock = self.reloadAction;
        }
    }
    [self addSubview:self.errorPageView];
    [self bringSubviewToFront:self.errorPageView];
}


- (void)hideErrorPageView{
    if (self.errorPageView) {
        [self.errorPageView removeFromSuperview];
        self.errorPageView = nil;
    }
}

#pragma mark - ——————— OSCBlankPageView ————————

- (void)setBlankPageView:(DWQBlankPageView *)blankPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(blankPageView))];
    objc_setAssociatedObject(self, @selector(blankPageView), blankPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    [self didChangeValueForKey:NSStringFromSelector(@selector(blankPageView))];
}
- (DWQBlankPageView *)blankPageView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)showBlankPageView{
    
    if (!self.blankPageView) {
        self.blankPageView = [[DWQBlankPageView alloc]initWithFrame:self.bounds];
    }
    [self addSubview:self.blankPageView];
    [self bringSubviewToFront:self.blankPageView];
}
- (void)hideBlankPageView{
    if (self.blankPageView) {
        [self.blankPageView removeFromSuperview];
        self.blankPageView = nil;
    }
}



#pragma mark - ——————— 服务器报错页面：XMFServerErrorPageView ————————

-(void)setServerErrorPageView:(XMFServerErrorPageView *)serverErrorPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(serverErrorPageView))];
    objc_setAssociatedObject(self, @selector(serverErrorPageView), serverErrorPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(serverErrorPageView))];
}

-(XMFServerErrorPageView *)serverErrorPageView{
    
    return objc_getAssociatedObject(self, _cmd);
}


-(void)configServerErrorReloadAction:(void (^)(void))block{
    
    self.reloadAction = block;
    
    if (self.serverErrorPageView && self.reloadAction) {
        
        self.serverErrorPageView.serverErrorClickReloadBlock = self.reloadAction;
    }
    
}

-(void)showServerErrorPageView{
    
    
    if (!self.serverErrorPageView) {
        
        CGRect viewFrame = self.bounds;
        
//        viewFrame.origin.y = kTopHeight;
        
        self.serverErrorPageView = [[XMFServerErrorPageView alloc]initWithFrame:viewFrame];
        
        if (self.reloadAction) {
            self.serverErrorPageView.serverErrorClickReloadBlock  = self.reloadAction;
        }
    }
    [self addSubview:self.serverErrorPageView];
    [self bringSubviewToFront:self.serverErrorPageView];
    
}

//带contentViewY的方法
-(void)showServerErrorPageViewWithY:(CGFloat)contentViewY{
    
    
    if (!self.serverErrorPageView) {
        
        CGRect viewFrame = self.bounds;
        
        viewFrame.origin.y = contentViewY;
        
        self.serverErrorPageView = [[XMFServerErrorPageView alloc]initWithFrame:viewFrame];
        
        if (self.reloadAction) {
            self.serverErrorPageView.serverErrorClickReloadBlock  = self.reloadAction;
        }
    }
    [self addSubview:self.serverErrorPageView];
    [self bringSubviewToFront:self.serverErrorPageView];
    
}


-(void)hideServerErrorPageView{
    
    if (self.serverErrorPageView) {
        [self.serverErrorPageView removeFromSuperview];
        self.serverErrorPageView = nil;
    }
    
}


#pragma mark - ——————— XMFLoadingPageView 加载动画 ————————

-(void)setLoadingPageView:(XMFLoadingPageView *)loadingPageView{
    
    [self willChangeValueForKey:NSStringFromSelector(@selector(loadingPageView))];
    objc_setAssociatedObject(self, @selector(loadingPageView), loadingPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    [self didChangeValueForKey:NSStringFromSelector(@selector(loadingPageView))];
    
}


-(XMFLoadingPageView *)loadingPageView{
    
    return objc_getAssociatedObject(self, _cmd);

}


-(void)showLoadingPageView{
    
    if (!self.loadingPageView) {
        
        CGRect tempFrame = self.bounds;
        
        tempFrame.origin.y -= kTopHeight;
        
        
        self.loadingPageView = [[XMFLoadingPageView alloc]initWithFrame:tempFrame];
    }
    [self addSubview:self.loadingPageView];
    [self bringSubviewToFront:self.loadingPageView];
}


-(void)hideLoadingPageView{
    
    if (self.loadingPageView) {
        [self.loadingPageView removeFromSuperview];
        self.loadingPageView = nil;
    }
    
}


@end








#pragma mark ---  DWQErrorPageView
@interface DWQErrorPageView ()
@property (nonatomic,weak) UIImageView* errorImageView;
@property (nonatomic,weak) UILabel* errorTipLabel;
@property (nonatomic,weak) UIButton* reloadButton;

@end
@implementation DWQErrorPageView
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xF2F2F2);
        
        UIImageView* errorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nonetwork"]];
        _errorImageView = errorImageView;
        
        [self addSubview:_errorImageView];
        
        UILabel* errorTipLabel = [[UILabel alloc]init];
        errorTipLabel.numberOfLines = 1;
        errorTipLabel.font = [UIFont systemFontOfSize:15];
        errorTipLabel.textAlignment = NSTextAlignmentCenter;
        errorTipLabel.textColor = UIColorFromRGB(0x999999);
        errorTipLabel.text = XMFLI(@"网络不给力哦");
        _errorTipLabel = errorTipLabel;
        [self addSubview:_errorTipLabel];
        
        UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadButton setTitle:XMFLI(@"刷新一下") forState:UIControlStateNormal];
        reloadButton.titleLabel.font =[UIFont fontWithName:@"PingFang-SC-Semibold" size:17.f];
        [reloadButton setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
        [reloadButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(_clickReloadButton:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton = reloadButton;
        
        [self addSubview:_reloadButton];
        
        [_errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
//            make.centerY.equalTo(self.mas_centerY).offset(-30);
            make.top.equalTo(self.mas_top).offset(97);
        }];
        
        [_errorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(_errorImageView.mas_bottom).offset(30);
        }];
        
        [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(44);
            make.centerX.equalTo(self);
            make.top.equalTo(_errorTipLabel.mas_bottom).offset(25);
        }];
    }
    return self;
}
- (void)_clickReloadButton:(UIButton* )btn{
    if (_didClickReloadBlock) {
        _didClickReloadBlock();
    }
}

@end


#pragma mark --- DWQBlankPageView
@interface DWQBlankPageView ()
@property (nonatomic,weak) UIImageView* nodataImageView;
@property (nonatomic,weak) UILabel* nodataTipLabel;
@end

@implementation DWQBlankPageView

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* nodataImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_nonetwork"]];
        _nodataImageView = nodataImageView;
        [self addSubview:_nodataImageView];
        
        UILabel* nodataTipLabel = [[UILabel alloc]init];
        nodataTipLabel.numberOfLines = 1;
        nodataTipLabel.font = [UIFont systemFontOfSize:15];
        nodataTipLabel.textAlignment = NSTextAlignmentCenter;
        nodataTipLabel.textColor = [UIColor grayColor];
        nodataTipLabel.text = @"暂无相关数据~";
        _nodataTipLabel = nodataTipLabel;
        [self addSubview:_nodataTipLabel];
        
        [_nodataImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.mas_centerY).offset(-10);
        }];
        
        [_nodataTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@50);
            make.top.equalTo(_nodataImageView.mas_bottom).offset(5);
        }];
    }
    return self;
}

@end


#pragma mark ---  XMFServerErrorPageView
@interface XMFServerErrorPageView ()
@property (nonatomic,weak) UIImageView* errorImageView;
@property (nonatomic,weak) UILabel* errorTipLabel;
@property (nonatomic,weak) UIButton* reloadButton;

@end
@implementation XMFServerErrorPageView
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xF2F2F2);
        
        UIImageView* errorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_servererror"]];
        _errorImageView = errorImageView;
        
        [self addSubview:_errorImageView];
        
        UILabel* errorTipLabel = [[UILabel alloc]init];
        errorTipLabel.numberOfLines = 1;
        errorTipLabel.font = [UIFont systemFontOfSize:15];
        errorTipLabel.textAlignment = NSTextAlignmentCenter;
        errorTipLabel.textColor = UIColorFromRGB(0x999999);
        errorTipLabel.text = XMFLI(@"哎呀,服务器睡着了…");
        _errorTipLabel = errorTipLabel;
        [self addSubview:_errorTipLabel];
        
        UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadButton setTitle:XMFLI(@"刷新") forState:UIControlStateNormal];
        reloadButton.titleLabel.font =[UIFont fontWithName:@"PingFang-SC-Semibold" size:17.f];
        [reloadButton setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
        [reloadButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(_clickReloadButton:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton = reloadButton;
        
        [self addSubview:_reloadButton];
        
        [_errorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self.mas_centerY).offset(-80);
//            make.top.equalTo(self.mas_top).offset(215);
        }];
        
        [_errorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(_errorImageView.mas_bottom).offset(30);
        }];
        
        [_reloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(44);
            make.centerX.equalTo(self);
            make.top.equalTo(_errorTipLabel.mas_bottom).offset(25);
        }];
    }
    return self;
}

//刷新按钮绑定方法
- (void)_clickReloadButton:(UIButton* )btn{
    
    if (_serverErrorClickReloadBlock) {
        _serverErrorClickReloadBlock();
    }
    
}

@end

#pragma mark --- XMFLoadingPageView加载动画
@interface XMFLoadingPageView ()

/** GIF加载动画 */
@property (nonatomic, strong) SYGifImageView *GIFImageView;

@end

@implementation XMFLoadingPageView

- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
        //1、GIF动图
        NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"icon_loading" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:imageFile];
        
        SYGifImageView *gifView = [[SYGifImageView alloc] initWithGIFData:imageData];
        
            
        self.backgroundColor = UIColorFromRGBA(0x333333, 0.5);
        
        [self addSubview:gifView];
       
        [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(60);
            
        }];
    }
    return self;
}

@end

