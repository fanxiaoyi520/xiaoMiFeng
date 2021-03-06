//
//  XMFOrdersCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/14.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFOrdersCell.h"
#import "XMFOrdersCellModel.h"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFOrdersCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;


@property (weak, nonatomic) IBOutlet UILabel *goodsAmountLB;



@end

@implementation XMFOrdersCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //ä»¥ä¸ä¸è¡ä»£ç é²æ­¢å¾çåå½¢
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.coverImgView.autoresizesSubviews = YES;

    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}


-(void)setGoodListModel:(XMFOrdersCellGoodsListModel *)goodListModel{
    
    _goodListModel = goodListModel;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:goodListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = goodListModel.goodsName;
    
    self.goodsAmountLB.text = [NSString stringWithFormat:@"å±%@ä»¶",goodListModel.number];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
