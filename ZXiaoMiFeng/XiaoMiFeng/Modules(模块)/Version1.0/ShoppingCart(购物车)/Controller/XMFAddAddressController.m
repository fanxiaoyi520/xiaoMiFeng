//
//  XMFAddAddressController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAddAddressController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XMFMyOrdersPopView.h"//订单单按钮弹窗
#import "UIImage+Wechat.h"//仿微信图片压缩



@interface XMFAddAddressController ()<UITextFieldDelegate,WCLActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


@property (weak, nonatomic) IBOutlet UITextField *nameTfd;

@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;


@property (weak, nonatomic) IBOutlet UITextField *areaTfd;


@property (weak, nonatomic) IBOutlet UIButton *chooseAreaBtn;


@property (weak, nonatomic) IBOutlet UITextField *detailAddressTfd;


//@property (weak, nonatomic) IBOutlet UITextField *postCodeTfd;


@property (weak, nonatomic) IBOutlet UITextField *identityTfd;


@property (weak, nonatomic) IBOutlet UIButton *setDefaultBtn;


/** 身份证图片背景view */
@property (weak, nonatomic) IBOutlet UIView *identityImgBgView;

/** 身份证图片背景view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identityImgBgViewHeight;



@property (weak, nonatomic) IBOutlet UIImageView *frontImgView;


@property (weak, nonatomic) IBOutlet UIButton *frontBtn;


@property (weak, nonatomic) IBOutlet UIImageView *backImgView;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;



/** 选中的图片 */
@property (nonatomic, strong) UIImageView *selectedImgView;


/** 重新上传view */
@property (weak, nonatomic) IBOutlet UIView *reuploadBgView;

/** 重新上传按钮 */
@property (weak, nonatomic) IBOutlet UIButton *reuploadBtn;



/** 保存按钮 */
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

//来源类型
@property (nonatomic, assign) addAddressType type;

//地址id
@property (nonatomic, copy) NSString *addressIdStr;

//省
@property (nonatomic, copy) NSString *provinceIdStr;

@property (nonatomic, copy) NSString *provinceNameStr;

//市
@property (nonatomic, copy) NSString *cityIdStr;

@property (nonatomic, copy) NSString *cityNameStr;

//区
@property (nonatomic, copy) NSString *areaIdStr;

@property (nonatomic, copy) NSString *areaNameStr;



/*** 选择器 **/
@property (nonatomic, strong) WCLActionSheet *photoActionSheet;

/** 相机位置信息 */
@property (strong, nonatomic) CLLocation *location;

/** 相机 */
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

/** 身份证正面信息 */
@property (nonatomic, strong) NSDictionary *ocrFrontDic;

/** 身份证反面信息 */
@property (nonatomic, strong) NSDictionary *ocrBackDic;


/** 地址信息详情字典 */
@property (nonatomic, strong) NSDictionary *addressDetailDic;

/** 是否需要重新上传 */
@property (nonatomic, assign) BOOL isReupload;

/** 已经认证的姓名 */
@property (nonatomic, copy) NSString *isAuthenedNameStr;

/** 已经认证的身份证号 */
@property (nonatomic, copy) NSString *isAuthenedIdentityStr;


@end

@implementation XMFAddAddressController


