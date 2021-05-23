//
//  XMFHomeAllGoodsCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeAllGoodsCell.h"
#import "XMFHomeGoodsCellModel.h"


//在.m文件中添加
@interface  XMFHomeAllGoodsCell()

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

/** 添加购物车 */
@property (weak, nonatomic) IBOutlet UIButton *addBtn;



@end

@implementation XMFHomeAllGoodsCell

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


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeAllGoodsCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFHomeAllGoodsCellDidClick:self button:sender];
    }
    
}


-(void)setRecommendModel:(XMFHomeGoodsCellModel *)recommendModel{
    
    _recommendModel = recommendModel;
    
    
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:recommendModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    
    self.goodsNameLB.text = [NSString stringWithFormat:@"%@\n",recommendModel.goodsName];
    
   
    /** 是否包税 0-否 1-是p */
    if ([recommendModel.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
    }
    
    /** 是否包邮 0-否 1-是 */
    if ([recommendModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;

    }
    

    
    self.salesLB.text = [NSString stringWithFormat:@"销量 %@",recommendModel.salesNum];
    
//    self.origPriceLB.text = recommendModel.counterPrice;
    
    self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:recommendModel.counterPrice]]];
    
//    self.actPriceLB.text = recommendModel.retailPrice;
    
    self.actPriceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.actPriceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12.f] lowerStr:[NSString removeSuffix:recommendModel.retailPrice] lowerColor:self.actPriceLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17.f]];
    
    
    self.addBtn.selected = [recommendModel.cartNum boolValue];
    
    
}

@end
