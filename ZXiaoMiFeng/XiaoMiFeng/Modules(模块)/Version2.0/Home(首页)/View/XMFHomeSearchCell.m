//
//  XMFHomeSearchCell.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeSearchCell.h"

//在.m文件中添加
@interface  XMFHomeSearchCell()

@property (weak, nonatomic) IBOutlet KKPaddingLabel *keywordLB;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keywordLBRightSpace;


@property (weak, nonatomic) IBOutlet UIButton *switchBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchBtnWidth;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchBtnLeftSpace;




@end

@implementation XMFHomeSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //获取历史数据
     NSArray *historyArr = [GlobalManager getSearchHistoryArrayFromLocal];
    
    if (self.indexPath.section == 0 && self.indexPath.item == 7 && historyArr.count > 8) {
        
     
        self.keywordLBRightSpace.constant = 40.f;
        
        
    }else{
        
        
        self.keywordLBRightSpace.constant = 0.f;
        
    }
    
    
    
}

-(void)setKeywordStr:(NSString *)keywordStr{
    
    _keywordStr = keywordStr;
    
    
    self.keywordLB.text = keywordStr;
    
    
}


//页面的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFHomeSearchCellDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFHomeSearchCellDidClick:self button:sender];
    }
    
}


/*
-(void)setIndexPath:(NSIndexPath *)indexPath{
    
    _indexPath = indexPath;
    
    if (indexPath.section == 0 && indexPath.item == 7) {
        
        self.switchBtn.hidden = NO;
        
        self.switchBtn.width = 30.f;
        
        self.switchBtnLeftSpace.constant = 10.f;
        
    }else{
        
        self.switchBtn.hidden = YES;
        
        self.switchBtn.width = 0.f;
        
        self.switchBtnLeftSpace.constant = 0.f;
    }
    
}*/

-(void)setIsSelectedBtn:(BOOL)isSelectedBtn{
    
    _isSelectedBtn = isSelectedBtn;
    
    self.switchBtn.selected = isSelectedBtn;
    
}


@end
