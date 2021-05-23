//
//  XMFConfirmOrderFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFConfirmOrderFooterView.h"
#import "XMFConfirmOrderModel.h"//订单确认总model


//在.m文件中添加
@interface  XMFConfirmOrderFooterView()<UITextViewDelegate>

/** 商品合计 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalMoneyLB;

/** 税费 */
@property (weak, nonatomic) IBOutlet UILabel *taxesLB;

/** 运费 */
@property (weak, nonatomic) IBOutlet UILabel *postageFeeLB;


/** 其他优惠 */

@property (weak, nonatomic) IBOutlet UIView *discountBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discountBgViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *discountLB;

/** 商城优惠 */

@property (weak, nonatomic) IBOutlet UIView *mallDiscountBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mallDiscountBgViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *mallDiscountLB;


/** 订单合计 */
@property (weak, nonatomic) IBOutlet UILabel *orderTotalMoneyLB;


@end

@implementation XMFConfirmOrderFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
    self.messageTxW.zw_placeHolder = XMFLI(@"选填");
    
    self.messageTxW.delegate = self;
    
    
    [self.messageTxW setValue:@70 forKey:@"LimitInput"];
    
}


-(void)setOrderModel:(XMFConfirmOrderModel *)orderModel{
    
    _orderModel = orderModel;
    
    //更新View的frame值才有效，使用layoutSubviews无效
    
    CGRect tempFrame = self.frame;
        
   
    CGFloat bgViewHeight = 32.f;
    
    
    self.goodsTotalMoneyLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:orderModel.goodsTotalPrice]];
    
    self.taxesLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:orderModel.taxTotalPrice]];
    

    self.postageFeeLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:orderModel.postageTotalPrice]];
    
    //其他优惠
    
    if ([orderModel.reducePrice doubleValue] > 0) {
        
        self.discountLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:orderModel.reducePrice]];

        self.discountBgView.hidden = NO;
        
        self.discountBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        
        self.discountBgView.hidden = YES;
        
        self.discountBgViewHeight.constant = 0.f;
        
        tempFrame.size.height -= bgViewHeight;
    }
    
    
    //商城优惠
    NSString *otherDiscountStr = [NSString string];
    
    if ([orderModel.otherDiscount doubleValue] > 0) {
        
        otherDiscountStr = @"-";
        
        self.mallDiscountLB.text = [NSString stringWithFormat:@"%@HK$ %@",otherDiscountStr,[NSString removeSuffix:orderModel.otherDiscount]];
        
        self.mallDiscountBgView.hidden = NO;
        
        self.mallDiscountBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        otherDiscountStr = @"";
        
        self.mallDiscountBgView.hidden = YES;
        
        self.mallDiscountBgViewHeight.constant = 0.f;
        
        tempFrame.size.height -= bgViewHeight;

    }
    
    
    self.orderTotalMoneyLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:orderModel.totalPrice]];
    
    self.frame = tempFrame;

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
