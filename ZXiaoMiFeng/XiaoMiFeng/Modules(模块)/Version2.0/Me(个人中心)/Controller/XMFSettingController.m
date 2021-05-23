//
//  XMFSettingController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSettingController.h"
#import "XMFAboutusController.h"//关于我们
#import "XMFCommonPopView.h"//公共弹框
#import "MYActionSheetViewController.h"//底部弹框
#import "XMFHomeSimpleController.h"//简易版首页
#import "XMFHomeController.h"//标准版首页
#import "XMFAuthenticationController.h"//实名认证



@interface XMFSettingController ()<WCLActionSheetDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

/** 切换语言 */
@property (nonatomic, strong) WCLActionSheet *languageSheet;


/** 切换布局 */
@property (nonatomic, strong) WCLActionSheet *layoutSheet;


@end

@implementation XMFSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.naviTitle = XMFLI(@"设置");
    
    self.topSpace.constant = kNavBarHeight;
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//实名认证
            
            
            XMFAuthenticationController  *VCtrl = [[XMFAuthenticationController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
            
        case 1:{//切换语言

            NSMutableArray *actionSheetItems = [@[FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"简体中文")),FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"繁体中文")),FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"英文"))] mutableCopy];
            FSActionSheet *actionSheet = [[FSActionSheet alloc] initWithTitle:@"" cancelTitle:XMFLI(@"取消") items:actionSheetItems];
            // 展示并绑定选择回调
            [actionSheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
                //                FSActionSheetItem *item = actionSheetItems[selectedIndex];
                
                [weakself switchLanguage:selectedIndex];
                
                
            }];
            
            
            
            
        }
            break;
        case 2:{//切换布局
            

            NSMutableArray *actionSheetItems = [@[FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"标准版")),FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"VIP尊享版"))] mutableCopy];
            FSActionSheet *actionSheet = [[FSActionSheet alloc] initWithTitle:@"" cancelTitle:XMFLI(@"取消") items:actionSheetItems];
            // 展示并绑定选择回调
            [actionSheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
                //                FSActionSheetItem *item = actionSheetItems[selectedIndex];
                
                [weakself switchLayout:selectedIndex];
                
                
            }];
            
            
            
            
            
        }
            break;
        case 3:{//关于我们
            
            
            XMFAboutusController  *VCtrl = [[XMFAboutusController alloc]init];

            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 4:{//退出登录
            
            if (UserInfoModel.token.length == 0) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"您还未登录，请先登录")];
                
            }else{
                
                XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
                
                popView.tipsLB.text = @"确认退出登录吗?";
                
                popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                    
                    if (button.tag == 0) {//确定
                        
                        [self getLogout];
                    }
                    
                };
                
                [popView show];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - ——————— 切换语言 ————————
-(void)switchLanguage:(NSInteger)seletedIndex{
    
    switch (seletedIndex) {
          case 0:{//简体中文
              
              DLog(@"简体中文");
              
              [MBProgressHUD showSuccess:@"简体中文" toView:self.view];
              
              
          }
              
              break;
              
          case 1:{//繁体中文
              
              DLog(@"繁体中文");
              
              [MBProgressHUD showSuccess:@"繁体中文" toView:self.view];
              
              
          }
              
              break;
            
        case 2:{//英文
            
            DLog(@"英文");
            
            [MBProgressHUD showSuccess:@"英文" toView:self.view];
            
            
        }
            
            break;
              
          default:
              break;
      }
    
    
}


#pragma mark - ——————— 切换布局 ————————

