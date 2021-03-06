//
//  XMFCommonCustomPopView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/11/12.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFCommonCustomPopView.h"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFCommonCustomPopView()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end


@implementation XMFCommonCustomPopView

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
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCommonCustomPopViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFCommonCustomPopViewDidClick:self button:sender];
    }
    
    
    if (_commonCustomPopViewBtnsClickBlock) {
        
        _commonCustomPopViewBtnsClickBlock(self,sender);
        
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
