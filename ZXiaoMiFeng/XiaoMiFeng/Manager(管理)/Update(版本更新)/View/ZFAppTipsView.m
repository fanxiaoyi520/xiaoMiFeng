//
//  ZFAppTipsView.m
//  ZFDaYaNews
//
//  Created by 小蜜蜂 on 2019/6/4.
//  Copyright © 2019 Jellyfish. All rights reserved.
//

#import "ZFAppTipsView.h"

@implementation ZFAppTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
 
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    
    self.bgView.layer.cornerRadius = 10.f;
    self.bgView.layer.masksToBounds = YES;
    
    //    [self.bgView xw_roundedCornerWithRadius:10.f cornerColor:self.backgroundColor];
//    self.tipsLB.text = XMFLI(@"当前已是最新版本");
    [self.sureBtn setTitle:XMFLI(@"确定") forState:UIControlStateNormal];
}

- (IBAction)sureBtnDidClick:(UIButton *)sender {
    
    [self removeFromSuperview];
}


-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [keyWindow addSubview:self];
    }];
    
}

-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

@end
