//
//  XMFOrderRateFooterView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/13.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFOrderRateFooterView.h"

//ๅจ.mๆไปถไธญๆทปๅ 
@interface  XMFOrderRateFooterView()


/** ๆไบคๆ้ฎ */
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


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFOrderRateFooterViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFOrderRateFooterViewDidClick:self button:sender];
    }
    
}


@end
