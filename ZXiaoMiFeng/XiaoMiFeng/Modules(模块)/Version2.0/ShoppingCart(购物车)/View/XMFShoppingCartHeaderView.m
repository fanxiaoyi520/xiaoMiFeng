//
//  XMFShoppingCartHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingCartHeaderView.h"
#import "XMFShoppingCartCellModel.h"//购物车的总model


//在.m文件中添加
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
    
    //仓库
    self.warehouseLB.text = goodsInfoModel.warehouseName;
    
    self.switchBtn.selected = goodsInfoModel.isfolded;
    
    NSMutableArray *selectedGoodsArr = [[NSMutableArray alloc]init];
    
    for (XMFShoppingCartCellGoodsModel *goodsModel in goodsInfoModel.cartGoodsRespVos) {
        
        if ([goodsModel.checked boolValue]) {
            
            [selectedGoodsArr addObject:goodsModel];
            
        }
    }
    
    
    //选中按钮
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
        //蜜蜂海淘
        
        //展开收起
//        self.switchBtn.selected = cartModel.isFirstFolded;
        
        self.switchBtn.selected = self.isFirstFolded;

        
        for (XMFShoppingCartCellGoodsModel *goodsModel in self.cartModel.ccGoods) {
            
            if ([goodsModel.checked boolValue]) {
                
                [selectedGoodsArr addObject:goodsModel];
                
            }
            
        }
        

        //选中按钮
        if (selectedGoodsArr.count == self.cartModel.ccGoods.count) {
            
            self.selectBtn.selected = YES;
            
        }else{
            
            self.selectBtn.selected = NO;

        }
        
        
    }else if (self.selectedIndexPath.section == 1){
        //蜜蜂国际
        
        
        //展开收起
//        self.switchBtn.selected = cartModel.isSecondFolded;
        self.switchBtn.selected = self.isSecondFolded;

        
        for (XMFShoppingCartCellGoodsModel *goodsModel in self.cartModel.bcGoods) {
            
            if ([goodsModel.checked boolValue]) {
                
                [selectedGoodsArr addObject:goodsModel];
                
            }
            
        }
        
        
        //选中按钮
        if (selectedGoodsArr.count == self.cartModel.bcGoods.count) {
            
            
            self.selectBtn.selected = YES;
            
        }else{
            
            self.selectBtn.selected = NO;
            
        }
        
        
        
    }*/
     
    
}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingCartHeaderViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFShoppingCartHeaderViewDidClick:self button:sender];
    }
    
}





@end
