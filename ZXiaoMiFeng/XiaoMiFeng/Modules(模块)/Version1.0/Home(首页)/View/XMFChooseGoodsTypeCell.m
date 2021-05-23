//
//  XMFChooseGoodsTypeCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFChooseGoodsTypeCell.h"
#import "XMFGoodsDetailValueListModel.h"


@implementation XMFChooseGoodsTypeCell


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
    
    [standardBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
    
    standardBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    
    
    [standardBtn setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_guige"] forState:UIControlStateNormal];
    
    [standardBtn setBackgroundImage:[UIImage imageNamed:@"shoppingcart_btn_guige_sel"] forState:UIControlStateSelected];
    
    [standardBtn addTarget:self action:@selector(buttonsOnViewDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:standardBtn];
    
    
    self.standardBtn = standardBtn;
    
    
    [self.standardBtn setTitle:@"500ml" forState:UIControlStateNormal];
    
}


-(void)buttonsOnViewDidClick:(UIButton *)button{
    
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFChooseGoodsTypeCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFChooseGoodsTypeCellDidClick:self button:button];
    }
   
    
}


-(void)setValueModel:(XMFGoodsDetailValueListModel *)valueModel{
    
    _valueModel = valueModel;
    
    [self.standardBtn setTitle:valueModel.value forState:UIControlStateNormal];
    
    self.standardBtn.frame = CGRectMake(0, 0, [NSString SG_widthWithString:valueModel.value font:self.standardBtn.titleLabel.font] + 20, self.height);
    
    
}


-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    self.standardBtn.selected = selected;
    
}

@end
