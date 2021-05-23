//
//  XMFLoginRemindView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFLoginRemindView.h"

@implementation XMFLoginRemindView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    
    if (_loginRemindViewTapBlock) {
        _loginRemindViewTapBlock();
    }
}


@end
