//
//  XMFBindPhoneController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/28.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBindPhoneController.h"
#import "XMFSelectAreaCodeView.h"//区号选择


@interface XMFBindPhoneController ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


//手机号绑定
@property (weak, nonatomic) IBOutlet UIButton *areacodeBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;


@property (weak, nonatomic) IBOutlet UITextField *phoneCodeTfd;


@property (weak, nonatomic) IBOutlet UIButton *getPhonecodeBtn;



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


@end

@implementation XMFBindPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}


-(void)setupUI{
    
    self.naviTitle = @"绑定手机号";
    
    self.topSpace.constant = kNavBarHeight;

    
    //默认中国大陆86
    self.areaCodeStr = @"86";

    self.patternStr = @"^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(19[0-9]{1})|(17[0-9]{1})|(14[4-7]{1})|(16[0-9]{1}))+\\d{8})$";
    
    [self.phoneTfd setValue:@11 forKey:@"LimitInput"];
    
    
    [self.phoneCodeTfd setValue:@6 forKey:@"LimitInput"];
    
    
    [self.phoneTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.getPhonecodeBtn.enabled = NO;
    
    self.getPhonecodeBtn.alpha = 0.6;
    
}


-(void)popAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    //布局按钮
    
    CGFloat imageTitleSpace = 10;
    
    
    [self.areacodeBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imageTitleSpace];
    
    
    [self.sureBtn cornerWithRadius:5.f];
    
    [self.getPhonecodeBtn cornerWithRadius:5.f];
    
    
    
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


        case 2:{//确定
            
            [self gotoPhoneBind];
            
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
        
        
    }
    
    
}


#pragma mark - ——————— 网络请求 ————————

//获取手机验证码
-(void)getPhoneCode{
    
  
    [self.view endEditing:YES];

    
    if (![self.phoneTfd.text isMatchPatternString:self.patternStr]) {
        
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入正确的手机号")];
        
        return;
        
    }
    
    
    
    NSDictionary *dic = @{
        
        @"userMobile":self.phoneTfd.text,
        @"mobileCode":self.areaCodeStr
        
    };
    
    self.getPhonecodeBtn.enabled = NO;
    
    
    [MBProgressHUD showOnlyLoadToView:self.view];
 
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_bind_captcha parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取验证码：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];

        //成功时候返回的data是字符串
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess && [responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
            self.phoneDownCount = 60;
            
            [self phoneRetextBtn];
            
            self.phoneTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(phoneRetextBtn) userInfo:nil repeats:YES];
            
            [self.phoneCodeTfd becomeFirstResponder];
            
            
            
        }else{
            
            //失败时候返回的data是字典
            
            self.getPhonecodeBtn.enabled = YES;
        
            [self.view endEditing:YES];
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
         self.getPhonecodeBtn.enabled = YES;
        
        [MBProgressHUD hideHUDForView:self.view];

        
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

    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_bind_phone parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"绑定手机%@",responseObject);
        
        [MBProgressHUD hideHUDForView:self.view];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
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
