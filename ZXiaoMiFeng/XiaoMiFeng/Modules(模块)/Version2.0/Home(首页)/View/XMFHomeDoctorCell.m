//
//  XMFHomeDoctorCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeDoctorCell.h"
#import "XMFHomeGoodsCellModel.h"

//在.m文件中添加
@interface  XMFHomeDoctorCell()


/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** 包税 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *taxTagLB;

/** 包税标签宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxTagLBWidth;


/** 包邮 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageTagLB;

/** 包邮标签左边间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageTagLBLeftSpace;


/** 销量 */
@property (weak, nonatomic) IBOutlet UILabel *salesLB;

/** 原价 */
@property (weak, nonatomic) IBOutlet UILabel *origPriceLB;

/** 实价 */
@property (weak, nonatomic) IBOutlet UILabel *actPriceLB;

/** 减少购物车 */
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;


/** 添加购物车 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

/** 商品数量 */
@property (weak, nonatomic) IBOutlet UIButton *amountBtn;


@end


@implementation XMFHomeDoctorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //给cell切圆角
    [self cornerWithRadius:4.f];
    
    
    //以下三行代码防止图片变形
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.goodsPicImgView.autoresizesSubviews = YES;

    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}


-(void)setModel:(XMFHomeGoodsCellModel *)model{
    
    _model = model;
    
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:model.simplifyPicUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeSqua"]];
    
    
    self.goodsNameLB.text = [NSString stringWithFormat:@"%@\n",model.goodsName];
    
    
    /** 是否包税 0-否 1-是p */
    if ([model.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
    }
    
    /** 是否包邮 0-否 1-是 */
    if ([model.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;
        
    }
    
    
    
    self.salesLB.text = [NSString stringWithFormat:@"销量 %@",model.salesNum];
    
    
    self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:model.counterPrice]]];
    
    
    self.actPriceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.actPriceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f] lowerStr:[NSString removeSuffix:model.retailPrice] lowerColor:self.actPriceLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:24.f]];
    
    [self.amountBtn setTitle:model.cartNum forState:UIControlStateNormal];
        
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    static NSTimeInterval time = 0.0;
     
     NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
     
     //限制用户点击按钮的时间间隔大于1秒钟
     
     if (currentTime - time > 0.5) {
         
         //大于这个时间间隔就处理
         if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeDoctorCellDidClick:button:)]) {
             
             [self.delegate buttonsOnXMFHomeDoctorCellDidClick:self button:sender];
         }
         
         
     }
     
     time = currentTime;
    
    
}



@end
