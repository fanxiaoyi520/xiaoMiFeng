//
//  XMFGoodsDetailFooterView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/8.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFGoodsDetailFooterView.h"
#import "XMFGoodsDatailModel.h"//ååè¯¦æmodel


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFGoodsDetailFooterView()

//å®¢æ
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;

//æ¶è
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;


@end


@implementation XMFGoodsDetailFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.serviceBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:3];
    
    [self.collectBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:3];
    
}

-(void)setDetailModel:(XMFGoodsDatailModel *)detailModel{
    
    _detailModel = detailModel;
    
    self.collectBtn.selected = [detailModel.userHasCollect boolValue];
    
    
}


//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsDetailFooterViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFGoodsDetailFooterViewDidClick:self button:sender];
    }
    
    
}



@end
