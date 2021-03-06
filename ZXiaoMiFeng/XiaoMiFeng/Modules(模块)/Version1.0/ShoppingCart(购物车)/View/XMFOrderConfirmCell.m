//
//  XMFOrderConfirmCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/30.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFOrderConfirmCell.h"
#import "XMFShopCartModel.h"

//å¨.mæä»¶ä¸­æ·»å 
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
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
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
    
    self.goodCountLB.text = [NSString stringWithFormat:@"Ã%@",model.number];
    
    /*
    if (model.specifications.count > 0) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@",model.specifications[0]];
        
    }*/
    
    
    //éä¸­çååç±»å
    self.goodTypeLB.text = @"";
    for (int i= 0; i < model.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,model.specifications[i]];
        
    }
    
    self.postageLB.hidden = ![model.freeShipping boolValue];
    
}

@end
