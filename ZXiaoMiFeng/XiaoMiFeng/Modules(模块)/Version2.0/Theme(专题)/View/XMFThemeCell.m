//
//  XMFThemeCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFThemeCell.h"
#import "XMFThemeModel.h"


//在.m文件中添加
@interface  XMFThemeCell()

@property (weak, nonatomic) IBOutlet UIImageView *themeImgView;


@end


@implementation XMFThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self cornerWithRadius:4.f];
    
    //以下三行代码防止图片变形
//    self.themeImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.themeImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.themeImgView.autoresizesSubviews = YES;
    
    self.themeImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}


-(void)setModel:(XMFThemeModel *)model{
    
    _model = model;
    
    
    [self.themeImgView sd_setImageWithURL:[NSURL URLWithString:model.mainPic] placeholderImage:[UIImage imageNamed:@"icon_common_placeSqua"]];
    
}

@end
