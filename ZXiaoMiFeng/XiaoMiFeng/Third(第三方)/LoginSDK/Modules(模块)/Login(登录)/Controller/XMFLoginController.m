//
//  XMFLoginController.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/27.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFLoginController.h"
#import "XMFRegisterController.h"//注册
#import "XMFForgetPasswdController.h"//忘记密码
#import "XMFThirdBindController.h"//账号绑定
#import "XMFSelectAreaCodeView.h"//区号选择

//微信
#import "WXApi.h"


//谷歌
#import <GoogleSignIn/GoogleSignIn.h>
#import <Firebase.h>

//脸书
#import "FBSDKLoginKit.h"

//苹果登录
#import <AuthenticationServices/AuthenticationServices.h>





@interface XMFLoginController ()<YBAttributeTapActionDelegate,GIDSignInDelegate,FBSDKLoginButtonDelegate,WXApiDelegate,ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>{
    
    NSString *_code;//用户换取access_token的code，仅在ErrCode为0时有效
/*    NSString *_accessToken;//接口调用凭证
    NSString *_refreshToken;//用户刷新access_token
    NSString *_openid;//授权用户唯一标识
    NSString *_scope;//用户授权的作用域，使用逗号（,）分隔
    NSString *_unionid; //当且仅当该移动应用已获得该用户的userinfo授权时，才会出现该字段*/
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;


//手机号登录
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginBtn;

//邮箱登录
@property (weak, nonatomic) IBOutlet UIButton *emailLoginBtn;

//选中按钮的中间值
@property (nonatomic, strong) UIButton *selectedBtn;

//底部横线
@property (weak, nonatomic) IBOutlet UIView *lineView;

//登录内容类型ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *loginTypeScrollView;

//手机号登录
@property (weak, nonatomic) IBOutlet UIButton *areacodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;


@property (weak, nonatomic) IBOutlet UITextField *phonePwdTfd;


//邮箱登录
@property (weak, nonatomic) IBOutlet UITextField *emailTfd;


@property (weak, nonatomic) IBOutlet UITextField *emailPwdTfd;

//协议
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;


@property (weak, nonatomic) IBOutlet UILabel *agreementLB;


//登录
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;


@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;


//第三方登录

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdBgViewTopSpace;

@property (weak, nonatomic) IBOutlet UIView *thirdBgView;



@property (weak, nonatomic) IBOutlet UIButton *FacebookBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *FacebookBtnWidth;


@property (weak, nonatomic) IBOutlet UIButton *GoogleBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GoogleBtnWidth;


@property (weak, nonatomic) IBOutlet UIButton *WechatBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *WechatBtnWidth;


@property (weak, nonatomic) IBOutlet UIButton *signInAppleBtn;


//必传的参数字典
@property (nonatomic, strong) NSDictionary *mustParamsDic;

//正则表达式字符串
@property (nonatomic, copy) NSString *patternStr;

//区号
@property (nonatomic, copy) NSString *areaCodeStr;

//第三方用户信息
@property (nonatomic, strong) NSMutableDictionary *thirdUserInfo;


@end

@implementation XMFLoginController


//自定义方法
-(instancetype)initWithDic:(NSDictionary *)mustParamsDic{
    
    if (self = [super init]) {
        
        //MD5密钥
        NSString *MD5KeyStr = [NSString stringWithFormat:@"%@",[mustParamsDic notNullObjectForKey:@"MD5Key"]];
        

        if ([MD5KeyStr nullToString]) {
            
            
            [self.view makeToastOnCenter:@"缺少MD5Key密钥参数"];
            
            
        }else{
            
            
            //MD5密钥
            [CommonManager updateMD5Key:[mustParamsDic notNullObjectForKey:@"MD5Key"]];
            
        }
        
        
        
        //平台标识
        NSString *platformCodeStr = [NSString stringWithFormat:@"%@",[mustParamsDic notNullObjectForKey:@"platformCode"]];
        
        
        if ([platformCodeStr nullToString]) {
            
            [self.view makeToastOnCenter:@"缺少平台标识platformCode参数"];
            
            
        }else{
            
            //平台标识
            [CommonManager updatePlatformCode:[mustParamsDic notNullObjectForKey:@"platformCode"]];
            
        }
        
        
        
         //注册类型
        NSString *accountTypeStr = [NSString stringWithFormat:@"%@",[mustParamsDic notNullObjectForKey:@"accountType"]];
        
        
        if ([accountTypeStr nullToString]) {
            
            
            [self.view makeToastOnCenter:@"缺少accountType注册类型参数"];
            
        }else{
            
            //注册类型
            [CommonManager updateAccountType:[mustParamsDic notNullObjectForKey:@"accountType"]];
            
        }
        
        
        /*
        //Facebook脸书：应用程式编号
        NSString *facebookAppIDStr = [NSString stringWithFormat:@"%@",[mustParamsDic notNullObjectForKey:@"facebookAppID"]];
        
        
        if ([facebookAppIDStr nullToString]) {
            
            
            [self.view makeToastOnCenter:@"缺少facebookAppID应用程式编号参数"];
            
        }else{
            
            //应用程式编号
            [CommonManager updateFacebookAppID:facebookAppIDStr];
            
        }
        
        
        
        
        
        //微信应用的APPID
        NSString *wechatAppIDStr = [NSString stringWithFormat:@"%@",[mustParamsDic notNullObjectForKey:@"wechatAppID"]];
        
        
        if ([wechatAppIDStr nullToString]) {
            
            
            [self.view makeToastOnCenter:@"缺少wechatAppID微信应用的APPID参数"];
            
        }else{
            
            //微信应用的APPID
            [CommonManager updateWechat_APPID:wechatAppIDStr];
            
        }
        
        
        //微信应用的Universal Links
        NSString *wechatUniversalLinksStr = [NSString stringWithFormat:@"%@",[mustParamsDic notNullObjectForKey:@"wechatUniversalLinks"]];
        
        
        if ([wechatUniversalLinksStr nullToString]) {
            
            
            [self.view makeToastOnCenter:@"缺少wechatUniversalLinks微信应用的Universal Links参数"];
            
        }else{
            
            //微信应用的APPID
            [CommonManager updateWechat_UniversalLinks:wechatUniversalLinksStr];
            
        }*/
        
        
    }
    
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
    
    //如果不包含区号数据就请求接口
    if (![CommonManager isContainsAreaModelArr]) {
        
        [self getCountryRegionQuery];
    }
    
    
    // 设置代理
       [GIDSignIn sharedInstance].delegate = self;
    // 必须设置 否则会Crash
    [GIDSignIn sharedInstance].presentingViewController = self;
    
    
    //微信支付登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wxLogin:) name:@"wxLogin" object:nil];
    
    
    //获取平台信息
    [self getPlatformInfo];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)popAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_backBlock) {
        _backBlock();
    }
    
}


