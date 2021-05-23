//
//  XMFOrdersDetailHeaderView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/15.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersDetailHeaderView.h"
#import "XMFOrdersDetailModel.h"
#import "XMFOrdersCellModel.h"
#import "XMFOrdersDetailModel.h"//订单详情model


//在.m文件中添加
@interface  XMFOrdersDetailHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLB;



@property (weak, nonatomic) IBOutlet UILabel *orderTimeLB;


@property (weak, nonatomic) IBOutlet UILabel *orderNumLB;

//订单进度

@property (weak, nonatomic) IBOutlet UIView *orderProgressBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderProgressBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *orderProgressLB;

//免税袋条码

@property (weak, nonatomic) IBOutlet UIView *dutyBagCodeBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dutyBgCodeBgViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *dutyBagCodeLB;



//物流轨迹
@property (weak, nonatomic) IBOutlet UIView *logisticsBgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logisticsBgViewHeight;


//快递单号背景View
@property (weak, nonatomic) IBOutlet UIView *expressNumBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expressNumBgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *expressNumLB;


//快递公司背景View
@property (weak, nonatomic) IBOutlet UIView *expressCompanyBgView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *expressCompanyBgViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *expressCompanyLB;


@property (weak, nonatomic) IBOutlet UILabel *consigneeLB;


@property (weak, nonatomic) IBOutlet UILabel *addressLB;


//缺货状态

@property (weak, nonatomic) IBOutlet UILabel *stockoutsTitleLB;

@property (weak, nonatomic) IBOutlet UILabel *stockoutsLB;


@end

@implementation XMFOrdersDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.logisticsBgView addGestureRecognizer:tap];
    
}


//物流轨迹View添加点击手势
-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    
    if ([self.delegate respondsToSelector:@selector(viewOnXMFOrdersDetailHeaderViewDidTap:)]) {
        
        [self.delegate viewOnXMFOrdersDetailHeaderViewDidTap:self];
    }
    
}


