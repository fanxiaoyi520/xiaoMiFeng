//
//  XMFConfirmOrderSectionHeaderView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/8.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFConfirmOrderSectionHeaderView.h"
#import "XMFConfirmOrderModel.h"//è®¢åç¡®è®¤æ»model


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFConfirmOrderSectionHeaderView()


/** ä»åº */
@property (weak, nonatomic) IBOutlet UIButton *warehouseBtn;


/** è®¢åå· */
@property (weak, nonatomic) IBOutlet UILabel *orderNumLB;


@end

@implementation XMFConfirmOrderSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setChildOrderListModel:(XMFConfirmOrderChildOrderListModel *)childOrderListModel{
    
    _childOrderListModel = childOrderListModel;
    
    
   
    //ä»åºåç§°
    [self.warehouseBtn setTitle:[NSString stringWithFormat:@"  %@",childOrderListModel.warehouseName] forState:UIControlStateNormal];
    
    //è®¢åç¼å·
    self.orderNumLB.text = [NSString stringWithFormat:@"è®¢åç¼å·ï¼%@",childOrderListModel.orderSn];
    
    
}

@end
