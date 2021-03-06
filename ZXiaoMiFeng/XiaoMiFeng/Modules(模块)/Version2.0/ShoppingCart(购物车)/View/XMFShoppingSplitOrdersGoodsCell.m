//
//  XMFShoppingSplitOrdersGoodsCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2021/1/27.
//  Copyright Β© 2021 πε°θθπ. All rights reserved.
//

#import "XMFShoppingSplitOrdersGoodsCell.h"
#import "XMFShoppingSplitOrdersModel.h"


//ε¨.mζδ»ΆδΈ­ζ·»ε 
@interface XMFShoppingSplitOrdersGoodsCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;



@property (weak, nonatomic) IBOutlet KKPaddingLabel *goodsAmountLB;


@end


@implementation XMFShoppingSplitOrdersGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //δ»₯δΈδΈθ‘δ»£η ι²ζ­’εΎηεε½’
    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsImgView.autoresizesSubviews = YES;
    
    self.goodsImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}

-(void)setGoodsModel:(XMFShoppingSplitOrdersGoodsModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.url] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsAmountLB.text = [NSString stringWithFormat:@"Γ%@",goodsModel.number];
}

@end
