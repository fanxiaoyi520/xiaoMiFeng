//
//  XMFHomeDoctorCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/12.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFHomeDoctorCell.h"
#import "XMFHomeGoodsCellModel.h"

//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFHomeDoctorCell()


/** ååå¾ç */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** åååç§° */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** åç¨ */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *taxTagLB;

/** åç¨æ ç­¾å®½åº¦ */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxTagLBWidth;


/** åé® */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageTagLB;

/** åé®æ ç­¾å·¦è¾¹é´è· */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageTagLBLeftSpace;


/** éé */
@property (weak, nonatomic) IBOutlet UILabel *salesLB;

/** åä»· */
@property (weak, nonatomic) IBOutlet UILabel *origPriceLB;

/** å®ä»· */
@property (weak, nonatomic) IBOutlet UILabel *actPriceLB;

/** åå°è´­ç©è½¦ */
@property (weak, nonatomic) IBOutlet UIButton *reduceBtn;


/** æ·»å è´­ç©è½¦ */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

/** ååæ°é */
@property (weak, nonatomic) IBOutlet UIButton *amountBtn;


@end


@implementation XMFHomeDoctorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //ç»cellååè§
    [self cornerWithRadius:4.f];
    
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.goodsPicImgView.autoresizesSubviews = YES;

    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}


-(void)setModel:(XMFHomeGoodsCellModel *)model{
    
    _model = model;
    
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:model.simplifyPicUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeSqua"]];
    
    
    self.goodsNameLB.text = [NSString stringWithFormat:@"%@\n",model.goodsName];
    
    
    /** æ¯å¦åç¨ 0-å¦ 1-æ¯p */
    if ([model.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
    }
    
    /** æ¯å¦åé® 0-å¦ 1-æ¯ */
    if ([model.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;
        
    }
    
    
    
    self.salesLB.text = [NSString stringWithFormat:@"éé %@",model.salesNum];
    
    
    self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:model.counterPrice]]];
    
    
    self.actPriceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.actPriceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f] lowerStr:[NSString removeSuffix:model.retailPrice] lowerColor:self.actPriceLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:24.f]];
    
    [self.amountBtn setTitle:model.cartNum forState:UIControlStateNormal];
        
    
}


//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    static NSTimeInterval time = 0.0;
     
     NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
     
     //éå¶ç¨æ·ç¹å»æé®çæ¶é´é´éå¤§äº1ç§é
     
     if (currentTime - time > 0.5) {
         
         //å¤§äºè¿ä¸ªæ¶é´é´éå°±å¤ç
         if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeDoctorCellDidClick:button:)]) {
             
             [self.delegate buttonsOnXMFHomeDoctorCellDidClick:self button:sender];
         }
         
         
     }
     
     time = currentTime;
    
    
}



@end
