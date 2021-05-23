//
//  ZDPay_OrderSureHeaderView.h
//  ReadingEarn
//
//  Created by FANS on 2020/4/14.
//  Copyright © 2020 FANS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZDPay_OrderSureRespModel.h"
#import "ZDPayFuncTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZDPay_OrderSureHeaderView : UITableViewHeaderFooterView

@property (nonatomic ,strong)NSString *zdPayTimer;
@property (nonatomic ,strong)UILabel *paytimeLab;
@property (nonatomic ,strong)UILabel *moneyUnitLab;
@property (nonatomic ,strong)UILabel *orderNumberLab;
@property (nonatomic ,strong)UILabel *discountCodeLab;

- (void)layoutAndLoadData:(ZDPay_OrderSureModel *)model countDownForLab:(CountDown *)countDownForLab;
@end

NS_ASSUME_NONNULL_END
