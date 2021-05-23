//
//  XMFThirdBindController.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/30.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFThirdBindController.h"
#import "XMFSelectAreaCodeView.h"//区号选择
#import "XMFSetPwdController.h"


@interface XMFThirdBindController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

//logo图片
@property (weak, nonatomic) IBOutlet UIImageView *logoImgView;



//手机号绑定
@property (weak, nonatomic) IBOutlet UIButton *phoneBindBtn;

//邮箱绑定
@property (weak, nonatomic) IBOutlet UIButton *emailBindBtn;

//选中按钮的中间值
@property (nonatomic, strong) UIButton *selectedBtn;

//底部横线
@property (weak, nonatomic) IBOutlet UIView *lineView;

//账号绑定类型ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *thirdBindTypeScrollView;

//手机号绑定
@property (weak, nonatomic) IBOutlet UIButton *areacodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;


@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTfd;


@property (weak, nonatomic) IBOutlet UIButton *getPhonecodeBtn;




//邮箱绑定
@property (weak, nonatomic) IBOutlet UITextField *emailTfd;

@property (weak, nonatomic) IBOutlet UITextField *emailCodeTfd;


@property (weak, nonatomic) IBOutlet UIButton *getEmailcodeBtn;


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

//第三方用户信息
@property (nonatomic, strong) NSMutableDictionary *userInfo;


@end

@implementation XMFThirdBindController


//自定义创建方法：传入第三方用户信息的字典
-(instancetype)initWithDic:(NSMutableDictionary *)userInfoDic{
    
    
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
    
    self.naviTitle = @"绑定账号";
    
    self.topSpace.constant = kNavBarHeight;
    
    
    //设置按钮不同状态不同
    [CommonManager setButton:self.phoneBindBtn titleStr:@"绑定手机号"];
    [CommonManager setButton:self.emailBindBtn titleStr:@"绑定邮箱"];
    
    [self thirdBindTypeBtnDidClick:self.phoneBindBtn];
    
    //默认中国大陆86
    self.areaCodeStr = @"86";

    self.patternStr = @"^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(19[0-9]{1})|(17[0-9]{1})|(14[4-7]{1})|(16[0-9]{1}))+\\d{8})$";
    
    [self.phoneTfd setValue:@11 forKey:@"LimitInput"];
    
    
    [self.phoneCodeTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.emailTfd setValue:@30 forKey:@"LimitInput"];
    
    [self.emailCodeTfd setValue:@6 forKey:@"LimitInput"];
    
    
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
    
    [self.sureBtn cornerWithRadius:5.f];
    
    [self.getPhonecodeBtn cornerWithRadius:5.f];
    
    [self.getEmailcodeBtn cornerWithRadius:5.f];
    
    
}



