//
//  XMFHomeTitleBgView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/10/12.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFHomeTitleBgView.h"

//ๅจ.mๆไปถไธญๆทปๅ 
@interface  XMFHomeTitleBgView()

/** ็ญ้ๆ้ฎ */
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


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {


    if (_filtrateBtnBlock) {
        _filtrateBtnBlock();
    }

}


@end
