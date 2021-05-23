//
//  XMFAddressListCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAddressListCell.h"
#import "XMFAddressListModel.h"


//在.m文件中添加
@interface  XMFAddressListCell()

//收货人
@property (weak, nonatomic) IBOutlet UILabel *consigneeLB;


@property (weak, nonatomic) IBOutlet UILabel *defaultLB;

//右边间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLBLeftSpace;

@property (weak, nonatomic) IBOutlet UILabel *addressLB;

//编辑按钮
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


//编辑按钮被点击
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
