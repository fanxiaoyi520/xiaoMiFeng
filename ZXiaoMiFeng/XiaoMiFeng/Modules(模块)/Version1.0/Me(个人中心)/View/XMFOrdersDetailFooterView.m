//
//  XMFOrdersDetailFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/18.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersDetailFooterView.h"
#import "XMFOrdersDetailModel.h"


//在.m文件中添加
@interface  XMFOrdersDetailFooterView()

@property (weak, nonatomic) IBOutlet UILabel *goodsTotalAmountLB;

//运费
@property (weak, nonatomic) IBOutlet UILabel *postageLB;

//税费
@property (weak, nonatomic) IBOutlet UILabel *taxesLB;

//其他优惠
@property (weak, nonatomic) IBOutlet UILabel *discountLB;

//实付金额
@property (weak, nonatomic) IBOutlet UILabel *payAcountLB;


@end

@implementation XMFOrdersDetailFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setInfoModel:(XMFOrdersDetailOrderInfoModel *)infoModel{
    
    _infoModel = infoModel;
    
    //商品总额
//    self.goodsTotalAmountLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.goodsPrice]];
    
    
    self.goodsTotalAmountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.goodsTotalAmountLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:infoModel.goodsPrice] lowerColor:self.goodsTotalAmountLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    
    
    //运费
//    self.postageLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.freightPrice]];
    
    self.postageLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.postageLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:infoModel.freightPrice] lowerColor:self.postageLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    //税费
//    self.taxesLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.taxPrice]];
    
    self.taxesLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.taxesLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:infoModel.taxPrice] lowerColor:self.taxesLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    //优惠金额
//    self.discountLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.couponPrice]];
    
    self.discountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.discountLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:infoModel.couponPrice] lowerColor:self.discountLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    //实付金额
//    self.payAcountLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.actualPrice]];
    
    self.payAcountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.payAcountLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12.f] lowerStr:[NSString removeSuffix:infoModel.actualPrice] lowerColor:self.payAcountLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17.f]];
    
}

@end
