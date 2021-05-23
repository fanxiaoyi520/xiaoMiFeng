//
//  XMFShoppingSplitOrdersGoodsCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/27.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingSplitOrdersGoodsCell.h"
#import "XMFShoppingSplitOrdersModel.h"


//在.m文件中添加
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
    
    //以下三行代码防止图片变形
    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsImgView.autoresizesSubviews = YES;
    
    self.goodsImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}

-(void)setGoodsModel:(XMFShoppingSplitOrdersGoodsModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.url] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsAmountLB.text = [NSString stringWithFormat:@"×%@",goodsModel.number];
}

@end