//账号绑定类型选择
- (IBAction)thirdBindTypeBtnDidClick:(UIButton *)sender {
    
    if (sender != self.selectedBtn) {
        
        self.selectedBtn.selected = NO;
        
        sender.selected = YES;
        
        self.selectedBtn = sender;
        
    }else{
        
        self.selectedBtn.selected = YES;
    }
    
    //设置导航线
    self.lineView.centerX = self.selectedBtn.centerX;
    
    
    [self.thirdBindTypeScrollView setContentOffset:CGPointMake(KScreenWidth * sender.tag, 0) animated:YES];

    
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
            
            [self gotoBind];
            
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
    
      [self.activityIndicator startAnimating];

      [self.view endEditing:YES];

      
      [XMFNetworking POSTWithURLContainParams:URL_verify_sms_oauth_send Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
          
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
    
    [self.activityIndicator startAnimating];
    
    [self.view endEditing:YES];

    
    [XMFNetworking POSTWithURLContainParams:URL_verify_mail_oauth_send Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
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
-(void)gotoBind{
    
     [self.view endEditing:YES];
    
    switch (self.selectedBtn.tag) {
        case 0:{//手机号绑定
            
            [self gotoPhoneBind];
        }
            break;
            
        case 1:{//邮箱绑定
            
            [self gotoEmailBind];
        }
            break;
            
        default:
            break;
    }
    
}

//手机号绑定
-(void)gotoPhoneBind{
    
    
     if ([self.phoneTfd.text nullToString]) {
         
         [self.view makeToastOnCenter:XMFLI(@"请输入手机号")];
         
         return;
         
     }else if (![self.phoneTfd.text isMatchPatternString:self.patternStr]) {
         
         [self.view makeToastOnCenter:XMFLI(@"请输入正确的手机号")];
         
         return;
         
     }else if ([self.phoneCodeTfd.text nullToString]){
         
         [self.view makeToastOnCenter:XMFLI(@"请输入验证码")];
          
         return;
         
     }
    
    
    NSDictionary *dic = @{
                        
        @"mobileCode":self.areaCodeStr,
                        
        @"userMobile":self.phoneTfd.text,
        
        @"verifyCode":self.phoneCodeTfd.text
        
        
    };
    
    kWeakSelf(self)
    
    [self.activityIndicator startAnimating];

    
    [XMFNetworking POSTWithURLContainParams:URL_verify_sms_oauth_check Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"检测手机是否绑定：%@",responseObject);
        
        [weakself.activityIndicator stopAnimating];

        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
     
            /**
             
             {
                 bindedFlag = 1;
                 checkedIdx = kcDe6Fg5VyaM3IkNTwp0OrZ3eHFPc9oL6kIf;
                 timestamp = "<null>";
             }
             
             */
            
            //bindedFlag:0 是新用户直接绑定 1 是老用户绑定过第三方弹出提示框;
            
            NSString *bindedFlagStr = [NSString stringWithFormat:@"%@",responseObjectModel.data[@"bindedFlag"]];
            
            //bindedFlag=0时NNEW
            //bindedFlag=1：用户选择新用户时ENEW 用户选择绑定到旧帐号时EOLD
            if ([bindedFlagStr isEqualToString:@"1"]) {
          
                        
                jxt_showAlertTwoButton(XMFLI(@"提示"), XMFLI(@"该手机号已经注册！"), XMFLI(@"关联旧手机"), ^(NSInteger buttonIndex) {
                    
                    
                     [weakself.userInfo setValue:@"EOLD" forKey:@"createType"];
                     
                     [weakself.userInfo setValue:[NSString stringWithFormat:@"%@",responseObjectModel.data[@"checkedIdx"]] forKey:@"checkedIdx"];
                     
                     //                    前置安全验证类型（授权登录后绑定关键字段的类型；EMAL：邮箱绑定，MOBS=手机绑定
                     [weakself.userInfo setValue:@"MOBS" forKey:@"checkedType"];
                     
                     //手机号码等
                     [weakself.userInfo setValue:weakself.areaCodeStr forKey:@"mobileCode"];
                     
                     [weakself.userInfo setValue:weakself.phoneTfd.text forKey:@"userMobile"];
                     
                     
                     [weakself gotoThirdBindLogin];
                    
                    
                }, XMFLI(@"绑定新手机") , ^(NSInteger buttonIndex) {
                    
                    //其实这个ENEW目前逻辑是不会用到
                    [weakself.userInfo setValue:@"ENEW" forKey:@"createType"];
                    
                    [weakself resetPhoneBindUI];
                    
                });
            
            
            }else if ([bindedFlagStr isEqualToString:@"0"]){
                
                [weakself.userInfo setValue:@"NNEW" forKey:@"createType"];
                
                [weakself.userInfo setValue:[NSString stringWithFormat:@"%@",responseObjectModel.data[@"checkedIdx"]] forKey:@"checkedIdx"];
                                    
                //                    前置安全验证类型（授权登录后绑定关键字段的类型；EMAL：邮箱绑定，MOBS=手机绑定
                [weakself.userInfo setValue:@"MOBS" forKey:@"checkedType"];
                
                //手机号码等
                [weakself.userInfo setValue:weakself.areaCodeStr forKey:@"mobileCode"];
                
                [weakself.userInfo setValue:weakself.phoneTfd.text forKey:@"userMobile"];
                
                
                //设置密码
                XMFSetPwdController  *VCtrl = [[XMFSetPwdController alloc]initWithUserInfo:[weakself.userInfo mutableCopy]];
                
                [weakself.navigationController pushViewController:VCtrl animated:YES];
                
                
            }
        
            
        }else{
            
            [weakself.view makeToastOnCenter:responseObjectModel.message];
        }
        
        
        
    } failure:^(NSString * _Nonnull error) {
        
        [weakself.activityIndicator stopAnimating];

        
        
    }];

}



