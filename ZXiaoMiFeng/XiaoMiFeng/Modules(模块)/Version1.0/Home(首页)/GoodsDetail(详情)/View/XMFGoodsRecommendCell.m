//
//  XMFGoodsRecommendCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsRecommendCell.h"
#import "XMFGoodsRecommendModel.h"


//在.m文件中添加
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

//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsRecommendCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFGoodsRecommendCellDidClick:self button:sender];
    }
    
}



//商品详情里面的为你推荐
-(void)setModel:(XMFGoodsRecommendModel *)model{
    
    _model = model;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = model.name;
    
//    self.goodsBriefLB.text = model.brief;
    
    self.goodsPriceLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:model.retailPrice]];
    
    
}

//个人中心里面的我的足迹
-(void)setFootprintModel:(XMFGoodsRecommendModel *)footprintModel{
    
    _footprintModel = footprintModel;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:footprintModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = footprintModel.name;
    
//    self.goodsBriefLB.text = footprintModel.brief;
    
    self.goodsPriceLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footprintModel.retailPrice]];
    
    self.chooseBtn.hidden = !footprintModel.isShow;
    
    self.chooseBtn.selected = footprintModel.isSelected;
    
}


//个人中心里面的我的收藏
-(void)setCollectionModel:(XMFGoodsRecommendModel *)collectionModel{
    
    _collectionModel = collectionModel;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:collectionModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
       
       self.goodsNameLB.text = collectionModel.name;
       
//       self.goodsBriefLB.text = collectionModel.brief;
       
       self.goodsPriceLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:collectionModel.retailPrice]];
    
}

@end
