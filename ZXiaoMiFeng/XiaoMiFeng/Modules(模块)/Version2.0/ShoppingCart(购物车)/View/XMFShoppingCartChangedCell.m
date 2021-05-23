//
//  XMFShoppingCartChangedCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingCartChangedCell.h"
#import "XMFShoppingCartCellModel.h"


//在.m文件中添加
@interface  XMFShoppingCartChangedCell()

/** 图片和状态背景view */
@property (weak, nonatomic) IBOutlet UIView *goodsImgStatusBgView;


/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** 商品规格 */
@property (weak, nonatomic) IBOutlet UILabel *goodTypeLB;


/** 包税 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *taxTagLB;

/** 包税标签宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxTagLBWidth;


/** 包邮 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageTagLB;

/** 包邮标签左边间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageTagLBLeftSpace;

/** 税费 */
@property (weak, nonatomic) IBOutlet UILabel *taxFeeLB;

/** 实价 */
@property (weak, nonatomic) IBOutlet UILabel *actPriceLB;

/** 数量 */
@property (weak, nonatomic) IBOutlet UILabel *countLB;

/** 商品状态 */
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
    
    
    //以下三行代码防止图片变形
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [self.goodsImgStatusBgView cornerWithRadius:5.f];
    
    
}


-(void)setGoodsModel:(XMFShoppingCartCellGoodsModel *)goodsModel{
    
    
    _goodsModel = goodsModel;
    
    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //商品名称
    self.goodsNameLB.text = goodsModel.goodsName;
    
    
    //选中的商品类型
    self.goodTypeLB.text = @"";
    for (int i= 0; i < goodsModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,goodsModel.specifications[i]];
        
    }
    
    /** 是否包税 0-否 1-是p */
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
        
        //税费
        self.taxFeeLB.text = [NSString stringWithFormat:@"税费 HK$ %@",[NSString removeSuffix:goodsModel.incomeTax]];
        
    }
    
    /** 是否包邮 0-否 1-是 */
    if ([goodsModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
    }else{
        
        self.postageTagLB.hidden = YES;

    }
    

    
    //实际价格
    self.actPriceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:goodsModel.retailPrice]];
    
    //商品数量
    self.countLB.text = [NSString stringWithFormat:@"×%@",goodsModel.number];
    
    
}

@end
