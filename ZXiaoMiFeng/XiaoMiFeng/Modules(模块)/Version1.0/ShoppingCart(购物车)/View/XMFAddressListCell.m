//
//  XMFAddressListCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/6.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFAddressListCell.h"
#import "XMFAddressListModel.h"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFAddressListCell()

//æ¶è´§äºº
@property (weak, nonatomic) IBOutlet UILabel *consigneeLB;


@property (weak, nonatomic) IBOutlet UILabel *defaultLB;

//å³è¾¹é´è·
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLBLeftSpace;

@property (weak, nonatomic) IBOutlet UILabel *addressLB;

//ç¼è¾æé®
@property (weak, nonatomic) IBOutlet UIButton *editBtn;



@end

@implementation XMFAddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    if ([_model.isDefault boolValue]) {
        
         [self.defaultLB cornerWithRadius:self.defaultLB.height/2.0];
    }
    
}

-(void)setModel:(XMFAddressListModel *)model{
    
    _model = model;
    
    self.consigneeLB.text = [NSString stringWithFormat:@"%@  %@",model.name,model.mobile];
    
    if ([model.isDefault boolValue]) {
        
        self.defaultLB.hidden = NO;
        
        self.addressLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.defaultLB.hidden = YES;
        
        self.addressLBLeftSpace.constant = -33.f;
        
    }
    
        
    self.addressLB.text = [NSString stringWithFormat:@"%@%@%@%@",[AddressManager getProvinceName:model.provinceId],[AddressManager getCityName:model.cityId],[AddressManager getAreaName:model.areaId],model.address];
}


//ç¼è¾æé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFAddressListCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFAddressListCellDidClick:self button:sender];
    }
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
