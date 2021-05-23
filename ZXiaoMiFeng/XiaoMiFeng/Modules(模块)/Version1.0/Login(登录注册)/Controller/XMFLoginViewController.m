//
//  XMFLoginViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFLoginViewController.h"
#import "XMFRegisterViewController.h"//注册
#import "XMFForgetPwdController.h"//忘记密码
#import "ZFPickerView.h"//区号选择
#import "XMFSelectAreaView.h"//区号选择
#import "XMFAreaCode.h"//地区区号model


@interface XMFLoginViewController ()<ZFPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


@property (weak, nonatomic) IBOutlet UIButton *mainlandBtn;


@property (weak, nonatomic) IBOutlet UIButton *HongKongBtn;


@property (weak, nonatomic) IBOutlet UIButton *othersBtn;


//选中按钮的中间值
@property (nonatomic, strong) UIButton *selectedBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;



@property (weak, nonatomic) IBOutlet UITextField *pwdTfd;



@property (weak, nonatomic) IBOutlet UITextField *codeTfd;


@property (weak, nonatomic) IBOutlet UIButton *codeBtn;


@property (weak, nonatomic) IBOutlet UIButton *loginBtn;



@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

//验证码
@property (nonatomic, copy) NSString *codeKeyStr;

@property (nonatomic, copy) NSString *codeStr;

//区号
@property (nonatomic, copy) NSString *areaCodeStr;

//区号选择
@property (nonatomic, strong)ZFPickerView *areaPicker;

@property (nonatomic, strong)NSMutableArray *areaArray;

//地区model数组
@property (nonatomic, strong) NSMutableArray<XMFAreaCode *> *areaModelArr;

//正则表达式字符串
@property (nonatomic, copy) NSString *patternStr;



@end

@implementation XMFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.codeBtn cornerWithRadius:5.f];
    
    [self.loginBtn cornerWithRadius:5.f];
    
    
}


-(void)setupUI{
    
    
    self.topSpace.constant = kTopHeight;
    
    self.naviTitle = XMFLI(@"登录");
    
    //默认选中中国大陆
    
    [self selectAreaBtnsDidClick:self.mainlandBtn];
    
    
    [self getCode];
    
    [self getAreaCode];
    
    [self.view addSubview:self.areaPicker];
    
    //限制位数
    
    [self.codeTfd setValue:@4 forKey:@"LimitInput"];
    
    [self.pwdTfd setValue:@6 forKey:@"LimitInput"];
    
    
}

-(void)popAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


