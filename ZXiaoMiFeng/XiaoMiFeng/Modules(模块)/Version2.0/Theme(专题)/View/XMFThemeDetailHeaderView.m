//
//  XMFThemeDetailHeaderView.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/9/29.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFThemeDetailHeaderView.h"

//ε¨.mζδ»ΆδΈ­ζ·»ε 
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
