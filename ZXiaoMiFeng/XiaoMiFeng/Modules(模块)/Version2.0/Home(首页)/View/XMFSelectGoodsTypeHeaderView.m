//
//  XMFSelectGoodsTypeHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSelectGoodsTypeHeaderView.h"

@implementation XMFSelectGoodsTypeHeaderView

//重写init方法
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}


//设置UI
-(void)setupUI{
    
    UILabel *standardLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, self.height)];
    
    standardLB.font = [UIFont systemFontOfSize:15.0f];
    
    standardLB.textAlignment = NSTextAlignmentLeft;
   
    standardLB.backgroundColor = [UIColor whiteColor];
    
    standardLB.textColor = UIColorFromRGB(0x333333);
    
    [self addSubview:standardLB];
    
    self.standardLB = standardLB;
    
    
}

@end
