//
//  XMFMilkTypeGoodsTipsView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/29.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
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


//ๆพ็คบๅจๆดไธช็้ขไธ
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.frame = [UIScreen mainScreen].bounds;
        [keyWindow addSubview:self];
        
    }];
    
}

//้่ๅผนๆก
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

//ๅๆถๆ้ฎ่ขซ็นๅป
- (IBAction)cancelBtnDidClick:(UIButton *)sender {
    
    [self hide];
}


//็นๅปๆๅฟ้่
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //ๅคๆญ็นๅป็็นๆฏๅฆๅจๆไธชๅบๅ่ๅดๅ
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
}



@end
