//
//  XMFGoodsShareQRView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsShareQRView.h"
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDatailInfoModel.h"//商品信息model

//在.m文件中添加
@interface  XMFGoodsShareQRView()

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;


@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLB;


@property (weak, nonatomic) IBOutlet UIImageView *goodsQRImgView;






@end


@implementation XMFGoodsShareQRView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //以下三行代码防止图片变形
    self.coverImgView.contentMode = UIViewContentModeScaleAspectFit;

    self.coverImgView.autoresizesSubviews = YES;

    self.coverImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
}

-(void)setDetailModel:(XMFGoodsDatailModel *)detailModel{
    
    _detailModel = detailModel;
    
    self.goodsNameLB.text = detailModel.info.name;
    
    self.goodsPriceLB.text = [NSString stringWithFormat:@"售价：HK$%@",[NSString removeSuffix:detailModel.info.retailPrice]];
    
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:detailModel.info.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    //拼接商品链接
    NSString *shareGoodsURL = [NSString stringWithFormat:@"%@/client#/product/%@",XMF_BASE_URL,detailModel.info.goodsId];
    
    //生成二维码
    self.goodsQRImgView.image = [SGQRCodeObtain generateQRCodeWithData:shareGoodsURL size:self.goodsQRImgView.height];
    
}


//显示在整个界面上
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.frame = [UIScreen mainScreen].bounds;
        [keyWindow addSubview:self];
        
//         [[[[UIApplication sharedApplication] windows] lastObject] addSubview:self];
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

//点击手势隐藏
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
}


- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    [self hide];
}


@end
