//
//  XMFOrdersDetailFooterView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/18.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFOrdersDetailFooterView.h"
#import "XMFOrdersDetailModel.h"


//åš.mæä»¶äž­æ·»å 
@interface  XMFOrdersDetailFooterView()

@property (weak, nonatomic) IBOutlet UILabel *goodsTotalAmountLB;

//è¿èŽ¹
@property (weak, nonatomic) IBOutlet UILabel *postageLB;

//çšèŽ¹
@property (weak, nonatomic) IBOutlet UILabel *taxesLB;

//å¶ä»äŒæ 
@property (weak, nonatomic) IBOutlet UILabel *discountLB;

//å®ä»éé¢
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
    
    //ååæ»é¢
//    self.goodsTotalAmountLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.goodsPrice]];
    
    
    self.goodsTotalAmountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.goodsTotalAmountLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:infoModel.goodsPrice] lowerColor:self.goodsTotalAmountLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    
    
    //è¿èŽ¹
//    self.postageLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.freightPrice]];
    
    self.postageLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.postageLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:infoModel.freightPrice] lowerColor:self.postageLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    //çšèŽ¹
//    self.taxesLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.taxPrice]];
    
    self.taxesLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.taxesLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:infoModel.taxPrice] lowerColor:self.taxesLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    //äŒæ éé¢
//    self.discountLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.couponPrice]];
    
    self.discountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.discountLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:infoModel.couponPrice] lowerColor:self.discountLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    //å®ä»éé¢
//    self.payAcountLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:infoModel.actualPrice]];
    
    self.payAcountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.payAcountLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12.f] lowerStr:[NSString removeSuffix:infoModel.actualPrice] lowerColor:self.payAcountLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17.f]];
    
}

@end
