//
//  XMFMyOrdersListFooterCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/9.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFMyOrdersListFooterCell.h"
#import "XMFMyOrdersListFooterModel.h"//ζδ½ηmodel


//ε¨.mζδ»ΆδΈ­ζ·»ε 
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
