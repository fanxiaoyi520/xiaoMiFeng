//
//  XMFConfirmOrderCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/2.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFConfirmOrderCell.h"
#import "XMFConfirmOrderModel.h"//è®¢åç¡®è®¤æ»model


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFConfirmOrderCell()

/** ååå¾ç */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** ä¾åºå */
@property (weak, nonatomic) IBOutlet UIButton *supplierBtn;


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


/** ååæ°é */
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLB;


@end

@implementation XMFConfirmOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [self.goodsPicImgView cornerWithRadius:5.f];

    
}


-(void)setGoodsListModel:(XMFConfirmOrderGoodsListModel *)goodsListModel{
    
    _goodsListModel = goodsListModel;
    
    //å¾ç
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //ä¾åºå
    
    NSString *supplierNameStr;
        
    if (goodsListModel.supplierName.length > 4) {
        
        supplierNameStr = [NSString stringWithFormat:@"  %@...  ",[goodsListModel.supplierName substringToIndex:4]];
        
    }else{
        
        supplierNameStr = [NSString stringWithFormat:@"  %@  ",goodsListModel.supplierName];
    }
    
    [self.supplierBtn setTitle:supplierNameStr forState:UIControlStateNormal];
    
//    [self.supplierBtn setTitle:@"æå¤åå­..." forState:UIControlStateNormal];
    
    //ååå½å±åç±»
    /** ç¨å·ç±»å 1-èèå½é-bc 2-èèæµ·æ·-cc */
    
    NSString *goodsResourceImgName;
    
    if ([goodsListModel.orderType isEqualToString:@"2"]) {
        
        
        goodsResourceImgName = @"icon_haitao_60x17";
        
    }else{
        
        
        goodsResourceImgName = @"icon_guoji_60x17";
        
    }
    
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",goodsListModel.goodsName]];
    
    // æ·»å è¡¨æ
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // è¡¨æå¾ç
    attch.image = [UIImage imageNamed:goodsResourceImgName];
    // è®¾ç½®å¾çå¤§å°
    attch.bounds = CGRectMake(0, -2, 60, 17);
    
    // åå»ºå¸¦æå¾ççå¯ææ¬
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    [attri insertAttributedString:string atIndex:0];
    
    //åååç§°
    self.goodsNameLB.attributedText = attri;
    
    
    //åååç§°
//    self.goodsNameLB.text = goodsListModel.goodsName;
    
    
    //éä¸­çååç±»å
    self.goodTypeLB.text = @"";
    for (int i= 0; i < goodsListModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,goodsListModel.specifications[i]];
        
    }
    
    /** æ¯å¦åç¨ 0-å¦ 1-æ¯p */
    if ([goodsListModel.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxFeeLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
        self.taxFeeLB.hidden = NO;

        
        //ç¨è´¹
         self.taxFeeLB.text = [NSString stringWithFormat:@"ç¨è´¹ HK$ %@",[NSString removeSuffix:goodsListModel.incomeTax]];
        
    }
    
    
    /** æ¯å¦åé® 0-å¦ 1-æ¯ */
       if ([goodsListModel.freeShipping boolValue]) {
           
           self.postageTagLB.hidden = NO;
           
       }else{
           
           self.postageTagLB.hidden = YES;

       }
    

    
    //å®éä»·æ ¼
    self.actPriceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:goodsListModel.price]];
    
    //ååæ°é
    self.goodsCountLB.text = [NSString stringWithFormat:@"Ã%@",goodsListModel.number];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
