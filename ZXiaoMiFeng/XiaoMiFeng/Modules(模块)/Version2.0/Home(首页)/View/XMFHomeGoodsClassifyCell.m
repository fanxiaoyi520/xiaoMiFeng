//
//  XMFHomeGoodsClassifyCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/7.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsClassifyCell.h"
#import "XMFHomeGoodsClassifyModel.h"//商品分类的model


//在.m文件中添加
@interface  XMFHomeGoodsClassifyCell()

@property (weak, nonatomic) IBOutlet UIImageView *classifyImgView;


@property (weak, nonatomic) IBOutlet UILabel *classifyNameLB;




@end

@implementation XMFHomeGoodsClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
//    [self.classifyImgView cornerWithRadius:self.classifyImgView.height/2.0];

    
}


-(void)setClassifyModel:(XMFHomeGoodsClassifyModel *)classifyModel{
    
    _classifyModel = classifyModel;
    
    [self.classifyImgView sd_setImageWithURL:[NSURL URLWithString:classifyModel.icon] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.classifyNameLB.text = classifyModel.name;
    
    
}


@end
