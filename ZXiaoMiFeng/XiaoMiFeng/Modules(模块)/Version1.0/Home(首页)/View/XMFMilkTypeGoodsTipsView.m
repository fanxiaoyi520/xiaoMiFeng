//
//  XMFMilkTypeGoodsTipsView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/29.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMilkTypeGoodsTipsView.h"

@implementation XMFMilkTypeGoodsTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
 
    [super awakeFromNib];
   
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    
    
}


//显示在整个界面上
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.frame = [UIScreen mainScreen].bounds;
        [keyWindow addSubview:self];
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

//取消按钮被点击
- (IBAction)cancelBtnDidClick:(UIButton *)sender {
    
    [self hide];
}


//点击手势隐藏
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
}



@end
