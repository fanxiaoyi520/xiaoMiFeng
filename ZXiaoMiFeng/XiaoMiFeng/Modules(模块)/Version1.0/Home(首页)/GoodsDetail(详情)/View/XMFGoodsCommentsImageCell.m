//
//  XMFGoodsCommentsImageCell.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/11.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFGoodsCommentsImageCell.h"

//ๅจ.mๆไปถไธญๆทปๅ 
@interface  XMFGoodsCommentsImageCell()

@property (nonatomic, strong) UIImageView *commentImageView;

@end

@implementation XMFGoodsCommentsImageCell


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}


//ๅธๅฑUI
-(void)setupUI{
    
    self.commentImageView = [[UIImageView alloc]init];
    
    [self.contentView addSubview:self.commentImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    self.commentImageView.userInteractionEnabled = YES;
    
    [self.commentImageView addGestureRecognizer:tap];
    
    [self.commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
    
    
}

//ๆๅฟ็ปๅฎ็ๆนๆณ
-(void)tapAction:(UIGestureRecognizer *)tap{
    
    UIImageView *tapView = (UIImageView *)tap.view;
    
    if (_commentsImageViewBlock) {
        _commentsImageViewBlock(tapView);
    }
    
}

-(void)setImageNameStr:(NSString *)imageNameStr{
    
    _imageNameStr = imageNameStr;
    
    
    [self.commentImageView sd_setImageWithURL:[NSURL URLWithString:imageNameStr] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    
}

@end