-(instancetype)initWithType:(addAddressType)type addressId:(NSString *)addressIdStr{
    
    if (self = [super init]) {
        
        self.addressIdStr = addressIdStr;
        
        self.type = type;
        
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
}

-(void)setupUI{
    
    self.topSpace.constant = kTopHeight;
    
    
    switch (self.type) {
        case editAddress:{//编辑地址
            
            self.naviTitle = XMFLI(@"编辑地址");

        }
            break;
            
        case addAddress:{//新增地址
            
            self.naviTitle = XMFLI(@"添加收货地址");
            
//            self.reuploadBgView.hidden = YES;
            
            
        }
            break;
            
        default:{
            
            self.naviTitle = @" ";
        }
            break;
    }
    
    
    //限制位数
    
//    [self.nameTfd setValue:@15 forKey:LimitInputKey];
    
//    [self.postCodeTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.identityTfd setValue:@18 forKey:LimitInputKey];

//    [self.detailAddressTfd setValue:@70 forKey:LimitInputKey];
    
    switch (self.type) {
            
        case editAddress:{//编辑
            
             [self addRightItemWithTitle:@"删除" action:@selector(rightBtnDidClick)];
            
            [self getAddressDetail:self.addressIdStr];
            
            //赋初始值
//            self.isReupload = NO;
            
        }
            
            break;
        case addAddress:{//新增
            
            
            
        }
            
            break;
            
            
        default:
            break;
    }

    self.areaTfd.delegate = self;
       
    
    [self.nameTfd addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.detailAddressTfd addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    

    
}

//限制标题长度，数字及英文1，中文及中文符号2
- (void)textFieldEditingChanged:(UITextField *)textField{
   
    if (textField == self.nameTfd) {
        
        
        NSInteger maxLength = 15;
        
        HWTitleInfo title = [textField.text getInfoWithTextMaxLength:maxLength];
        
        if (title.length > maxLength) {
            
            textField.text = [textField.text substringToIndex:title.number];
            
            [textField resignFirstResponder];
            
            [MBProgressHUD showOnlyTextToView:self.view title:@"最多只能输入15个字符"];
            
        }
        
    }else if (textField == self.detailAddressTfd){
        
        NSInteger maxLength = 70;
        
        HWTitleInfo title = [textField.text getInfoWithTextMaxLength:maxLength];
        
        if (title.length > maxLength) {
            
            textField.text = [textField.text substringToIndex:title.number];
            
            [textField resignFirstResponder];
            
            [MBProgressHUD showOnlyTextToView:self.view title:@"最多只能输入70个字符"];
            
        }
        
    }
    
 
    
    
    /*
    HWTitleInfo title = [self getInfoWithText:textField.text maxLength:maxLength];
    
    if (title.length > maxLength) {
        
        textField.text = [textField.text substringToIndex:title.number];
        
          [MBProgressHUD showOnlyTextToView:self.view title:@"最多只能输入15个"];
    }*/
    
}


-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.createBtn cornerWithRadius:5.f];
    
    
    [self.reuploadBtn xw_roundedCornerWithCornerRadii:CGSizeMake(5, 5) cornerColor:KWhiteColor corners:UIRectCornerAllCorners borderColor:UIColorFromRGB(0xF7CF20) borderWidth:1.f];
    
 
    
}


//右边按钮被点击
-(void)rightBtnDidClick{
    
    
    kWeakSelf(self)
    
    [XMFAlertController acWithTitle:@"地址删除" msg:@"确定要删除这条地址信息吗？" confirmBtnTitle:@"确定" cancleBtnTitle:@"取消" confirmAction:^(UIAlertAction * _Nonnull action) {
       
        [weakself deleteAddress];
        
    }];
    
    
    
}

