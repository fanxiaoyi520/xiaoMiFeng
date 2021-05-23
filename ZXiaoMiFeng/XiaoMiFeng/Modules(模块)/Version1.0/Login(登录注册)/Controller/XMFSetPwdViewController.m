//
//  XMFSetPwdViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/22.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSetPwdViewController.h"
#import "XMFNetworking.h"//会员系统的网络请求工具


@interface XMFSetPwdViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (weak, nonatomic) IBOutlet UIView *oldPwdBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldPwdBgViewHeight;


@property (weak, nonatomic) IBOutlet UITextField *oldPwdTfd;


@property (weak, nonatomic) IBOutlet UITextField *pwdTfd;


@property (weak, nonatomic) IBOutlet UITextField *surePwdTfd;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end

@implementation XMFSetPwdViewController

-(instancetype)initWithType:(setPwdType)pwdType{
    
    if (self = [super init]) {
        
        self.pwdType = pwdType;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.sureBtn cornerWithRadius:5.f];
    
    
    
}


-(void)setupUI{
    
    //限制位数
    [self.oldPwdTfd setValue:@6 forKey:@"LimitInput"];
    [self.pwdTfd setValue:@6 forKey:@"LimitInput"];
    [self.surePwdTfd setValue:@6 forKey:@"LimitInput"];
    
    
    /**
     
     forgetPwdSetPwd,//忘记密码
     resetPwd,//重置密码
     registerSetPwd,//注册
     
     */
    
    
    switch (self.pwdType) {
        case registerSetPwd:{
            
            self.naviTitle = XMFLI(@"设置密码");
            
            self.topSpace.constant = kTopHeight;
            
            self.oldPwdBgView.hidden = YES;
            
            self.oldPwdBgViewHeight.constant = 0.f;
            
            
        }
            break;
            
        case resetPwd:{
            
            self.naviTitle = XMFLI(@"修改密码");
            
            self.topSpace.constant = kTopHeight;
 
            
        }
            break;
            
        case forgetPwdSetPwd:{
            
            self.naviTitle = XMFLI(@"忘记密码");
            
            self.topSpace.constant = kTopHeight;
            
            self.oldPwdBgView.hidden = YES;
            
            self.oldPwdBgViewHeight.constant = 0.f;
            
            
        }
            break;
   
            
        default:
            break;
    }
    
   
    
    
}

//确认修改密码
- (IBAction)sureBtnDidClick:(UIButton *)sender {
    
    switch (self.pwdType) {
           case registerSetPwd:{
               
            
               
           }
               break;
               
           case resetPwd:{
            
               [self postModifyPassword];
               
           }
               break;
               
           case forgetPwdSetPwd:{
              
               [self postForgetPassword];
               
           }
               break;
      
               
           default:
               break;
       }
    
    
    
}


#pragma mark - ——————— 网络请求 ————————

//修改密码
-(void)postModifyPassword{
    
    if (![self.oldPwdTfd.text isValidPassword] || ![self.pwdTfd.text isValidPassword] || ![self.surePwdTfd.text isValidPassword]) {
    
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入6位数字密码")];
        
        return;
        
    }else if (![self.pwdTfd.text isEqualToString:self.surePwdTfd.text]) {
        
        
         [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请确认密码一致")];
        
        return;
    }
    
//    {"oldPassword":"123456","newPassword":"123456"}
    
    NSDictionary *dic = @{
        
        @"oldPassword":[CommonManager getEntryPwdWithMD5:self.oldPwdTfd.text],
        
        @"newPassword":[CommonManager getEntryPwdWithMD5:self.pwdTfd.text]
        
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    
    [XMFNetworking POSTWithURLContainParams:URL_option_password_modify Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        DLog(@"修改密码：%@",responseObject);
          
        [MBProgressHUD hideHUDForView:self.view];

               
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            [MBProgressHUD showSuccess:XMFLI(@"密码修改成功！") toView:kAppWindow];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSString * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view];

    }];
    
    
    /*
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_modifyPassword parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"密码修改：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            [MBProgressHUD showSuccess:XMFLI(@"密码修改成功！") toView:kAppWindow];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
    }];*/
    
}


//忘记密码
-(void)postForgetPassword{
    
    
    if (![self.pwdTfd.text isValidPassword] || ![self.surePwdTfd.text isValidPassword]) {
    
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入6位数字密码")];
        
        return;
        
    }else if (![self.pwdTfd.text isEqualToString:self.surePwdTfd.text]) {
        
        
         [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请确认密码一致")];
        
        return;
    }
    
    
    /**
     
     {"phone":"18825257966","areaCode":"+86","password":"123456","code":"840248"}
     
     */
    
    NSDictionary *dic = @{
        
        @"phone":self.phoneStr,
        
        @"areaCode":self.areaCodeStr,
        
        @"code":self.codeStr,
        
        @"password":self.pwdTfd.text
        
        
    };
    
     [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_forgetPassword parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"忘记密码：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            [MBProgressHUD showSuccess:XMFLI(@"密码设置成功，请重新登录") toView:kAppWindow];
            
          [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else{
            
          [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        
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
