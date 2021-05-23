//
//  XMFXMFHomeSearchHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeSearchHeaderView.h"

@implementation XMFHomeSearchHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (_buttonsClickBlock) {
        _buttonsClickBlock(sender);
    }
    
}


@end
