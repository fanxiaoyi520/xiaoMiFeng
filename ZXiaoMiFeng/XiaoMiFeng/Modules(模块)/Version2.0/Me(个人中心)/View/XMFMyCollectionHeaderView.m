//
//  XMFMyCollectionHeaderView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/19.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFMyCollectionHeaderView.h"

//ๅจ.mๆไปถไธญๆทปๅ 
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



//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (_emptyInvalidCollectionBlock) {
        _emptyInvalidCollectionBlock(self);
    }
    
}


@end
