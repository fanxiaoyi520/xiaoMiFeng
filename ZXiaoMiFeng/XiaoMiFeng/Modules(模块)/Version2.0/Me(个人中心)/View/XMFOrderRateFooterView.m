//
//  XMFOrderRateFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/13.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderRateFooterView.h"

//在.m文件中添加
@interface  XMFOrderRateFooterView()


/** 提交按钮 */
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;



@end

@implementation XMFOrderRateFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFOrderRateFooterViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFOrderRateFooterViewDidClick:self button:sender];
    }
    
}


@end
