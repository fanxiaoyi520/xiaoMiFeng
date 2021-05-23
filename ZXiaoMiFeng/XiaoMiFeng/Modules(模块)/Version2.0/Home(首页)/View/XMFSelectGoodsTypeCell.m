//
//  XMFSelectGoodsTypeCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSelectGoodsTypeCell.h"
#import "XMFHomeGoodsPropertyModel.h"//规格总model
#import "XMFGoodsSpecInfoModel.h"//2.1商品规格总model


@implementation XMFSelectGoodsTypeCell

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

//UI布局
-(void)setupUI{

    UIButton *standardBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [standardBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateSelected];
    
    [standardBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    
    standardBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    
    
    [standardBtn setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_guige"] forState:UIControlStateNormal];
    
    [standardBtn setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_guige_sel"] forState:UIControlStateSelected];
    
    [standardBtn addTarget:self action:@selector(buttonsOnViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:standardBtn];
    
    
    self.standardBtn = standardBtn;
    
    
    [self.standardBtn setTitle:@"-" forState:UIControlStateNormal];
    
}

//页面上按钮被点击
-(void)buttonsOnViewDidClick:(UIButton *)button{
    
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFSelectGoodsTypeCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFSelectGoodsTypeCellDidClick:self button:button];
    }
   
    
}



//重写set方法
-(void)setSpecivaluewsModel:(XMFHomeGoodsPropertySpecificationsValuesModel *)specivaluewsModel{
    
    _specivaluewsModel = specivaluewsModel;
    
    [self.standardBtn setTitle:specivaluewsModel.value forState:UIControlStateNormal];
    
    self.standardBtn.frame = CGRectMake(0, 0, [NSString SG_widthWithString:specivaluewsModel.value font:self.standardBtn.titleLabel.font] + 20, self.height);
    
    
}


-(void)setSpecValuesModel:(XMFGoodsSpecInfoSpecValuesModel *)specValuesModel{
    
    
    _specValuesModel = specValuesModel;
    

    self.standardBtn.enabled = specValuesModel.enable;
    
    
    if (specValuesModel.enable) {
       
        //可以点击
        [self.standardBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        
        self.standardBtn.selected = specValuesModel.isSelected;
        
    }else{
        
        //不可点击
        [self.standardBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
        
        self.standardBtn.selected = NO;

    }
    
    
}


-(void)setFastFindNodeModel:(XMFGoodsSpecInfoFastFindNodeModel *)fastFindNodeModel{
    
    _fastFindNodeModel = fastFindNodeModel;
    
    
    [self.standardBtn setTitle:fastFindNodeModel.value forState:UIControlStateNormal];
    
    self.standardBtn.frame = CGRectMake(0, 0, [NSString SG_widthWithString:fastFindNodeModel.value font:self.standardBtn.titleLabel.font] + 20, self.height);
    
}


-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
//    self.standardBtn.selected = selected;
    
    if (self.specValuesModel.enable) {
        
        self.standardBtn.selected = selected;
        
        
    }else{
        
        self.standardBtn.selected = NO;
    }
    
}



@end
