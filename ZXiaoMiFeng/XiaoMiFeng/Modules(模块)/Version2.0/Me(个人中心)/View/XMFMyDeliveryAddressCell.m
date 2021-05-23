//
//  XMFMyDeliveryAddressCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyDeliveryAddressCell.h"
#import "XMFMyDeliveryAddressModel.h"


//在.m文件中添加
@interface  XMFMyDeliveryAddressCell()


/** 收货人 */
@property (weak, nonatomic) IBOutlet UILabel *consigneeLB;

/** 无货提示 */
@property (weak, nonatomic) IBOutlet UILabel *noStockTipsLB;


/** 默认 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *defaultLB;


/** 默认左边间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultLBLeftSpace;


/** 默认宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultLBWidth;



/** 未认证 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *unverifiedLB;

/** 未认证宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unerifiedLBWidth;



/** 收货地址 */
@property (weak, nonatomic) IBOutlet UILabel *addressLB;


/** 收货地址左边间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLBLeftSpace;


/** 编辑按钮 */
@property (weak, nonatomic) IBOutlet UIButton *editBtn;


@end

@implementation XMFMyDeliveryAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAddressModel:(XMFMyDeliveryAddressModel *)addressModel{
    
    _addressModel = addressModel;
    
    self.consigneeLB.text = [NSString stringWithFormat:@"%@  %@",addressModel.name,addressModel.mobile];
    
    //地址是否可以用
    self.noStockTipsLB.hidden = !addressModel.unusable;
    
    //未认证标签
    self.unverifiedLB.hidden = addressModel.verified;
    
    if (!addressModel.verified) {
        
        self.unerifiedLBWidth.constant = 42.f;
        
        self.defaultLBLeftSpace.constant = 10.f;
        
    }else{
        
        self.unerifiedLBWidth.constant = 0.f;
        
        self.defaultLBLeftSpace.constant = 0.f;
    }
    
    
    
    //默认标签
    self.defaultLB.hidden = ![addressModel.isDefault boolValue];
    
    if ([addressModel.isDefault boolValue]) {
        
        self.defaultLBWidth.constant = 31.f;
        
        self.addressLBLeftSpace.constant = 10.f;
        
    }else{
        
        self.defaultLBWidth.constant = 0.f;
        
        self.addressLBLeftSpace.constant = 0.f;
    }
    
    
    self.addressLB.text = [NSString stringWithFormat:@"%@%@%@%@",[AddressManager getProvinceName:addressModel.provinceId],[AddressManager getCityName:addressModel.cityId],[AddressManager getAreaName:addressModel.areaId],addressModel.address];
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFMyDeliveryAddressCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFMyDeliveryAddressCellDidClick:self button:sender];
    }
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
