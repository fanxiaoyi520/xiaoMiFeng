//
//  XMFRegisterController.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/30.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFRegisterController.h"
#import "XMFSelectAreaCodeView.h"//区号选择
#import "XMFAreaCodeModel.h"//区号model

@interface XMFRegisterController ()<YBAttributeTapActionDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


//logo图片
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;



//手机号注册
@property (weak, nonatomic) IBOutlet UIButton *phoneRegisterBtn;

//邮箱注册
@property (weak, nonatomic) IBOutlet UIButton *emailRegisterBtn;

//选中按钮的中间值
@property (nonatomic, strong) UIButton *selectedBtn;

//底部横线
@property (weak, nonatomic) IBOutlet UIView *lineView;

//注册内容类型ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *registerTypeScrollView;

//手机号注册
@property (weak, nonatomic) IBOutlet UIButton *areacodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;


@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTfd;


@property (weak, nonatomic) IBOutlet UIButton *getPhonecodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *phonePwdTfd;


@property (weak, nonatomic) IBOutlet UITextField *phoneSurePwdTfd;

//邮箱注册
@property (weak, nonatomic) IBOutlet UITextField *emailTfd;

@property (weak, nonatomic) IBOutlet UITextField *emailCodeTfd;


@property (weak, nonatomic) IBOutlet UIButton *getEmailcodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *emailPwdTfd;

@property (weak, nonatomic) IBOutlet UITextField *emailSurePwdTfd;

//协议
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;


@property (weak, nonatomic) IBOutlet UILabel *agreementLB;


//注册

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


//手机号注册计时器
@property (nonatomic, strong)NSTimer *phoneTimer;

//手机号注册倒计时秒数
@property (nonatomic, assign)NSInteger phoneDownCount;


//邮箱注册计时器
@property (nonatomic, strong)NSTimer *eamilTimer;

//邮箱注册倒计时秒数
@property (nonatomic, assign)NSInteger emailDownCount;


//正则表达式字符串
@property (nonatomic, copy) NSString *patternStr;

//区号
@property (nonatomic, copy) NSString *areaCodeStr;


@end

@implementation XMFRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}


-(void)setupUI{
    
    self.naviTitle = @"注册";
    
    self.topSpace.constant = kNavBarHeight;
    
    //设置按钮不同状态不同
    [CommonManager setButton:self.phoneRegisterBtn titleStr:@"手机号注册"];
    [CommonManager setButton:self.emailRegisterBtn titleStr:@"邮箱注册"];

    
    
    [self RegisterTypeBtnDidClick:self.phoneRegisterBtn];
    
    
    //协议富文本设置
    NSMutableAttributedString *upperAttriStr = [[NSMutableAttributedString alloc]initWithString:@"同意《用户协议》并注册"];
    
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
    
    
    [self.phoneCodeTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.emailCodeTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.phonePwdTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.phoneSurePwdTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.emailTfd setValue:@30 forKey:@"LimitInput"];
    
    [self.emailPwdTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.emailSurePwdTfd setValue:@6 forKey:@"LimitInput"];
    
    //绑定方法
    [self.emailTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.getEmailcodeBtn.enabled = NO;
    
    self.getEmailcodeBtn.alpha = 0.6;
    
    [self.phoneTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.getPhonecodeBtn.enabled = NO;
    
    self.getPhonecodeBtn.alpha = 0.6;
    
    //logo图片
    
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:[CommonManager getPlatformInfoModel].logoUrl] placeholderImage:[UIImage imageNamed:@"logo_signin"]];
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    //布局按钮
    
    CGFloat imageTitleSpace = 10;
    
    
    [self.areacodeBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imageTitleSpace];
    
    [self.lineView cornerWithRadius:self.lineView.height/2.0];
    
    [self.registerBtn cornerWithRadius:5.f];
    
    [self.getPhonecodeBtn cornerWithRadius:5.f];
    
    [self.getEmailcodeBtn cornerWithRadius:5.f];
    
    
}