-(void)switchLayout:(NSInteger)seletedIndex{
    
    switch (seletedIndex) {
          case 0:{//标准版
              
              DLog(@"标准版");
              
              //单独更新版本信息
              [UserInfoManager updateValue:@(standard) forKey:@"skinType"];
              
              //替换首页
              XMFBaseUseingTabarController *tabBarVc = (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
              
              XMFHomeController *homeVc  = [[XMFHomeController alloc]init];
              
              XMFBaseNavigationController *simpleNavi = [[XMFBaseNavigationController alloc]initWithRootViewController:homeVc];
              
              NSMutableArray *tabarVcArr = [NSMutableArray arrayWithArray:tabBarVc.viewControllers];
              
              [tabarVcArr replaceObjectAtIndex:0 withObject:simpleNavi];
              
              tabBarVc.viewControllers = tabarVcArr;
              
              
              tabBarVc.selectedIndex = 0;
              
              
              [self.navigationController popToRootViewControllerAnimated:YES];
              
              
          }
              
              break;
              
          case 1:{//VIP尊享版
              
              DLog(@"VIP尊享版");
              
              //单独更新版本信息
              [UserInfoManager updateValue:@(simple) forKey:@"skinType"];
              
              
              //替换首页
              XMFBaseUseingTabarController *tabBarVc = (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
              
              XMFHomeSimpleController *simpleVc  = [[XMFHomeSimpleController alloc]init];
              
              XMFBaseNavigationController *simpleNavi = [[XMFBaseNavigationController alloc]initWithRootViewController:simpleVc];
              
              NSMutableArray *tabarVcArr = [NSMutableArray arrayWithArray:tabBarVc.viewControllers];
              
              [tabarVcArr replaceObjectAtIndex:0 withObject:simpleNavi];
              
              tabBarVc.viewControllers = tabarVcArr;
              
              
              tabBarVc.selectedIndex = 0;
              
              
              [self.navigationController popToRootViewControllerAnimated:YES];
              
              
          }
              
              break;
              
          default:
              break;
      }
    
    
}


#pragma mark - ——————— WCLActionSheetDelegate ————————

-(void)actionImageSheet:(WCLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (actionSheet == self.languageSheet) {
        
        
        
        
        
        
    }else{
        
        switch (buttonIndex) {
            case 0:{//标准版
                
                DLog(@"标准版");
                
                //替换首页
                XMFBaseUseingTabarController *tabBarVc = (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
                
                XMFHomeController *homeVc  = [[XMFHomeController alloc]init];
                
                XMFBaseNavigationController *simpleNavi = [[XMFBaseNavigationController alloc]initWithRootViewController:homeVc];
                
                NSMutableArray *tabarVcArr = [NSMutableArray arrayWithArray:tabBarVc.viewControllers];
                
                [tabarVcArr replaceObjectAtIndex:0 withObject:simpleNavi];
                
                tabBarVc.viewControllers = tabarVcArr;
                
                
                tabBarVc.selectedIndex = 0;
                
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            }
                
                break;
                
            case 1:{//VIP尊享版
                
                DLog(@"VIP尊享版");
                
                //替换首页
                XMFBaseUseingTabarController *tabBarVc = (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
                
                XMFHomeSimpleController *simpleVc  = [[XMFHomeSimpleController alloc]init];
                
                XMFBaseNavigationController *simpleNavi = [[XMFBaseNavigationController alloc]initWithRootViewController:simpleVc];
                
                NSMutableArray *tabarVcArr = [NSMutableArray arrayWithArray:tabBarVc.viewControllers];
                
                [tabarVcArr replaceObjectAtIndex:0 withObject:simpleNavi];
                
                tabBarVc.viewControllers = tabarVcArr;
                
                
                tabBarVc.selectedIndex = 0;
                
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                
            }
                
                break;
                
            default:
                break;
        }
        
    }

    
}


#pragma mark - ——————— 网络请求 ————————

//退出登录
-(void)getLogout{
    
    
    NSDictionary *dic = @{
        
        @"X-Beemall-Token":UserInfoModel.token
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_auth_dropout parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"退出登录：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            //移除缓存
            [UserInfoManager removeUserInfo];
            [AddressManager removeAddressInfo];
            
            //清空搜索记录
            [GlobalManager removeUserDefaultsObjectForKey:HistoryStringArray];
            
            //脸书退出
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            
            [loginManager logOut];
            
            
            XMFBaseUseingTabarController *tabBarVC = (XMFBaseUseingTabarController *)self.tabBarController;
            //            AxcAE_TabBarItem *item = tabBarVC.axcTabBar.currentSelectItem; // 因为已经到这个页面，说明就是当前的选项卡item
            AxcAE_TabBarItem *item = tabBarVC.axcTabBar.tabBarItems[GlobalManager.getShoppingCartIndex];
            // 为0是否自动隐藏
            item.badgeLabel.automaticHidden = YES;
            
            //清空为0
            item.badge = @"";
            
            
            //退出登录发送通知
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, nil);
            
            
            
            //跳到登录页面
            [[XMFGlobalManager getGlobalManager] presentLoginControllerWithBlock:self block:^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];

                
                //选中首页
                XMFBaseUseingTabarController *tabBarVc = (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
                
                tabBarVc.selectedIndex = 0;
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }];
            

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
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
