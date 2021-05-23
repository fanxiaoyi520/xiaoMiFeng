//
//  XMFHomeGoodsFilterCommonCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/5.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsFilterCommonCell.h"
#import "XMFHomeGoodsFilterModel.h"


//在.m文件中添加
@interface  XMFHomeGoodsFilterCommonCell()





@end


@implementation XMFHomeGoodsFilterCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/*
-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.standardBtn.selected = selected;
    
}*/


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeGoodsFilterCommonCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFHomeGoodsFilterCommonCellDidClick:self button:sender];
    }
    
}


-(void)setSonModel:(XMFHomeGoodsFilterSonModel *)sonModel{
    
    _sonModel = sonModel;
    
    
    self.standardBtn.selected = sonModel.tagSeleted;
    
    [self.standardBtn setTitle:sonModel.standard forState:UIControlStateNormal];
    
}

@end
