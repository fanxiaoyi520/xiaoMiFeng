//
//  XMFGoodsGuideCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/5/11.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFGoodsGuideCell.h"
#import "XMFGoodsDetailIssueModel.h"

//ε¨.mζδ»ΆδΈ­ζ·»ε 
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
    
    self.titleLB.text = [NSString stringWithFormat:@"%@γ%@",model.issueId,model.question];
    
    self.contentLB.text = model.answer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