-(void)setupUI{
    
    self.naviTitle = @"登录";
    
    self.topSpace.constant = kNavBarHeight;
    
    
    //适配底部保证在一屏内
    
    if (iPhone6) {
        
        self.thirdBgViewTopSpace.constant = 15;
   
    }else{
        
        self.thirdBgViewTopSpace.constant = 30;

    }
    
    
    //设置按钮不同状态不同
    [CommonManager setButton:self.phoneLoginBtn titleStr:@"手机号登录"];
    [CommonManager setButton:self.emailLoginBtn titleStr:@"邮箱登录"];
    
    [self loginTypeBtnDidClick:self.phoneLoginBtn];
    
    
    //协议富文本设置
    NSMutableAttributedString *upperAttriStr = [[NSMutableAttributedString alloc]initWithString:@"同意《用户协议》并登录"];
    
    [upperAttriStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:13.f] range:NSMakeRange(2, 6)];
    
    [upperAttriStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGBA(0xF7CF20, 0.5) range:NSMakeRange(2, 6)];
    
    self.agreementLB.attributedText = upperAttriStr;
    
    self.agreementLB.enabledTapEffect = NO;
       //注意所有文字都要设置NSFontAttributeName这个属性，要不可能会造成点击不正确
    
    [self.agreementLB yb_addAttributeTapActionWithStrings:@[@"《用户协议》"] delegate:self];
    
    
    //默认中国大陆86
    self.areaCodeStr = @"86";

    self.patternStr = @"^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(19[0-9]{1})|(17[0-9]{1})|(14[4-7]{1})|(16[0-9]{1}))+\\d{8})$";
    
    [self.phoneTfd setValue:@11 forKey:@"LimitInput"];
  
    [self.phonePwdTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.emailTfd setValue:@30 forKey:@"LimitInput"];
    
    [self.emailPwdTfd setValue:@6 forKey:@"LimitInput"];
    

    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    //布局按钮
    
    CGFloat imageTitleSpace = 10;
    
    [self.FacebookBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:imageTitleSpace];
    
    [self.WechatBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:imageTitleSpace];
    
    [self.GoogleBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:imageTitleSpace];
    
    
    [self.areacodeBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imageTitleSpace];
    
    [self.lineView cornerWithRadius:self.lineView.height/2.0];
    
    [self.loginBtn cornerWithRadius:5.f];
    
    
    [self.signInAppleBtn xw_roundedCornerWithCornerRadii:CGSizeMake(5, 5) cornerColor:KWhiteColor corners:UIRectCornerAllCorners borderColor:UIColorFromRGB(0x333333) borderWidth:1.f];
    

    
}


-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    
    /*
    //判断手机系统是否是iOS 13以上
    if (@available(iOS 13.0,*)) {
        

        self.signInAppleBtn.hidden = NO;
        
    }else{
        
        self.signInAppleBtn.hidden = YES;
 
    }
    
    
    
    //判断微信是否安装
    if (![WXApi isWXAppInstalled]) {
        
        self.WechatBtn.hidden = YES;
        
        self.WechatBtnWidth.constant = 0.f;
        
        
    }else{
        
        
        self.WechatBtn.hidden = NO;
        
        self.WechatBtnWidth.constant = 98.f;
        
    }*/
    
    
    
}


