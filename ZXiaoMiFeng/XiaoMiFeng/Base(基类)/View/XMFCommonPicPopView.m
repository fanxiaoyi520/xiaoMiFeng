//
//  XMFCommonPicPopView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2021/1/28.
//  Copyright Â© 2021 ðå°èèð. All rights reserved.
//

#import "XMFCommonPicPopView.h"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFCommonPicPopView()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@end


@implementation XMFCommonPicPopView

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

    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCommonPicPopViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFCommonPicPopViewDidClick:self button:sender];
    }
    
    
    if (_popViewBtnsClickBlock) {
        _popViewBtnsClickBlock(sender);
    }


    [self hide];
}


//æ¾ç¤ºå¨æ´ä¸ªçé¢ä¸
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
         self.frame = [UIScreen mainScreen].bounds;
         [keyWindow addSubview:self];
        
    } completion:^(BOOL finished) {
        
 
        
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
