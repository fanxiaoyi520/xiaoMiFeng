//
//  XMFSureRegisterController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSureRegisterController.h"

@interface XMFSureRegisterController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;

@property (weak, nonatomic) IBOutlet UITextField *nameTfd;


@property (weak, nonatomic) IBOutlet UITextField *pwdTfd;


@property (weak, nonatomic) IBOutlet UITextField *surePwdTfd;



@property (weak, nonatomic) IBOutlet UIButton *sureBtn;



@end

@implementation XMFSureRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}

-(void)setupUI{
    
    self.naviTitle = @"注册";
    
    self.topSpace.constant = kTopHeight;
    
    self.phoneTfd.text = self.phoneStr;
    
    self.nameTfd.text = self.nameStr;
    
    [self.pwdTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.surePwdTfd setValue:@6 forKey:@"LimitInput"];
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.sureBtn cornerWithRadius:5.f];


}


//确认注册
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {

    
    if (![self.pwdTfd.text isValidPassword] || ![self.surePwdTfd.text isValidPassword]) {
    
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入6位数字密码")];
        
        return;
        
    }else if (![self.pwdTfd.text isEqualToString:self.surePwdTfd.text]) {
        
        
         [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请确认密码一致")];
        
        return;
    }
    
    
    
    /**
     
     {"realName":"","password":"123456","mobile":"18825257966","areaCode":"+86","agentNo":"10001"}
     
     */
    
    
    NSDictionary *dic = @{
        
        @"mobile":self.phoneTfd.text,
        
        @"realName":self.nameTfd.text,
        
        @"password":self.pwdTfd.text,
        
        @"areaCode":self.areaCodeStr,
        
        @"agentNo":@"10001"
        
        
    };
    
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_register parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"注册成功：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSDictionary *userInfoDic = responseObjectModel.data[@"userInfo"];
            
            //保存用户信息
            [UserInfoManager updateUserInfo:userInfoDic];
            
            //单独保存token
            [UserInfoManager updateValue:responseObjectModel.data[@"token"] forKey:@"token"];
            
            //单独保存tokenExpire
            [UserInfoManager updateValue:responseObjectModel.data[@"tokenExpire"] forKey:@"tokenExpire"];
            
            
            XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
            
            //防止tabbar位置变动，遍历子控制器并选中
            for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                
                UIViewController *firstVc = navVc.viewControllers[0];
                
                if ([firstVc  isKindOfClass:[XMFMineViewController class]]) {
                    
                    NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                    
                    tabBarVc.selectedIndex = index;
                    
                }
            }
            
            
            //present方式
            [self dismissViewControllerAnimated:YES completion:nil];
            
            [self.navigationController popToRootViewControllerAnimated:YES];

            
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
