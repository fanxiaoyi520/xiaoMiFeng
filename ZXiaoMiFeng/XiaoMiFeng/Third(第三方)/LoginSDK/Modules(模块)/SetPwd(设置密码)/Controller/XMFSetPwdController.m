//
//  XMFSetPwdController.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/9.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFSetPwdController.h"

@interface XMFSetPwdController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

//logo图片
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;


@property (weak, nonatomic) IBOutlet UITextField *pwdTfd;


@property (weak, nonatomic) IBOutlet UITextField *surePwdTfd;


//确定
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


//第三方用户信息
@property (nonatomic, strong) NSMutableDictionary *userInfo;

@end

@implementation XMFSetPwdController


//自定义方法
-(instancetype)initWithUserInfo:(NSMutableDictionary *)userInfoDic{
    
    if (self = [super init]) {
         
        self.userInfo = userInfoDic;
         
     }
     
     return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = @"设置密码";
    
    self.topSpace.constant = kNavBarHeight;
    
    [self.pwdTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.surePwdTfd setValue:@6 forKey:@"LimitInput"];
    
    //logo图片
    
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:[CommonManager getPlatformInfoModel].logoUrl] placeholderImage:[UIImage imageNamed:@"logo_signin"]];
    
  
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];

    [self.sureBtn cornerWithRadius:5.f];

}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    //第三方授权登录
    
    if (![self.pwdTfd.text isValidPassword] || ![self.surePwdTfd.text isValidPassword]){
        
        [self.view makeToastOnCenter:XMFLI(@"请输入6位数字密码")];
        
        return;
        
    }else if (![self.pwdTfd.text isEqualToString:self.surePwdTfd.text]){
        
        
        [self.view makeToastOnCenter:XMFLI(@"请确认密码一致")];
        
        return;
        
        
    }
    

    NSDictionary *dic = @{
        
        @"accountType":[CommonManager getAccountType],
        @"password":[CommonManager getEntryPwdWithMD5:self.pwdTfd.text]
        
    };
    
    //拼接字典
    [self.userInfo addEntriesFromDictionary:dic];
    
    
    kWeakSelf(self)
    
    [self.activityIndicator startAnimating];
    
    [XMFNetworking POSTWithURLContainParams:URL_third_bound Params:self.userInfo success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        DLog(@"第三方登录：%@",responseObject);
        
        [weakself.activityIndicator stopAnimating];
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            
            [weakself dismissViewControllerAnimated:YES completion:nil];
            
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            
            //发送登录状态的通知和回调相关信息
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @YES, responseObject);
            
            
        }else{
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];
            
            //发送登录状态的通知和回调相关信息
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, responseObject);
            
        }
        
        
    } failure:^(NSString * _Nonnull error) {
        
        [weakself.activityIndicator stopAnimating];

        
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
