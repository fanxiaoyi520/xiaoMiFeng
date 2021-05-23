//
//  XMFCartHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/21.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFCartHeaderView.h"
#import "XMFShopCartModel.h"



//在.m文件中添加
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
     shipmentRegion=0 国内自营商品
     shipmentRegion=1 海外自营商品
     shipmentRegion=11 海外奶粉专区
     
     */
    
    DLog(@"middleModel.shipmentRegion:%@",middleModel.shipmentRegion);

    if ([middleModel.shipmentRegion isEqualToString:@"0"]) {
        
        self.shopNameLB.text = @"国内自营商品";
        
    }else if([middleModel.shipmentRegion isEqualToString:@"11"]){
        
        self.shopNameLB.text = @"海外奶粉专区";
        
    }else{
        
        self.shopNameLB.text = @"海外自营商品";
    }
    
    
    self.chooseBtn.selected = middleModel.isChoose;
    
    
}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFCartHeaderViewDidClick:button:section:)]) {
        
        [self.delegate buttonsOnXMFCartHeaderViewDidClick:self button:sender section:self.section];
    }
    
    
}


@end
