//
//  XMFMyCollectionCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyCollectionCell.h"
//#import "XMFMyCollectionModel.h"//收藏的model
#import "XMFHomeGoodsCellModel.h"//首页商品model


//在.m文件中添加
@interface  XMFMyCollectionCell()


@property (weak, nonatomic) IBOutlet UIView *cellBgView;


@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

/** 选择按钮的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewRightSpace;

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

@implementation XMFMyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectBtnWidth.constant = 0.f;
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
       
    //以下三行代码防止图片变形
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [self.cellBgView xw_roundedCornerWithRadius:10.f cornerColor:self.contentView.backgroundColor];
    
}



-(void)setIsSelected:(BOOL)isSelected{
    
    if (isSelected) {
        
        self.selectBtnWidth.constant = 35.f;
        
        self.bgViewRightSpace.constant = -23.f;
        
        
    }else{
        
        self.selectBtnWidth.constant = 0.f;
        
        self.bgViewRightSpace.constant = 0.f;
                
    }
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFMyCollectionCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFMyCollectionCellDidClick:self button:sender];
    }
    
}


/*
-(void)setSonModel:(XMFMyCollectionSonModel *)sonModel{
    
    _sonModel = sonModel;
    
    
    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:sonModel.goodsPicUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //商品名称
    self.goodsNameLB.text = sonModel.goodsName;
    

    
    // 是否包税 0-否 1-是p
    if ([sonModel.goodsTaxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
    }
    
    // 是否包邮 0-否 1-是
    if ([sonModel.goodsShipFlag boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;
        
    }
    
    
    //销量
    self.salesLB.text = [NSString stringWithFormat:@"销量 %@",sonModel.goodsSalesNum];
    
    //标价
    self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:sonModel.goodsCounterPrice]]];

    //实际价格
    self.actPriceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:sonModel.goodsRetailPrice]];

    //按钮选中与否
    self.selectBtn.selected = sonModel.isSelected;
    
    
}*/



-(void)setGoodsModel:(XMFHomeGoodsCellModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //商品名称
    self.goodsNameLB.text = goodsModel.goodsName;
    

    
    /** 是否包税 0-否 1-是p */
    if ([goodsModel.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
    }
    
    /** 是否包邮 0-否 1-是 */
    if ([goodsModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;
        
    }
    
    
    //销量
    self.salesLB.text = [NSString stringWithFormat:@"销量 %@",goodsModel.salesNum];
    
    //标价
    self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:goodsModel.counterPrice]]];

    //实际价格
    self.actPriceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:goodsModel.retailPrice]];

    //按钮选中与否
    self.selectBtn.selected = goodsModel.isSelected;
    
    //购物车按钮的选中状态
//    self.addBtn.selected = [goodsModel.cartNum boolValue];

    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
