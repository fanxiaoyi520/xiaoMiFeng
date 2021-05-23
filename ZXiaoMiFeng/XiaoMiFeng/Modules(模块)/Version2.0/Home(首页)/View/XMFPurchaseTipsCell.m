//
//  XMFPurchaseTipsCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFPurchaseTipsCell.h"
#import "XMFHomeGoodsDetailModel.h"


//在.m文件中添加
@interface  XMFPurchaseTipsCell()

@property (weak, nonatomic) IBOutlet UILabel *contentLB;


@end

@implementation XMFPurchaseTipsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setInstructionsModel:(XMFHomeGoodsDetailPurchaseInstructionsModel *)instructionsModel{
    
    _instructionsModel = instructionsModel;
    
    
    self.contentLB.text = [NSString stringWithFormat:@"%zd.%@\n%@",self.cellRow + 1,instructionsModel.question,instructionsModel.answer];
    
    
}

@end
