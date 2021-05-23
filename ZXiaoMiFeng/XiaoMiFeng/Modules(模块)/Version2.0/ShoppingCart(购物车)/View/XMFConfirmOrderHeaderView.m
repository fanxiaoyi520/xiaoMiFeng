//
//  XMFConfirmOrderHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFConfirmOrderHeaderView.h"
#import "XMFConfirmOrderModel.h"//订单确认总model
#import "XMFMyDeliveryAddressModel.h"//地址的model


//在.m文件中添加
@interface  XMFConfirmOrderHeaderView()

/** 提示语 */
@property (weak, nonatomic) IBOutlet UILabel *tipsLB;

/** 提示语的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsLBHeight;


/** 地址背景view */
@property (weak, nonatomic) IBOutlet UIView *addressBgView;


/** 收货人 */
@property (weak, nonatomic) IBOutlet UILabel *consigneeLB;


/** 地址 */
@property (weak, nonatomic) IBOutlet UILabel *addressLB;

/** 默认 */
@property (weak, nonatomic) IBOutlet UILabel *defaultLB;


/** 默认的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *defaultLBWidth;





/** 无货提示 */
@property (weak, nonatomic) IBOutlet UILabel *noStockTipsLB;


/** 添加地址按钮 */
@property (weak, nonatomic) IBOutlet UIButton *addAddressBtn;




@end

@implementation XMFConfirmOrderHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
    //添加手势
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        
    [self.addressBgView addGestureRecognizer:tap1];
    
    
}


//点击手势
-(void)tapAction:(UITapGestureRecognizer *)gesture{
    
    UIView *tapView = (UIView *)gesture.view;

    
    if ([self.delegate respondsToSelector:@selector(tapGestureOnXMFConfirmOrderHeaderViewDidTap:tapView:)]) {
        
        [self.delegate tapGestureOnXMFConfirmOrderHeaderViewDidTap:self tapView:tapView];
    }
    
    
    
}


-(void)setOrderModel:(XMFConfirmOrderModel *)orderModel{
    
    _orderModel = orderModel;
        
    
    if ([orderModel.isSplit boolValue]) {
        
        self.tipsLB.hidden = NO;
        
        self.tipsLBHeight.constant = 34.f;
    
        
    }else{
        
        self.tipsLB.hidden = YES;
        
        self.tipsLBHeight.constant = 0.f;
        
        //重新布局高度
        CGRect viewFrame = self.frame;
        
        viewFrame.size.height -= 34.f;
        
        self.frame = viewFrame;
    }
    
    
}



-(void)setAddressModel:(XMFMyDeliveryAddressModel *)addressModel{
    
    _addressModel = addressModel;
    
    
    //防止没有数据的时候
    if (addressModel.name.length > 0) {
        
        
        self.addAddressBtn.hidden = YES;
        

    }else{
        
        self.addAddressBtn.hidden = NO;

    }
    
    
    /*
    NSMutableAttributedString *consigneeInfoStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:XMFLI(@"收件人：") upperColor:UIColorFromRGB(0x333333) upperFont:[UIFont systemFontOfSize:14.f] lowerStr:[NSString stringWithFormat:@"%@ %@",addressModel.name,addressModel.mobile] lowerColor:UIColorFromRGB(0x333333) lowerFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:14.f]];
        
    self.consigneeLB.attributedText = consigneeInfoStr;
     */
    
    self.consigneeLB.text = [NSString stringWithFormat:@"%@ %@",addressModel.name,addressModel.mobile];
    

    self.defaultLB.hidden = ![addressModel.isDefault boolValue];
    
    if ([addressModel.isDefault boolValue]) {
        //是否是默认的
        self.defaultLBWidth.constant = 40.f;
        
    }else{
        
        self.defaultLBWidth.constant = 0.f;
    }
    
    
    //地址是否可以用
    self.noStockTipsLB.hidden = !addressModel.unusable;
    
    
    self.addressLB.text = [NSString stringWithFormat:@"%@%@%@%@",[AddressManager getProvinceName:addressModel.provinceId],[AddressManager getCityName:addressModel.cityId],[AddressManager getAreaName:addressModel.areaId],addressModel.address];
    
    
    
    
}

@end