//注册类型选择
- (IBAction)RegisterTypeBtnDidClick:(UIButton *)sender{
    
    if (sender != self.selectedBtn) {
        
        self.selectedBtn.selected = NO;
        
        sender.selected = YES;
        
        self.selectedBtn = sender;
        
    }else{
        
        self.selectedBtn.selected = YES;
    }
    
    //设置导航线
    self.lineView.centerX = self.selectedBtn.centerX;
    
    
    [self.registerTypeScrollView setContentOffset:CGPointMake(KScreenWidth * sender.tag, 0) animated:YES];

    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {

    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//区号选择
            
             
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
            
        case 1:{//发送手机验证码
            
            [self getPhoneCode];
            
        }
            break;
        case 2:{//发送邮箱验证码
            
            [self getEmailCode];
        }
            break;
        case 3:{//协议选择
            
            [self.view endEditing:YES];
            
             sender.selected = !sender.selected;
        }
            break;
        case 4:{//注册
            
            [self gotoRegister];
        }
            break;

            
        default:
            break;
    }
    
    
    

}


#pragma mark - ——————— YBAttributeTapActionDelegate文字可点击 ————————
-(void)yb_tapAttributeInLabel:(UILabel *)label string:(NSString *)string range:(NSRange)range index:(NSInteger)index{
    
    
//    NSLog(@"点击了协议");
    
//    [self.view makeToastOnCenter:@"点击了协议,等待提供协议"];
    
    NSString *aboutusURLStr = [NSString stringWithFormat:@"%@/client#/Serviceagreement",XMF_BASE_URL];
    
    XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
    
    VCtrl.urlStr = aboutusURLStr;
    
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}

#pragma mark 文本框字符变化时

- (void)textFieldDidChange:(UITextField *)textField{
    
    
    //手机
    if (textField == self.phoneTfd) {
        
        if (textField.text.length > 0) {
            
            
            self.getPhonecodeBtn.enabled = YES;
            
            self.getPhonecodeBtn.alpha = 1.0;
            
        }else{
            
            
            self.getPhonecodeBtn.enabled = NO;
            
            self.getPhonecodeBtn.alpha = 0.6;
            
        }
        
        
    }else if (textField == self.emailTfd){
        //邮箱
        
        if (textField.text.length > 0) {
            
            
            self.getEmailcodeBtn.enabled = YES;
            
            self.getEmailcodeBtn.alpha = 1.0;
            
        }else{
            
            
            self.getEmailcodeBtn.enabled = NO;
            
            self.getEmailcodeBtn.alpha = 0.6;
        }
        
        
        
    }
    
    
}




#pragma mark - ——————— 网络请求 ————————

//获取手机验证码
-(void)getPhoneCode{
    
    
      
      if (![self.phoneTfd.text isMatchPatternString:self.patternStr]) {
          
          [self.view makeToastOnCenter:XMFLI(@"请输入正确的手机号")];
          
          return;
          
      }
    
    
      
      
      NSDictionary *dic = @{
          
          @"mobileCode":self.areaCodeStr,
          
          @"userMobile": self.phoneTfd.text
          
      };
      
      kWeakSelf(self)
      
       self.getPhonecodeBtn.enabled = NO;
    
     [self.view endEditing:YES];

    
      [self.activityIndicator startAnimating];
      
      [XMFNetworking POSTWithURLContainParams:URL_verify_sms_unex_send Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
          
          DLog(@"发送手机验证码：%@",responseObject);
          
          [weakself.activityIndicator stopAnimating];
          
          if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
              
              weakself.phoneDownCount = 60;
              
              [weakself phoneRetextBtn];
              
              weakself.phoneTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(phoneRetextBtn) userInfo:nil repeats:YES];
              
              [weakself.phoneCodeTfd becomeFirstResponder];
              
              
              [weakself.view makeToastOnCenter:responseObjectModel.message];
              
              
          }else{
              
              
              weakself.getPhonecodeBtn.enabled = YES;


              [weakself.view makeToastOnCenter:responseObjectModel.message];
          }
          
          
      } failure:^(NSString * _Nonnull error) {
          
          weakself.getPhonecodeBtn.enabled = YES;

          [weakself.activityIndicator stopAnimating];
      }];
    
    
}

