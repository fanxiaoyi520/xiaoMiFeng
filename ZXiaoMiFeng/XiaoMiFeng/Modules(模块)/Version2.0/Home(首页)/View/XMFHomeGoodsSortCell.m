//
//  XMFHomeGoodsSortCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsSortCell.h"


@implementation XMFHomeGoodsSortCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    if (selected) {
        
        self.titleLB.textColor = UIColorFromRGB(0xF7CF20);
        
        
    }else{
        
        self.titleLB.textColor = UIColorFromRGB(0x666666);
    }
    
    self.chooseImgView.hidden = !selected;

}

@end