//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//选择地区
            
            
            // 地区
             BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
             addressPickerView.pickerMode = BRAddressPickerModeArea;
             addressPickerView.title = @"请选择地区";
             
            addressPickerView.dataSourceArr = AddressInModel.provincelist;
         
             addressPickerView.isAutoSelect = YES;
             addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                 
                 weakself.areaTfd.text = [NSString stringWithFormat:@"%@%@%@", province.name, city.name, area.name];
                 
                 
                 weakself.provinceNameStr = province.name;
                 
                 weakself.provinceIdStr = province.code;
                 
                 weakself.cityNameStr = city.name;
                 
                 weakself.cityIdStr = city.code;
                 
                 weakself.areaNameStr = area.name;
                 
                 weakself.areaIdStr = area.code;
                 
                 
             };
             
             [addressPickerView show];
            
    
            
            
            /*
            [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeArea defaultSelected:nil isAutoSelect:YES themeColor:UIColorFromRGB(0x999999) resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                
                self.areaTfd.text = [NSString stringWithFormat:@"%@%@%@", province.name, city.name, area.name];
                
                
                self.provinceNameStr = province.name;
                
                self.provinceIdStr = province.code;
                
                self.cityNameStr = city.name;
                
                self.cityIdStr = city.code;
                
                self.areaNameStr = area.name;
                
                self.areaIdStr = area.code;
                

                
            } cancelBlock:^{
                
                
                
            }];*/
        
             
            
        }
            break;
            
        case 1:{//设置默认
            
            sender.selected = !sender.selected;
            
        }
            break;
        case 2:{//身份证正面
            
            self.selectedImgView = self.frontImgView;
            
            [self.view endEditing:YES];
            
            
            [self.photoActionSheet showInView:self.view];
            
        }
            break;
            
        case 3:{//身份证反面
            
            self.selectedImgView = self.backImgView;
            
            [self.view endEditing:YES];
            
            [self.photoActionSheet showInView:self.view];

        }
            break;
            
        case 4:{//新建
            
            [self saveAddress];
            
        }
            break;
            
        case 5:{//重新上传
            
            self.isReupload = YES;
            
            self.reuploadBgView.hidden = YES;
            
            self.identityImgBgView.hidden = NO;
            
            self.identityImgBgViewHeight.constant = 193/343.0 * (KScreenW - 32) * 2 + 12;
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}

//给页面上的内容赋值
-(void)setDataForView:(NSDictionary *)dic{
    
    /**
     "data" : {
      "address" : "f",
      "areaId" : 110114,
      "mobile" : "18825257966",
      "postalCode" : "123456",
      "id" : 2323,
      "cityId" : 110100,
      "provinceId" : 110000,
      "isDefault" : false,
      "personCard" : "110101199003070257",
      "districtId" : 110114,
      "name" : "发的"
    }*/
    
    self.isAuthenedNameStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
    
    self.nameTfd.text = self.isAuthenedNameStr;
    
    self.phoneTfd.text = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    
    //省市区
    self.provinceIdStr = [NSString stringWithFormat:@"%@",dic[@"provinceId"]];
    
    self.provinceNameStr = [AddressManager getProvinceName:self.provinceIdStr];
    
    
    self.cityIdStr = [NSString stringWithFormat:@"%@",dic[@"cityId"]];
    
    self.cityNameStr = [AddressManager getCityName:self.cityIdStr];
    
        
    self.areaIdStr = [dic stringWithKey:@"areaId"];
    
    self.areaNameStr = [AddressManager getAreaName:self.areaIdStr];
    
    
    self.areaTfd.text = [NSString stringWithFormat:@"%@%@%@",self.provinceNameStr,self.cityNameStr,self.areaNameStr];
    
    
    self.detailAddressTfd.text = [dic stringWithKey:@"address"];
    
        
//    self.postCodeTfd.text =  [dic stringWithKey:@"postalCode"];
    
    //身份证号
    self.isAuthenedIdentityStr = [dic stringWithKey:@"personCard"];
    
    self.identityTfd.text = self.isAuthenedIdentityStr;
    
//    self.setDefaultBtn.selected = [dic[@"isDefault"] boolValue];
    
    self.setDefaultBtn.selected = [[dic stringWithKey:@"isDefault"] boolValue];
    
    
    //是否已认证
//    BOOL isVerified = [dic[@"verified"] boolValue];
    
    BOOL isVerified = [[dic stringWithKey:@"verified"] boolValue];
    
    if (isVerified) {
        
        self.reuploadBgView.hidden = NO;
        
        self.identityImgBgViewHeight.constant = self.reuploadBgView.height;
        
        self.identityImgBgView.hidden = YES;
        
    }else{
        
        self.reuploadBgView.hidden = YES;
        
        self.identityImgBgViewHeight.constant = 193/343.0 * (KScreenW - 32) * 2 + 12;
        
        self.identityImgBgView.hidden = NO;
    }
    
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.areaTfd) {
        [self.view endEditing:YES];
        [self handlerTextFieldSelect:textField];
        return NO; // 当前 textField 不可编辑，可以响应点击事件
    }else {
       
        return YES;
    }
}

