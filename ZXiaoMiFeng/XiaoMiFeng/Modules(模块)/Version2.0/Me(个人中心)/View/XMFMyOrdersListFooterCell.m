//
//  XMFMyOrdersListFooterCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersListFooterCell.h"
#import "XMFMyOrdersListFooterModel.h"//操作的model


//在.m文件中添加
@interface  XMFMyOrdersListFooterCell()

@property (weak, nonatomic) IBOutlet UIButton *operateBtn;


@end

@implementation XMFMyOrdersListFooterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setFooterModel:(XMFMyOrdersListFooterModel *)footerModel{
    
    _footerModel = footerModel;
    
    [self.operateBtn setTitle:footerModel.name forState:UIControlStateNormal];
    
    if ([footerModel.handleOption isEqualToString:@"confirm"] || [footerModel.handleOption isEqualToString:@"comment"] || [footerModel.handleOption isEqualToString:@"cancelRefund"] || [footerModel.handleOption isEqualToString:@"remind"] || [footerModel.handleOption isEqualToString:@"pay"] || [footerModel.handleOption isEqualToString:@"addCart"]) {
        
        [self.operateBtn setBackgroundImage:[UIImage imageNamed:@"btn_order_querendd"] forState:UIControlStateNormal];
        
    }else{
        
        [self.operateBtn setBackgroundImage:[UIImage imageNamed:@"btn_order_quxiaodd"] forState:UIControlStateNormal];
    }
    
}

@end
