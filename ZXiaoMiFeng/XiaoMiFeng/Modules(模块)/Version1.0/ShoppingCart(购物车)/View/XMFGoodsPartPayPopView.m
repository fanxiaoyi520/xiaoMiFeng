//
//  XMFGoodsPartPayPopView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsPartPayPopView.h"
#import "XMFShopCartModel.h"//购物车多层级model


//在.m文件中添加
@interface  XMFGoodsPartPayPopView()

/**
 *  按钮选中,中间值
 */
@property (nonatomic,strong) UIButton *selectedBtn;


@end

@implementation XMFGoodsPartPayPopView

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
    
    [self.bgView cornerWithRadius:10.f];
    
    
}


-(void)setSelectedGoodsArr:(NSMutableArray *)selectedGoodsArr{
    
    _selectedGoodsArr = selectedGoodsArr;
    
    /**
    shipmentRegion=0 国内自营商品
    shipmentRegion=1 海外自营商品
    shipmentRegion=11 海外奶粉专区
    
    */
    
    NSString *shipmentRegionStr;
    
    for (int i = 0; i < selectedGoodsArr.count; ++i) {
        
        NSMutableArray<XMFShopCartDetailModel *> *arr = selectedGoodsArr[i];
    
        NSMutableArray<XMFShopCartDetailModel *> *firstArr = selectedGoodsArr[0];
        
        //保存数组第一个的地区
        shipmentRegionStr = firstArr[0].shipmentRegion;
        
        if (arr.count > 0 && [arr[0].shipmentRegion isEqualToString:@"1"]) {
            
            
            //tag保存数组位置，以便购车获取数组
            self.abroadGoodsBtn.tag = i;
            
            [self.abroadGoodsBtn  setTitle:[NSString stringWithFormat:@"    海外自营商品%@件",self.selectedGoodsCountArr[i]] forState:UIControlStateNormal];
            
            self.abroadGoodsBtn.hidden = NO;
            
            self.abroadGoodsBtnHeight.constant = 38.f;
            
        }else if (arr.count > 0 && [arr[0].shipmentRegion isEqualToString:@"0"]){
   
            
            //tag保存数组位置，以便购车获取数组
            self.inlandBtn.tag = i;
            
            [self.inlandBtn  setTitle:[NSString stringWithFormat:@"    国内自营商品%@件",self.selectedGoodsCountArr[i]] forState:UIControlStateNormal];
            
            self.inlandBtn.hidden = NO;
            
            self.inlandBtnHeight.constant = 38.f;
            
        }else if (arr.count > 0 && [arr[0].shipmentRegion isEqualToString:@"11"]){
          
            //tag保存数组位置，以便购车获取数组
            self.milkGoodsBtn.tag = i;
            
            [self.milkGoodsBtn  setTitle:[NSString stringWithFormat:@"    海外奶粉专区%@件",self.selectedGoodsCountArr[i]] forState:UIControlStateNormal];
            
            self.milkGoodsBtn.hidden = NO;
            
            self.milkGoodsBtnHeight.constant = 38.f;
            
        }
        
    }
    
    
    /**
       shipmentRegion=0 国内自营商品
       shipmentRegion=1 海外自营商品
       shipmentRegion=11 海外奶粉专区
       
       */
    
    if ([shipmentRegionStr isEqualToString:@"0"]) {
        
        self.inlandBtn.selected = YES;
        
        self.selectedBtn = self.inlandBtn;
        
    }else if ([shipmentRegionStr isEqualToString:@"1"]){
        
        self.abroadGoodsBtn.selected = YES;
        
        self.selectedBtn = self.abroadGoodsBtn;
        
        
    }else if ([shipmentRegionStr isEqualToString:@"11"]){
        
        self.milkGoodsBtn.selected = YES;
        
        self.selectedBtn = self.milkGoodsBtn;
        
    }
    
    
}


//显示在整个界面上
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.frame = [UIScreen mainScreen].bounds;
        [keyWindow addSubview:self];
        
    }];
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        //海外、国内、奶粉tag不定
        case 0:
        case 1:
        case 2:{
            
            if (sender!= self.selectedBtn) {
                
                self.selectedBtn.selected = NO;
               
                sender.selected = YES;
                
                self.selectedBtn = sender;
                
            }else{
                
                self.selectedBtn.selected = YES;
                
            }
            
        }
            break;
        case 3:{//回购物车
            
            [self hide];
        }
            break;
        case 4:{//去结算
            
            if (!self.selectedBtn.selected) {
                
                [MBProgressHUD showError:@"请选择结算的商品" toView:kAppWindow];
                
                return;
            }
            
            
            [self hide];
            
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsPartPayPopViewDidClick:selectedButton:)]) {
                
                [self.delegate buttonsOnXMFGoodsPartPayPopViewDidClick:self selectedButton:self.selectedBtn];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}


@end
