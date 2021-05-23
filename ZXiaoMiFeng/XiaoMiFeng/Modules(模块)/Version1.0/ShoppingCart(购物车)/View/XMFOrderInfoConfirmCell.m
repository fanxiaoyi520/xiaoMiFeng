//
//  XMFOrderInfoConfirmCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/28.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderInfoConfirmCell.h"
#import "XMFOrderCheckedGoodsListModel.h"



//在.m文件中添加
@interface  XMFOrderInfoConfirmCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodCoverImgView;


@property (weak, nonatomic) IBOutlet UILabel *goodNameLB;


@property (weak, nonatomic) IBOutlet UILabel *goodPriceLB;


@property (weak, nonatomic) IBOutlet UILabel *goodCountLB;


@property (weak, nonatomic) IBOutlet KKPaddingLabel *goodTypeLB;


@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageLB;




//商品合计
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalMoneyLB;

//运费
@property (weak, nonatomic) IBOutlet UILabel *postageFeeLB;

//税费
@property (weak, nonatomic) IBOutlet UILabel *taxesLB;


@property (weak, nonatomic) IBOutlet UILabel *orderTotalMoneyLB;





@end


@implementation XMFOrderInfoConfirmCell

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


-(void)setGoodListModel:(XMFOrderCheckedGoodsListModel *)goodListModel{
    
    _goodListModel = goodListModel;
    
    
    [self.goodCoverImgView sd_setImageWithURL:[NSURL URLWithString:goodListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodNameLB.text = goodListModel.goodsName;
    
    self.goodPriceLB.text =  [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:goodListModel.price]];;
    
    self.goodCountLB.text = [NSString stringWithFormat:@"×%@",goodListModel.number];
    
    /*
    if (goodListModel.specifications.count > 0) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@",goodListModel.specifications[0]];
        
    }*/
    
    //选中的商品类型
    self.goodTypeLB.text = @"";
    for (int i= 0; i < goodListModel.specifications.count; ++i) {
        
        self.goodTypeLB.text = [NSString stringWithFormat:@"%@  %@",self.goodTypeLB.text,goodListModel.specifications[i]];
        
    }
    
    self.postageLB.hidden = ![goodListModel.freeShipping boolValue];
    
    
    
    //
    
    self.goodsTotalMoneyLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:goodListModel.goodsTotalPrice]];
    
    self.postageFeeLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:goodListModel.freightPrice]];
    
    self.taxesLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:goodListModel.tariffPrice]];
    
    self.orderTotalMoneyLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:goodListModel.orderTotalPrice]];
    
    
    
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
