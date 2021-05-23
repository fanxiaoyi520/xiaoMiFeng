//
//  XMFOrdersCommentAddImgCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersCommentAddImgCell.h"

//在.m文件中添加
@interface  XMFOrdersCommentAddImgCell()



@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end

@implementation XMFOrdersCommentAddImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFOrdersCommentAddImgCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFOrdersCommentAddImgCellDidClick:self button:sender];
    }
    
}


@end
