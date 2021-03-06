//
//  XMFHomeAllGoodsCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/12.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFHomeAllGoodsCell.h"
#import "XMFHomeGoodsCellModel.h"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFHomeAllGoodsCell()

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

/** æ·»å è´­ç©è½¦ */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;



@end

@implementation XMFHomeAllGoodsCell

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


//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeAllGoodsCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFHomeAllGoodsCellDidClick:self button:sender];
    }
    
}


-(void)setRecommendModel:(XMFHomeGoodsCellModel *)recommendModel{
    
    _recommendModel = recommendModel;
    
    
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:recommendModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    
    self.goodsNameLB.text = [NSString stringWithFormat:@"%@\n",recommendModel.goodsName];
    
   
    /** æ¯å¦åç¨ 0-å¦ 1-æ¯p */
    if ([recommendModel.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
    }
    
    /** æ¯å¦åé® 0-å¦ 1-æ¯ */
    if ([recommendModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;

    }
    

    
    self.salesLB.text = [NSString stringWithFormat:@"éé %@",recommendModel.salesNum];
    
//    self.origPriceLB.text = recommendModel.counterPrice;
    
    self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:recommendModel.counterPrice]]];
    
//    self.actPriceLB.text = recommendModel.retailPrice;
    
    self.actPriceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.actPriceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12.f] lowerStr:[NSString removeSuffix:recommendModel.retailPrice] lowerColor:self.actPriceLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17.f]];
    
    
    self.addBtn.selected = [recommendModel.cartNum boolValue];
    
    
}

@end
