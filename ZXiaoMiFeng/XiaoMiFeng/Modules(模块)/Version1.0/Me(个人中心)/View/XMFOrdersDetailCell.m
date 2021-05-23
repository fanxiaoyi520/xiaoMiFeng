//
//  XMFOrdersDetailCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/18.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersDetailCell.h"
#import "XMFOrdersDetailModel.h"


//在.m文件中添加
@interface  XMFOrdersDetailCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

@property (weak, nonatomic) IBOutlet UILabel *goodsAcountLB;


@property (weak, nonatomic) IBOutlet UILabel *goodsTypeLB;


@property (weak, nonatomic) IBOutlet UILabel *goodsCountLb;




@end

@implementation XMFOrdersDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //以下三行代码防止图片变形
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.coverImgView.autoresizesSubviews = YES;

    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}



-(void)setGoodsModel:(XMFOrdersDetailOrderGoodsModel *)goodsModel{
    
    _goodsModel = goodsModel;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:goodsModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = goodsModel.goodsName;
    
//    self.goodsAcountLB.text =  [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:goodsModel.price]];
    
    
    self.goodsAcountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.goodsAcountLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:10.f] lowerStr:[NSString removeSuffix:goodsModel.price] lowerColor:self.goodsAcountLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:15.f]];
    
    
    self.goodsCountLb.text = [NSString stringWithFormat:@"×%@",goodsModel.number];
    
    /*
    if (goodsModel.specifications.count > 0) {

        self.goodsTypeLB.text = [NSString stringWithFormat:@"%@",goodsModel.specifications[0]];

    }*/
    
    //商品类型
    self.goodsTypeLB.text = @"";
    for (int i= 0; i < goodsModel.specifications.count; ++i) {
        
        self.goodsTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodsTypeLB.text,goodsModel.specifications[i]];
        
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
