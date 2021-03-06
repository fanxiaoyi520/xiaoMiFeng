//
//  XMFChooseGoodsTypeHeaderView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/27.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFChooseGoodsTypeHeaderView.h"

@implementation XMFChooseGoodsTypeHeaderView

//้ๅinitๆนๆณ
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupUI];
        
    }
    
    return self;
}


//่ฎพ็ฝฎUI
-(void)setupUI{
    
    UILabel *standardLB = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, KScreenWidth - 30, self.height)];
    
    standardLB.font = [UIFont systemFontOfSize:15.0f];
    
    standardLB.textAlignment = NSTextAlignmentLeft;
   
    standardLB.backgroundColor = [UIColor whiteColor];
    
    standardLB.textColor = UIColorFromRGB(0x333333);
    
    [self addSubview:standardLB];
    
    self.standardLB = standardLB;
    
    
}

@end