-(void)setDetailModel:(XMFOrdersDetailModel *)detailModel{
    
    _detailModel = detailModel;
    
    self.orderStatusLB.text = detailModel.orderInfo.orderStatusText;
       
       self.orderTimeLB.text = detailModel.orderInfo.addTime;
       
       self.orderNumLB.text = detailModel.orderInfo.orderSn;
       
       //allocateCargoStatus：1待拣货 2拣货完成
       if ([detailModel.orderInfo.allocateCargoStatus isEqualToString:@"1"]) {
           
           self.orderProgressLB.text = XMFLI(@"待拣货");
           
       }else if ([detailModel.orderInfo.allocateCargoStatus isEqualToString:@"2"]){
           
           self.orderProgressLB.text = XMFLI(@"拣货完成");
       }
       

       self.expressNumLB.text = detailModel.orderInfo.shipSn;
       
       self.expressCompanyLB.text = detailModel.orderInfo.shipChannel;
       
       self.consigneeLB.text = [NSString stringWithFormat:@"收货人：%@ %@",detailModel.orderInfo.consignee,detailModel.orderInfo.mobile];
       
       self.addressLB.text = detailModel.orderInfo.address;
    
    
    //判断缺货状态
    if ([detailModel.orderInfo.orderStatusText isEqualToString:@"缺货"]) {
        
        self.stockoutsLB.hidden = NO;
        
        self.stockoutsTitleLB.hidden = NO;
    
        self.stockoutsLB.text = detailModel.orderInfo.remark;
        
    }else{
        
        self.stockoutsLB.text = @"";
        
        self.stockoutsLB.hidden = YES;
        
        self.stockoutsTitleLB.hidden = YES;
    }
    
    
    switch (detailModel.statusType) {
            
            case pengdingStock:{//待进货（缺货）
                
                //设置状态文字颜色
                self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
                
                self.countdownLB.hidden = YES;
                
                self.orderProgressBgView.hidden = YES;
                self.orderProgressBgViewHeight.constant = 0.f;
                
                self.logisticsBgView.hidden = YES;
                self.logisticsBgViewHeight.constant = 0.f;
                
                self.expressNumBgView.hidden = YES;
                self.expressNumBgViewHeight.constant = 0.f;
                
                self.expressCompanyBgView.hidden = YES;
                self.expressCompanyBgViewHeight.constant = 0.f;
                
                //更新View的frame值，使用layoutSubviews无效
                
                CGRect tempFrame = self.frame;
                
                tempFrame.size.height -= 200;
                
                self.frame = tempFrame;
            }
                break;
            
         
          case pendingReceipt:{//待收货
              
              //设置状态文字颜色
              self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
              
              self.countdownLB.hidden = YES;
              
              self.orderProgressBgView.hidden = YES;
              self.orderProgressBgViewHeight.constant = 0.f;
              
              self.logisticsBgView.hidden = NO;
              self.logisticsBgViewHeight.constant = 50.f;
              
              self.expressNumBgView.hidden = NO;
              self.expressNumBgViewHeight.constant = 50.f;
              
              self.expressCompanyBgView.hidden = NO;
              self.expressCompanyBgViewHeight.constant = 50.f;
              
              //更新View的frame值，使用layoutSubviews无效
              
              CGRect tempFrame = self.frame;
              
              tempFrame.size.height -= 50;
              
              self.frame = tempFrame;
              
          }
              break;
              
          case pendingComment:{//待评价
              
              //设置状态文字颜色
              self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
              
              self.countdownLB.hidden = YES;
              
              self.orderProgressBgView.hidden = YES;
              self.orderProgressBgViewHeight.constant = 0.f;
              
              self.logisticsBgView.hidden = NO;
              self.logisticsBgViewHeight.constant = 50.f;
              
              self.expressNumBgView.hidden = NO;
              self.expressNumBgViewHeight.constant = 50.f;
              
              self.expressCompanyBgView.hidden = NO;
              self.expressCompanyBgViewHeight.constant = 50.f;
              
              //更新View的frame值，使用layoutSubviews无效
              
              CGRect tempFrame = self.frame;
              
              tempFrame.size.height -= 50;
              
              self.frame = tempFrame;
              
          }
              break;
          case pendingPay:{//待付款
              
              //设置状态文字为红色
              self.orderStatusLB.textColor = UIColorFromRGB(0xFB4D44);
              
              self.countdownLB.hidden = NO;
              
              self.orderProgressBgView.hidden = YES;
              self.orderProgressBgViewHeight.constant = 0.f;
              
              self.logisticsBgView.hidden = YES;
              self.logisticsBgViewHeight.constant = 0.f;
              
              self.expressNumBgView.hidden = YES;
              self.expressNumBgViewHeight.constant = 0.f;
              
              self.expressCompanyBgView.hidden = YES;
              self.expressCompanyBgViewHeight.constant = 0.f;
              
              //更新View的frame值，使用layoutSubviews无效
              
              CGRect tempFrame = self.frame;
              
              tempFrame.size.height -= 200;
              
              self.frame = tempFrame;
              
          }
              break;
              
          case pendingRebuy:{//待重买
              
              //设置状态文字颜色
              self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
              
              self.countdownLB.hidden = YES;
              
              self.orderProgressBgView.hidden = YES;
              self.orderProgressBgViewHeight.constant = 0.f;
              
              self.logisticsBgView.hidden = NO;
              self.logisticsBgViewHeight.constant = 50.f;
              
              self.expressNumBgView.hidden = NO;
              self.expressNumBgViewHeight.constant = 50.f;
              
              self.expressCompanyBgView.hidden = NO;
              self.expressCompanyBgViewHeight.constant = 50.f;
              
              //更新View的frame值，使用layoutSubviews无效
              
              CGRect tempFrame = self.frame;
              
              tempFrame.size.height -= 50;
              
              self.frame = tempFrame;
          }
              break;
              
          case pendingDelivery:{//待发货
              
              //设置状态文字颜色
              self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
              
              self.countdownLB.hidden = YES;
              
              self.orderProgressBgView.hidden = NO;
              self.orderProgressBgViewHeight.constant = 50.f;
              
              self.logisticsBgView.hidden = YES;
              self.logisticsBgViewHeight.constant = 0.f;
              
              self.expressNumBgView.hidden = YES;
              self.expressNumBgViewHeight.constant = 0.f;
              
              self.expressCompanyBgView.hidden = YES;
              self.expressCompanyBgViewHeight.constant = 0.f;
              
              //更新View的frame值，使用layoutSubviews无效
              
              CGRect tempFrame = self.frame;
              
              tempFrame.size.height -= 150;
              
              self.frame = tempFrame;
          }
              break;
              
          default:{
              
              //设置状态文字颜色
              self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
              
              self.countdownLB.hidden = YES;
              
              self.orderProgressBgView.hidden = YES;
              self.orderProgressBgViewHeight.constant = 0.f;
              
              self.logisticsBgView.hidden = YES;
              self.logisticsBgViewHeight.constant = 0.f;
              
              self.expressNumBgView.hidden = YES;
              self.expressNumBgViewHeight.constant = 0.f;
              
              self.expressCompanyBgView.hidden = YES;
              self.expressCompanyBgViewHeight.constant = 0.f;
              
              //更新View的frame值，使用layoutSubviews无效
              
              CGRect tempFrame = self.frame;
              
              tempFrame.size.height -= 200;
              
              self.frame = tempFrame;
              
          }
              break;
      }
    
    
    //判断免税袋条码有无值
    if (detailModel.orderInfo.freeTaxBarCode.length == 0) {
        
        self.dutyBagCodeBgView.hidden = YES;
        
        self.dutyBgCodeBgViewHeight.constant = 0.f;
        
        //更新View的frame值，使用layoutSubviews无效
        
        CGRect tempFrame = self.frame;
        
        tempFrame.size.height -= 60;
        
        self.frame = tempFrame;
        
        
        
    }else{
        
        NSString *freeTaxBarCodeStr = [detailModel.orderInfo.freeTaxBarCode stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
        
        //计算文字高度
        CGFloat freeTaxBarCodeStrHeigt = [NSString getStrHeightWithFont:14.f withWidth:KScreenWidth - 100 withContentStr:freeTaxBarCodeStr];
        
        self.dutyBgCodeBgViewHeight.constant = freeTaxBarCodeStrHeigt > 60 ? freeTaxBarCodeStrHeigt + 10 : 60;
        
        
        self.dutyBagCodeBgView.hidden = NO;
        
//        self.dutyBgCodeBgViewHeight.constant = 60.f;
        
        self.dutyBagCodeLB.text = freeTaxBarCodeStr;
        
        
    }
    
}



//订单信息详情
-(void)setInfoModel:(XMFOrdersDetailOrderInfoModel *)infoModel{
    
    _infoModel = infoModel;
    
    self.orderStatusLB.text = infoModel.orderStatusText;
    
    self.orderTimeLB.text = infoModel.addTime;
    
    self.orderNumLB.text = infoModel.orderSn;
    
    //allocateCargoStatus：1待拣货 2拣货完成
    if ([infoModel.allocateCargoStatus isEqualToString:@"1"]) {
        
        self.orderProgressLB.text = XMFLI(@"待拣货");
        
    }else if ([infoModel.allocateCargoStatus isEqualToString:@"2"]){
        
        self.orderProgressLB.text = XMFLI(@"拣货完成");
    }
    

    self.expressNumLB.text = infoModel.shipSn;
    
    self.expressCompanyLB.text = infoModel.shipChannel;
    
    self.consigneeLB.text = [NSString stringWithFormat:@"收货人：%@ %@",infoModel.consignee,infoModel.mobile];
    
    self.addressLB.text = infoModel.address;
    
    
    //判断缺货状态
    if ([infoModel.orderStatusText isEqualToString:@"缺货"]) {
        
        self.stockoutsLB.hidden = NO;
        
        self.stockoutsTitleLB.hidden = NO;
    
        self.stockoutsLB.text = infoModel.remark;
        
    }else{
        
        self.stockoutsLB.text = @"";
        
        self.stockoutsLB.hidden = YES;
        
        self.stockoutsTitleLB.hidden = YES;
    }
    
}


/*
//订单状态
-(void)setOrdersCellModel:(XMFOrdersCellModel *)ordersCellModel{
    
    _ordersCellModel = ordersCellModel;
    
    //人工赋值
    if ([ordersCellModel.orderStatusText isEqualToString:@"已付款"]) {
        
        ordersCellModel.statusType = pendingDelivery;
    }
    
    switch (ordersCellModel.statusType) {
       
        case pendingReceipt:{//待收货
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.orderProgressBgView.hidden = YES;
            self.orderProgressBgViewHeight.constant = 0.f;
            
            self.logisticsBgView.hidden = NO;
            self.logisticsBgViewHeight.constant = 50.f;
            
            self.expressNumBgView.hidden = NO;
            self.expressNumBgViewHeight.constant = 50.f;
            
            self.expressCompanyBgView.hidden = NO;
            self.expressCompanyBgViewHeight.constant = 50.f;
            
            //更新View的frame值，使用layoutSubviews无效
            
            CGRect tempFrame = self.frame;
            
            tempFrame.size.height -= 50;
            
            self.frame = tempFrame;
            
        }
            break;
            
        case pendingComment:{//待评价
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.orderProgressBgView.hidden = YES;
            self.orderProgressBgViewHeight.constant = 0.f;
            
            self.logisticsBgView.hidden = NO;
            self.logisticsBgViewHeight.constant = 50.f;
            
            self.expressNumBgView.hidden = NO;
            self.expressNumBgViewHeight.constant = 50.f;
            
            self.expressCompanyBgView.hidden = NO;
            self.expressCompanyBgViewHeight.constant = 50.f;
            
            //更新View的frame值，使用layoutSubviews无效
            
            CGRect tempFrame = self.frame;
            
            tempFrame.size.height -= 50;
            
            self.frame = tempFrame;
            
        }
            break;
        case pendingPay:{//待付款
            
            //设置状态文字为红色
            self.orderStatusLB.textColor = UIColorFromRGB(0xFB4D44);
            
            self.countdownLB.hidden = NO;
            
            self.orderProgressBgView.hidden = YES;
            self.orderProgressBgViewHeight.constant = 0.f;
            
            self.logisticsBgView.hidden = YES;
            self.logisticsBgViewHeight.constant = 0.f;
            
            self.expressNumBgView.hidden = YES;
            self.expressNumBgViewHeight.constant = 0.f;
            
            self.expressCompanyBgView.hidden = YES;
            self.expressCompanyBgViewHeight.constant = 0.f;
            
            //更新View的frame值，使用layoutSubviews无效
            
            CGRect tempFrame = self.frame;
            
            tempFrame.size.height -= 200;
            
            self.frame = tempFrame;
            
        }
            break;
            
        case pendingRebuy:{//待重买
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.orderProgressBgView.hidden = YES;
            self.orderProgressBgViewHeight.constant = 0.f;
            
            self.logisticsBgView.hidden = NO;
            self.logisticsBgViewHeight.constant = 50.f;
            
            self.expressNumBgView.hidden = NO;
            self.expressNumBgViewHeight.constant = 50.f;
            
            self.expressCompanyBgView.hidden = NO;
            self.expressCompanyBgViewHeight.constant = 50.f;
            
            //更新View的frame值，使用layoutSubviews无效
            
            CGRect tempFrame = self.frame;
            
            tempFrame.size.height -= 50;
            
            self.frame = tempFrame;
        }
            break;
            
        case pendingDelivery:{//待发货
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.orderProgressBgView.hidden = NO;
            self.orderProgressBgViewHeight.constant = 50.f;
            
            self.logisticsBgView.hidden = YES;
            self.logisticsBgViewHeight.constant = 0.f;
            
            self.expressNumBgView.hidden = YES;
            self.expressNumBgViewHeight.constant = 0.f;
            
            self.expressCompanyBgView.hidden = YES;
            self.expressCompanyBgViewHeight.constant = 0.f;
            
            //更新View的frame值，使用layoutSubviews无效
            
            CGRect tempFrame = self.frame;
            
            tempFrame.size.height -= 150;
            
            self.frame = tempFrame;
        }
            break;
            
        default:{
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.orderProgressBgView.hidden = YES;
            self.orderProgressBgViewHeight.constant = 0.f;
            
            self.logisticsBgView.hidden = YES;
            self.logisticsBgViewHeight.constant = 0.f;
            
            self.expressNumBgView.hidden = YES;
            self.expressNumBgViewHeight.constant = 0.f;
            
            self.expressCompanyBgView.hidden = YES;
            self.expressCompanyBgViewHeight.constant = 0.f;
            
            //更新View的frame值，使用layoutSubviews无效
            
            CGRect tempFrame = self.frame;
            
            tempFrame.size.height -= 200;
            
            self.frame = tempFrame;
            
        }
            break;
    }
    
    
}*/


//本地进行修改后的model
-(void)setModifyOrdersCellModel:(XMFOrdersCellModel *)modifyOrdersCellModel{
    
    _modifyOrdersCellModel = modifyOrdersCellModel;
    
    switch (modifyOrdersCellModel.statusType) {
            
        case pendingReceipt:{//待收货
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.logisticsBgView.hidden = NO;
            self.logisticsBgViewHeight.constant = 50.f;
            
            self.expressNumBgView.hidden = NO;
            self.expressNumBgViewHeight.constant = 50.f;
            
            self.expressCompanyBgView.hidden = NO;
            self.expressCompanyBgViewHeight.constant = 50.f;
            
            
            
        }
            break;
            
        case pendingComment:{//待评价
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.logisticsBgView.hidden = NO;
            self.logisticsBgViewHeight.constant = 50.f;
            
            self.expressNumBgView.hidden = NO;
            self.expressNumBgViewHeight.constant = 50.f;
            
            self.expressCompanyBgView.hidden = NO;
            self.expressCompanyBgViewHeight.constant = 50.f;
            
        }
            break;
        case pendingPay:{//待付款
            
            //设置状态文字为红色
            self.orderStatusLB.textColor = UIColorFromRGB(0xFB4D44);
            
            self.countdownLB.hidden = NO;
            
            self.logisticsBgView.hidden = YES;
            self.logisticsBgViewHeight.constant = 0.f;
            
            self.expressNumBgView.hidden = YES;
            self.expressNumBgViewHeight.constant = 0.f;
            
            self.expressCompanyBgView.hidden = YES;
            self.expressCompanyBgViewHeight.constant = 0.f;
            
         
            
        }
            break;
            
        case pendingRebuy:{//待重买
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.logisticsBgView.hidden = NO;
            self.logisticsBgViewHeight.constant = 50.f;
            
            self.expressNumBgView.hidden = NO;
            self.expressNumBgViewHeight.constant = 50.f;
            
            self.expressCompanyBgView.hidden = NO;
            self.expressCompanyBgViewHeight.constant = 50.f;
            
            
        }
            break;
            
        default:{
            
            //设置状态文字颜色
            self.orderStatusLB.textColor = UIColorFromRGB(0x333333);
            
            self.countdownLB.hidden = YES;
            
            self.logisticsBgView.hidden = YES;
            self.logisticsBgViewHeight.constant = 0.f;
            
            self.expressNumBgView.hidden = YES;
            self.expressNumBgViewHeight.constant = 0.f;
            
            self.expressCompanyBgView.hidden = YES;
            self.expressCompanyBgViewHeight.constant = 0.f;
            
           
            
        }
            break;
    }
    
    
}

@end
