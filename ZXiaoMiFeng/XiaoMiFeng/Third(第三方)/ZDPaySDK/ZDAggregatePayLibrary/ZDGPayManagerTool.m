//
//  ZDGPayManagerTool.m
//  AllPayDemo
//
//  Created by FANS on 2020/4/2.
//  Copyright © 2020 彭金光. All rights reserved.
//

#import "ZDGPayManagerTool.h"
#import "AlipayTool.h"
#import "WeiXinPayTool.h"
#import "UPPayTool.h"
#import "UPPaymentControl.h"
#import "ZDPayFuncTool.h"

typedef void (^MySucess) (id responseObject);
typedef void (^MyFailed) (id desc);
typedef void (^MyCancel) (id desc);
@interface ZDGPayManagerTool ()
@property (nonatomic ,copy)MySucess mySucess;
@property (nonatomic ,copy)MySucess myFailed;
@property (nonatomic ,copy)MySucess myCancel;
@end
@implementation ZDGPayManagerTool
/**
 *  单类方法
 */
+ (instancetype)shareTool {

    static ZDGPayManagerTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[ZDGPayManagerTool alloc]init];
    });  
    return _tool;
}

- (void)zdpay_handleOpenURL:(NSNotification *)noti {
    NSString *str = [NSString stringWithFormat:@"%@",[noti.userInfo objectForKey:@"url"]];
    NSURL *url = [NSURL URLWithString:str];
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            NSDictionary *aliDict    = resultDic;
            if ([aliDict[@"resultStatus"] isEqualToString:@"9000"]){
                if (self.mySucess) {
                    self.mySucess(resultDic);
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"8000"]) {
                if (self.myFailed) {
                    self.myFailed(resultDic);
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"4000"]) {
                 if (self.myFailed) {
                     self.myFailed(resultDic);
                 }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6001"]) {
                if (self.myCancel) {
                     self.myCancel(resultDic);
                 }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6002"]) {
                 if (self.myFailed) {
                     self.myFailed(resultDic);
                 }
            }
        }];
    }
}

- (void)startPaymentWithPayMethod:(NSInteger)payMethod
               payParametersModel:(PayModel *)paymodel
                   viewController:(UIViewController*)viewController
                       PaySuccess:(PaySuccess)success
                        payCancel:(PayCancel)payCancel
                        PayFailed:(PayFailed)Failed {
    if (payMethod == WeiXin) {
        NSDictionary *dic = [paymodel mj_keyValues];
        [[WeiXinPayTool shareTool] PayWithPrograms:dic WeiXinPaySuccess:^{
            success(@"支付成功");
        } WeiXinPayFailed:^(WeixinPayErrorCode code) {
            NSString *str = [NSString stringWithFormat:@"%lu",(unsigned long)code];
            Failed(str);
        }];
    } else if (payMethod == Alipay) {
        self.mySucess = success;
        self.myCancel = payCancel;
        self.myFailed = Failed;
        NSString *str = [NSString stringWithFormat:@"%@",paymodel.goodsName];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zdpay_handleOpenURL:) name:@"ZDPay_callback" object:nil];
        [[AlipaySDK defaultService] payOrder:str fromScheme:@"alisdkdemo" callback:^(NSDictionary *resultDic) {
            NSDictionary *aliDict    = resultDic;
            if ([aliDict[@"resultStatus"] isEqualToString:@"9000"]){
                if (success) {
                    success(resultDic);
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"8000"]) {
                if (Failed) {
                    payCancel(resultDic);
                }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"4000"]) {
                 if (Failed) {
                     Failed(resultDic);
                 }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6001"]) {
                 if (payCancel) {
                     payCancel(resultDic);
                 }
            }
            if ([aliDict[@"resultStatus"] isEqualToString:@"6002"]) {
                 if (Failed) {
                     Failed(resultDic);
                 }
            }
        }];
    } else if (payMethod == ApplePay) {
       [[UPPayTool shareTool] startApplePay:paymodel.apple_tn viewController:viewController ApplePayCallBack:^(UPPayResult *payResult) {
           if (payResult.paymentResultStatus == UPPaymentResultStatusSuccess) {
               success(payResult);
               return ;
           }
           
           if (payResult.paymentResultStatus == UPPaymentResultStatusFailure) {
               Failed(payResult);
               return;
           }
           if (payResult.paymentResultStatus == UPPaymentResultStatusCancel) {
               payCancel(payResult);
               return;
           }
           if (payResult.paymentResultStatus == UPPaymentResultStatusUnknownCancel) {
               payCancel(payResult);
               return;
           }
       }];
    } else if (payMethod == UPPay) {
        [[UPPayTool shareTool] startPay:paymodel.tn viewController:viewController SuccessBlock:^(NSDictionary *data) {
            success(data);
        } CancelBlock:^(NSString *desc) {
            payCancel(desc);
        } FailedBlock:^(NSString *desc) {
            Failed(desc);
        }];
    } else {
        NSString *str = [NSString stringWithFormat:@"%@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].The_correct_payment_method_is_not_passed_in_please_refer_to_the_document];
        Failed(str);
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
