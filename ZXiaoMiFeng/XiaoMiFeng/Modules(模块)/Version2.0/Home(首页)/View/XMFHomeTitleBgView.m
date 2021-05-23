//
//  XMFHomeTitleBgView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeTitleBgView.h"

//在.m文件中添加
@interface  XMFHomeTitleBgView()

/** 筛选按钮 */
@property (weak, nonatomic) IBOutlet UIButton *filtrateBtn;



@end

@implementation XMFHomeTitleBgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.filtrateBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleLeft imageTitleSpace:4.f];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {


    if (_filtrateBtnBlock) {
        _filtrateBtnBlock();
    }

}


@end
