//
//  XMFGoodsShareView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsShareView.h"
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model


//在.m文件中添加
@interface  XMFGoodsShareView()



@property (weak, nonatomic) IBOutlet UIImageView *goodsImgViw;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

@property (weak, nonatomic) IBOutlet UILabel *priceLB;


@property (weak, nonatomic) IBOutlet UILabel *orginPriceLB;


@property (weak, nonatomic) IBOutlet UIImageView *QRImgView;


@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@end

@implementation XMFGoodsShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.7);
    
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressToDo:)];
    
    //至少0.5秒后触发
    longPressGesture.minimumPressDuration = 0.5;
    
//    self.QRImgView.userInteractionEnabled = YES;
    
    [self.screenshotBgView addGestureRecognizer:longPressGesture];
    
    
 
    
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.bgView cornerWithRadius:10.f direction:CornerDirectionTypeTopLeft | UIRectCornerTopRight];
    
    [self.shareBtn cornerWithRadius:4.f];
    
}


//显示在整个界面上
-(void)show{
    
    //可以底部弹出
    [UIView animateWithDuration:0.3 animations:^{
        
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
           self.frame = [UIScreen mainScreen].bounds;
           [keyWindow addSubview:self];
        
        
        self.bgView.centerY = self.bgView.centerY - CGRectGetHeight(self.bgView.frame);

        
    } completion:^(BOOL finished) {
        
       
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.centerY = self.bgView.centerY+CGRectGetHeight(self.bgView.frame);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 0:{//关闭
            
            [self hide];
            
        }
            break;
             
        case 1:{//分享
            
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsShareViewDidClick:button:)]) {
                
                [self.delegate buttonsOnXMFGoodsShareViewDidClick:self button:sender];
            }
            
            [self hide];
            
        }
            break;
            
        default:
            break;
    }
    
}




//隐藏弹框
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
 
    
}


#pragma mark长按手势
-(void)longPressToDo:(UILongPressGestureRecognizer*)gesture{
    
    //直接return掉，不在开始的状态里面添加任何操作，则长按手势就会被少调用一次了
    if(gesture.state!=UIGestureRecognizerStateBegan){
        
        return;
    }
    
    
    
    if ([self.delegate respondsToSelector:@selector(viewsOnXMFGoodsShareViewDidLongPress:)]) {
        
        [self.delegate viewsOnXMFGoodsShareViewDidLongPress:self];
    }
}



-(void)setDetailModel:(XMFHomeGoodsDetailModel *)detailModel{
    
    _detailModel = detailModel;
    
    [self.goodsImgViw sd_setImageWithURL:[NSURL URLWithString:detailModel.picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = detailModel.goodsName;
    
//    self.priceLB.text = [NSString stringWithFormat:@"HK$ %@",detailModel.retailPrice];
    
    //售价
    self.priceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.priceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:14.f] lowerStr:[NSString removeSuffix:detailModel.retailPrice] lowerColor:self.priceLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:24.f]];
    
    //原价
    self.orginPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:detailModel.counterPrice]]];
     
     //生成二维码
    self.QRImgView.image = [SGQRCodeObtain generateQRCodeWithData:detailModel.shareUrl size:self.QRImgView.height];
    
}


-(void)setTipsStr:(NSString *)tipsStr{
    
    _tipsStr = tipsStr;
    
    self.tipsLB.text = tipsStr;
    
}


@end
