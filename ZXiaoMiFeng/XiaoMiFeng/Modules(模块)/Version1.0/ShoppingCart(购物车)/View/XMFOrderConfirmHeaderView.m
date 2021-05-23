//
//  XMFOrderConfirmHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderConfirmHeaderView.h"
#import "XMFOrderConfirmModel.h"
#import "XMFAddressListModel.h"


//在.m文件中添加
@interface  XMFOrderConfirmHeaderView()

@property (weak, nonatomic) IBOutlet UIView *addressBgView;

//收货人
@property (weak, nonatomic) IBOutlet UILabel *consigneeLB;


@property (weak, nonatomic) IBOutlet UILabel *defaultLB;

//右边间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLBLeftSpace;



/**已设置不能用户交互*/
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;


@property (weak, nonatomic) IBOutlet UIView *shopNameBgView;


@property (weak, nonatomic) IBOutlet UILabel *shopNameLB;



@end

@implementation XMFOrderConfirmHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.defaultLB cornerWithRadius:self.defaultLB.height/2.0];
}


-(void)setHeaderModel:(XMFOrderConfirmModel *)headerModel{
    
    _headerModel = headerModel;
    
    XMFCheckedaddressModel *addressModel = headerModel.checkedAddress;
    
    if ([addressModel.addressId isEqualToString:@"0"]) {
        
        self.addAddressBtn.hidden = NO;
        
    }else{
        
        self.addAddressBtn.hidden = YES;
        
        self.consigneeLB.text = [NSString stringWithFormat:@"收货人：%@ %@",addressModel.name,addressModel.mobile];
        
        self.addressLB.text = [NSString stringWithFormat:@"%@%@%@%@",[AddressManager getProvinceName:addressModel.provinceId],[AddressManager getCityName:addressModel.cityId],[AddressManager getAreaName:addressModel.areaId],addressModel.address];
        
        
        if ([addressModel.isDefault boolValue]) {
            
            self.defaultLB.hidden = NO;
            
            self.addressLBLeftSpace.constant = 5.f;
            
        }else{
            
            self.defaultLB.hidden = YES;
            
            self.addressLBLeftSpace.constant = -self.defaultLB.width;
            
        }
        
    }
    
    
    
}

//地址列表的model
-(void)setAddressListModel:(XMFAddressListModel *)addressListModel{
    
    _addressListModel = addressListModel;
    
    self.addAddressBtn.hidden = YES;
    
    self.consigneeLB.text = [NSString stringWithFormat:@"收货人：%@ %@",addressListModel.name,addressListModel.mobile];
    
    self.addressLB.text = [NSString stringWithFormat:@"%@%@%@%@",[AddressManager getProvinceName:addressListModel.provinceId],[AddressManager getCityName:addressListModel.cityId],[AddressManager getAreaName:addressListModel.areaId],addressListModel.address];
    
    if ([addressListModel.isDefault boolValue]) {
        
        self.defaultLB.hidden = NO;
        
        self.addressLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.defaultLB.hidden = YES;
        
        self.addressLBLeftSpace.constant = -self.defaultLB.width;
        
    }
    
}


//点击手势
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(tapGestureOnXMFOrderConfirmHeaderViewDidTap:)]) {
        
        [self.delegate tapGestureOnXMFOrderConfirmHeaderViewDidTap:self];
    }
    
}





@end
