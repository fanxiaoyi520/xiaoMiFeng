//
//  XMFGoodsParameterCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsParameterCell.h"
#import "XMFGoodsDetailAttributeModel.h"

//在.m文件中添加
@interface  XMFGoodsParameterCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (weak, nonatomic) IBOutlet UILabel *contentLB;


@end


@implementation XMFGoodsParameterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setAttributeModel:(XMFGoodsDetailAttributeModel *)attributeModel{
    
    _attributeModel = attributeModel;
    
    self.titleLB.text = attributeModel.attribute;
    
    self.contentLB.text = attributeModel.value;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
