//
//  XMFGoodsCommentDetailCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsCommentDetailCell.h"

//在.m文件中添加
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
