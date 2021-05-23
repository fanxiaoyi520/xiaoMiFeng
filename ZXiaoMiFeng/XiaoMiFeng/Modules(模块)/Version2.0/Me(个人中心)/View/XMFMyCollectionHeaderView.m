//
//  XMFMyCollectionHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyCollectionHeaderView.h"

//在.m文件中添加
@interface  XMFMyCollectionHeaderView()

@property (weak, nonatomic) IBOutlet UIView *bgView;




@end

@implementation XMFMyCollectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.bgView cornerWithRadius:4.f direction:CornerDirectionTypeTopLeft | CornerDirectionTypeTopRight];
    
}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (_emptyInvalidCollectionBlock) {
        _emptyInvalidCollectionBlock(self);
    }
    
}


@end