//根据后台返回数据设置界面
-(void)setDataForThirdView{
    
      //注意以下代码顺序不能颠倒
    
      //判断手机系统是否是iOS 13以上
       if (@available(iOS 13.0,*)) {
           

           self.signInAppleBtn.hidden = NO;
           
       }else{
           
           self.signInAppleBtn.hidden = YES;
    
       }
       
       
       
 
    
    
    
    
    //logo图片
    
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:[CommonManager getPlatformInfoModel].logoUrl] placeholderImage:[UIImage imageNamed:@"logo_signin"]];
    
    
    
    //微信
    if ([[CommonManager getPlatformInfoModel].enableWechat boolValue]) {
        
        self.WechatBtn.hidden = YES;
        
        self.WechatBtnWidth.constant = 0.f;
        
    }else{
        
        self.WechatBtn.hidden = NO;
    }
    
    
    //判断微信是否安装
     if (![WXApi isWXAppInstalled]) {
         
         self.WechatBtn.hidden = YES;
         
         self.WechatBtnWidth.constant = 0.f;
         
         
     }else{
         
         
         self.WechatBtn.hidden = NO;
         
        
         
     }
    
    
    //脸书
    if ([[CommonManager getPlatformInfoModel].enableFacebook boolValue]) {
        
        self.FacebookBtn.hidden = YES;
        
        self.FacebookBtnWidth.constant = 0.f;
        
    }else{
        
        self.FacebookBtn.hidden = NO;
    }
    
    
    //谷歌
    if ([[CommonManager getPlatformInfoModel].enableGoogle boolValue]) {
        
        self.GoogleBtn.hidden = YES;
        
        self.GoogleBtnWidth.constant = 0.f;
        
    }else{
        
         self.GoogleBtn.hidden = NO;
    }
    
    
    //三个都没有
    if ([[CommonManager getPlatformInfoModel].enableGoogle boolValue] && [[CommonManager getPlatformInfoModel].enableFacebook boolValue] && [[CommonManager getPlatformInfoModel].enableWechat boolValue]) {
        
        self.thirdBgView.hidden = YES;
        
        self.signInAppleBtn.hidden = YES;
        
    }else{
        
        self.thirdBgView.hidden = NO;
    }
    
    
    
    
    //苹果
    if (![[CommonManager getPlatformInfoModel].enableGoogle boolValue] || ![[CommonManager getPlatformInfoModel].enableFacebook boolValue] || ![[CommonManager getPlatformInfoModel].enableWechat boolValue]) {
        
        self.signInAppleBtn.hidden = NO;
                
    }
    
    
}


//登录方式选择
- (IBAction)loginTypeBtnDidClick:(UIButton *)sender {


    if (sender != self.selectedBtn) {
        
        self.selectedBtn.selected = NO;
        
        sender.selected = YES;
        
        self.selectedBtn = sender;
        
    }else{
        
        self.selectedBtn.selected = YES;
    }
    

    
    
    //设置导航线
    self.lineView.centerX = self.selectedBtn.centerX;
    
    
    [self.loginTypeScrollView setContentOffset:CGPointMake(KScreenWidth * sender.tag, 0) animated:YES];

}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {

    kWeakSelf(self)

    switch (sender.tag) {
        case 0:{//同意协议
            
            [self.view endEditing:YES];
            
            sender.selected = !sender.selected;
        }
            
            break;
            
        case 1:{//登录
            
            [self gotoLogin];
        }
            
            break;
        case 2:{//注册
            
            XMFRegisterController  *VCtrl = [[XMFRegisterController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            
            break;
        case 3:{//忘记密码
            
            XMFForgetPasswdController  *VCtrl = [[XMFForgetPasswdController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            
            break;
        case 4:{//facebook登录
            
            // 点击 Facebook 登录按钮的时候调用如下代码即可调用 Facebook 登录功能
            FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
            
            [loginManager logInWithPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult * _Nullable result, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Process error");
                } else if (result.isCancelled) {
                    NSLog(@"Cancelled");
                } else {
                    NSLog(@"token信息：%@", result.token);
                    
                    [self FacebookLoginDidCompleteWithResult:result error:error];
                    
                }
            }];
            
            
        }
            
            break;
        case 5:{//谷歌登录
            
            // 点击自定义的 Google 登录按钮 可以调用如下API
            [[GIDSignIn sharedInstance] signIn];
        }
            
            break;
        case 6:{//微信登录
            
            [self sendWXAuthReq];

            
        }
            
            break;
            
        case 7:{//区号选择
                        
            
            [self.view endEditing:YES];
            
            
            //先判断有没有缓存数据
            if (![CommonManager isContainsAreaModelArr]) {
                
                [self getCountryRegionQuery];
                
                return;
            }
            
            
            XMFSelectAreaCodeView *areaView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFSelectAreaCodeView class]) owner:nil options:nil] firstObject];
            
            areaView.areaArr = [[CommonManager getAreaModelArr] copy];
            
            
            areaView.selectedAreaBlock = ^(XMFAreaCodeModel * _Nonnull areaModel) {
                
                [sender setTitle:[NSString stringWithFormat:@"+%@",areaModel.phoneCode] forState:UIControlStateNormal];
                
                weakself.areaCodeStr = areaModel.phoneCode;
                
                
                if ([weakself.areaCodeStr isEqualToString:@"86"]) {
                    //中国大陆
                    
                    weakself.patternStr = @"^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(19[0-9]{1})|(17[0-9]{1})|(14[4-7]{1})|(16[0-9]{1}))+\\d{8})$";
                    
                    [weakself.phoneTfd setValue:@11 forKey:@"LimitInput"];
                    
                    if (weakself.phoneTfd.text.length > 11) {
                        
                        weakself.phoneTfd.text =  [weakself.phoneTfd.text substringWithRange: NSMakeRange(0, 11)];
                    }

                    
                }else if ([weakself.areaCodeStr isEqualToString:@"852"]){
                    
                    //中国香港
                    
                    weakself.patternStr = @"^([5|6|8|9])\\d{7}$";
                               
                    [weakself.phoneTfd setValue:@8 forKey:@"LimitInput"];
                    
                    if (weakself.phoneTfd.text.length > 8) {
                        
                        weakself.phoneTfd.text =  [weakself.phoneTfd.text substringWithRange: NSMakeRange(0, 8)];
                    }

                    
                }else{
                    
                    //其他
                    weakself.patternStr = @"[0-9]*";
                    
                    [weakself.phoneTfd setValue:@15 forKey:@"LimitInput"];
                    
                    if (weakself.phoneTfd.text.length > 15) {
                        
                        weakself.phoneTfd.text =  [weakself.phoneTfd.text substringWithRange: NSMakeRange(0, 15)];
                    }
                    

                    
                }

                
            };
            
            
            areaView.areaViewStatus = ^(BOOL isShow) {
                
                sender.selected = isShow;
                
            };
            
            
            [areaView show];
            
            
        }
            
            break;
            
            
        case 8:{//苹果登录
            
            [self userAppleIDLogin];
            
        }
            break;
            
        default:
            break;
    }

}


