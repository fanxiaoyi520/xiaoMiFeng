//
//  XMFMineViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMineViewController.h"
#import "XMFLoginViewController.h"
#import "XMFAddressListController.h"//选择地址页面
#import "XMFMineInfoViewController.h"//个人资料
#import "XMFFootprintViewController.h"//我的足迹
#import "XMFMyCollectionController.h"//我的收藏
#import "XMFMyOrdersController.h"//订单中心
#import "XMFOrdersPayModel.h"//去付款的model
#import "XMFAboutusViewController.h"//关于我们


@interface XMFMineViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLB;

//版本号
@property (weak, nonatomic) IBOutlet UILabel *versionLB;


//退出登录背景View
@property (weak, nonatomic) IBOutlet UIView *logoutBgView;



@end

@implementation XMFMineViewController


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    

    kWeakSelf(self)
    
    //监听token

    [JJKeyValueObserver addObserveObject:UserInfoModel keyPath:@"token" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew changeBlock:^(NSDictionary *dict) {
    
        //获取token的字符串值
        NSString *tokenStr = [NSString stringWithFormat:@"%@",dict[@"new"]];

        if (![tokenStr nullToString]) {

            [weakself getUserInfo];
            
            weakself.logoutBgView.hidden = NO;
            
        }else{
            
            weakself.logoutBgView.hidden = YES;
        }
        
    }];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //防止设置了myScrollView顶到状态栏但是没到的问题
    //顶到最顶部
    if (@available(iOS 11.0, *)) {
        
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    //接收登录状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    
    [self getUserInfo];
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versionLB.text = [NSString stringWithFormat:@"版本号 V%@",oldVersion];
    
    
    
    
}


-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    
    [self.avatarImgView cornerWithRadius:self.avatarImgView.height/2.0];
    
    
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    
    
    [self setDataForView];
    
    
    BOOL loginSuccess = [notification.object boolValue];
    

    
    if (loginSuccess) {
        
      
        
    }else{
       
    
        
    }
    
    
}



- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    static NSTimeInterval time = 0.0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    //限制用户点击按钮的时间间隔大于1秒钟
    
    if (currentTime - time < 0.75) {
        
        //大于这个时间间隔就处理
    
        return;
        
    }
    
    time = currentTime;
    
    
    switch (sender.tag) {
        case 0:{//登录

            if (UserInfoModel.token.length > 0) {
                
                 DLog(@"缓存的token：%@",UserInfoModel.token);
                
                XMFMineInfoViewController  *VCtrl = [[XMFMineInfoViewController alloc]init];
                
                kWeakSelf(self)
                
                VCtrl.modifyUserInfoBlock = ^{
                    
                    [weakself getUserInfo];
                    
                };
                
                
                [self.navigationController pushViewController:VCtrl animated:YES];
                
                return;
                
            }
            
            [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
            
        }
            break;
          
            
        case 1:{//订单中心
            
            if (UserInfoModel.token.length == 0) {

                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFMyOrdersController  *VCtrl = [[XMFMyOrdersController alloc]init];
                
                [self.navigationController pushViewController:VCtrl animated:YES];
            }
            
           
            
            
        }
            break;
        case 2:{//收货地址
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFAddressListController  *VCtrl = [[XMFAddressListController alloc]initWithJumpType:jumpFromMineVcToAddressList];
                
                
                [self.navigationController pushViewController:VCtrl animated:YES];
            }
                       
            
          
            
        }
            break;
        case 3:{//我的足迹
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFFootprintViewController  *VCtrl = [[XMFFootprintViewController alloc]init];
                
                [self.navigationController pushViewController:VCtrl animated:YES];
            }
            

            
            
        }
            break;
        case 4:{//我的收藏
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFMyCollectionController  *VCtrl = [[XMFMyCollectionController alloc]init];
                
                [self.navigationController pushViewController:VCtrl animated:YES];
            }
            

            
        }
            break;
        case 5:{//我的钱包
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                [self postSDKWalletInfo];
                
            }
            
            
           
            
        }
            break;
        case 6:{//联系客服
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = @"https://im.7x24cc.com/phone_webChat.html?accountId=N000000013029&chatId=6aded8fa-f405-4371-8aba-c982f8fb7f8d";
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 7:{//版本更新
            
           [[ZFAppUpdateManager sharedManager] checkAppUpdate:UpdateManual];
 
            
            
        }
            break;
        case 8:{//退出登录
            
            [XMFAlertController acWithTitle:XMFLI(@"提示") msg:XMFLI(@"确定要退出吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"取消") confirmAction:^(UIAlertAction * _Nonnull action) {
                
                [weakself logout];
                
            }];
            
           
            
        }
            break;
            
        case 9:{//关于我们
            
            
            XMFAboutusViewController  *VCtrl = [[XMFAboutusViewController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
        
            
           
            
        }
            break;
            
            
        default:
            break;
    }
    
    
    
}

#pragma mark - ——————— 网络请求 ————————

-(void)getUserInfo{
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_oauth_mallUserInfo parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"获取用户信息：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSString *tokenStr = UserInfoModel.token;
            
            NSString *tokenExpireStr = UserInfoModel.tokenExpire;
            
            
            //人为增加并赋值avatarUrl字段
            NSMutableDictionary *dataMutableDic = [NSMutableDictionary dictionaryWithDictionary:responseObjectModel.data];
            
            [dataMutableDic setValue:[dataMutableDic objectForKey:@"headImg"] forKey:@"userAvatar"];
            
            
            [UserInfoManager updateUserInfo:dataMutableDic];
            
            
            //单独保存token
            [UserInfoManager updateValue:tokenStr forKey:@"token"];
            
            //单独保存tokenExpire
            [UserInfoManager updateValue:tokenExpireStr forKey:@"tokenExpire"];
            
            
            //设置数据
            [self setDataForView];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}

//为页面设置数据
-(void)setDataForView{
    
    DLog(@"头像地址：%@",UserInfoModel.avatarUrl);
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:UserInfoModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_me_touxiang"]];
    
    //防止后台没有nickname返回
    if (UserInfoModel.nickName.length == 0 && UserInfoModel.token.length == 0) {
        
        self.nickNameLB.text = XMFLI(@"立即登录");
        
    }else{
        
        self.nickNameLB.text = UserInfoModel.nickName;
    }
    
    
    if (UserInfoModel.token.length == 0) {

        self.logoutBgView.hidden = YES;
        
    }else{
        
        self.logoutBgView.hidden = NO;
    }
    
    
    
}

//退出登录
-(void)logout{
    
    
    NSDictionary *dic = @{
        
        @"X-Litemall-Token":UserInfoModel.token
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_drop_out parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"退出登录：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            //移除缓存
            [UserInfoManager removeUserInfo];
            [AddressManager removeAddressInfo];
            
            
            //脸书退出
             FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            
             [loginManager logOut];
            
            
            [self setDataForView];
            
            //购物车tabbar的红点清除
               XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
               
               //防止tabbar位置变动，遍历子控制器并选中
               for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                   
                   UIViewController *firstVc = navVc.viewControllers[0];
                   
                   if ([firstVc  isKindOfClass:[XMFShoppingCartController class]]) {
                       
                       navVc.tabBarItem.badgeValue = nil;

                       
                   }
                   
                   
               }
            
            
            //跳到登录页面
            [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
            
            //退出登录发送通知
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, nil);
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


//我的钱包
-(void)postSDKWalletInfo{
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_wallet_sdkwalletinfo parameters:@{} success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"我的钱包：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            XMFOrdersPayModel *moneyModel = [XMFOrdersPayModel yy_modelWithDictionary:responseObjectModel.data];
            
            NSDictionary *dic = @{
                @"merId": moneyModel.merId,
                @"mcc": moneyModel.mcc,
                @"orderNo": [DateUtils getCurrentDateWithFormat:@"yyyyMMddHHmmss"],
                @"notifyUrl": moneyModel.notifyUrl,
                @"realIp": [[IPToolManager sharedManager] currentIPAddress:YES],
                @"service": @"1",
                @"subject": @"1",
                @"phoneSystem":@"Ios",
                @"userId": @"1",
                @"version": moneyModel.version,
                @"txnAmt": @"1",
                @"language": [XMFGlobalManager getGlobalManager].getCurrentLanguage,
                @"registerCountryCode": moneyModel.registerCountryCode,
                @"registerMobile": moneyModel.registerMobile,//@"13927495764"
                @"txnCurr": @"1",
                @"purchaseType":@"TRADE",//TRADE
                @"amount": @"1",
//                @"countryCode":moneyModel.countryCode,
                @"countryCode":[[XMFGlobalManager getGlobalManager]getCountryCodeStr],
                @"isSendPurchase":@"1",
                @"AES_Key":moneyModel.aesKey,
                @"md5_salt":moneyModel.md5,
                @"urlStr":ZDPaySDK_URL
            };
         
            [[ZDPay_OrderSureModel sharedSingleten] setModelProcessingDic:dic];
            
            ZDPay_MyWalletViewController *vc = [ZDPay_MyWalletViewController new];
            
            vc.orderModel = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
            
            vc.walletType = WalletType_binding;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }else if (responseObjectModel.kerrno == 504){//绑定手机
            
            [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
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
