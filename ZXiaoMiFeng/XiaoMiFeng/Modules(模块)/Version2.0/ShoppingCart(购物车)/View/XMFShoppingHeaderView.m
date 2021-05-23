//
//  XMFShoppingHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/29.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingHeaderView.h"
#import "XMFShoppingCartCellModel.h"//购物车的总model


//在.m文件中添加
@interface  XMFShoppingHeaderView()

/** 商品数量 */
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


//蜜蜂海淘-cc
-(void)setOverseaModel:(XMFShoppingCartCellModel *)overseaModel{
    
    _overseaModel = overseaModel;
    
    //循环找出商品个数
    NSInteger goodsAmount = 0;
    
    for (XMFShoppingCartCellGoodsInfoModel *goodsInfoModel in overseaModel.ccGoodsInfos) {
 
        goodsAmount += goodsInfoModel.cartGoodsRespVos.count;
    }
    
    
    self.goodsAmountLB.text = [NSString stringWithFormat:@"共%zd件商品",goodsAmount];
    
}


/**蜜蜂国际-bc 购物车总model */
-(void)setInternationalModel:(XMFShoppingCartCellModel *)internationalModel{
    
    _internationalModel = internationalModel;
    
    //循环找出商品个数
    NSInteger goodsAmount = 0;
    
    for (XMFShoppingCartCellGoodsInfoModel *goodsInfoModel in internationalModel.bcGoodsInfos) {
 
        goodsAmount += goodsInfoModel.cartGoodsRespVos.count;
    }
    

    self.goodsAmountLB.text = [NSString stringWithFormat:@"共%zd件商品(不同仓需分开结算)",goodsAmount];
    
    
}

@end