//选择地区的按钮被点击
- (IBAction)selectAreaBtnsDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//中国大陆
            
            self.areaCodeStr = @"+86";
            
            self.patternStr = @"^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(19[0-9]{1})|(17[0-9]{1})|(14[4-7]{1})|(16[0-9]{1}))+\\d{8})$";
            
            [self.phoneTfd setValue:@11 forKey:@"LimitInput"];
            
            if (self.phoneTfd.text.length > 11) {
                
                self.phoneTfd.text =  [self.phoneTfd.text substringWithRange: NSMakeRange(0, 11)];
            }
            
            
            
        }
            break;
        case 1:{//香港
            
             self.areaCodeStr = @"+852";
            
             self.patternStr = @"^([5|6|8|9])\\d{7}$";
                       
             [self.phoneTfd setValue:@8 forKey:@"LimitInput"];
            
            
            if (self.phoneTfd.text.length > 8) {
                
                self.phoneTfd.text =  [self.phoneTfd.text substringWithRange: NSMakeRange(0, 8)];
            }
            
//            self.phoneTfd.text = @"";
            
        }
            break;
        case 2:{//其他
            
            [self.view endEditing:YES];
            
            if (self.areaModelArr.count <= 0) {
                
                [self getAreaCode];
                
                return;
            }
            
            //只有当为大陆和香港区号的时候置空
            if ([self.areaCodeStr isEqualToString:@"+86"] || [self.areaCodeStr isEqualToString:@"+852"]) {
                
                self.areaCodeStr = @"";
            }
            
            
            XMFSelectAreaView *areaView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFSelectAreaView class]) owner:nil options:nil] firstObject];
            
            //数组传递
            areaView.areaArr = [self.areaModelArr copy];
            
            
            areaView.selectedAreaBlock = ^(XMFAreaCode * _Nonnull areaModel) {
                
                weakself.areaCodeStr = areaModel.areaCode;
                
            };
            
            [areaView show];
            
            /*
            if (!_areaArray) {
                
                [self getAreaCode];
                
                return;
            }
            
            //置空
            self.areaCodeStr = @"";
            
            _areaPicker.dataArray = _areaArray;
            
            [_areaPicker show];
             
             */
            
            self.patternStr = @"[0-9]*";
            
            [self.phoneTfd setValue:@15 forKey:@"LimitInput"];
            
            if (self.phoneTfd.text.length > 15) {
                
                self.phoneTfd.text =  [self.phoneTfd.text substringWithRange: NSMakeRange(0, 15)];
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    if (sender != self.selectedBtn) {
        
        self.selectedBtn.selected = NO;
        
        sender.selected = YES;
        
        self.selectedBtn = sender;
        
    }else{
        
        self.selectedBtn.selected = YES;
    }
    
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    switch (sender.tag) {
            
        case 0:{//登录
            
            
            [self login];
            
            
        }
            
            break;
            
        case 1:{//用户注册
            
            XMFRegisterViewController  *VCtrl = [[XMFRegisterViewController alloc]init];
                       
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            
            break;
            
        case 2:{//忘记密码
            
            XMFForgetPwdController  *VCtrl = [[XMFForgetPwdController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            
            break;
            
        case 3:{//切换验证码
            
              [self getCode];
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - ——————— ZFPickerView的代理方法 ————————
-(void)selectZFPickerViewTag:(NSInteger)tag index:(NSInteger)index{
    
    NSDictionary *seletedDic = self.areaArray[index];
    
    self.areaCodeStr = [NSString stringWithFormat:@"%@",seletedDic[@"areaCode"]];
    

    
}


#pragma mark - ——————— 网络请求 ————————

//获取验证码
-(void)getCode{
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_auth_getCode parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
         DLog(@"请求验证码：%@",[responseObject description]);
    
        
       //请求的头部信息；（我们执行网络请求的时候给服务器发送的包头信息）
       DLog(@"originalRequest请求的头部信息:%@",operation.originalRequest.allHTTPHeaderFields);
       
       DLog(@"currentRequest请求的头部信息:%@",operation.currentRequest.allHTTPHeaderFields);
        
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.response;
            NSDictionary *allHeaders = response.allHeaderFields;
            DLog(@"响应--%@\n响应头--%@",response,allHeaders);
        
      
        
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            self.codeKeyStr = responseObjectModel.data[@"key"];
            
            self.codeStr = responseObjectModel.data[@"code"];
            
            [self.codeBtn setTitle:self.codeStr forState:UIControlStateNormal];
            
        }else{
            
             [MBProgressHUD showOnlyTextToView:self.view title:responseObjectModel.kerrmsg];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];

}

//登录
-(void)login{
    
    [self.view endEditing:YES];
    
    kWeakSelf(self)
    
    if (![self.phoneTfd.text isMatchPatternString:self.patternStr] || [self.phoneTfd.text nullToString]) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入正确的手机号")];
        return;
        
    }else if ([self.pwdTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入密码")];
        return;
        
    }else if ([self.codeTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入验证码")];
        return;
        
    }else if ([self.areaCodeStr nullToString]){
        

        
        if (self.areaModelArr.count <= 0) {
            
            [self getAreaCode];
            
            return;
        }
        
        //只有当为大陆和香港区号的时候置空
        if ([self.areaCodeStr isEqualToString:@"+86"] || [self.areaCodeStr isEqualToString:@"+852"]) {
            
            self.areaCodeStr = @"";
        }
        
        
        XMFSelectAreaView *areaView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFSelectAreaView class]) owner:nil options:nil] firstObject];
        
        //数组传递
        areaView.areaArr = [self.areaModelArr copy];
        
        
        areaView.selectedAreaBlock = ^(XMFAreaCode * _Nonnull areaModel) {
            
            weakself.areaCodeStr = areaModel.areaCode;
            
        };
        
        [areaView show];
        
        [MBProgressHUD showOnlyTextToView:areaView title:XMFLI(@"请选择地区")];
        
        
        return;
        
    }
    
    
    
    
    NSDictionary *dic = @{
        
        @"phone":self.phoneTfd.text,
        @"password":self.pwdTfd.text,
        @"code":self.codeTfd.text,
        @"key":self.codeKeyStr,
        @"areaCode":self.areaCodeStr
                        
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_login parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"登录：%@",[responseObject description]);
  
        
        [MBProgressHUD hideHUDForView:self.view];
        
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSDictionary *userInfoDic = responseObjectModel.data[@"userInfo"];
            
            //保存用户信息
            [UserInfoManager updateUserInfo:userInfoDic];
            
            //单独保存token
            [UserInfoManager updateValue:responseObjectModel.data[@"token"] forKey:@"token"];
            
            //单独保存tokenExpire
            [UserInfoManager updateValue:responseObjectModel.data[@"tokenExpire"] forKey:@"tokenExpire"];
            
            
            DLog(@"token:%@",UserInfoModel.token);
            
            DLog(@"nicheng:%@",UserInfoModel.nickName);
            
            [self popAction];
            
            //选中首页
            XMFBaseUseingTabarController *tabBarVc = (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
            
            tabBarVc.selectedIndex = 0;
            
            
            //登录成功发送通知
            KPostNotification(KPost_LoginStatusChange_Notice_NeedLoginStatus_LoginStatusHasChanged, @YES, nil);
            
            
        
        }else if (responseObjectModel.kerrno == 901){//验证码已过期,请刷新验证码
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
            self.codeTfd.text = @"";
            
            [self getCode];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        
    }];
    
}

//获取国际手机号区号
-(void)getAreaCode{
    
    
    NSDictionary *dic = @{
        
        @"condition":@""
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_phoneAreaCode parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取区号：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
//            self.areaArray = (NSMutableArray *)responseObjectModel.data;
            
            self.areaArray = responseObject[@"data"];
            
            NSArray *dataArr = responseObject[@"data"];
            
            [self.areaModelArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFAreaCode *areaModel = [XMFAreaCode yy_modelWithDictionary:dic];
                
                [self.areaModelArr addObject:areaModel];
                
                
            }

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


#pragma mark - ——————— 懒加载 ————————
-(ZFPickerView *)areaPicker{
    
    if (_areaPicker == nil) {
        
        _areaPicker = [[ZFPickerView alloc] init];
        
        _areaPicker.delegate = self;
    }
    
    return _areaPicker;
    
}

-(NSMutableArray *)areaArray{
    
    if (_areaArray == nil) {
        _areaArray = [[NSMutableArray alloc] init];
    }
    return _areaArray;
}

-(NSMutableArray<XMFAreaCode *> *)areaModelArr{
    
    if (_areaModelArr == nil) {
        _areaModelArr = [[NSMutableArray alloc] init];
    }
    return _areaModelArr;
    
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