#pragma mark - ——————— YBAttributeTapActionDelegate文字可点击 ————————
-(void)yb_tapAttributeInLabel:(UILabel *)label string:(NSString *)string range:(NSRange)range index:(NSInteger)index{
    
        
    
//    [self.view makeToastOnCenter:@"点击了协议,等待提供协议"];
    
    
    NSString *aboutusURLStr = [NSString stringWithFormat:@"%@/client#/Serviceagreement",XMF_BASE_URL];
    
    aboutusURLStr = @"https://www.bmall.com.hk/client#/Serviceagreement";
    
    XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
    
    VCtrl.urlStr = aboutusURLStr;
    
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
}



#pragma mark - ——————— 网络请求 ————————

//登录
-(void)gotoLogin{
    
    [self.view endEditing:YES];
    
    switch (self.selectedBtn.tag) {
        case 0:{//手机号登录
            
            [self gotoPhoneLogin];
        }
            break;
            
        case 1:{//邮箱登录
            
            [self gotoEmailLogin];
        }
            break;
            
        default:
            break;
    }
    
    
}


//手机号登录
-(void)gotoPhoneLogin{
    
    
    if ([self.phoneTfd.text nullToString]) {
        
        [self.view makeToastOnCenter:XMFLI(@"请输入手机号")];
        
        return;
        
    }else if (![self.phoneTfd.text isMatchPatternString:self.patternStr]) {
        
        [self.view makeToastOnCenter:XMFLI(@"请输入正确的手机号")];
        
        return;
        
    }else if (![self.phonePwdTfd.text isValidPassword]){
        
        [self.view makeToastOnCenter:XMFLI(@"请输入6位数字密码")];
        
        return;
        
    }else if (!self.agreementBtn.selected){
        
        [self.view makeToastOnCenter:XMFLI(@"请勾选协议")];
        
        return;
        
    }
    
    
    NSDictionary *dic = @{
        
        @"accountType":[CommonManager getAccountType],
        @"authcType":@"MOBP",
        @"credential":[CommonManager getEntryPwdWithMD5:self.phonePwdTfd.text],
        @"mobileCode":self.areaCodeStr,
        @"userMobile":self.phoneTfd.text
        
    };
    
    [self.activityIndicator  startAnimating];
    
    kWeakSelf(self)
    
    [XMFNetworking POSTWithURLContainParams:URL_auth_login_mobile Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        
        [weakself.activityIndicator stopAnimating];
        
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            DLog(@"手机登录：%@",responseObject);
            
            /**
             
             data =     {
                    createTime = 20200708165254;
                    expireTime = 20200709165254;
                    timestamp = "<null>";
                    token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxNTEyNTc5IiwiZXhwIjoxNTk0Mjg0Nzc0fQ.tYQYiI1LoUSnsIZpULgkG8h5oTqwIGZfMqeDKT2xGeg";
                    unionId = 1512579;
                }
             
             */
            
            [weakself popAction];
            
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


//邮箱登录
-(void)gotoEmailLogin{
    
    if ([self.emailTfd.text nullToString]) {
        
        [self.view makeToastOnCenter:XMFLI(@"请输入邮箱账号")];
        
        return;
        
    }else if (![self.emailTfd.text isEmail]) {
        
        [self.view makeToastOnCenter:XMFLI(@"请输入正确的邮箱账号")];
        
        return;
        
    }else if (![self.emailPwdTfd.text isValidPassword]){
        
        [self.view makeToastOnCenter:XMFLI(@"请输入6位数字密码")];
        
        return;
        
    }else if (!self.agreementBtn.selected){
        
        [self.view makeToastOnCenter:XMFLI(@"请勾选协议")];
        
        return;
        
    }
    
    
    NSDictionary *dic = @{
        
        @"accountType":[CommonManager getAccountType],
        @"authcType":@"EMAL",
        @"password":[CommonManager getEntryPwdWithMD5:self.emailPwdTfd.text],
        @"principal":self.emailTfd.text
        
    };
    
    kWeakSelf(self)
    
    [XMFNetworking POSTWithURLContainParams:URL_auth_login_basic Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"邮箱登录：%@",responseObject);
        
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
                        
            /**
             
             data =     {
                    createTime = 20200708165254;
                    expireTime = 20200709165254;
                    timestamp = "<null>";
                    token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxNTEyNTc5IiwiZXhwIjoxNTk0Mjg0Nzc0fQ.tYQYiI1LoUSnsIZpULgkG8h5oTqwIGZfMqeDKT2xGeg";
                    unionId = 1512579;
                }
             
             */
            
            [weakself popAction];
            
            //发送登录状态的通知和回调相关信息
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @YES, responseObject);
            
            
        }else{
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];
            
            //发送登录状态的通知和回调相关信息
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, responseObject);
        }
        
        
    } failure:^(NSString * _Nonnull error) {
        
        
        
    }];
    
    
}



