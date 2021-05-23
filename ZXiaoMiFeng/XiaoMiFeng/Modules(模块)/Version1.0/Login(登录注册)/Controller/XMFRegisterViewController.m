//
//  XMFRegisterViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFRegisterViewController.h"
#import "XMFSureRegisterController.h"
#import "XMFSelectAreaView.h"//区号选择
#import "XMFAreaCode.h"//地区区号model


@interface XMFRegisterViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (weak, nonatomic) IBOutlet UIButton *mainlandBtn;

@property (weak, nonatomic) IBOutlet UIButton *HongKongBtn;


@property (weak, nonatomic) IBOutlet UIButton *othersBtn;


@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;



@property (weak, nonatomic) IBOutlet UITextField *nameTfd;


@property (weak, nonatomic) IBOutlet UITextField *codeTfd;


@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;



@property (weak, nonatomic) IBOutlet UIButton *nextBtn;


//选中按钮的中间值
@property (nonatomic, strong) UIButton *selectedBtn;


//验证码

@property (nonatomic, copy) NSString *codeStr;

//区号
@property (nonatomic, copy) NSString *areaCodeStr;


//计时器
@property (nonatomic, strong)NSTimer *timer;

//倒计时秒数
@property (nonatomic, assign)NSInteger downCount;

//正则表达式字符串
@property (nonatomic, copy) NSString *patternStr;

//地区model数组
@property (nonatomic, strong) NSMutableArray<XMFAreaCode *> *areaModelArr;

@end

@implementation XMFRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}


-(void)setupUI{
    
    self.naviTitle = @"注册";
    
    self.topSpace.constant = kTopHeight;
    
    
    //默认选中中国大陆
   
    [self selectAreaBtnsDidClick:self.mainlandBtn];
    
    [self getAreaCode];
        
    
    //限制位数
    
    [self.codeTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.nameTfd setValue:@20 forKey:@"LimitInput"];
    
    self.getCodeBtn.enabled = NO;
    
    self.getCodeBtn.alpha = 0.6;
    
    //textfield改变的通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.phoneTfd];
    
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.getCodeBtn cornerWithRadius:5.f];
    
    [self.nextBtn cornerWithRadius:5.f];
    
    
}

-(void)dealloc{
    
    
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
            
        case 0:{//发送验证码
            
            [self getCode];
            
        }
            
            break;
            
        case 1:{//下一步
                
            
            [self goToAauthPhoneCode];
                
        }
                
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma mark - ——————— 网络请求 ————————
//获取国际手机号区号
-(void)getAreaCode{
    
    
    NSDictionary *dic = @{
        
        @"condition":@""
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_phoneAreaCode parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取区号：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
//            self.areaArray = (NSMutableArray *)responseObjectModel.data;
            
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



//获取验证码
-(void)getCode{
    
    if (![self.phoneTfd.text isMatchPatternString:self.patternStr]) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入正确的手机号")];
        
        return;
        
    }else if ([self.areaCodeStr nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请选择地区")];
        
        return;
        
    }
    
    
    
    NSDictionary *dic = @{
        
        @"phone":self.phoneTfd.text,
        @"areaCode":self.areaCodeStr
        
    };
    
    self.getCodeBtn.enabled = NO;
 
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_regCaptcha parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取验证码：%@",[responseObject description]);

        //成功时候返回的data是字符串
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess && [responseObject[@"data"] isKindOfClass:[NSString class]]) {
            
            self.downCount = 60;
            
            [self retextBtn];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(retextBtn) userInfo:nil repeats:YES];
            
            [self.codeTfd becomeFirstResponder];
            
            
            
        }else{
            
            //失败时候返回的data是字典
            
            self.getCodeBtn.enabled = YES;
            
            
            
            [MBProgressHUD showError:responseObjectModel.data[@"errmsg"] toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
         self.getCodeBtn.enabled = YES;
        
    }];
    

    
}

//根据计时器设置按钮
- (void)retextBtn{
    _downCount--;
    [_getCodeBtn setTitle:[NSString stringWithFormat:@"%zds", _downCount] forState:UIControlStateNormal];
    _getCodeBtn.alpha = 0.6;
    
    if (_downCount <= 0) {
        _getCodeBtn.enabled = YES;
        [_getCodeBtn setTitle:XMFLI(@"重新获取") forState:UIControlStateNormal];
        _getCodeBtn.alpha = 1.0;
        [_timer invalidate];
    }
}

//手机验证码校验
-(void)goToAauthPhoneCode{
    
     [self.view endEditing:YES];
    
    kWeakSelf(self)
    
    if (![self.phoneTfd.text isMatchPatternString:self.patternStr] || [self.phoneTfd.text nullToString]) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入正确的手机号")];
        
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
        @"areaCode":self.areaCodeStr,
        @"code":self.codeTfd.text
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_authPhoneCode parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"验证验证码：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            XMFSureRegisterController  *VCtrl = [[XMFSureRegisterController alloc]init];
            
            VCtrl.phoneStr = self.phoneTfd.text;
            
            VCtrl.nameStr = self.nameTfd.text;
            
            VCtrl.areaCodeStr = self.areaCodeStr;
                     
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
    }];
    

    
}


//textField改变后通知的方法
-(void)textFieldDidChange:(NSNotification *)notification{
    
    
     //去掉空格
    NSString *phoneStr = [self.phoneTfd.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    
    if (phoneStr.length == 0){

        self.getCodeBtn.enabled = NO;
        
        self.getCodeBtn.alpha = 0.6;
        
    }else{
        
        self.getCodeBtn.enabled = YES;
        
        self.getCodeBtn.alpha = 1.0;
    }
    

    
   
    
    
}


#pragma mark - ——————— 懒加载 ————————


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
