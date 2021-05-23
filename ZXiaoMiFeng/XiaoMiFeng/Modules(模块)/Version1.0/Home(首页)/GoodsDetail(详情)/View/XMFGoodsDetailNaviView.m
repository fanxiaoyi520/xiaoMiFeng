//
//  XMFGoodsDetailNaviView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailNaviView.h"

//在.m文件中添加
@interface  XMFGoodsDetailNaviView()



@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;


@property (nonatomic, strong) UIButton *selectedBtn;



@end

@implementation XMFGoodsDetailNaviView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.detailBtn.selected = YES;
    
    self.selectedBtn = self.detailBtn;
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (sender.tag == 1 || sender.tag == 2) {
        
        if (self.selectedBtn != sender) {
            
            self.selectedBtn.selected = NO;
            
            sender.selected = YES;
            
            self.selectedBtn = sender;
            
            
        }else{
            
            self.selectedBtn.selected = YES;
        }
        
    }
    
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsDetailNaviViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFGoodsDetailNaviViewDidClick:self button:sender];
    }
    
}


@end
