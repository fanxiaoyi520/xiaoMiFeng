//
//  XMFHomeHeaderView.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/4/16.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFHomeHeaderView.h"

//ε¨.mζδ»ΆδΈ­ζ·»ε 
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
