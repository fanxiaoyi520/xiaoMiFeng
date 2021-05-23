//
//  XMFSelectGoodsTypeFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSelectGoodsTypeFooterView.h"

@implementation XMFSelectGoodsTypeFooterView


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}


//布局
-(void)setupUI{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, self.width - 20 - 20, 1.f)];
    
    lineView.backgroundColor = UIColorFromRGB(0xDCDCDC);
    
    [self addSubview:lineView];
    
    self.lineView = lineView;
    
    
}



@end
