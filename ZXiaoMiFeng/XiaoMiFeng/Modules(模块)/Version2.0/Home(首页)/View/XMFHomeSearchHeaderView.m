//
//  XMFXMFHomeSearchHeaderView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/3.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFHomeSearchHeaderView.h"

@implementation XMFHomeSearchHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (_buttonsClickBlock) {
        _buttonsClickBlock(sender);
    }
    
}


@end
