//
//  WCLActionSheet.m
//  WCLPictureClippingRotation
//
//  Created by wcl on 2016/12/28.
//  Copyright © 2016年 QianTangTechnology. All rights reserved.
//

#import "WCLActionSheet.h"

#define SCREEN_WIDTH   [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
//#define RGB(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define TitleFont     [UIFont systemFontOfSize:18.0f]

#define TitleHeight 60.0f
#define ButtonHeight  49.0f

#define ACDarkShadowViewAlpha 0.7f
#define ACShowAnimateDuration 0.3f
#define ACHideAnimateDuration 0.2f

@interface WCLActionSheet ()
{
    
    NSString *_cancelButtonTitle;
    NSString *_destructiveButtonTitle;
    NSArray *_otherButtonTitles;
    
    
    UIView *_buttonBackgroundView;
    UIView *_darkShadowView;
}
@end

@implementation WCLActionSheet

- (instancetype)initWithTitle:(NSString *)title delegate:(id<WCLActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    if(self = [super init]) {
        _title = title;
        _delegate = delegate;
        _cancelButtonTitle = cancelButtonTitle.length>0 ? cancelButtonTitle : @"取消";
        _destructiveButtonTitle = destructiveButtonTitle;
        
        NSMutableArray *args = [NSMutableArray array];
        
        if(_destructiveButtonTitle.length) {
            [args addObject:_destructiveButtonTitle];
        }
        
        [args addObject:otherButtonTitles];
        
        if (otherButtonTitles) {
            va_list params;
            va_start(params, otherButtonTitles);
            id buttonTitle;
            while ((buttonTitle = va_arg(params, id))) {
                if (buttonTitle) {
                    [args addObject:buttonTitle];
                }
            }
            va_end(params);
        }
        
        _otherButtonTitles = [NSArray arrayWithArray:args];
        
        [self initSubViews];
    }
    
    return self;
}
- (void)initSubViews {
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    
    _darkShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    _darkShadowView.backgroundColor = RGB(30, 30, 30);
    _darkShadowView.backgroundColor = UIColorFromRGB(0x000000);

    _darkShadowView.alpha = 0.0f;
    [self addSubview:_darkShadowView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView:)];
    [_darkShadowView addGestureRecognizer:tap];
    
    _buttonBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _buttonBackgroundView.backgroundColor = RGB(220, 220, 220); // RGB(220, 220, 220);
    [self addSubview:_buttonBackgroundView];
    
    if (self.title.length) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ButtonHeight-TitleHeight, SCREEN_WIDTH, ButtonHeight)];
        titleLabel.text = _title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.backgroundColor = [UIColor whiteColor];
        [_buttonBackgroundView addSubview:titleLabel];
    }
    
    
    for (int i = 0; i < _otherButtonTitles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:_otherButtonTitles[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = TitleFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i==0 && _destructiveButtonTitle.length) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        UIImage *image = [UIImage imageNamed:@"ACActionSheet.bundle/actionSheetHighLighted.png"];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonY = ButtonHeight * (i + (_title.length>0?1:0));
        button.frame = CGRectMake(0, buttonY, SCREEN_WIDTH, ButtonHeight);
        [_buttonBackgroundView addSubview:button];
        
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = RGB(200, 200, 200); // RGB(200, 200, 200);
        line.frame = CGRectMake(0, buttonY, SCREEN_WIDTH, 0.5);
        [_buttonBackgroundView addSubview:line];
    }
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.tag = 0;
    [cancelButton setTitle:_cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = TitleFont;
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton_Click:) forControlEvents:UIControlEventTouchUpInside];
    CGFloat buttonY = ButtonHeight * (_otherButtonTitles.count + (_title.length>0?1:0)) + 5;
    cancelButton.frame = CGRectMake(0, buttonY, SCREEN_WIDTH, ButtonHeight);
    [_buttonBackgroundView addSubview:cancelButton];
    
    CGFloat height = ButtonHeight * (_otherButtonTitles.count+1 + (_title.length>0?1:0)) + 5 + SafeAreaBottomHeight;
    _buttonBackgroundView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
    
}

- (void)didClickButton:(UIButton *)button {
    
    //DLog(@" === %@", _delegate);
    
    if (_delegate && [_delegate respondsToSelector:@selector(actionImageSheet:clickedButtonAtIndex:)]) {
        [_delegate actionImageSheet:self clickedButtonAtIndex:button.tag];
    }
    [self hide];
}
- (void)cancelButton_Click:(UIButton *)button {
    
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_delegate actionSheetCancel:self];
    }
    [self hide];
}
- (void)dismissView:(UITapGestureRecognizer *)tap {
    
    if (_delegate && [_delegate respondsToSelector:@selector(actionSheetCancel:)]) {
        [_delegate actionSheetCancel:self];
    }
    [self hide];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    
    self.hidden = NO;
    
    [UIView animateWithDuration:ACShowAnimateDuration animations:^{
        _darkShadowView.alpha = ACDarkShadowViewAlpha;
        _buttonBackgroundView.transform = CGAffineTransformMakeTranslation(0, -_buttonBackgroundView.frame.size.height - kSAFE_AREA_BOTTOM);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide {
    
    [UIView animateWithDuration:ACHideAnimateDuration animations:^{
        _darkShadowView.alpha = 0;
        _buttonBackgroundView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}



@end