//第三方授权检查接口
/**
 
 微信：WECHAT
 脸书：FACEBOOK
 谷歌：GOOGLE
 
 thirdAppId 第三方应用级主体标识（例：微信公众号的appid代码）
 
 thirdGlobalId  第三方全局级授权代码（例：支付宝的userid代码）
 
 thirdOpenId  第三方应用级授权代码（例：微信公众号openid代码）
 
 thirdUnionId 第三方平台级授权代码（例：微信公众号的unionid代码）
 
 thirdZoneId 第三方平台级主体标识（例：微信开放平台的appid代码）
 

 */
-(void)thirdCheckWithThirdAuthType:(NSString *)thirdAuthType thirdOpenId:(NSString *)thirdOpenId thirdGlobalId:(NSString * _Nullable)thirdGlobalId thirdUnionId:(NSString * _Nullable)thirdUnionId thirdZoneId:(NSString * _Nullable)thirdZoneId thirdAppId:(NSString * _Nullable)thirdAppId{
    
    NSDictionary *dic = @{
        
        @"accountType":[CommonManager getAccountType],
        
        @"thirdAppId":thirdAppId,
        
        //        @"thirdAppCode":thirdAppCode, _Nullable
        @"thirdAuthType":thirdAuthType,
        
        @"thirdOpenId":thirdOpenId,
        
        @"thirdGlobalId":thirdGlobalId,
        
        @"thirdUnionId":thirdUnionId,
        
        @"thirdZoneId":thirdZoneId
        
    };
    
    [self.activityIndicator startAnimating];
    
    kWeakSelf(self)
    
    [XMFNetworking POSTWithURLContainParams:URL_third_check Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        DLog(@"第三方绑定情况：%@",responseObject);
        
        [weakself.activityIndicator stopAnimating];
        
        //（未授权=状态值202，调用授权的相关接口；已授权=状态值200且返回对应的Token值，相当于登录）
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            
            [weakself popAction];
            
            //发送登录状态的通知和回调相关信息
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @YES, responseObject);
            
            
        }else if (responseObjectModel.code == 202){
            
            XMFThirdBindController  *VCtrl = [[XMFThirdBindController alloc]initWithDic:[weakself.thirdUserInfo mutableCopy]];
            
            [weakself.navigationController pushViewController:VCtrl animated:YES];
            
        }else{
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];
            
            
            //发送登录状态的通知和回调相关信息
            KPostNotification(KPost_LoginSDK_Notice_LoginStatusChange, @NO, responseObject);
            
            
        }
        
        
    } failure:^(NSString * _Nonnull error) {
        
        [weakself.activityIndicator stopAnimating];

        
    }];
    
    
}


//获取后台登录页面的配置
-(void)getPlatformInfo{
    
    NSDictionary *dic = @{};
    
    
    kWeakSelf(self)
    
    [XMFNetworking POSTWithURLContainParams:URL_platform_info Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"获取平台信息：%@",responseObject);
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            XMFPlatformInfoModel *model = [XMFPlatformInfoModel yy_modelWithDictionary:responseObjectModel.data];
            
//            model.logoUrl = @"https://kuajingdianshang.oss-cn-shenzhen.aliyuncs.com/xsaaa3yanfs9kgzu12hii2tr9791.png";
            
            [CommonManager updatePlatformInfoModel:model];
            
            [weakself setDataForThirdView];
        
            
        }else{
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];
        }

        
    } failure:^(NSString * _Nonnull error) {
        
        
    }];
    
    
    
}


