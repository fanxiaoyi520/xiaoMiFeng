//
//  XMFShoppingCartHeaderView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/22.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFShoppingCartHeaderView.h"
#import "XMFShoppingCartCellModel.h"//è´­ç©è½¦çæ»model


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFShoppingCartHeaderView()





@end

@implementation XMFShoppingCartHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
}


-(void)setGoodsInfoModel:(XMFShoppingCartCellGoodsInfoModel *)goodsInfoModel{
    
    _goodsInfoModel = goodsInfoModel;
    
    //ä»åº
    self.warehouseLB.text = goodsInfoModel.warehouseName;
    
    self.switchBtn.selected = goodsInfoModel.isfolded;
    
    NSMutableArray *selectedGoodsArr = [[NSMutableArray alloc]init];
    
    for (XMFShoppingCartCellGoodsModel *goodsModel in goodsInfoModel.cartGoodsRespVos) {
        
        if ([goodsModel.checked boolValue]) {
            
            [selectedGoodsArr addObject:goodsModel];
            
        }
    }
    
    
    //éä¸­æé®
    if (selectedGoodsArr.count == goodsInfoModel.cartGoodsRespVos.count) {
        
        self.selectBtn.selected = YES;
        
        
    }else{
        
        self.selectBtn.selected = NO;

    }
    
}

-(void)setCartModel:(XMFShoppingCartCellModel *)cartModel{
    
    _cartModel = cartModel;
    
    NSMutableArray *selectedGoodsArr = [[NSMutableArray alloc]init];
    

    
    /*
    if (self.selectedIndexPath.section == 0) {
        //èèæµ·æ·
        
        //å±å¼æ¶èµ·
//        self.switchBtn.selected = cartModel.isFirstFolded;
        
        self.switchBtn.selected = self.isFirstFolded;

        
        for (XMFShoppingCartCellGoodsModel *goodsModel in self.cartModel.ccGoods) {
            
            if ([goodsModel.checked boolValue]) {
                
                [selectedGoodsArr addObject:goodsModel];
                
            }
            
        }
        

        //éä¸­æé®
        if (selectedGoodsArr.count == self.cartModel.ccGoods.count) {
            
            self.selectBtn.selected = YES;
            
        }else{
            
            self.selectBtn.selected = NO;

        }
        
        
    }else if (self.selectedIndexPath.section == 1){
        //èèå½é
        
        
        //å±å¼æ¶èµ·
//        self.switchBtn.selected = cartModel.isSecondFolded;
        self.switchBtn.selected = self.isSecondFolded;

        
        for (XMFShoppingCartCellGoodsModel *goodsModel in self.cartModel.bcGoods) {
            
            if ([goodsModel.checked boolValue]) {
                
                [selectedGoodsArr addObject:goodsModel];
                
            }
            
        }
        
        
        //éä¸­æé®
        if (selectedGoodsArr.count == self.cartModel.bcGoods.count) {
            
            
            self.selectBtn.selected = YES;
            
        }else{
            
            self.selectBtn.selected = NO;
            
        }
        
        
        
    }*/
     
    
}



//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingCartHeaderViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFShoppingCartHeaderViewDidClick:self button:sender];
    }
    
}





@end