//邮箱绑定
-(void)gotoEmailBind{
    
   
   if ([self.emailTfd.text nullToString]) {
        
        [self.view makeToastOnCenter:XMFLI(@"请输入邮箱账号")];
        
        return;
        
    }else if (![self.emailTfd.text isEmail]) {
        
        [self.view makeToastOnCenter:XMFLI(@"请输入正确的邮箱账号")];
        
        return;
        
        
    }else if ([self.emailCodeTfd.text nullToString]){
        
        [self.view makeToastOnCenter:XMFLI(@"请输入验证码")];
         
        return;
        
    }
    
    NSDictionary *dic = @{
                
        @"userEmail":self.emailTfd.text,
                
        @"verifyCode":self.emailCodeTfd.text
        
        
    };
    
    kWeakSelf(self)
    
    [self.activityIndicator startAnimating];

    
    [XMFNetworking POSTWithURLContainParams:URL_verify_mail_oauth_check Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
            
            
            DLog(@"检测邮箱是否绑定：%@",responseObject);
        
        [weakself.activityIndicator stopAnimating];

            
            if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
         
                /**
                 
                 {
                     bindedFlag = 1;
                     checkedIdx = kcDe6Fg5VyaM3IkNTwp0OrZ3eHFPc9oL6kIf;
                     timestamp = "<null>";
                 }
                 
                 */
                
                //bindedFlag:0 是新用户直接绑定 1 是老用户绑定过第三方弹出提示框;
                
                NSString *bindedFlagStr = [NSString stringWithFormat:@"%@",responseObjectModel.data[@"bindedFlag"]];
                
                //bindedFlag=0时NNEW
                //bindedFlag=1：用户选择新用户时ENEW 用户选择绑定到旧帐号时EOLD
                if ([bindedFlagStr isEqualToString:@"1"]) {
                    
                    
                    jxt_showAlertTwoButton(XMFLI(@"提示"), XMFLI(@"该邮箱账号已经注册！"), XMFLI(@"关联旧邮箱"), ^(NSInteger buttonIndex) {
                        
                        
                        [weakself.userInfo setValue:@"EOLD" forKey:@"createType"];
                        
                        [weakself.userInfo setValue:[NSString stringWithFormat:@"%@",responseObjectModel.data[@"checkedIdx"]] forKey:@"checkedIdx"];
                        
                        //                    前置安全验证类型（授权登录后绑定关键字段的类型；EMAL：邮箱绑定，MOBS=手机绑定
                        [weakself.userInfo setValue:@"EMAL" forKey:@"checkedType"];
                        
                        //邮箱等
                        [weakself.userInfo setValue:weakself.emailTfd.text forKey:@"userEmail"];
                        
                        
                        [weakself gotoThirdBindLogin];
                        
                        
                    }, XMFLI(@"绑定新邮箱")  , ^(NSInteger buttonIndex) {
                        
                        //其实这个ENEW目前逻辑是不会用到
                        [weakself.userInfo setValue:@"ENEW" forKey:@"createType"];
                        
                        [weakself resetEmaiBindUI];
                        
                    });
                    

                    
                }else if ([bindedFlagStr isEqualToString:@"0"]){
                    
                    [weakself.userInfo setValue:@"NNEW" forKey:@"createType"];
                    
                    [weakself.userInfo setValue:[NSString stringWithFormat:@"%@",responseObjectModel.data[@"checkedIdx"]] forKey:@"checkedIdx"];
                    
                    //                    前置安全验证类型（授权登录后绑定关键字段的类型；EMAL：邮箱绑定，MOBS=手机绑定
                    [weakself.userInfo setValue:@"EMAL" forKey:@"checkedType"];
                    
                    //邮箱等
                    [weakself.userInfo setValue:weakself.emailTfd.text forKey:@"userEmail"];
                    
                    
                    //设置密码
                    XMFSetPwdController  *VCtrl = [[XMFSetPwdController alloc]initWithUserInfo:[weakself.userInfo mutableCopy]];
                    
                    [weakself.navigationController pushViewController:VCtrl animated:YES];
                    
                    
                }
            
                
            }else{
                
                [weakself.view makeToastOnCenter:responseObjectModel.message];
            }
            
            
            
        } failure:^(NSString * _Nonnull error) {
        
        
            [weakself.activityIndicator stopAnimating];

        
    }];
    

}


//重置绑定手机号相关UI
-(void)resetPhoneBindUI{
    
    [self.phoneTimer invalidate];
    
    [self.getPhonecodeBtn setTitle:XMFLI(@"发送验证码") forState:UIControlStateNormal];
    
    self.getPhonecodeBtn.enabled = YES;
    
    self.phoneTfd.text = @"";
    
    self.phoneCodeTfd.text = @"";
    
    
}

//重置绑定手机号相关UI
-(void)resetEmaiBindUI{
    
    [self.eamilTimer invalidate];
    
    [self.getEmailcodeBtn setTitle:XMFLI(@"发送验证码") forState:UIControlStateNormal];
    
    self.getEmailcodeBtn.enabled = YES;
    
    self.emailTfd.text = @"";
    
    self.emailCodeTfd.text = @"";
    
    
}


//第三方授权登录
-(void)gotoThirdBindLogin{
    
    
    NSDictionary *dic = @{
        
        @"accountType":[CommonManager getAccountType],
        
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
