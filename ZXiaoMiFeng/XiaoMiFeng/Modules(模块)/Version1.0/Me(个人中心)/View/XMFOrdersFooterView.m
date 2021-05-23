//
//  XMFOrdersFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersFooterView.h"
#import "XMFOrdersCellModel.h"


//在.m文件中添加
@interface  XMFOrdersFooterView()

@property (weak, nonatomic) IBOutlet UILabel *amountLB;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;



@end


@implementation XMFOrdersFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)setOrderModel:(XMFOrdersCellModel *)orderModel{
    
    _orderModel = orderModel;
    
    self.amountLB.text = [NSString stringWithFormat:@"实付：HK$%@",[NSString removeSuffix:orderModel.actualPrice]];
    
    /**
     
     "cancel":取消订单,
     "delete":暂时没用,
     "pay":去付款,
     "comment":去评价,
     "confirm":确认收货,
     "refund":申请退款,
     "rebuy":暂时没用
     
     
     */
     if (orderModel.statusType == pendingPay){
         //待付款
         
        self.rightBtn.hidden = NO;
        
        self.leftBtn.hidden = NO;
        
        [self.rightBtn setTitle:XMFLI(@"去付款") forState:UIControlStateNormal];
      
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
      
        
    }else if (orderModel.statusType == pendingDelivery){
        
        //待发货
        
        self.rightBtn.hidden = NO;
        
        self.leftBtn.hidden = YES;
        
                
        [self.rightBtn setTitle:XMFLI(@"申请退款") forState:UIControlStateNormal];
    
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_quxiaodd"] forState:UIControlStateNormal];
        
        
    }else if (orderModel.statusType == pendingReceipt) {
        
        //待收货
        
        self.rightBtn.hidden = NO;
        
        self.leftBtn.hidden = YES;
        
        [self.rightBtn setTitle:XMFLI(@"确认收货") forState:UIControlStateNormal];
      
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
        
        
    }else if (orderModel.statusType == pendingComment){
        
        //待评价
        
        self.rightBtn.hidden = NO;
        
        self.leftBtn.hidden = YES;
                
        [self.rightBtn setTitle:XMFLI(@"去评价") forState:UIControlStateNormal];
        
        [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
                
        
    }else{
        
        self.rightBtn.hidden = YES;
        
        self.leftBtn.hidden = YES;
        
    }
    
    
    
}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFOrdersFooterViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFOrdersFooterViewDidClick:self button:sender];
    }
    
}


@end