#pragma mark - 处理编辑事件
- (void)handlerTextFieldSelect:(UITextField *)textField{
    
    kWeakSelf(self)
    // 地区
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
    addressPickerView.pickerMode = BRAddressPickerModeArea;
    addressPickerView.title = @"请选择地区";
    
    addressPickerView.dataSourceArr = AddressInModel.provincelist;
    
    addressPickerView.isAutoSelect = YES;
    addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        
        weakself.areaTfd.text = [NSString stringWithFormat:@"%@%@%@", province.name, city.name, area.name];
        
        
        weakself.provinceNameStr = province.name;
        
        weakself.provinceIdStr = province.code;
        
        weakself.cityNameStr = city.name;
        
        weakself.cityIdStr = city.code;
        
        weakself.areaNameStr = area.name;
        
        weakself.areaIdStr = area.code;
        
        
    };
    
    [addressPickerView show];
    
    
}


#pragma mark - ——————— 网络请求 ————————

//获取地址详情
-(void)getAddressDetail:(NSString *)addressIdStr{
    
    
    NSDictionary *dic = @{
        
        @"id":addressIdStr
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_address_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"获取地址详情：%@",[responseObject description]);
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            //保存地址详情数据
            self.addressDetailDic = responseObjectModel.data;
            
            [self setDataForView:responseObjectModel.data];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
        
    }];
    
    
}


//删除地址
-(void)deleteAddress{
    
    NSDictionary *dic = @{
        
        @"id":self.addressIdStr
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_address_delete parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"删除地址：%@",[responseObject description]);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self popAction];
            
            if (self->_addAddressBlock) {
                self->_addAddressBlock();
            }
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
    /*
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_address_delete parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"删除地址：%@",[responseObject description]);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self popAction];
            
            if (self->_addAddressBlock) {
                self->_addAddressBlock();
            }
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
    }];
     */
    
}