//根据计时器设置按钮
- (void)phoneRetextBtn{
    _phoneDownCount--;
    [_getPhonecodeBtn setTitle:[NSString stringWithFormat:@"%zds", _phoneDownCount] forState:UIControlStateNormal];
//    _getPhonecodeBtn.alpha = 0.6;
    
    if (_phoneDownCount <= 0) {
        _getPhonecodeBtn.enabled = YES;
        [_getPhonecodeBtn setTitle:XMFLI(@"发送验证码") forState:UIControlStateNormal];
//        _getPhonecodeBtn.alpha = 1.0;
        [_phoneTimer invalidate];
    }
}




//获取邮箱验证码
-(void)getEmailCode{
    
    
    if (![self.emailTfd.text isEmail]) {
        
        [self.view makeToastOnCenter:@"请输入正确的邮箱账号"];
        
        return;
        
    }
    
    
    NSDictionary *dic = @{
        
        @"userEmail":self.emailTfd.text
        
    };
    
    kWeakSelf(self)
    
     self.getEmailcodeBtn.enabled = NO;
    
    [self.view endEditing:YES];
    
    [self.activityIndicator startAnimating];
    
    [XMFNetworking POSTWithURLContainParams:URL_verify_mail_unex_send Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        DLog(@"发送邮箱验证码：%@",responseObject);
        
        [weakself.activityIndicator stopAnimating];
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            weakself.emailDownCount = 300;
            
            [weakself emailRetextBtn];
            
            weakself.eamilTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(emailRetextBtn) userInfo:nil repeats:YES];
            
            [weakself.emailCodeTfd becomeFirstResponder];
            
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];
            
            
        }else{
            
            
            weakself.getEmailcodeBtn.enabled = YES;
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];


        }
        
        
    } failure:^(NSString * _Nonnull error) {
        
        weakself.getEmailcodeBtn.enabled = YES;

        [weakself.activityIndicator stopAnimating];

    }];
    

    
}

//根据计时器设置按钮
- (void)emailRetextBtn{
    _emailDownCount--;
    [_getEmailcodeBtn setTitle:[NSString stringWithFormat:@"%zds", _emailDownCount] forState:UIControlStateNormal];
//    _getEmailcodeBtn.alpha = 0.6;
    
    if (_emailDownCount <= 0) {
        _getEmailcodeBtn.enabled = YES;
        [_getEmailcodeBtn setTitle:XMFLI(@"发送验证码") forState:UIControlStateNormal];
//        _getEmailcodeBtn.alpha = 1.0;
        [_eamilTimer invalidate];
    }
}


//注册
-(void)gotoRegister{
    
     [self.view endEditing:YES];
    
    switch (self.selectedBtn.tag) {
        case 0:{//手机号注册
            
            [self gotoPhoneRegister];
        }
            break;
            
        case 1:{//邮箱注册
            
            [self gotoEmailRegister];
        }
            break;
            
        default:
            break;
    }
    
}

