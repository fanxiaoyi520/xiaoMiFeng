//
//  XMFGoodsCommentDetailCell.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/8/26.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFGoodsCommentDetailCell.h"

//ε¨.mζδ»ΆδΈ­ζ·»ε 
@interface  XMFGoodsCommentDetailCell()

@property (weak, nonatomic) IBOutlet UIImageView *commentImgView;


@end

@implementation XMFGoodsCommentDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self cornerWithRadius:4.f];
    
}

-(void)setPicURLStr:(NSString *)picURLStr{
    
    
    _picURLStr = picURLStr;
    
    [self.commentImgView sd_setImageWithURL:[NSURL URLWithString:picURLStr] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
}

@end
