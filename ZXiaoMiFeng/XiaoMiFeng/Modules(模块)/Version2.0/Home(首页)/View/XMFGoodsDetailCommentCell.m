//
//  XMFGoodsDetailCommentCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailCommentCell.h"
//#import "XMFHomeGoodsDetailModel.h"//商品详情的评论model
#import "XMFGoodsCommentModel.h"//评论列表的model


//在.m文件中添加
@interface  XMFGoodsDetailCommentCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

@property (weak, nonatomic) IBOutlet KKPaddingLabel *goodsPicsNumLB;


@property (weak, nonatomic) IBOutlet UILabel *contentLB;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLB;


@end

@implementation XMFGoodsDetailCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codea
    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

    
    //给cell切圆角
    [self xw_roundedCornerWithCornerRadii:CGSizeMake(4, 4) cornerColor:self.backgroundColor corners:UIRectCornerAllCorners borderColor:UIColorFromRGB(0xE4E4E4) borderWidth:1.f];
    
    //以下三行代码防止图片变形
    self.goodsImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.goodsImgView.autoresizesSubviews = YES;
    
    self.goodsImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.avatarImgView cornerWithRadius:self.avatarImgView.height/2.0];
    
}

/** 商品详情的评论model */

-(void)setCommentModel:(XMFGoodsCommentModel *)commentModel{
    
    _commentModel = commentModel;
    
    
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[commentModel.picUrls firstObject][@"image"]] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsPicsNumLB.text = [NSString stringWithFormat:@"%zd",commentModel.picUrls.count];
    
    self.contentLB.text = [NSString stringWithFormat:@"%@\n",commentModel.content];
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.userIcon] placeholderImage:[UIImage imageNamed:@"icon_me_touxiang"]];
    
    self.nickNameLB.text = commentModel.userName;
    
}



/*
-(void)setCommentModel:(XMFHomeGoodsDetailGoodsCommentsModel *)commentModel{
    
    _commentModel = commentModel;
    
    
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[commentModel.picUrls firstObject][@"image"]] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsPicsNumLB.text = [NSString stringWithFormat:@"%zd",commentModel.picUrls.count];
    
    self.contentLB.text = commentModel.content;
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.userIcon] placeholderImage:[UIImage imageNamed:@"icon_me_touxiang"]];
    
    self.nickNameLB.text = commentModel.userName;
    
}*/

/** 评论列表的model */
-(void)setCommentListModel:(XMFGoodsCommentModel *)commentListModel{
    
    
    _commentListModel = commentListModel;
    
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[commentListModel.picUrls firstObject][@"image"]] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsPicsNumLB.text = [NSString stringWithFormat:@"%zd",commentListModel.picUrls.count];
    
    self.contentLB.text = [NSString stringWithFormat:@"%@\n",commentListModel.content];
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:commentListModel.userIcon] placeholderImage:[UIImage imageNamed:@"icon_me_touxiang"]];
    
    self.nickNameLB.text = commentListModel.userName;
    
}

@end
