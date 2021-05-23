//
//  ZDPay_OrderSureHeaderView.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureHeaderView.h"

@interface ZDPay_OrderSureHeaderView ()

@end

@implementation ZDPay_OrderSureHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)initialize {
    
//    _countDownForLab = [[CountDown alloc] init];
    //支付剩余时间
    UILabel *paytimeLab = [UILabel new];
    self.paytimeLab = paytimeLab;
    paytimeLab.font = ZD_Fout_Medium(ratioH(14));
    paytimeLab.textAlignment = NSTextAlignmentCenter;
    paytimeLab.textColor = COLORWITHHEXSTRING(@"#666666", 1.0);
    [self.contentView addSubview:paytimeLab];
    
    //金额
    UILabel *moneyUnitLab = [UILabel new];
    self.moneyUnitLab = moneyUnitLab;
    moneyUnitLab.textAlignment = NSTextAlignmentCenter;
    moneyUnitLab.font = ZD_Fout_Medium(ratioH(18));
    moneyUnitLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    [self.contentView addSubview:moneyUnitLab];
    
    //订单编号
    UILabel *orderNumberLab = [UILabel new];
    self.orderNumberLab = orderNumberLab;
    orderNumberLab.textAlignment = NSTextAlignmentCenter;
    orderNumberLab.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
    orderNumberLab.font = ZD_Fout_Medium(ratioH(14));
    [self.contentView addSubview:orderNumberLab];
    
    //优惠码
    UILabel *discountCodeLab = [UILabel new];
    self.discountCodeLab = discountCodeLab;
    discountCodeLab.textAlignment = NSTextAlignmentCenter;
    discountCodeLab.textColor = COLORWITHHEXSTRING(@"#C28E1E", 1.0);
    discountCodeLab.font = ZD_Fout_Medium(ratioH(13));
    [self.contentView addSubview:discountCodeLab];
}

- (NSString *)getNowTimeTimestamp{
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_OrderSureModel *)model countDownForLab:(CountDown *)countDownForLab{
    if (!model) {
        return;
    }

    self.paytimeLab.frame = CGRectMake(0, 20, self.width, 14);

    @WeakObj(self)
    [countDownForLab countDownWithTimeExpire:[[ZDPay_OrderSureModel sharedSingleten] getModelData].timeExpire completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        @StrongObj(self);
        [self refreshUIDay:day hour:hour minute:minute second:second];
    }];

    //金额[ZDPayFuncTool formatToTwoDecimal:@"1289.6"]
    //[ZDPayFuncTool getRoundFloat:[model.amount doubleValue] withPrecisionNum:2]
    NSString *amountMoneyStr = [ZDPayFuncTool formatToTwoDecimal:model.txnAmt];
    self.moneyUnitLab.frame = CGRectMake(0, self.paytimeLab.bottom+20, self.width, 30);
    self.moneyUnitLab.text = [NSString stringWithFormat:@"%@ %@",[[ZDPay_OrderSureModel sharedSingleten] getModelData].txnCurr,amountMoneyStr];
    [ZDPayFuncTool LabelAttributedString:self.moneyUnitLab FontNumber:ZD_Fout_Medium(ratioH(30)) AndRange:NSMakeRange(4, amountMoneyStr.length-2) AndColor:nil];
    
    //订单编号
    NSString *orderNumberStr = [NSString stringWithFormat:@"%@: %@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].ORDER_NO,model.orderNo];
    self.orderNumberLab.frame = CGRectMake(self.paytimeLab.left, self.moneyUnitLab.bottom+16, self.moneyUnitLab.width, 14);
    self.orderNumberLab.text = orderNumberStr;
    
    //优惠码 countryCode
    NSString *discountCodeLabStr = [NSString stringWithFormat:@"优惠码抵扣%@ %@",[[ZDPay_OrderSureModel sharedSingleten] getModelData].currencyCode,@"2.00"];
    self.discountCodeLab.frame = CGRectMake(self.paytimeLab.left, self.paytimeLab.bottom+6, self.moneyUnitLab.width, 13);
    self.discountCodeLab.hidden = YES;
    self.discountCodeLab.text = discountCodeLabStr;

}

-(void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    NSString *minuteStr;
    NSString *secondStr;
    if (minute < 10) {
        minuteStr = [NSString stringWithFormat:@"0%ld",minute];
    } else {
        minuteStr = [NSString stringWithFormat:@"%ld",minute];
    }
    if (second < 10) {
        secondStr = [NSString stringWithFormat:@"0%ld",second];
    } else {
        secondStr = [NSString stringWithFormat:@"%ld",second];
    }
    
    self.paytimeLab.text = [NSString stringWithFormat:@"%@ %@:%@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].TIME_REMAINING,minuteStr,secondStr];
}

@end
