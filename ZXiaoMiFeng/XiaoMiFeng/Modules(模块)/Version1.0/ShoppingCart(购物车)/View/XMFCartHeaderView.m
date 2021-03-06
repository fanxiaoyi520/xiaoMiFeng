//
//  XMFCartHeaderView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/21.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFCartHeaderView.h"
#import "XMFShopCartModel.h"



//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFCartHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


@property (weak, nonatomic) IBOutlet UILabel *shopNameLB;


@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


@end

@implementation XMFCartHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)setMiddleModel:(XMFShopCartMiddleModel *)middleModel{
    
    
    _middleModel = middleModel;

    /**
     shipmentRegion=0 å½åèªè¥åå
     shipmentRegion=1 æµ·å¤èªè¥åå
     shipmentRegion=11 æµ·å¤å¥¶ç²ä¸åº
     
     */
    
    DLog(@"middleModel.shipmentRegion:%@",middleModel.shipmentRegion);

    if ([middleModel.shipmentRegion isEqualToString:@"0"]) {
        
        self.shopNameLB.text = @"å½åèªè¥åå";
        
    }else if([middleModel.shipmentRegion isEqualToString:@"11"]){
        
        self.shopNameLB.text = @"æµ·å¤å¥¶ç²ä¸åº";
        
    }else{
        
        self.shopNameLB.text = @"æµ·å¤èªè¥åå";
    }
    
    
    self.chooseBtn.selected = middleModel.isChoose;
    
    
}



//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCartHeaderViewDidClick:button:section:)]) {
        
        [self.delegate buttonsOnXMFCartHeaderViewDidClick:self button:sender section:self.section];
    }
    
    
}


@end
