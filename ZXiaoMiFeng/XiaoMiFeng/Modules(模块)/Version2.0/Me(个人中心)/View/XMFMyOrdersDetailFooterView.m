//
//  XMFMyOrdersDetailFooterView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersDetailFooterView.h"
//#import "XMFMyOrdersDetailModel.h"//订单详情总model
#import "XMFMyOrdersListModel.h"//我的订单总model
#import "XMFOrderBarcodePopView.h"//防伪袋条码弹框


//在.m文件中添加
@interface  XMFMyOrdersDetailFooterView()

/** 金额背景view */
@property (weak, nonatomic) IBOutlet UIView *orderAmountBgView;


/** 商品总额 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTotalMoneyLB;

/** 税费 */
@property (weak, nonatomic) IBOutlet UILabel *taxesFeeLB;

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


/** 实付金额 */
@property (weak, nonatomic) IBOutlet UILabel *acAmountLB;


/** 订单信息背景view */
@property (weak, nonatomic) IBOutlet UIView *orderInfoBgView;



/** 订单编号 */
@property (weak, nonatomic) IBOutlet UIView *orderSnBgView;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderSnBgViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *orderSnLB;


@property (weak, nonatomic) IBOutlet UIButton *orderSnCopyBtn;


/** 支付方式 */
@property (weak, nonatomic) IBOutlet UIView *paymentBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paymentBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *paymentLB;


/** 物流公司 */
@property (weak, nonatomic) IBOutlet UIView *logisticsBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logisticsBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *logisticsLB;

/** 快递单号 */
@property (weak, nonatomic) IBOutlet UIView *expressNoBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expressNoBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *expressNoLB;

@property (weak, nonatomic) IBOutlet UIButton *expressNoCopyBtn;


/** 防伪袋条码 */
@property (weak, nonatomic) IBOutlet UIView *barcodeBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barcodeBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *barcodeLB;

@property (weak, nonatomic) IBOutlet UIButton *moreBarcodeBtn;


/** 下单时间 */
@property (weak, nonatomic) IBOutlet UIView *orderTimeBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTimeBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *orderTimeLB;

/** 发货时间 */
@property (weak, nonatomic) IBOutlet UIView *deliveryTimeBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deliveryTimeBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLB;

/** 订单来源 */
@property (weak, nonatomic) IBOutlet UIView *orderSourceBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderSourceBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *orderSourceLB;




@end

@implementation XMFMyOrdersDetailFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    
    [self.moreBarcodeBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:0.f];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    switch (sender.tag) {
        case 0:{//复制订单号
            
            pasteboard.string = self.detailModel.orderSn;
            
            [MBProgressHUD showSuccess:XMFLI(@"复制成功") toView:kAppWindow];
        }
            break;
            
        case 1:{//复制快递单号
            
            pasteboard.string = self.detailModel.shipSn;
            
            [MBProgressHUD showSuccess:XMFLI(@"复制成功") toView:kAppWindow];
        }
            break;
            
        case 2:{//更多防伪袋条码
            
//            pasteboard.string = self.detailModel.cartonBoxBarCode;
  
            XMFOrderBarcodePopView *popView = [XMFOrderBarcodePopView XMFLoadFromXIB];
            
            popView.detailModel = self.detailModel;
            
            
            [popView show];
            
            
        }
            break;
            
        default:
            break;
    }
    

}


