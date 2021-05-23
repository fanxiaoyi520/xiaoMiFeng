//
//  XMFHomeHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/16.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeHeaderView.h"

//在.m文件中添加
@interface  XMFHomeHeaderView()

@property (weak, nonatomic) IBOutlet UIButton *scanBtn;


@property (weak, nonatomic) IBOutlet UIButton *searchBtn;


@property (weak, nonatomic) IBOutlet UIButton *meBtn;


@end

@implementation XMFHomeHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeHeaderViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFHomeHeaderViewDidClick:self button:sender];
    }
    
}


@end
