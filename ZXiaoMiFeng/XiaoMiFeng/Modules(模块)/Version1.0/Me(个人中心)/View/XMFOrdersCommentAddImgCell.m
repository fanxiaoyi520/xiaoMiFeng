//
//  XMFOrdersCommentAddImgCell.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/19.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFOrdersCommentAddImgCell.h"

//ๅจ.mๆไปถไธญๆทปๅ 
@interface  XMFOrdersCommentAddImgCell()



@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end

@implementation XMFOrdersCommentAddImgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFOrdersCommentAddImgCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFOrdersCommentAddImgCellDidClick:self button:sender];
    }
    
}


@end
