//
//  XMFOrderConfirmCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderConfirmCell.h"
#import "XMFShopCartModel.h"

//在.m文件中添加
@interface  XMFOrderConfirmCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodCoverImgView;


@property (weak, nonatomic) IBOutlet UILabel *goodNameLB;


@property (weak, nonatomic) IBOutlet UILabel *goodPriceLB;


@property (weak, nonatomic) IBOutlet UILabel *goodCountLB;


@property (weak, nonatomic) IBOutlet KKPaddingLabel *goodTypeLB;


@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageLB;



@end


@implementation XMFOrderConfirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //以下三行代码防止图片变形
    self.goodCoverImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.goodCoverImgView.autoresizesSubviews = YES;

    self.goodCoverImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(XMFShopCartDetailModel *)model{
    
    _model = model;
    
    [self.goodCoverImgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodNameLB.text = model.goodsName;
    
    self.goodPriceLB.text =  [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:model.price]];;
    
    self.goodCountLB.text = [NSString stringWithFormat:@"×%@",model.number];
    
    /*
    if (model.specifications.count > 0) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@",model.specifications[0]];
        
    }*/
    
    
    //选中的商品类型
    self.goodTypeLB.text = @"";
    for (int i= 0; i < model.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,model.specifications[i]];
        
    }
    
    self.postageLB.hidden = ![model.freeShipping boolValue];
    
}

@end
