//
//  XMFGoodsRecommendCell.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/12.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFGoodsRecommendCell.h"
#import "XMFGoodsRecommendModel.h"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFGoodsRecommendCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;


@property (weak, nonatomic) IBOutlet UILabel *goodsBriefLB;


@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLB;


@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;



@end

@implementation XMFGoodsRecommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.coverImgView.autoresizesSubviews = YES;

    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}

//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsRecommendCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFGoodsRecommendCellDidClick:self button:sender];
    }
    
}



//ååè¯¦æéé¢çä¸ºä½ æ¨è
-(void)setModel:(XMFGoodsRecommendModel *)model{
    
    _model = model;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = model.name;
    
//    self.goodsBriefLB.text = model.brief;
    
    self.goodsPriceLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:model.retailPrice]];
    
    
}

//ä¸ªäººä¸­å¿éé¢çæçè¶³è¿¹
-(void)setFootprintModel:(XMFGoodsRecommendModel *)footprintModel{
    
    _footprintModel = footprintModel;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:footprintModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = footprintModel.name;
    
//    self.goodsBriefLB.text = footprintModel.brief;
    
    self.goodsPriceLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footprintModel.retailPrice]];
    
    self.chooseBtn.hidden = !footprintModel.isShow;
    
    self.chooseBtn.selected = footprintModel.isSelected;
    
}


//ä¸ªäººä¸­å¿éé¢çæçæ¶è
-(void)setCollectionModel:(XMFGoodsRecommendModel *)collectionModel{
    
    _collectionModel = collectionModel;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:collectionModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
       
       self.goodsNameLB.text = collectionModel.name;
       
//       self.goodsBriefLB.text = collectionModel.brief;
       
       self.goodsPriceLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:collectionModel.retailPrice]];
    
}

@end
