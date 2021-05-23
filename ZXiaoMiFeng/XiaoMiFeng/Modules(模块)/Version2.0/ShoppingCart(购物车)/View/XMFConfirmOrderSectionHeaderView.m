//
//  XMFConfirmOrderSectionHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFConfirmOrderSectionHeaderView.h"
#import "XMFConfirmOrderModel.h"//订单确认总model


//在.m文件中添加
@interface  XMFConfirmOrderSectionHeaderView()


/** 仓库 */
@property (weak, nonatomic) IBOutlet UIButton *warehouseBtn;


/** 订单号 */
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
    
    
   
    //仓库名称
    [self.warehouseBtn setTitle:[NSString stringWithFormat:@"  %@",childOrderListModel.warehouseName] forState:UIControlStateNormal];
    
    //订单编号
    self.orderNumLB.text = [NSString stringWithFormat:@"订单编号：%@",childOrderListModel.orderSn];
    
    
}

@end
