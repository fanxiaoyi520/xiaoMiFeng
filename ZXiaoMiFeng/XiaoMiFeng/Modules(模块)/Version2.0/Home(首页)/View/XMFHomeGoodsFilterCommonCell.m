//
//  XMFHomeGoodsFilterCommonCell.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/5.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFHomeGoodsFilterCommonCell.h"
#import "XMFHomeGoodsFilterModel.h"


//ๅจ.mๆไปถไธญๆทปๅ 
@interface  XMFHomeGoodsFilterCommonCell()





@end


@implementation XMFHomeGoodsFilterCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/*
-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.standardBtn.selected = selected;
    
}*/


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeGoodsFilterCommonCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFHomeGoodsFilterCommonCellDidClick:self button:sender];
    }
    
}


-(void)setSonModel:(XMFHomeGoodsFilterSonModel *)sonModel{
    
    _sonModel = sonModel;
    
    
    self.standardBtn.selected = sonModel.tagSeleted;
    
    [self.standardBtn setTitle:sonModel.standard forState:UIControlStateNormal];
    
}

@end
