//
//  XMFHomeGoodsClassifyCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/7.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFHomeGoodsClassifyCell.h"
#import "XMFHomeGoodsClassifyModel.h"//εεεη±»ηmodel


//ε¨.mζδ»ΆδΈ­ζ·»ε 
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
