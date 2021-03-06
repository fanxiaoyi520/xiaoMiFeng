//
//  XMFOrdersHeaderView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/14.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFOrdersHeaderView.h"
#import "XMFOrdersCellModel.h"


//ๅจ.mๆไปถไธญๆทปๅ 
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
    
    self.orderNumLB.text = [NSString stringWithFormat:@"่ฎขๅ็ผๅท๏ผ%@",orderModel.orderSn];
    
    self.orderStatusLB.text = orderModel.orderStatusText;
    
}

@end