//保存地址
-(void)saveAddress{
    
    if (![self.nameTfd.text isAvailableName]) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入正确的姓名")];
        
        return;
        
    }/*else if (![self.postCodeTfd.text isPostCode]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入正确的邮政编码")];
        
        return;
        
    }*/else if (![self.identityTfd.text isIdentityCard]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入正确的身份证号")];
        
        return;
        
    }else if (![self.phoneTfd.text isPhone] && ![self.phoneTfd.text isHongKongPhone]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入正确的手机号")];
        
        return;
        
    }else if ([self.areaTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请选择地区")];
        
        return;
        
    }else if ([self.detailAddressTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请填写详细地址")];
        
        return;
        
    }
    
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    switch (self.type) {
        case editAddress:{//编辑
            
            /*
            //当只是编辑姓名和身份证的文本没有上传的时候进行一次校验
            if ((![self.isAuthenedNameStr isEqualToString:self.nameTfd.text] || ![self.isAuthenedIdentityStr isEqualToString:self.identityTfd.text]) && !self.isReupload) {
                
                XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
                
                popView.tipsLB.text = XMFLI(@"请您核对填写的身份证号码和姓名与上传的身份证照片是否一致");
                
                
                [popView show];
                
                return;;
            }*/
            
            
        
        
            //是否已认证
            BOOL isVerified = [self.addressDetailDic[@"verified"] boolValue];
            
            
            NSDictionary *editDic = @{
                
                @"address":self.detailAddressTfd.text,
                @"areaId":self.areaIdStr,
                @"cityId":self.cityIdStr,
                @"cityName":self.cityNameStr,
                @"countyName":self.areaNameStr,
                @"detailAddress":[NSString stringWithFormat:@"%@%@%@%@",self.provinceNameStr,self.cityNameStr,self.areaNameStr,self.detailAddressTfd.text],
                @"id":self.addressIdStr,
                @"isDefault":@(self.setDefaultBtn.selected),
                @"mobile":self.phoneTfd.text,
                @"name":self.nameTfd.text,
                @"personCard":self.identityTfd.text,
                //                @"postalCode":self.postCodeTfd.text,
                @"provinceId":self.provinceIdStr,
                @"provinceName":self.provinceNameStr
            };
            
            
            if (isVerified && !self.isReupload) {
                
                [dic addEntriesFromDictionary:editDic];
                
            }else{
               
                NSString *ocrFrontIdxStr = [self.ocrFrontDic stringWithKey:@"ocrFrontIdx"];
                
                NSString *ocrBackIdxStr = [self.ocrBackDic stringWithKey:@"ocrBackIdx"];
                
                if ((ocrFrontIdxStr.length <= 0) || ocrBackIdxStr.length <= 0) {
                    
                    [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"跨境商品请上传身份证照片")];
                    
                    
                    return;
                    
                }else if ((![self.nameTfd.text isEqualToString:[self.ocrFrontDic stringWithKey:@"realName"]]) || ![self.identityTfd.text isEqualToString:[self.ocrFrontDic stringWithKey:@"idCardNo"]]){
                    
                    XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
                    
                    popView.tipsLB.text = XMFLI(@"请您核对填写的身份证号码和姓名与上传的身份证照片是否一致");
                    
                    
                    [popView show];
                    
                    return;;
                }
                
                [dic addEntriesFromDictionary:editDic];
                
                //加入正反面图片
                [dic setValue:[self.ocrBackDic stringWithKey:@"ocrBackIdx"] forKey:@"ocrBackIdx"];
                
                [dic setValue:[self.ocrFrontDic stringWithKey:@"ocrFrontIdx"] forKey:@"ocrFrontIdx"];
                
            }
            
        }
            
            break;
            
        case addAddress:{//添加
            
            
            NSString *ocrFrontIdxStr = [self.ocrFrontDic stringWithKey:@"ocrFrontIdx"];
            
            NSString *ocrBackIdxStr = [self.ocrBackDic stringWithKey:@"ocrBackIdx"];
            
            if ((ocrFrontIdxStr.length <= 0) || ocrBackIdxStr.length <= 0) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"跨境商品请上传身份证照片")];
                
                
                return;
                
            }else if ((![self.nameTfd.text isEqualToString:[self.ocrFrontDic stringWithKey:@"realName"]]) || ![self.identityTfd.text isEqualToString:[self.ocrFrontDic stringWithKey:@"idCardNo"]]){
                
                XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
                
                popView.tipsLB.text = XMFLI(@"请您核对填写的身份证号码和姓名与\n上传的身份证照片是否一致");
                
                
                [popView show];
                
                return;;
            }
            

            
            NSDictionary *addDic = @{
                @"address":self.detailAddressTfd.text,
                @"areaId":self.areaIdStr,
                @"cityId":self.cityIdStr,
                @"cityName":self.cityNameStr,
                @"countyName":self.areaNameStr,
                @"detailAddress":[NSString stringWithFormat:@"%@%@%@%@",self.provinceNameStr,self.cityNameStr,self.areaNameStr,self.detailAddressTfd.text],
                @"isDefault":@(self.setDefaultBtn.selected),
                @"mobile":self.phoneTfd.text,
                @"name":self.nameTfd.text,
                @"personCard":self.identityTfd.text,
//                @"postalCode":self.postCodeTfd.text,
                @"provinceId":self.provinceIdStr,
                @"provinceName":self.provinceNameStr,
                @"ocrBackIdx":[self.ocrBackDic stringWithKey:@"ocrBackIdx"],
                @"ocrFrontIdx":[self.ocrFrontDic stringWithKey:@"ocrFrontIdx"],
            };
            
            [dic addEntriesFromDictionary:addDic];
            
        }
            
            break;
            
        default:
            break;
    }
    
    
    
MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_address_save parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self popAction];
            
            if (self->_addAddressBlock) {
                self->_addAddressBlock();
            }
            
            [MBProgressHUD showSuccess:XMFLI(@"成功") toView:kAppWindow];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:kAppWindow];
            
        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
    
}


#pragma mark - ——————— WCLActionSheetDelegate ————————
- (void)actionImageSheet:(WCLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.photoActionSheet) {
        
        switch (buttonIndex) {
            case 0:{
                
                [self takePhoto];
                
            }
                
                break;
                
            case 1:{
                
                // 单独的选照片
                [self pushPhotoTZImagePickerController];
            }
                
                break;
                
            default:
                break;
        }
        
     
        
    }
}


// 弹出相册选择器
- (void)pushPhotoTZImagePickerController
{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    
    imagePickerVc.allowTakePicture = YES;                     // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.showSelectedIndex = YES;
    //imagePickerVc.allowPickingGif = self.allowPickingGifSwitch.isOn;
    //imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch.isOn; // 是否可以多选视频
    if(@available(iOS 13.0,*)){
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        
}


#pragma mark - TZImagePickerControllerDelegate

#pragma mark -  选择相册回调
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
   
    UIImage *editedImage = [photos firstObject];

    if (self.selectedImgView == self.frontImgView) {
        //正面
            
        [self dealWithFrontImage:editedImage];
        
        
    }else if (self.selectedImgView == self.backImgView){//反面
        
        
        [self dealWithBackImage:editedImage];
        
        
    }
    
}



