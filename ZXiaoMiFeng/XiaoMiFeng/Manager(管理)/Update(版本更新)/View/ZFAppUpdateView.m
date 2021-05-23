//
//  ZFAppUpdateView.m
//  ZFDaYaNews
//
//  Created by 小蜜蜂 on 2019/5/28.
//  Copyright © 2019 Jellyfish. All rights reserved.
//

#import "ZFAppUpdateView.h"

//在.m文件中添加
@interface  ZFAppUpdateView()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation ZFAppUpdateView

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
    
    [self.cancelBtn setTitle:XMFLI(@"取消") forState:UIControlStateNormal];
    [self.updateBtn setTitle:XMFLI(@"去更新") forState:UIControlStateNormal];
}


//取消按钮被点击

- (IBAction)cancelBtnDidClick:(UIButton *)sender {
    
    if (_cancelBtnBlock) {
        _cancelBtnBlock(sender);
    }
    
    [self hide];
}

//去更新
- (IBAction)updateBtnDidClick:(UIButton *)sender {
        
    if (_updateBtnBlock) {
        _updateBtnBlock(sender);
    }
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
