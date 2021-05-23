//
//  XMFHomePartGoodsCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomePartGoodsCell.h"
#import "XMFHomeGoodsCellModel.h"
#import "XMFThemeDetailModel.h"//专题详情列表model


//在.m文件中添加
@interface  XMFHomePartGoodsCell()

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

@implementation XMFHomePartGoodsCell

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
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomePartGoodsCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFHomePartGoodsCellDidClick:self button:sender];
    }
    
    
}


-(void)setModel:(XMFHomeGoodsCellModel *)model{
    
    _model = model;
    
    
     [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
        
        
        self.goodsNameLB.text = model.goodsName;
        
       
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
        
    //    self.origPriceLB.text = recommendModel.counterPrice;
        
        self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:model.counterPrice]]];
        
    //    self.actPriceLB.text = recommendModel.retailPrice;
        
        self.actPriceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.actPriceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12.f] lowerStr:[NSString removeSuffix:model.retailPrice] lowerColor:self.actPriceLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17.f]];
        
        
        self.addBtn.selected = [model.cartNum boolValue];
    
    
}


//专题详情列表的model
-(void)setThemeListModel:(XMFThemeDetailListModel *)themeListModel{
    
    
    _themeListModel = themeListModel;
    
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:themeListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    
    self.goodsNameLB.text = themeListModel.goodsName;
    
    
    /** 是否包税 0-否 1-是p */
    if ([themeListModel.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
    }
    
    /** 是否包邮 0-否 1-是 */
    if ([themeListModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;
        
    }
    
    
    
    self.salesLB.text = [NSString stringWithFormat:@"销量 %@",themeListModel.salesNum];
    
    //    self.origPriceLB.text = recommendModel.counterPrice;
    
    self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:themeListModel.counterPrice]]];
    
    //    self.actPriceLB.text = recommendModel.retailPrice;
    
    self.actPriceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.actPriceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12.f] lowerStr:[NSString removeSuffix:themeListModel.retailPrice] lowerColor:self.actPriceLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:17.f]];
    
    
    self.addBtn.selected = [themeListModel.cartNum boolValue];
    
}


@end