#pragma mark - ——————— 谷歌登录代理方法 ————————
//谷歌： 实现代理方法
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    kWeakSelf(self)
    
    if (!error) {
        
        NSLog(@"用户ID：%@", user.userID);
        
        GIDAuthentication *authentication = user.authentication;
        
        FIRAuthCredential *credential =
        [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken
                                         accessToken:authentication.accessToken];
        NSLog(@"credential Provider：%@", credential.provider);
        // Firebase 身份验证
        // Summary
        // Asynchronously signs in to Firebase with the given 3rd-party credentials (e.g. a Facebook login Access Token, a Google ID Token/Access Token pair, etc.) and returns additional identity provider data.
        // 三方异步登录Firebase
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error) {
                NSLog(@"错误信息：%@", error.debugDescription);
            }
            if (!authResult) {
                NSLog(@"授权结果为空");
                return;
            }
            NSLog(@"Firebase uid：%@", authResult.user.uid);
            
            
            [weakself.thirdUserInfo removeAllObjects];
            
            [weakself.thirdUserInfo setValue:authResult.user.uid forKey:ThirdOpenId];
            
            [weakself.thirdUserInfo setValue:[authResult.user.photoURL absoluteString] forKey:UserAvatar];
            
            [weakself.thirdUserInfo setValue:GOOGLE forKey:ThirdAuthType];
            
            
            [weakself.thirdUserInfo setValue:[FIRApp defaultApp].options.clientID forKey:ThirdAppId];

            
            //第三方检查接口
            [weakself thirdCheckWithThirdAuthType:GOOGLE thirdOpenId:authResult.user.uid thirdGlobalId:nil thirdUnionId:nil thirdZoneId:nil thirdAppId:[FIRApp defaultApp].options.clientID];
            
            
            // 用于获取登录用户 Firebase token 信息交给服务端校验
            [[FIRAuth auth].currentUser getIDTokenWithCompletion:^(NSString * _Nullable token, NSError * _Nullable error) {
                if (error) {
                    
                    NSLog(@"获取当前token出现错误：%@", error);
                    return;
                }
                // Send token to your backend via HTTPS
                NSLog(@"Firebase当前用户 token 信息：%@", token);
           }];
            /**
             * 2020-03-06 20:48:46.859887+0800 FirebaseDemo[95438:3699395] credential Provider：google.com
             * 2020-03-06 20:48:47.914463+0800 FirebaseDemo[95438:3699395] Firebase uid：ma4dqHEO7JZm************QVE3
             * 2020-03-06 21:21:22.486530+0800 FirebaseDemo[95931:3798238] Firebase当前用户 token 信息：eyJhbGciOiJSUzI1NiIsImtpZCI6IjhjZjBjNjQyZDQ.*********4ZTRiZDc5OTkzOTZiNTY3NDAiLCJ0eX*********vbSJ9fQ.pvyaaG2dKKDH4CxO4VGiq_jcwDnmP************gQhHE-j-W
             // 这部分token 信息是 jwt 格式的内容
             */
        }];
    } else {
        NSLog(@"错误：%@", error.debugDescription);
//        self.userInfoLabel.text = error.debugDescription;
    }
}


