//
//  XMFGoodsDetailInfoCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailInfoCell.h"
#import "XMFHomeGoodsDetailModel.h"


//在.m文件中添加
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
