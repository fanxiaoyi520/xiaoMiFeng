//
//  XMFOrderConfirmFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderConfirmFooterView.h"
#import "XMFOrderConfirmModel.h"

//在.m文件中添加
@interface  XMFOrderConfirmFooterView()<UITextViewDelegate>

//商品合计
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalMoneyLB;

//运费
@property (weak, nonatomic) IBOutlet UILabel *postageLB;

//税费
@property (weak, nonatomic) IBOutlet UILabel *taxesLB;


@property (weak, nonatomic) IBOutlet UILabel *orderTotalMoneyLB;



@end

@implementation XMFOrderConfirmFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
//    self.messageTxW.wzb_placeholder = XMFLI(@"选填");
    
    self.messageTxW.zw_placeHolder = XMFLI(@"选填");
    
    self.messageTxW.delegate = self;
    
}


-(void)setFooterModel:(XMFOrderConfirmModel *)footerModel{
    
    _footerModel = footerModel;
    
    self.goodsTotalMoneyLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footerModel.goodsTotalPrice]];
    
    self.postageLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footerModel.freightPrice]];
    
    self.taxesLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footerModel.tariffPrice]];
    
    self.orderTotalMoneyLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footerModel.orderTotalPrice]];
    
    
}


#pragma mark - ——————— UITextView的代理方法 ————————

-(void)textViewDidChange:(UITextView *)textView{
    
    
    NSInteger maxLength = 70;
    
    HWTitleInfo title = [textView.text getInfoWithTextMaxLength:maxLength];
    
    if (title.length > maxLength) {
        
        textView.text = [textView.text substringToIndex:title.number];
        
        [textView resignFirstResponder];
        
        [MBProgressHUD showOnlyTextToView:kAppWindow title:@"最多只能输入70个字符"];
        
    }
    
    
}

@end
