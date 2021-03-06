//
//  XMFOrderConfirmFooterView.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/30.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFOrderConfirmFooterView.h"
#import "XMFOrderConfirmModel.h"

//ๅจ.mๆไปถไธญๆทปๅ 
@interface  XMFOrderConfirmFooterView()<UITextViewDelegate>

//ๅๅๅ่ฎก
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalMoneyLB;

//่ฟ่ดน
@property (weak, nonatomic) IBOutlet UILabel *postageLB;

//็จ่ดน
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
    
//    self.messageTxW.wzb_placeholder = XMFLI(@"้ๅกซ");
    
    self.messageTxW.zw_placeHolder = XMFLI(@"้ๅกซ");
    
    self.messageTxW.delegate = self;
    
}


-(void)setFooterModel:(XMFOrderConfirmModel *)footerModel{
    
    _footerModel = footerModel;
    
    self.goodsTotalMoneyLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footerModel.goodsTotalPrice]];
    
    self.postageLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footerModel.freightPrice]];
    
    self.taxesLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footerModel.tariffPrice]];
    
    self.orderTotalMoneyLB.text = [NSString stringWithFormat:@"HK$%@",[NSString removeSuffix:footerModel.orderTotalPrice]];
    
    
}


#pragma mark - โโโโโโโ UITextView็ไปฃ็ๆนๆณ โโโโโโโโ

-(void)textViewDidChange:(UITextView *)textView{
    
    
    NSInteger maxLength = 70;
    
    HWTitleInfo title = [textView.text getInfoWithTextMaxLength:maxLength];
    
    if (title.length > maxLength) {
        
        textView.text = [textView.text substringToIndex:title.number];
        
        [textView resignFirstResponder];
        
        [MBProgressHUD showOnlyTextToView:kAppWindow title:@"ๆๅคๅช่ฝ่พๅฅ70ไธชๅญ็ฌฆ"];
        
    }
    
    
}

@end
