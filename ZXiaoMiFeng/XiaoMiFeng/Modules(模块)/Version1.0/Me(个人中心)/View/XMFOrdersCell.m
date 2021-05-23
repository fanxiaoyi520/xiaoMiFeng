//
//  XMFOrdersCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersCell.h"
#import "XMFOrdersCellModel.h"


//在.m文件中添加
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
    
    //以下三行代码防止图片变形
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.coverImgView.autoresizesSubviews = YES;

    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}


-(void)setGoodListModel:(XMFOrdersCellGoodsListModel *)goodListModel{
    
    _goodListModel = goodListModel;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:goodListModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = goodListModel.goodsName;
    
    self.goodsAmountLB.text = [NSString stringWithFormat:@"共%@件",goodListModel.number];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
