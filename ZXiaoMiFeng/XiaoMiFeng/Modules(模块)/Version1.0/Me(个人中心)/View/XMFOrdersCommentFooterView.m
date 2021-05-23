//
//  XMFOrdersCommentFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersCommentFooterView.h"

@implementation XMFOrdersCommentFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (_sureBtnBlock) {
        _sureBtnBlock();
    }
    
    
}


@end
