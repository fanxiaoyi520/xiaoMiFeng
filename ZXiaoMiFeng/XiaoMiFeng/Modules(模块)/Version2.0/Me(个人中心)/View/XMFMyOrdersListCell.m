//
//  XMFMyOrdersListCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/31.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersListCell.h"
#import "XMFMyOrdersListModel.h"//我的订单列表model



//在.m文件中添加
@interface  XMFMyOrdersListCell()


@property (weak, nonatomic) IBOutlet UIView *goodsImgBgView;


@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

/** 供应商 */
@property (weak, nonatomic) IBOutlet UIButton *supplierBtn;



@property (weak, nonatomic) IBOutlet UILabel *goodsStatusLB;


@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;


@property (weak, nonatomic) IBOutlet UILabel *goodsTypeLB;


@property (weak, nonatomic) IBOutlet UILabel *priceLB;


@property (weak, nonatomic) IBOutlet UILabel *feeLB;


@property (weak, nonatomic) IBOutlet UILabel *countLB;



@end

@implementation XMFMyOrdersListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    
    //以下三行代码防止图片变形
    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFit;
//    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.goodsImgView.autoresizesSubviews = YES;
    
    self.goodsImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
//    [self.goodsImgView cornerWithRadius:5.f];
     
    
    [self.goodsImgBgView cornerWithRadius:5.f];
    
}


/** 我的订单列表model */

-(void)setGoodsListModel:(XMFMyOrdersListGoodsListModel *)goodsListModel{
    
    _goodsListModel = goodsListModel;
    
    
    //图片
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goodsListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
  
    
    //是否缺货
    self.goodsStatusLB.hidden = ![goodsListModel.status boolValue];
    
    //商品名称
    self.goodsNameLB.text = [NSString stringWithFormat:@"%@\n",goodsListModel.goodsName];
    
    
    if ([goodsListModel.incomeTax doubleValue] > 0) {
        
        //税费
        self.feeLB.text = [NSString stringWithFormat:@"税费 HK$ %@",[NSString removeSuffix:goodsListModel.incomeTax]];
        
        self.feeLB.hidden = NO;

        
    }else{
        
        self.feeLB.hidden = YES;
        
    }
    
   
    
    
    //选中的商品类型
    self.goodsTypeLB.text = @"";
    for (int i= 0; i < goodsListModel.specifications.count; ++i) {
        
        self.goodsTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodsTypeLB.text,goodsListModel.specifications[i]];
        
    }

    
    //实际价格
    self.priceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:goodsListModel.price]];
    
    //商品数量
    self.countLB.text = [NSString stringWithFormat:@"×%@",goodsListModel.number];
    
    
}


/** 订单详情商品model */

-(void)setDetailGoodsModel:(XMFMyOrdersListGoodsListModel *)detailGoodsModel{
    
    _detailGoodsModel = detailGoodsModel;
    
    //图片
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:detailGoodsModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //供应商
    
    NSString *supplierNameStr;

    if (detailGoodsModel.supplierName.length == 0) {
        
        self.supplierBtn.hidden = YES;
        
        
    }else if (detailGoodsModel.supplierName.length > 4) {
        
        supplierNameStr = [NSString stringWithFormat:@"  %@...  ",[detailGoodsModel.supplierName substringToIndex:4]];
        
        self.supplierBtn.hidden = NO;
        
        [self.supplierBtn setTitle:supplierNameStr forState:UIControlStateNormal];
        
    }else{
        
        supplierNameStr = [NSString stringWithFormat:@"  %@  ",detailGoodsModel.supplierName];
        
        self.supplierBtn.hidden = NO;
        
        [self.supplierBtn setTitle:supplierNameStr forState:UIControlStateNormal];
    }
    

    
    
    
    
    //是否缺货
    self.goodsStatusLB.hidden = ![detailGoodsModel.status boolValue];
    
    
    //商品归属分类
    /** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
    
    NSString *goodsResourceImgName;
    
    if ([detailGoodsModel.orderType isEqualToString:@"2"]) {
        
        
        goodsResourceImgName = @"icon_haitao_60x17";
        
    }else{
        
        
        goodsResourceImgName = @"icon_guoji_60x17";
        
    }
    
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",detailGoodsModel.goodsName]];
    
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
    
    
//    self.goodsNameLB.text = detailGoodsModel.goodsName;
    
    
    if ([detailGoodsModel.incomeTax doubleValue] > 0) {
        
        //税费
        self.feeLB.text = [NSString stringWithFormat:@"税费 HK$ %@",[NSString removeSuffix:detailGoodsModel.incomeTax]];
        
        self.feeLB.hidden = NO;
        
        
    }else{
        
        self.feeLB.hidden = YES;
        
    }
    
    
    
    
    //选中的商品类型
    self.goodsTypeLB.text = @"";
    for (int i= 0; i < detailGoodsModel.specifications.count; ++i) {
        
        self.goodsTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodsTypeLB.text,detailGoodsModel.specifications[i]];
        
    }
    
    
    //实际价格
    self.priceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:detailGoodsModel.price]];
    
    //商品数量
    self.countLB.text = [NSString stringWithFormat:@"×%@",detailGoodsModel.number];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
