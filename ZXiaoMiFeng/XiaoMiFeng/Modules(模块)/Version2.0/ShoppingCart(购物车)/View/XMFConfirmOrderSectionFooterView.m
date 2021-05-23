//
//  XMFConfirmOrderSectionFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFConfirmOrderSectionFooterView.h"
#import "XMFConfirmOrderModel.h"//订单确认总model


//在.m文件中添加
@interface  XMFConfirmOrderSectionFooterView()

/** 运费 */
@property (weak, nonatomic) IBOutlet UILabel *postageLB;


@end

@implementation XMFConfirmOrderSectionFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setChildOrderListModel:(XMFConfirmOrderChildOrderListModel *)childOrderListModel{
    
    _childOrderListModel = childOrderListModel;
    
    
    
    //当运费为0的时候不显示
    if ([childOrderListModel.postagePrice doubleValue] > 0) {
        
        self.postageLB.text = [NSString stringWithFormat:@"运费：HK$ %@",[NSString removeSuffix:childOrderListModel.postagePrice]];
        
        self.postageLB.hidden = NO;
        
    }else{
        
        self.postageLB.hidden = YES;

    }
    
 
    
}

@end