//手机号注册
-(void)gotoPhoneRegister{
    
    
     if ([self.phoneTfd.text nullToString]) {
         
         [self.view makeToastOnCenter:XMFLI(@"请输入手机号")];
         
         return;
         
     }else if (![self.phoneTfd.text isMatchPatternString:self.patternStr]) {
         
         [self.view makeToastOnCenter:XMFLI(@"请输入正确的手机号")];
         
         return;
         
     }else if ([self.phoneCodeTfd.text nullToString]){
         
         [self.view makeToastOnCenter:XMFLI(@"请输入验证码")];
          
         return;
         
     }else if (![self.phonePwdTfd.text isValidPassword] || ![self.phoneSurePwdTfd.text isValidPassword]){
         
         [self.view makeToastOnCenter:XMFLI(@"请输入6位数字密码")];
         
         return;
         
     }else if (![self.phonePwdTfd.text isEqualToString:self.phoneSurePwdTfd.text]){
         
         
         [self.view makeToastOnCenter:XMFLI(@"请确认密码一致")];
         
         return;
         
         
     }else if (!self.agreementBtn.selected){
         
         [self.view makeToastOnCenter:XMFLI(@"请勾选协议")];
         
         return;
         
     }
    
    
    NSDictionary *dic = @{
        
        @"accountType":[CommonManager getAccountType],
                
        @"mobileCode":self.areaCodeStr,
        
        @"password":[CommonManager getEntryPwdWithMD5:self.phonePwdTfd.text],
        
        @"registerSource":@"小蜜蜂电商",
        
        @"userMobile":self.phoneTfd.text,
        
        @"verifyCode":self.phoneCodeTfd.text,
        
        @"verifyType":@"CODE"
        
        
    };
    
    kWeakSelf(self)
    
    [XMFNetworking POSTWithURLContainParams:URL_auth_register_mobile Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            DLog(@"手机注册：%@",responseObject);
            
            /**
             
             data =     {
                  createTime = 20200708160552;
                  expireTime = 20200709160552;
                  timestamp = "<null>";
                  token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxNTEyNTc3IiwiZXhwIjoxNTk0MjgxOTUyfQ.JyorHNT8fqg8pyp0KJLGTssD4euWmNCYC6TOaNH7kWE";
                  unionId = 1512577;
              }
             
             */
            
            
//           [weakself.view makeToastOnCenter:responseObjectModel.message];
            
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
        
    }];
    
    
    
    
    
}


//邮箱注册
-(void)gotoEmailRegister{
    
   
    if ([self.emailTfd.text nullToString]) {
        
        [self.view makeToastOnCenter:XMFLI(@"请输入邮箱账号")];
        
        return;
        
    }else if (![self.emailTfd.text isEmail]) {
        
        [self.view makeToastOnCenter:XMFLI(@"请输入正确的邮箱账号")];
        
        return;
        
        
    }else if ([self.emailCodeTfd.text nullToString]){
        
        [self.view makeToastOnCenter:XMFLI(@"请输入验证码")];
         
        return;
        
    }else if (![self.emailPwdTfd.text isValidPassword] || ![self.emailSurePwdTfd.text isValidPassword]){
        
        [self.view makeToastOnCenter:XMFLI(@"请输入6位数字密码")];
        
        return;
        
    }else if (![self.emailPwdTfd.text isEqualToString:self.emailSurePwdTfd.text]){
        
        
        [self.view makeToastOnCenter:XMFLI(@"请确认密码一致")];
        
        return;
        
        
    }else if (!self.agreementBtn.selected){
        
        [self.view makeToastOnCenter:XMFLI(@"请勾选协议")];
        
        return;
        
    }
    
    
    
    NSDictionary *dic = @{
        
        @"accountType":[CommonManager getAccountType],
        
        @"registerSource":@"小蜜蜂电商",
        
        @"userEmail":self.emailTfd.text,
        
        @"password":[CommonManager getEntryPwdWithMD5:self.emailPwdTfd.text],
        
        @"verifyCode":self.emailCodeTfd.text
        
        
    };
    
    kWeakSelf(self)
    
    [XMFNetworking POSTWithURLContainParams:URL_auth_register_email Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            DLog(@"邮箱注册：%@",responseObject);
            
            /**
             
             data =     {
                  createTime = 20200708160552;
                  expireTime = 20200709160552;
                  timestamp = "<null>";
                  token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxNTEyNTc3IiwiZXhwIjoxNTk0MjgxOTUyfQ.JyorHNT8fqg8pyp0KJLGTssD4euWmNCYC6TOaNH7kWE";
                  unionId = 1512577;
              }
             
             
             */
            
            
//          [weakself.view makeToastOnCenter:responseObjectModel.message];
            
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