#pragma mark - ——————— 脸书Facebok代理方法 ————————
//脸书自定义登录按钮调用方法
- (void)FacebookLoginDidCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    
    kWeakSelf(self)
    
    if (error) {
        NSLog(@"错误信息：%@", error);
    } else {
        FIRAuthCredential *credential =
        [FIRFacebookAuthProvider credentialWithAccessToken:result.token.tokenString];
        NSLog(@"credential Provider：%@", credential.provider);
   
        
        // Firebase 身份验证
        // Summary
        // Asynchronously signs in to Firebase with the given 3rd-party credentials (e.g. a Facebook login Access Token, a Google ID Token/Access Token pair, etc.) and returns additional identity provider data.
        // 三方异步登录Firebase
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if (error) {
                NSLog(@"错误信息：%@", error.debugDescription);
            }
            if (!authResult) {
                NSLog(@"授权结果为空");
                return;
            }
            NSLog(@"Firebase uid自定义按钮：%@", authResult.user.uid);
            
            
            
              [weakself.thirdUserInfo removeAllObjects];
              
              [weakself.thirdUserInfo setValue:authResult.user.uid forKey:ThirdOpenId];
              
              [weakself.thirdUserInfo setValue:[authResult.user.photoURL absoluteString] forKey:UserAvatar];
              
              [weakself.thirdUserInfo setValue:FACEBOOK forKey:ThirdAuthType];
            
            
              [weakself.thirdUserInfo setValue:kFacebookAppID forKey:ThirdAppId];
            
            
            //第三方检查接口
            [weakself thirdCheckWithThirdAuthType:FACEBOOK thirdOpenId:authResult.user.uid thirdGlobalId:nil thirdUnionId:nil thirdZoneId:nil thirdAppId:kFacebookAppID];
            
            /**
             * 2020-03-06 20:35:42.995671+0800 FirebaseDemo[95438:3699395] token信息：<FBSDKAccessToken: 0x600001bf6580>
             * 2020-03-06 20:35:45.301482+0800 FirebaseDemo[95438:3699395] Firebase uid：X8U372A8****************s3s1
             * 2020-03-06 21:22:49.582470+0800 FirebaseDemo[95931:3798238] Firebase当前用户 token 信息：eyJhbGc*******************************************************AiLCJ0eXAiOiJKV1QifQ.eyJuYW1lIjoi546L5rC45pe6IiwicGljdHVyZSI6Imh0dHBzOi8vZ3JhcGguZmFjZWJvb2suY29tLzEwMTAyNzQ5NDgxOTk4My9wa*******************************************************2tlbi5nb29nbGUuY29tL2Zpci1kZW1vLThkZj*******************************************************DM1MDA5NjgsInVzZXJfaWQiOiJYOFUzNzJBOG*******************************************************nlCdzNnS01nMXZ6czNzMSIsImlhdCI6MTU4MzUwMDk2OCwiZXhwIjoxNTgzNTA0NTY4LCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImZhY2Vib29rLmNvbSI6WyIxMDEwMjc0OTQ4MTk5ODMiXX0sInNpZ25faW5fcHJvdmlkZXIiOiJmYWNlYm9vay5jb20ifX0.VuhMUV_hr9Bc0Alrv2MS1X*******************************************************omeMXd5ebEe_FtKXEvSppDV8TN66p-*******************************************************lZpe-*******************************************************f-fyZ0lEK-p0PWB96WMKKY7jeVvPo_LR89u88kvjf7C-*******************************************************TWJmEYCMLqqtw9A
             */
            // 这部分token 信息是 jwt 格式的内容
        }];
        NSLog(@"token信息：%@", result.token);
//        self.userInfoLabel.text = [NSString stringWithFormat:@"token信息：%@", result.token.tokenString];
        
    }
}


#pragma mark - ——————— 微信登录 ————————
//微信
- (void)sendWXAuthReq{
    
    if([WXApi isWXAppInstalled]){//判断用户是否已安装微信App
        
         SendAuthReq *req = [[SendAuthReq alloc] init];
           req.state = @"wx_oauth_authorization_state";//用于保持请求和回调的状态，授权请求或原样带回
           req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
           
           //发送请求
//           [WXApi sendReq:req completion:^(BOOL success) {
//               NSLog(@"唤起微信:%@", success ? @"成功" : @"失败");
//           }];
        
        [WXApi sendAuthReq:req viewController:self delegate:self completion:^(BOOL success) {
            
             NSLog(@"唤起微信:%@", success ? @"成功" : @"失败");
            
        }];
        
        
    }else{
        
        //提示：未安装微信应用或版本过低
        
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请先安装微信客户端" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionConfim = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [vc addAction:actionConfim];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - ——————— 微信授权成功后的通知方法 ————————

- (void)wxLogin:(NSNotification*)noti{
    //获取到code
    SendAuthResp *resp = noti.object;
    NSLog(@"%@",resp.code);
    _code = resp.code;
    
    
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=%@",appId,appSecret,_code,@"authorization_code"];
    
     url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.activityIndicator startAnimating];
    
    kWeakSelf(self)
    
    [XMFNetworking GETWithURL:url Params:nil success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        [weakself.activityIndicator stopAnimating];
        
        NSLog(@"获取ascesstoken：%@",responseObject);
        
        NSLog(@"success");
        //            NSDictionary *resp = (NSDictionary*)responseObject;
        NSString *openid = responseObject[@"openid"];
        NSString *unionid = responseObject[@"unionid"];
        NSString *accessToken = responseObject[@"access_token"];
        NSString *refreshToken = responseObject[@"refresh_token"];
        if(accessToken && ![accessToken isEqualToString:@""] && openid && ![openid isEqualToString:@""]){
            
            [[NSUserDefaults standardUserDefaults] setObject:openid forKey:WX_OPEN_ID];
            [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:WX_ACCESS_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:refreshToken forKey:WX_REFRESH_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:unionid forKey:WX_UNION_ID];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            [weakself getWechatUserInfo];
        }

        
    } failure:^(NSString * _Nonnull error) {
        
        [weakself.activityIndicator stopAnimating];

        
    }];
    

    
}


