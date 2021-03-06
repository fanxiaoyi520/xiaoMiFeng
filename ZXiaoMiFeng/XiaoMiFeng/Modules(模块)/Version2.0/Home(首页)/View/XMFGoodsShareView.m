//
//  XMFGoodsShareView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/26.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFGoodsShareView.h"
#import "XMFHomeGoodsDetailModel.h"//ååè¯¦æçæ»model


//å¨.mæä»¶ä¸­æ·»å 
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
    
    //è³å°0.5ç§åè§¦å
    longPressGesture.minimumPressDuration = 0.5;
    
//    self.QRImgView.userInteractionEnabled = YES;
    
    [self.screenshotBgView addGestureRecognizer:longPressGesture];
    
    
 
    
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.bgView cornerWithRadius:10.f direction:CornerDirectionTypeTopLeft | UIRectCornerTopRight];
    
    [self.shareBtn cornerWithRadius:4.f];
    
}


//æ¾ç¤ºå¨æ´ä¸ªçé¢ä¸
-(void)show{
    
    //å¯ä»¥åºé¨å¼¹åº
    [UIView animateWithDuration:0.3 animations:^{
        
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
           self.frame = [UIScreen mainScreen].bounds;
           [keyWindow addSubview:self];
        
        
        self.bgView.centerY = self.bgView.centerY - CGRectGetHeight(self.bgView.frame);

        
    } completion:^(BOOL finished) {
        
       
        
    }];
    
}

//éèå¼¹æ¡
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.centerY = self.bgView.centerY+CGRectGetHeight(self.bgView.frame);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}



//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 0:{//å³é­
            
            [self hide];
            
        }
            break;
             
        case 1:{//åäº«
            
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




//éèå¼¹æ¡
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //å¤æ­ç¹å»çç¹æ¯å¦å¨æä¸ªåºåèå´å
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
 
    
}


#pragma marké¿ææå¿
-(void)longPressToDo:(UILongPressGestureRecognizer*)gesture{
    
    //ç´æ¥returnæï¼ä¸å¨å¼å§çç¶æéé¢æ·»å ä»»ä½æä½ï¼åé¿ææå¿å°±ä¼è¢«å°è°ç¨ä¸æ¬¡äº
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
    
    //å®ä»·
    self.priceLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:self.priceLB.textColor upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:14.f] lowerStr:[NSString removeSuffix:detailModel.retailPrice] lowerColor:self.priceLB.textColor lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:24.f]];
    
    //åä»·
    self.orginPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:detailModel.counterPrice]]];
     
     //çæäºç»´ç 
    self.QRImgView.image = [SGQRCodeObtain generateQRCodeWithData:detailModel.shareUrl size:self.QRImgView.height];
    
}


-(void)setTipsStr:(NSString *)tipsStr{
    
    _tipsStr = tipsStr;
    
    self.tipsLB.text = tipsStr;
    
}


@end
