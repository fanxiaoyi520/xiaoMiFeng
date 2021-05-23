//
//  XMFForgetPasswdController.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/15.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFForgetPasswdController.h"
#import "XMFSelectAreaCodeView.h"//区号选择


@interface XMFForgetPasswdController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

//logo图片
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;


//手机号找回
@property (weak, nonatomic) IBOutlet UIButton *phoneFindBtn;

//邮箱找回
@property (weak, nonatomic) IBOutlet UIButton *emailFindBtn;

//选中按钮的中间值
@property (nonatomic, strong) UIButton *selectedBtn;

//底部横线
@property (weak, nonatomic) IBOutlet UIView *lineView;

//注册内容类型ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *findPwdTypeScrollView;

//手机号找回
@property (weak, nonatomic) IBOutlet UIButton *areacodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;


@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTfd;


@property (weak, nonatomic) IBOutlet UIButton *getPhonecodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *phonePwdTfd;


@property (weak, nonatomic) IBOutlet UITextField *phoneSurePwdTfd;

//邮箱找回
@property (weak, nonatomic) IBOutlet UITextField *emailTfd;

@property (weak, nonatomic) IBOutlet UITextField *emailCodeTfd;


@property (weak, nonatomic) IBOutlet UIButton *getEmailcodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *emailPwdTfd;

@property (weak, nonatomic) IBOutlet UITextField *emailSurePwdTfd;


//确定

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


//正则表达式字符串
@property (nonatomic, copy) NSString *patternStr;

//区号
@property (nonatomic, copy) NSString *areaCodeStr;

//手机号注册计时器
@property (nonatomic, strong)NSTimer *phoneTimer;

//手机号注册倒计时秒数
@property (nonatomic, assign)NSInteger phoneDownCount;


//邮箱注册计时器
@property (nonatomic, strong)NSTimer *eamilTimer;

//邮箱注册倒计时秒数
@property (nonatomic, assign)NSInteger emailDownCount;

@end

@implementation XMFForgetPasswdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = @"忘记密码";
    
    self.topSpace.constant = kNavBarHeight;
    
    
    //设置按钮不同状态不同
    [CommonManager setButton:self.phoneFindBtn titleStr:@"手机号找回"];
    [CommonManager setButton:self.emailFindBtn titleStr:@"邮箱找回"];
    
    [self findPwdTypeBtnDidClick:self.phoneFindBtn];
    
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
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    //布局按钮
    
    CGFloat imageTitleSpace = 10;
    
    
    [self.areacodeBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imageTitleSpace];
    
    [self.lineView cornerWithRadius:self.lineView.height/2.0];
    
    [self.sureBtn cornerWithRadius:5.f];
    
    [self.getPhonecodeBtn cornerWithRadius:5.f];
    
    [self.getEmailcodeBtn cornerWithRadius:5.f];
    
    
    //logo图片
    
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:[CommonManager getPlatformInfoModel].logoUrl] placeholderImage:[UIImage imageNamed:@"logo_signin"]];
}



//密码找回类型选择
- (IBAction)findPwdTypeBtnDidClick:(UIButton *)sender {
    
    if (sender != self.selectedBtn) {
        
        self.selectedBtn.selected = NO;
        
        sender.selected = YES;
        
        self.selectedBtn = sender;
        
    }else{
        
        self.selectedBtn.selected = YES;
    }
    
    //设置导航线
    self.lineView.centerX = self.selectedBtn.centerX;
    
    
    [self.findPwdTypeScrollView setContentOffset:CGPointMake(KScreenWidth * sender.tag, 0) animated:YES];

    
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

        case 3:{//确定
            
            [self gotoFindPwd];
            
        }
            break;

            
        default:
            break;
    }
    
    
    

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
    
      [XMFNetworking POSTWithURLContainParams:URL_verify_sms_onex_send Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
          
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
    
    [XMFNetworking POSTWithURLContainParams:URL_verify_mail_onex_send Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
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
-(void)gotoFindPwd{
    
     [self.view endEditing:YES];
    
    switch (self.selectedBtn.tag) {
        case 0:{//手机号找回
            
            [self gotoPhoneFindPwd];
        }
            break;
            
        case 1:{//邮箱找回
            
            [self gotoEmailFindPwd];
        }
            break;
            
        default:
            break;
    }
    
}

//手机号找回
-(void)gotoPhoneFindPwd{
    
    
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
         
         
     }
    
    
    NSDictionary *dic = @{
        
                
        @"mobileCode":self.areaCodeStr,
        
        @"newPassword":[CommonManager getEntryPwdWithMD5:self.phonePwdTfd.text],
                
        @"userMobile":self.phoneTfd.text,
        
        @"verifyCode":self.phoneCodeTfd.text
        
        
    };
    
    
    kWeakSelf(self)
    
    [self.activityIndicator startAnimating];
    
    [XMFNetworking POSTWithURLContainParams:URL_option_password_reset_sms Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        DLog(@"手机号找回密码：%@",responseObject);
        
        [weakself.activityIndicator stopAnimating];
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
        
          [weakself popAction];
            
          [weakself.view makeToastOnCenter:responseObjectModel.message];
            
        }else{
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];
        }
        
        
        
    } failure:^(NSString * _Nonnull error) {
        
        [weakself.activityIndicator stopAnimating];

        
    }];
    
    
    
    
    
}


//邮箱号找回
-(void)gotoEmailFindPwd{
    
   
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
        
        
    }
    
    
    
    NSDictionary *dic = @{
        
        
        @"userEmail":self.emailTfd.text,
        
        @"newPassword":[CommonManager getEntryPwdWithMD5:self.emailPwdTfd.text],
        
        @"verifyCode":self.emailCodeTfd.text
        
        
    };
    
    
    kWeakSelf(self)
    
    [self.activityIndicator startAnimating];
    
    [XMFNetworking POSTWithURLContainParams:URL_option_password_reset_mail Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        [weakself.activityIndicator stopAnimating];

        DLog(@"邮箱号找回密码：%@",responseObject);

        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
                        
          [weakself popAction];
            
         
          [kAppWindow makeToastOnCenter:responseObjectModel.message];
            
            
        }else{
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];
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