//获取微信用户信息
-(void)getWechatUserInfo{
    
    kWeakSelf(self)

    NSString *requestUrlStr =  [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:WX_ACCESS_TOKEN],[[NSUserDefaults standardUserDefaults] objectForKey:WX_OPEN_ID]];
    
    [self.activityIndicator startAnimating];
    
    
    [XMFNetworking GETWithURL:requestUrlStr Params:nil success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        
        [weakself.activityIndicator stopAnimating];

        
        DLog(@"获取微信个人信息：%@",responseObject);
        
        
        /**
         
         {
             city = Shenzhen;
             country = CN;
             headimgurl = "http://thirdwx.qlogo.cn/mmopen/vi_32/8bTBINw4Pln2r4Uy45goO5oicbn2UwPZkEbNG9xF1RIKULAnZHqrOtib3vWiaMicYp3RWQg5LNib4nVyj0doY5uLib5w/132";
             language = "zh_CN";
             nickname = "小蜜蜂";
             openid = "oNLy6wJ5Hba_2PxdyvAjNz1G0dPM";
             privilege =     (
             );
             province = Guangdong;
             sex = 1;
             unionid = o0UOWv3cfJ9r93plGVmb3RwDtQeU;
         }
         
         */
        
        
        NSString *unionidStr = [NSString stringWithFormat:@"%@",responseObject[@"unionid"]];
        
        NSString *openidStr = [NSString stringWithFormat:@"%@",responseObject[@"openid"]];
        
        NSString *userAvatarStr = [NSString stringWithFormat:@"%@",responseObject[@"headimgurl"]];
        
        [weakself.thirdUserInfo removeAllObjects];
        
        [weakself.thirdUserInfo setValue:openidStr forKey:ThirdOpenId];
        
        [weakself.thirdUserInfo setValue:unionidStr forKey:ThirdUnionId];
        
        [weakself.thirdUserInfo setValue:userAvatarStr forKey:UserAvatar];
        
        [weakself.thirdUserInfo setValue:WECHAT forKey:ThirdAuthType];
        
        [weakself.thirdUserInfo setValue:WX_ZONE_ID forKey:ThirdZoneId];
        
        [weakself.thirdUserInfo setValue:appId forKey:ThirdAppId];
        

        [weakself thirdCheckWithThirdAuthType:WECHAT thirdOpenId:unionidStr thirdGlobalId:nil thirdUnionId:unionidStr thirdZoneId:WX_ZONE_ID thirdAppId:appId];
        
        
    } failure:^(NSString * _Nonnull error) {
        
        [weakself.activityIndicator stopAnimating];

        
    }];
    
}


#pragma mark - ——————— 苹果登录 ————————
//苹果登录处理授权
- (void)userAppleIDLogin{
    if (@available(iOS 13.0, *)) {
         // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        // 创建新的AppleID 授权请求
        ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
         // 在用户授权期间请求的联系信息
        request.requestedScopes = @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName];
        
         //需要考虑用户已经登录过，可以直接使用keychain密码来进行登录-这个很智能 (但是这个有问题)
//        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [[ASAuthorizationPasswordProvider alloc] init];
//        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
        
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
         // 设置授权控制器通知授权请求的成功与失败的代理
        controller.delegate = self;
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        controller.presentationContextProvider = self;
         // 在控制器初始化期间启动授权流
        [controller performRequests];
    } else {
        DLog(@"system is lower");
    }
}

//苹果登录授权成功的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *user = credential.user;
        NSData *identityToken = credential.identityToken;

        DLog(@"fullName -     %@",credential.fullName);
        //授权成功后，你可以拿到苹果返回的全部数据，根据需要和后台交互。
        DLog(@"user   -   %@  %@",user,identityToken);
        
        /*
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
        NSString *identityToken1 = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken1: %@", identityToken1);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
        */
        
        /*
         
          thirdAppId 就是这个应用的appid
          thirdOpenId直接传userId
          thirdZoneId传开发者的id
          thirdUnionId也传userId
         */
        
        
        [self.thirdUserInfo removeAllObjects];
        
        [self.thirdUserInfo setValue:user forKey:ThirdOpenId];
        
        [self.thirdUserInfo setValue:APPLE forKey:ThirdAuthType];
        
        [self.thirdUserInfo setValue:APPLE_TEAM_ID forKey:ThirdZoneId];
        
        [self.thirdUserInfo setValue:APPLE_APPLE_ID forKey:ThirdAppId];
        
        [self.thirdUserInfo setValue:user forKey:ThirdUnionId];
        
        
        //第三方检查接口
        [self thirdCheckWithThirdAuthType:APPLE thirdOpenId:user thirdGlobalId:nil thirdUnionId:user thirdZoneId:APPLE_TEAM_ID thirdAppId:APPLE_APPLE_ID];
        
        
        
        /*
        //保存apple返回的唯一标识符
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         */
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *psdCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = psdCredential.user;
        NSString *psd = psdCredential.password;
        DLog(@"psduser -  %@   %@",psd,user);
    } else {
       DLog(@"授权信息不符");
    }
}

//苹果登录授权回调失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
     NSLog(@"错误信息：%@", error);
     NSString *errorMsg;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            DLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            DLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            DLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            DLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            DLog(@"errorMsg -   %@",errorMsg);
            break;
                        
        default:
            break;
    }
}


#pragma mark - ——————— 懒加载 ————————
-(NSMutableDictionary *)thirdUserInfo{
    
    if (_thirdUserInfo == nil) {
        _thirdUserInfo = [[NSMutableDictionary alloc] init];
    }
    return _thirdUserInfo;
    
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
