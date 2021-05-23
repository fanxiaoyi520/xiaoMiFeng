//
//  XMFChooseGoodsTypeFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFChooseGoodsTypeFooterView.h"

@implementation XMFChooseGoodsTypeFooterView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}


//布局
-(void)setupUI{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.width - 15 - 15, 1.f)];
    
    lineView.backgroundColor = UIColorFromRGB(0xDCDCDC);
    
    [self addSubview:lineView];
    
    self.lineView = lineView;
    
    
}

@end
