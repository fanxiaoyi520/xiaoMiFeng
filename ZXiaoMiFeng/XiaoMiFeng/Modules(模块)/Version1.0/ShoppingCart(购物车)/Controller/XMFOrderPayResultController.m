//
//  XMFOrderPayResultController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/1.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderPayResultController.h"
//#import "XMFMyOrdersController.h"//我的订单
#import "XMFMyAllOrdersController.h"//我的订单2.0


@interface XMFOrderPayResultController ()

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


@property (weak, nonatomic) IBOutlet UIView *bgView;


@end

@implementation XMFOrderPayResultController

-(instancetype)initWithPayInfoDic:(NSDictionary *)infoDic jumpFromType:(payResultJumpFromType)jumpFromType{
    
    if (self = [super init]) {
        
        self.payInfoDic = infoDic;
        
        self.jumpFromType = jumpFromType;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setDataForView:self.payInfoDic];
    
    //主动查询订单状态
    NSString *orderIdStr = [NSString stringWithFormat:@"%@",self.payInfoDic[@"orderId"]];
    
    [self getQueryOrderStatus:orderIdStr];

}


-(void)setDataForView:(NSDictionary *)dic{
    /*
    {
      "code" : "1000",
      "message" : "支付成功",
      "data" : "支付成功",
      "paymentMethod" : "WECHAT",
      "txnCurr" : "HKD",
      "txnAmt" : "2"
    }*/
    
    /*
     
     paymentMethod:
     
     APPLEPAY
     ALIPAY
     UNIONCLOUDPAY
     WECHAT
     " "
     */
    
    //金额
    self.acountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:[NSString stringWithFormat:@"%@ ",dic[@"txnCurr"]] upperColor:self.acountLB.textColor upperFont:[UIFont fontWithName:@"PingFang-SC-Semibold" size:14.f] lowerStr:[NSString formatToTwoDecimal:dic[@"txnAmt"]] lowerColor:self.acountLB.textColor lowerFont:self.acountLB.font];
    
    
    //支付方式
    NSString *paymentMethodStr = [NSString stringWithFormat:@"%@",dic[@"paymentMethod"]];
    
    if ([paymentMethodStr nullToString]) {
        //银联支付
        paymentMethodStr = @"UnionPay";
    }
    
    
    self.payWayLB.text = paymentMethodStr;
    
//    NSString *acountStr = [NSString stringWithFormat:@"%@%@",dic[@"txnCurr"],[NSString formatToTwoDecimal:dic[@"txnAmt"]]];
    
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//继续逛，回到首页
            
            [self.navigationController popToRootViewControllerAnimated:NO];

            
            XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
            
            //防止tabbar位置变动，遍历子控制器并选中
            for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                
                UIViewController *firstVc = navVc.viewControllers[0];
                
                //当为标准版或者VIP尊享版首页时
                if ([firstVc  isKindOfClass:[XMFHomeController class]] || [firstVc  isKindOfClass:[XMFHomeSimpleController class]]) {
                    
                    NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                    
                    tabBarVc.selectedIndex = index;
                    
                }
                
                
            }
            
            
        }
            
            break;
            
        case 1:{//查看订单详情
            
            
            if (self.jumpFromType == payResultJumpFromOrdersVc) {
                
                
                //发送通知告知我的订单选中不同的页面
                KPostNotification(KPost_PayResultVc_Notice_MyOrdersVc_SelectIndex, nil, @{@"index":@(2)})
                
                //对控制器进行遍历然后进行相应跳转
                for (UIViewController *controller in self.navigationController.viewControllers){
                    
                    if ([controller isKindOfClass:[XMFMyAllOrdersController class]]){
                        
                        
                        [self.navigationController popToViewController:controller animated:YES];
                        
                    }
                }
                
                
                
            }else{
                
//                XMFMyOrdersController  *VCtrl = [[XMFMyOrdersController alloc]initWithMyOrdersJumpFromType:myOrdersJumpFromPaySuccess];
                
                XMFMyAllOrdersController  *VCtrl = [[XMFMyAllOrdersController alloc]initWithFromType:fromPaySuccess];
                
                
                [self.navigationController pushViewController:VCtrl animated:YES];
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark - ——————— 网络请求 ————————
-(void)getQueryOrderStatus:(NSString *)orderIdStr{
    
    
    NSDictionary *dic = @{
        
        @"orderId":orderIdStr
    };
    
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_queryOrderStatus parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"查询订单状态：%@",responseObject);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
        [MBProgressHUD hideHUDForView:self.view];

        
    }];
    
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
