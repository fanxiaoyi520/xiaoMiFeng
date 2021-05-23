//
//  XMFGoodsGuideCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsGuideCell.h"
#import "XMFGoodsDetailIssueModel.h"

//在.m文件中添加
@interface  XMFGoodsGuideCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLB;


@property (weak, nonatomic) IBOutlet UILabel *contentLB;


@end

@implementation XMFGoodsGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(XMFGoodsDetailIssueModel *)model{
    
    _model = model;
    
    self.titleLB.text = [NSString stringWithFormat:@"%@、%@",model.issueId,model.question];
    
    self.contentLB.text = model.answer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
