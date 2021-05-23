//
//  XMFAboutusController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAboutusController.h"

@interface XMFAboutusController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

//版本
@property (weak, nonatomic) IBOutlet UILabel *versionLB;


@property (weak, nonatomic) IBOutlet UILabel *versionStatusLB;



@end

@implementation XMFAboutusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];

}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"关于我们");
    
    self.topSpace.constant = kNavBarHeight;
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versionLB.text = [NSString stringWithFormat:@"V %@",oldVersion];
    
    //检查新版
    [self checkAppUpdate];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    //    服务协议地址: http://test19.qtopay.cn/client#/Serviceagreement
    //    隐私协议地址:http://test19.qtopay.cn/client#/Privacy
        
    switch (sender.tag) {
        case 0:{//服务协议
            
            
            NSString *aboutusURLStr = @"http://bmall.xmfstore.com/h5/pages/my/Serviceagreement?type=0";
            
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = aboutusURLStr;
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
        }
            break;
            
        case 1:{//隐私协议
            
        
            NSString *aboutusURLStr = @"http://bmall.xmfstore.com/h5/pages/my/Privacy?type=0";
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = aboutusURLStr;
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
            
        case 2:{//版本更新
            
            
            [[ZFAppUpdateManager sharedManager] checkAppUpdate:UpdateManual];
            
        
            
        }
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark - ——————— 网络请求 ————————
// APP更新检查
- (void)checkAppUpdate{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
//    NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // platform=0/1（0=安卓；1=苹果）
    // category=0/1（0=本地；1=市场）
    
    NSDictionary *dic = @{
        
        @"platform":@"1",
        @"category":@"1"
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_upgrade parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"版本更新：%@",[responseObject description]);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSDictionary *appUpdateInfo = [NSDictionary dictionaryWithDictionary:responseObjectModel.data];
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSString *newVersion = [appUpdateInfo notNullObjectForKey:@"lastVersion"];
            
            //去除版本号里的.
            oldVersion = [oldVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            newVersion = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            //如果新版本号大，则需要升级
            BOOL needUpdate = NO;
            
            if ([newVersion integerValue] > [oldVersion integerValue]) {
                
                needUpdate = YES;
                
            }
            
            if (needUpdate) {
                
                 self.versionStatusLB.text = XMFLI(@"有新版本可更新");
                
            }else{
                
                self.versionStatusLB.text = XMFLI(@"已是最新版本");
            }
            
  
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:kAppWindow];
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