//身份证正面上传图片
-(void)dealWithFrontImage:(UIImage *)image{
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];;
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    manager.securityPolicy.validatesDomainName = NO;
    
    manager.requestSerializer.timeoutInterval = 200;
    
    NSSet *set = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    manager.responseSerializer.acceptableContentTypes =[manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:set];
    
    //设置请求头
     [manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
    
    
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@",XMF_BASE_URL,URL_wx_auth_idcard_front];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [manager POST:requestUrlStr parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*图片的格式 是MultipartFile  post 名字叫files*/
        
        
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.25);

        
        UIImage *wcImage = [image wcSessionCompress];
        
        NSData *imageData = UIImageJPEGRepresentation(wcImage, 0.1);
        
        
        DLog(@"图片压缩后的大小：%lu KB",[imageData length]/1000);

    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        /*
         此方法参数：
         1、要上传的[二进制数据]
         2、对应后台上处理文件的[字段“files”]
         3、要保存在服务器上的[文件名]
         4、上传文件的[mimeType]
         
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [hud hideAnimated:YES];
        
        //data转json
//        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    

        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        
        DLog(@"上传正面：%@",responseDic);
        
        XMFResponseModel *responseModel = [XMFResponseModel yy_modelWithDictionary:responseObject];
    
        if (responseModel.code == XMFHttpReturnCodeSuccess){
            
            
            self.ocrFrontDic = responseModel.data;
            
            
            NSString  *imgURL = [NSString stringWithFormat:@"%@",responseModel.data[@"pictureUrl"]];
        
            [self setFrontImageViewWithURL:imgURL];
            
            
            //图片赋值
//            [self.frontImgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"icon_shiming_touxiang"]];
            
            //姓名
//            self.nameTfd.text = [NSString stringWithFormat:@"%@",[self.ocrFrontDic objectForKey:@"realName"]];
            
            
            //身份证号
//            self.identityTfd.text = [NSString stringWithFormat:@"%@",[self.ocrFrontDic objectForKey:@"idCardNo"]];
            
            
        }else{
            
                        
            [MBProgressHUD showError:responseDic[@"message"] toView:self.view];
            
        }
        
        
        DLog(@"上传成功:%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [hud hideAnimated:YES];

        DLog(@"failure：%@", error);
        
        //打印错误信息
        if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
            NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
            DLog(@"头像上传的错误信息：%@",str);
        }
        
    }];
    
    
}


//给身份证正面赋值
-(void)setFrontImageViewWithURL:(NSString *)imgURL{
    
    //图片赋值
    [self.frontImgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"icon_shiming_touxiang"]];
    
}



//身份证背面上传图片
- (void)dealWithBackImage:(UIImage *)image{
            
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];;
        
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        manager.securityPolicy.validatesDomainName = NO;
        
        manager.requestSerializer.timeoutInterval = 200;
        
        NSSet *set = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
        manager.responseSerializer.acceptableContentTypes =[manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:set];
        
        //设置请求头
         [manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
        
        
        NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@",XMF_BASE_URL,URL_wx_auth_idcard_back];
        
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
        
        [manager POST:requestUrlStr parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            /*图片的格式 是MultipartFile  post 名字叫files*/
            
            
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
            
            UIImage *wcImage = [image wcSessionCompress];
            
            
            NSData *imageData = UIImageJPEGRepresentation(wcImage, 0.1);

            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            /*
             此方法参数：
             1、要上传的[二进制数据]
             2、对应后台上处理文件的[字段“files”]
             3、要保存在服务器上的[文件名]
             4、上传文件的[mimeType]
             
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            [hud hideAnimated:YES];
            
            //data转json
    //        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        

            NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
            
            
            DLog(@"上传反面：%@",responseDic);
            
            XMFResponseModel *responseModel = [XMFResponseModel yy_modelWithDictionary:responseObject];
        
            if (responseModel.code == XMFHttpReturnCodeSuccess){
                
                self.ocrBackDic = responseModel.data;
                
                NSString  *imgURL = [NSString stringWithFormat:@"%@",responseModel.data[@"pictureUrl"]];
            
                //给身份证反面赋值
                [self setBackImageViewWithURL:imgURL];
                
                
            }else{
                
                            
                [MBProgressHUD showError:responseDic[@"message"] toView:self.view];
                
            }
            
            
            DLog(@"上传成功:%@",responseObject);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            [hud hideAnimated:YES];

            DLog(@"failure：%@", error);
            
            //打印错误信息
            if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
                NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
                DLog(@"头像上传的错误信息：%@",str);
            }
            
        }];
        
        
}


//给身份证反面赋值
-(void)setBackImageViewWithURL:(NSString *)imgURL{
    
            
    //给背面图片赋值
    [self.backImgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"icon_shiming_guohuimian"]];
            
}



#pragma mark - ———————测试相机 ————————
#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        
        //添加拍摄视频
//        [mediaTypes addObject:(NSString *)kUTTypeMovie];
      
        //添加拍摄照片
       [mediaTypes addObject:(NSString *)kUTTypeImage];
        
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        DLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}


- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
   
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        UIImageOrientation imageOrientation = image.imageOrientation;
        
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
        
        if(imageOrientation != UIImageOrientationUp){
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // image=矫正过的图片
            
            
        }
        
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:self.location completion:^(PHAsset *asset, NSError *error){
            if (error) {
                
                DLog(@"图片保存失败 %@",error);
                
            } else {
                
                DLog(@"图片保存成功");
                
                [self refreshCollectionViewWithAddedAsset:asset image:image];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    
    
    if (self.selectedImgView == self.frontImgView) {
        //正面
        
        [self dealWithFrontImage:image];
        
        
    }else if (self.selectedImgView == self.backImgView){//反面
        
        
        [self dealWithBackImage:image];
        
        
    }
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
    
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
 
    }
    return _imagePickerVc;
}



#pragma mark - ——————— 懒加载 ————————
- (WCLActionSheet *)photoActionSheet
{
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[WCLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:XMFLI(@"取消") destructiveButtonTitle:XMFLI(@"拍照") otherButtonTitles:XMFLI(@"从相册选择"), nil];
    }
    return _photoActionSheet;
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
