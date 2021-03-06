//
//  XMFComonPopView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/19.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFCommonPopView.h"

//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFCommonPopView()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end


@implementation XMFCommonPopView

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
    
    //èæ¯viewåè§
    [self.bgView cornerWithRadius:10.f];
    
    
}


//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCommonPopViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFCommonPopViewDidClick:self button:sender];
    }
    

    if (_commonPopViewBtnsClickBlock) {
        _commonPopViewBtnsClickBlock(sender);
    }
    
    [self hide];
}


//æ¾ç¤ºå¨æ´ä¸ªçé¢ä¸
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        

        
    } completion:^(BOOL finished) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
         self.frame = [UIScreen mainScreen].bounds;
         [keyWindow addSubview:self];
        
    }];
    
}

//éèå¼¹æ¡
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        [self removeFromSuperview];

        
    } completion:^(BOOL finished) {
        
        
    }];
    
}


@end
