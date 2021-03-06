//
//  XMFGoodsDetailInfoCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/2.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFGoodsDetailInfoCell.h"
#import "XMFHomeGoodsDetailModel.h"


//ε¨.mζδ»ΆδΈ­ζ·»ε 
@interface  XMFGoodsDetailInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *contentLB;

@end

@implementation XMFGoodsDetailInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setModel:(XMFHomeGoodsDetailGoodsAttributesModel *)model{
    
    _model = model;
    
    self.titleLB.text = model.attributeName;
    
    self.contentLB.text = model.attributeValue;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
