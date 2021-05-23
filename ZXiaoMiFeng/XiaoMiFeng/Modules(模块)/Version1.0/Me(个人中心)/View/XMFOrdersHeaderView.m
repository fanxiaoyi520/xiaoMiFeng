//
//  XMFOrdersHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersHeaderView.h"
#import "XMFOrdersCellModel.h"


//在.m文件中添加
@interface  XMFOrdersHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *orderNumLB;


@property (weak, nonatomic) IBOutlet UILabel *orderStatusLB;


@end

@implementation XMFOrdersHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setOrderModel:(XMFOrdersCellModel *)orderModel{
    
    _orderModel = orderModel;
    
    self.orderNumLB.text = [NSString stringWithFormat:@"订单编号：%@",orderModel.orderSn];
    
    self.orderStatusLB.text = orderModel.orderStatusText;
    
}

@end
