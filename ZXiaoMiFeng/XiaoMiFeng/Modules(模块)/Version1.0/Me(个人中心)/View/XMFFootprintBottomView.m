//
//  XMFFootprintBottomView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/13.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFFootprintBottomView.h"



@implementation XMFFootprintBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFFootprintBottomViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFFootprintBottomViewDidClick:self button:sender];
    }
    
}



@end
