//
//  XMFConfirmOrderCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFConfirmOrderCell.h"
#import "XMFConfirmOrderModel.h"//订单确认总model


//在.m文件中添加
@interface  XMFConfirmOrderCell()

/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** 供应商 */
@property (weak, nonatomic) IBOutlet UIButton *supplierBtn;


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


/** 商品数量 */
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLB;


@end

@implementation XMFConfirmOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //以下三行代码防止图片变形
    self.goodsPicImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsPicImgView.autoresizesSubviews = YES;
    
    self.goodsPicImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    
    [self.goodsPicImgView cornerWithRadius:5.f];

    
}


-(void)setGoodsListModel:(XMFConfirmOrderGoodsListModel *)goodsListModel{
    
    _goodsListModel = goodsListModel;
    
    //图片
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //供应商
    
    NSString *supplierNameStr;
        
    if (goodsListModel.supplierName.length > 4) {
        
        supplierNameStr = [NSString stringWithFormat:@"  %@...  ",[goodsListModel.supplierName substringToIndex:4]];
        
    }else{
        
        supplierNameStr = [NSString stringWithFormat:@"  %@  ",goodsListModel.supplierName];
    }
    
    [self.supplierBtn setTitle:supplierNameStr forState:UIControlStateNormal];
    
//    [self.supplierBtn setTitle:@"最多四字..." forState:UIControlStateNormal];
    
    //商品归属分类
    /** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
    
    NSString *goodsResourceImgName;
    
    if ([goodsListModel.orderType isEqualToString:@"2"]) {
        
        
        goodsResourceImgName = @"icon_haitao_60x17";
        
    }else{
        
        
        goodsResourceImgName = @"icon_guoji_60x17";
        
    }
    
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",goodsListModel.goodsName]];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:goodsResourceImgName];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2, 60, 17);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    [attri insertAttributedString:string atIndex:0];
    
    //商品名称
    self.goodsNameLB.attributedText = attri;
    
    
    //商品名称
//    self.goodsNameLB.text = goodsListModel.goodsName;
    
    
    //选中的商品类型
    self.goodTypeLB.text = @"";
    for (int i= 0; i < goodsListModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,goodsListModel.specifications[i]];
        
    }
    
    /** 是否包税 0-否 1-是p */
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

        
        //税费
         self.taxFeeLB.text = [NSString stringWithFormat:@"税费 HK$ %@",[NSString removeSuffix:goodsListModel.incomeTax]];
        
    }
    
    
    /** 是否包邮 0-否 1-是 */
       if ([goodsListModel.freeShipping boolValue]) {
           
           self.postageTagLB.hidden = NO;
           
       }else{
           
           self.postageTagLB.hidden = YES;

       }
    

    
    //实际价格
    self.actPriceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:goodsListModel.price]];
    
    //商品数量
    self.goodsCountLB.text = [NSString stringWithFormat:@"×%@",goodsListModel.number];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
