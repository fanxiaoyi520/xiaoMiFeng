//
//  XMFShoppingCartChangedCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/10/20.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFShoppingCartChangedCell.h"
#import "XMFShoppingCartCellModel.h"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFShoppingCartChangedCell()

/** å¾çåç¶æèæ¯view */
@property (weak, nonatomic) IBOutlet UIView *goodsImgStatusBgView;


/** ååå¾ç */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** åååç§° */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** ååè§æ ¼ */
@property (weak, nonatomic) IBOutlet UILabel *goodTypeLB;


/** åç¨ */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *taxTagLB;

/** åç¨æ ç­¾å®½åº¦ */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxTagLBWidth;


/** åé® */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageTagLB;

/** åé®æ ç­¾å·¦è¾¹é´è· */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageTagLBLeftSpace;

/** ç¨è´¹ */
@property (weak, nonatomic) IBOutlet UILabel *taxFeeLB;

/** å®ä»· */
@property (weak, nonatomic) IBOutlet UILabel *actPriceLB;

/** æ°é */
@property (weak, nonatomic) IBOutlet UILabel *countLB;

/** ååç¶æ */
@property (weak, nonatomic) IBOutlet UILabel *statusLB;


@end


@implementation XMFShoppingCartChangedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [self.goodsImgStatusBgView cornerWithRadius:5.f];
    
    
}


-(void)setGoodsModel:(XMFShoppingCartCellGoodsModel *)goodsModel{
    
    
    _goodsModel = goodsModel;
    
    //å¾ç
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //åååç§°
    self.goodsNameLB.text = goodsModel.goodsName;
    
    
    //éä¸­çååç±»å
    self.goodTypeLB.text = @"";
    for (int i= 0; i < goodsModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,goodsModel.specifications[i]];
        
    }
    
    /** æ¯å¦åç¨ 0-å¦ 1-æ¯p */
    if ([goodsModel.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
        self.taxFeeLB.hidden = YES;

        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
         self.taxFeeLB.hidden = NO;
        
        //ç¨è´¹
        self.taxFeeLB.text = [NSString stringWithFormat:@"ç¨è´¹ HK$ %@",[NSString removeSuffix:goodsModel.incomeTax]];
        
    }
    
    /** æ¯å¦åé® 0-å¦ 1-æ¯ */
    if ([goodsModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;

    }
    

    
    //å®éä»·æ ¼
    self.actPriceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:goodsModel.retailPrice]];
    
    //ååæ°é
    self.countLB.text = [NSString stringWithFormat:@"Ã%@",goodsModel.number];
    
    
}

@end
