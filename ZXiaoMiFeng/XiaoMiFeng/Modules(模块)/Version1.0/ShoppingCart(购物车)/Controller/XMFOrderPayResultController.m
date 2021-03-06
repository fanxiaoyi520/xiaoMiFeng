//
//  XMFOrderPayResultController.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/6/1.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFOrderPayResultController.h"
//#import "XMFMyOrdersController.h"//ๆ็่ฎขๅ
#import "XMFMyAllOrdersController.h"//ๆ็่ฎขๅ2.0


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
    
    //ไธปๅจๆฅ่ฏข่ฎขๅ็ถๆ
    NSString *orderIdStr = [NSString stringWithFormat:@"%@",self.payInfoDic[@"orderId"]];
    
    [self getQueryOrderStatus:orderIdStr];

}


-(void)setDataForView:(NSDictionary *)dic{
    /*
    {
      "code" : "1000",
      "message" : "ๆฏไปๆๅ",
      "data" : "ๆฏไปๆๅ",
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
    
    //้้ข
    self.acountLB.attributedText = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:[NSString stringWithFormat:@"%@ ",dic[@"txnCurr"]] upperColor:self.acountLB.textColor upperFont:[UIFont fontWithName:@"PingFang-SC-Semibold" size:14.f] lowerStr:[NSString formatToTwoDecimal:dic[@"txnAmt"]] lowerColor:self.acountLB.textColor lowerFont:self.acountLB.font];
    
    
    //ๆฏไปๆนๅผ
    NSString *paymentMethodStr = [NSString stringWithFormat:@"%@",dic[@"paymentMethod"]];
    
    if ([paymentMethodStr nullToString]) {
        //้ถ่ๆฏไป
        paymentMethodStr = @"UnionPay";
    }
    
    
    self.payWayLB.text = paymentMethodStr;
    
//    NSString *acountStr = [NSString stringWithFormat:@"%@%@",dic[@"txnCurr"],[NSString formatToTwoDecimal:dic[@"txnAmt"]]];
    
    
    
}


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//็ปง็ปญ้๏ผๅๅฐ้ฆ้กต
            
            [self.navigationController popToRootViewControllerAnimated:NO];

            
            XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
            
            //้ฒๆญขtabbarไฝ็ฝฎๅๅจ๏ผ้ๅๅญๆงๅถๅจๅนถ้ไธญ
            for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                
                UIViewController *firstVc = navVc.viewControllers[0];
                
                //ๅฝไธบๆ?ๅ็ๆ่VIPๅฐไบซ็้ฆ้กตๆถ
                if ([firstVc  isKindOfClass:[XMFHomeController class]] || [firstVc  isKindOfClass:[XMFHomeSimpleController class]]) {
                    
                    NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                    
                    tabBarVc.selectedIndex = index;
                    
                }
                
                
            }
            
            
        }
            
            break;
            
        case 1:{//ๆฅ็่ฎขๅ่ฏฆๆ
            
            
            if (self.jumpFromType == payResultJumpFromOrdersVc) {
                
                
                //ๅ้้็ฅๅ็ฅๆ็่ฎขๅ้ไธญไธๅ็้กต้ข
                KPostNotification(KPost_PayResultVc_Notice_MyOrdersVc_SelectIndex, nil, @{@"index":@(2)})
                
                //ๅฏนๆงๅถๅจ่ฟ่ก้ๅ็ถๅ่ฟ่ก็ธๅบ่ทณ่ฝฌ
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


#pragma mark - โโโโโโโ ็ฝ็ป่ฏทๆฑ โโโโโโโโ
-(void)getQueryOrderStatus:(NSString *)orderIdStr{
    
    
    NSDictionary *dic = @{
        
        @"orderId":orderIdStr
    };
    
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_queryOrderStatus parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"ๆฅ่ฏข่ฎขๅ็ถๆ๏ผ%@",responseObject);
        
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
