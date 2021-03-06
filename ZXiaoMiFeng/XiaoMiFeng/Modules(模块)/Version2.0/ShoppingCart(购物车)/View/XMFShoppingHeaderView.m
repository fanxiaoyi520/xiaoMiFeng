//
//  XMFShoppingHeaderView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2021/1/29.
//  Copyright Â© 2021 ðå°èèð. All rights reserved.
//

#import "XMFShoppingHeaderView.h"
#import "XMFShoppingCartCellModel.h"//è´­ç©è½¦çæ»model


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFShoppingHeaderView()

/** ååæ°é */
@property (weak, nonatomic) IBOutlet UILabel *goodsAmountLB;


@end

@implementation XMFShoppingHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


//èèæµ·æ·-cc
-(void)setOverseaModel:(XMFShoppingCartCellModel *)overseaModel{
    
    _overseaModel = overseaModel;
    
    //å¾ªç¯æ¾åºååä¸ªæ°
    NSInteger goodsAmount = 0;
    
    for (XMFShoppingCartCellGoodsInfoModel *goodsInfoModel in overseaModel.ccGoodsInfos) {
 
        goodsAmount += goodsInfoModel.cartGoodsRespVos.count;
    }
    
    
    self.goodsAmountLB.text = [NSString stringWithFormat:@"å±%zdä»¶åå",goodsAmount];
    
}


/**èèå½é-bc è´­ç©è½¦æ»model */
-(void)setInternationalModel:(XMFShoppingCartCellModel *)internationalModel{
    
    _internationalModel = internationalModel;
    
    //å¾ªç¯æ¾åºååä¸ªæ°
    NSInteger goodsAmount = 0;
    
    for (XMFShoppingCartCellGoodsInfoModel *goodsInfoModel in internationalModel.bcGoodsInfos) {
 
        goodsAmount += goodsInfoModel.cartGoodsRespVos.count;
    }
    

    self.goodsAmountLB.text = [NSString stringWithFormat:@"å±%zdä»¶åå(ä¸åä»éåå¼ç»ç®)",goodsAmount];
    
    
}

@end
