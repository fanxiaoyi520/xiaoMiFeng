//
//  ZDPay_MywalletTableViewCell.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/16.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_MywalletTableViewCell.h"
#import "ZDPayFuncTool.h"

typedef void (^BalanceBlock)(ZDPay_OrderBankListTokenModel *model,UIButton *sender,UIImageView *backImageView);
@interface ZDPay_MywalletTableViewCell ()

@property (nonatomic,strong)UIImageView *backImageView;
@property (nonatomic,strong)UILabel *typeLab;
@property (nonatomic,strong)UILabel *cardNumberLab;
@property (nonatomic,strong)UIButton *isHiddenBtn;
@property (nonatomic,strong)ZDPay_OrderBankListTokenModel *bankModel;
@property (nonatomic,strong)UILabel *balanceLab;
@property (nonatomic,copy)BalanceBlock balanceBlock;

@end
@implementation ZDPay_MywalletTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

#pragma mark - private
- (void)setFrame:(CGRect)frame {
    frame.origin.y += 16;
    frame.size.width = ScreenWidth-32;
    [super setFrame:frame];
}

- (void)initialize {
    
    UIImageView *backImageView = [UIImageView new];
    backImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:backImageView];
    self.backImageView = backImageView;
    
    UILabel *typeLab = [UILabel new];
    self.typeLab = typeLab;
    [backImageView addSubview:typeLab];
    typeLab.textColor = COLORWITHHEXSTRING(@"#FFFFFF", .8);
    typeLab.font = ZD_Fout_Medium(12);

    UILabel *cardNumberLab = [UILabel new];
    self.cardNumberLab = cardNumberLab;
    [backImageView addSubview:cardNumberLab];
    cardNumberLab.textColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);
    cardNumberLab.font = ZD_Fout_Medium(18);
    
    UIButton *isHiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.isHiddenBtn = isHiddenBtn;
    isHiddenBtn.selected = YES;
    [backImageView addSubview:isHiddenBtn];
    
    [isHiddenBtn setImage:REImageName(@"icon_yingcang") forState:UIControlStateNormal];
    [isHiddenBtn addTarget:self action:@selector(isHiddenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *balanceLab = [UILabel new];
    [backImageView addSubview:balanceLab];
    self.balanceLab = balanceLab;
    balanceLab.tag = 10;
    balanceLab.textColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);
    balanceLab.font = ZD_Fout_Medium(12);
}

- (void)isHiddenBtnAction:(UIButton *)sender {
    if (sender.selected == YES) {
        sender.selected = NO;
        [self.isHiddenBtn setImage:REImageName(@"icon_zhankai") forState:UIControlStateNormal];
        NSMutableString* str1=[[NSMutableString alloc] initWithString:self.bankModel.cardId];
        for(NSInteger i = str1.length -4; i >0; i -=4) {
            [str1 insertString:@" " atIndex:i];
        }
        self.cardNumberLab.text = [NSString stringWithFormat:@"%@",str1];
    } else {
        sender.selected = YES;
        [self.isHiddenBtn setImage:REImageName(@"icon_yingcang") forState:UIControlStateNormal];
        self.cardNumberLab.text = [NSString stringWithFormat:@"**** **** **** %@",self.bankModel.cardNum];
    }
    
    if ([self.bankModel.bankName isEqualToString:@"Sinopay"] || [self.bankModel.bankName isEqualToString:@"sinopay"] || [self.bankModel.bankName isEqualToString:@"SinoCard"]) {
        if (self.balanceBlock) {
            self.balanceBlock(self.bankModel,sender,self.backImageView);
        }
    }
}

#pragma mark - public
- (void)layoutAndLoadData:(ZDPay_OrderBankListTokenModel * __nullable)model callBack:(void(^)(ZDPay_OrderBankListTokenModel *model,UIButton *sender,UIImageView *backImageView))callBack {
    if (!model) {
        return;
    }
    
    self.balanceBlock = callBack;
    float x=0;
    NSString *imageStr = @"";
    UIImage *image;
    imageStr = model.cardBgImage;
    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageStr]];
    if (data != nil) {
        image = [[UIImage alloc]initWithData:data];
        x=image.size.height*(ScreenWidth-32)/image.size.width;
    } else {
        image = [UIImage imageNamed:@"card_yajincz"];
        x=image.size.height*(ScreenWidth-32)/image.size.width;
    }

    self.bankModel = model;
    self.backImageView.frame = CGRectMake(0, 5, self.width, x);
    self.backImageView.image = image;

    CGRect typeRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:model.cardType withFont:ZD_Fout_Medium(12)];
    self.typeLab.frame = CGRectMake(48, 34, typeRect.size.width, 12);
    self.typeLab.text = [NSString stringWithFormat:@"%@",model.cardType];
    
    
    NSMutableString* str1=[[NSMutableString alloc] initWithString:model.cardId];
    for(NSInteger i = str1.length -4; i >0; i -=4) {
        [str1 insertString:@" " atIndex:i];
    }
    CGRect cardNumberRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:str1 withFont:ZD_Fout_Medium(18)];
    self.cardNumberLab.frame = CGRectMake(48, 68, cardNumberRect.size.width, 18);
    self.cardNumberLab.text = [NSString stringWithFormat:@"**** **** **** %@",self.bankModel.cardNum];

    self.isHiddenBtn.frame = CGRectMake(self.width-57, 33, 57, 79);
    
    if ([model.bankName isEqualToString:@"Sinopay"] || [model.bankName isEqualToString:@"sinopay"] || [self.bankModel.bankName isEqualToString:@"SinoCard"]) {
        CGRect balanceLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"余额:****" withFont:ZD_Fout_Medium(12)];
        self.balanceLab.frame = CGRectMake(self.width-balanceLabRect.size.width-20, 5, balanceLabRect.size.width, 12);
        self.balanceLab.text = @"余额:****";
    }
}
@end
