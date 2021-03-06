//
//  XMFThemeCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/8/26.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFThemeCell.h"
#import "XMFThemeModel.h"


//ε¨.mζδ»ΆδΈ­ζ·»ε 
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
    
    //δ»₯δΈδΈθ‘δ»£η ι²ζ­’εΎηεε½’
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