-(void)setDetailModel:(XMFMyOrdersListModel *)detailModel{
    
    _detailModel = detailModel;
    
    //更新View的frame值才有效，使用layoutSubviews无效
    
    CGRect tempFrame = self.frame;
        
   
    CGFloat bgViewHeight = 32.f;
    
    
    
    //底部view的第一部分
    self.goodsTotalMoneyLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:detailModel.goodsPrice]];
    
    self.taxesFeeLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:detailModel.taxPrice]];
    
    self.postageFeeLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:detailModel.freightPrice]];
    
    //标点符号
    NSString *punctuation = [NSString string];
    
    if ([detailModel.couponPrice doubleValue] > 0) {
        
        punctuation = @"-";
        
    }else{
        
        punctuation = @"";
    }
    
    //其他优惠
    if ([detailModel.couponPrice doubleValue] > 0){
        
        self.discountLB.text = [NSString stringWithFormat:@"%@HK$ %@",punctuation,[NSString removeSuffix:detailModel.couponPrice]];
        
        self.discountBgView.hidden = NO;
        
        self.discountBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        self.discountBgView.hidden = YES;
        
        self.discountBgViewHeight.constant = 0.f;
        
        tempFrame.size.height -= bgViewHeight;

    }
    
    
    
    //商城优惠
    NSString *otherDiscountStr = [NSString string];
    
    if ([detailModel.otherDiscount doubleValue] > 0) {
        
        otherDiscountStr = @"-";
        
        self.mallDiscountBgView.hidden = NO;
        
        self.mallDiscountBgViewHeight.constant = bgViewHeight;
        
        self.mallDiscountLB.text = [NSString stringWithFormat:@"%@HK$ %@",otherDiscountStr,[NSString removeSuffix:detailModel.otherDiscount]];
        
    }else{
        
        otherDiscountStr = @"";
        
        self.mallDiscountBgView.hidden = YES;
        
        self.mallDiscountBgViewHeight.constant = 0.f;
        
        tempFrame.size.height -= bgViewHeight;

    }
    

    
    //实付金额
    self.acAmountLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:detailModel.actualPrice]];
    
    
    
    
    
    //底部view的第二部分
    

    
    
    //订单
    if (detailModel.orderSn.length > 0) {
        
        self.orderSnLB.text = detailModel.orderSn;

        self.orderSnBgView.hidden = NO;
        
        self.orderSnBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.orderSnBgView.hidden = YES;
        
        self.orderSnBgViewHeight.constant = 0.f;
    }
    
    
    //支付方式
    if (detailModel.transferId.length > 0) {
        
        /** 交易类型 1:银联 2:微信 3:支付宝 4:H5支付 5:Apple Pay  6:银联云闪付  7：银联二维码 8：微信H5 9:支付宝H5 10:未知 */
        
        NSString *transferIdStr = [NSString string];
        
        switch ([detailModel.transferId integerValue]) {
            case 1:{//
                
                transferIdStr = XMFLI(@"银联");
            }
                break;
            case 2:{//
                
                transferIdStr = XMFLI(@"微信");
            }
                break;
            case 3:{//
                
                transferIdStr = XMFLI(@"支付宝");
            }
                break;
            case 4:{//
                
                transferIdStr = XMFLI(@"H5支付");
            }
                break;
            case 5:{//
                
                transferIdStr = XMFLI(@"Apple Pay");
            }
                break;
            case 6:{//
                
                transferIdStr = XMFLI(@"银联云闪付");
            }
                break;
            case 7:{//
                
                transferIdStr = XMFLI(@"银联二维码 ");
            }
                break;
            case 8:{//
                
                transferIdStr = XMFLI(@"微信");
            }
                break;
            case 9:{//
                
                transferIdStr = XMFLI(@"支付宝");
            }
                break;
            case 10:{//
                
                transferIdStr = XMFLI(@"未知");
            }
                break;
                
                
            default:{
                
                 transferIdStr = XMFLI(@"未知");
            }
                break;
        }
        
        self.paymentLB.text = transferIdStr;

        self.paymentBgView.hidden = NO;
        
        self.paymentBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.paymentBgView.hidden = YES;
        
        self.paymentBgViewHeight.constant = 0.f;
    }
    
    
    
    
    //物流公司
    if (detailModel.shipChannel.length > 0) {
        
        self.logisticsLB.text = detailModel.shipChannel;

        self.logisticsBgView.hidden = NO;
        
        self.logisticsBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.logisticsBgView.hidden = YES;
        
        self.logisticsBgViewHeight.constant = 0.f;
    }
    
    
    
    //快递单号
    if (detailModel.shipSn.length > 0) {
        
        self.expressNoLB.text = detailModel.shipSn;
        
        self.expressNoBgView.hidden = NO;
        
        self.expressNoBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.expressNoBgView.hidden = YES;
        
        self.expressNoBgViewHeight.constant = 0.f;
    }
    
    
    

    /*
    //包装盒条码
    if (detailModel.cartonBoxBarCode.length > 0) {
        
        self.barcodeLB.text = detailModel.cartonBoxBarCode;
        
        self.barcodeBgView.hidden = NO;
        
        self.barcodeBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.barcodeBgView.hidden = YES;
        
        self.barcodeBgViewHeight.constant = 0.f;
    }*/
    
    //防伪袋条码
    if (detailModel.freeTaxBarCode.count > 0) {
        
        self.barcodeLB.text = [NSString stringWithFormat:@"%@",[detailModel.freeTaxBarCode firstObject]];
        
        self.barcodeBgView.hidden = NO;
        
        self.barcodeBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.barcodeBgView.hidden = YES;
        
        self.barcodeBgViewHeight.constant = 0.f;
        
    }
    
    //更多按钮
    if (detailModel.freeTaxBarCode.count > 1) {
        
        self.moreBarcodeBtn.hidden = NO;
        
    }else{
        
        self.moreBarcodeBtn.hidden = YES;
        
    }
    
    
    //下单时间
    if (detailModel.addTime.length > 0) {
        
        self.orderTimeLB.text = detailModel.addTime;

        self.orderTimeBgView.hidden = NO;
        
        self.orderSnBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.orderTimeBgView.hidden = YES;
        
        self.orderSnBgViewHeight.constant = 0.f;
    }
    
    
    //发货时间
    if (detailModel.shipTime.length > 0) {
        
        self.deliveryTimeLB.text = detailModel.shipTime;

        self.deliveryTimeBgView.hidden = NO;
        
        self.deliveryTimeBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.deliveryTimeBgView.hidden = YES;
        
        self.deliveryTimeBgViewHeight.constant = 0.f;
    }
    
    
    //订单来源
    if (detailModel.orderSources.length > 0) {
        
        self.orderSourceLB.text = detailModel.orderSources;
        
        self.orderSourceBgView.hidden = NO;
        
        self.orderSourceBgViewHeight.constant = bgViewHeight;
        
    }else{
        
        tempFrame.size.height -= bgViewHeight;
        
        self.orderSourceBgView.hidden = YES;
        
        self.orderSourceBgViewHeight.constant = 0.f;
    }
    
        
    
     self.frame = tempFrame;
    
    
    
}


@end
