//
//  XMFGoodsDetailFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailFooterView.h"
#import "XMFGoodsDatailModel.h"//商品详情model


//在.m文件中添加
@interface  XMFGoodsDetailFooterView()

//客服
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;

//收藏
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;


@end


@implementation XMFGoodsDetailFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self.serviceBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:3];
    
    [self.collectBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:3];
    
}

-(void)setDetailModel:(XMFGoodsDatailModel *)detailModel{
    
    _detailModel = detailModel;
    
    self.collectBtn.selected = [detailModel.userHasCollect boolValue];
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(buttonsOnXMFGoodsDetailFooterViewDidClick:button:)]) {
        
        [self.delegate buttonsOnXMFGoodsDetailFooterViewDidClick:self button:sender];
    }
    
    
}



@end
