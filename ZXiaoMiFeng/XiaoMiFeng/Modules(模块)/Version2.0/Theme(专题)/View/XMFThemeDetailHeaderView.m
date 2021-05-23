//
//  XMFThemeDetailHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/29.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFThemeDetailHeaderView.h"

//在.m文件中添加
@interface  XMFThemeDetailHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgImgViewBottomSpace;

@end

@implementation XMFThemeDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.bgImgViewBottomSpace.constant = KScaleWidth(-84);
    
}

-(void)setBgImgURLStr:(NSString *)bgImgURLStr{
    
    _bgImgURLStr = bgImgURLStr;
    
    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:bgImgURLStr]];
    
    
}

@end
