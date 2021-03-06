//
//  XMFPurchaseTipsCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/2.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFPurchaseTipsCell.h"
#import "XMFHomeGoodsDetailModel.h"


//ε¨.mζδ»ΆδΈ­ζ·»ε 
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
