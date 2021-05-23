//
//  XMFMyOrdersPopView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersPopView.h"

//在.m文件中添加
@interface  XMFMyOrdersPopView()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation XMFMyOrdersPopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.7);

    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //背景view圆角
       [self.bgView cornerWithRadius:10.f];
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFMyOrdersPopViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFMyOrdersPopViewDidClick:self button:sender];
    }
    
    
    if (_popViewBtnsClickBlock) {
        _popViewBtnsClickBlock(sender);
    }
    
    
    [self hide];
    
    
}


//显示在整个界面上
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
         self.frame = [UIScreen mainScreen].bounds;
         [keyWindow addSubview:self];
        
    } completion:^(BOOL finished) {
        
 
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self removeFromSuperview];

        
    } completion:^(BOOL finished) {
        
        
    }];
    
}



@end
