//
//  XMFAddAddressController.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/6.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFAddAddressController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "XMFMyOrdersPopView.h"//è®¢ååæé®å¼¹çª
#import "UIImage+Wechat.h"//ä»¿å¾®ä¿¡å¾çåç¼©



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


/** èº«ä»½è¯å¾çèæ¯view */
@property (weak, nonatomic) IBOutlet UIView *identityImgBgView;

/** èº«ä»½è¯å¾çèæ¯viewçé«åº¦ */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identityImgBgViewHeight;



@property (weak, nonatomic) IBOutlet UIImageView *frontImgView;


@property (weak, nonatomic) IBOutlet UIButton *frontBtn;


@property (weak, nonatomic) IBOutlet UIImageView *backImgView;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;



/** éä¸­çå¾ç */
@property (nonatomic, strong) UIImageView *selectedImgView;


/** éæ°ä¸ä¼ view */
@property (weak, nonatomic) IBOutlet UIView *reuploadBgView;

/** éæ°ä¸ä¼ æé® */
@property (weak, nonatomic) IBOutlet UIButton *reuploadBtn;



/** ä¿å­æé® */
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

//æ¥æºç±»å
@property (nonatomic, assign) addAddressType type;

//å°åid
@property (nonatomic, copy) NSString *addressIdStr;

//ç
@property (nonatomic, copy) NSString *provinceIdStr;

@property (nonatomic, copy) NSString *provinceNameStr;

//å¸
@property (nonatomic, copy) NSString *cityIdStr;

@property (nonatomic, copy) NSString *cityNameStr;

//åº
@property (nonatomic, copy) NSString *areaIdStr;

@property (nonatomic, copy) NSString *areaNameStr;



/*** éæ©å¨ **/
@property (nonatomic, strong) WCLActionSheet *photoActionSheet;

/** ç¸æºä½ç½®ä¿¡æ¯ */
@property (strong, nonatomic) CLLocation *location;

/** ç¸æº */
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

/** èº«ä»½è¯æ­£é¢ä¿¡æ¯ */
@property (nonatomic, strong) NSDictionary *ocrFrontDic;

/** èº«ä»½è¯åé¢ä¿¡æ¯ */
@property (nonatomic, strong) NSDictionary *ocrBackDic;


/** å°åä¿¡æ¯è¯¦æå­å¸ */
@property (nonatomic, strong) NSDictionary *addressDetailDic;

/** æ¯å¦éè¦éæ°ä¸ä¼  */
@property (nonatomic, assign) BOOL isReupload;

/** å·²ç»è®¤è¯çå§å */
@property (nonatomic, copy) NSString *isAuthenedNameStr;

/** å·²ç»è®¤è¯çèº«ä»½è¯å· */
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
        case editAddress:{//ç¼è¾å°å
            
            self.naviTitle = XMFLI(@"ç¼è¾å°å");

        }
            break;
            
        case addAddress:{//æ°å¢å°å
            
            self.naviTitle = XMFLI(@"æ·»å æ¶è´§å°å");
            
//            self.reuploadBgView.hidden = YES;
            
            
        }
            break;
            
        default:{
            
            self.naviTitle = @" ";
        }
            break;
    }
    
    
    //éå¶ä½æ°
    
//    [self.nameTfd setValue:@15 forKey:LimitInputKey];
    
//    [self.postCodeTfd setValue:@6 forKey:@"LimitInput"];
    
    [self.identityTfd setValue:@18 forKey:LimitInputKey];

//    [self.detailAddressTfd setValue:@70 forKey:LimitInputKey];
    
    switch (self.type) {
            
        case editAddress:{//ç¼è¾
            
             [self addRightItemWithTitle:@"å é¤" action:@selector(rightBtnDidClick)];
            
            [self getAddressDetail:self.addressIdStr];
            
            //èµåå§å¼
//            self.isReupload = NO;
            
        }
            
            break;
        case addAddress:{//æ°å¢
            
            
            
        }
            
            break;
            
            
        default:
            break;
    }

    self.areaTfd.delegate = self;
       
    
    [self.nameTfd addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.detailAddressTfd addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    

    
}

//éå¶æ é¢é¿åº¦ï¼æ°å­åè±æ1ï¼ä¸­æåä¸­æç¬¦å·2
- (void)textFieldEditingChanged:(UITextField *)textField{
   
    if (textField == self.nameTfd) {
        
        
        NSInteger maxLength = 15;
        
        HWTitleInfo title = [textField.text getInfoWithTextMaxLength:maxLength];
        
        if (title.length > maxLength) {
            
            textField.text = [textField.text substringToIndex:title.number];
            
            [textField resignFirstResponder];
            
            [MBProgressHUD showOnlyTextToView:self.view title:@"æå¤åªè½è¾å¥15ä¸ªå­ç¬¦"];
            
        }
        
    }else if (textField == self.detailAddressTfd){
        
        NSInteger maxLength = 70;
        
        HWTitleInfo title = [textField.text getInfoWithTextMaxLength:maxLength];
        
        if (title.length > maxLength) {
            
            textField.text = [textField.text substringToIndex:title.number];
            
            [textField resignFirstResponder];
            
            [MBProgressHUD showOnlyTextToView:self.view title:@"æå¤åªè½è¾å¥70ä¸ªå­ç¬¦"];
            
        }
        
    }
    
 
    
    
    /*
    HWTitleInfo title = [self getInfoWithText:textField.text maxLength:maxLength];
    
    if (title.length > maxLength) {
        
        textField.text = [textField.text substringToIndex:title.number];
        
          [MBProgressHUD showOnlyTextToView:self.view title:@"æå¤åªè½è¾å¥15ä¸ª"];
    }*/
    
}


-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.createBtn cornerWithRadius:5.f];
    
    
    [self.reuploadBtn xw_roundedCornerWithCornerRadii:CGSizeMake(5, 5) cornerColor:KWhiteColor corners:UIRectCornerAllCorners borderColor:UIColorFromRGB(0xF7CF20) borderWidth:1.f];
    
 
    
}


//å³è¾¹æé®è¢«ç¹å»
-(void)rightBtnDidClick{
    
    
    kWeakSelf(self)
    
    [XMFAlertController acWithTitle:@"å°åå é¤" msg:@"ç¡®å®è¦å é¤è¿æ¡å°åä¿¡æ¯åï¼" confirmBtnTitle:@"ç¡®å®" cancleBtnTitle:@"åæ¶" confirmAction:^(UIAlertAction * _Nonnull action) {
       
        [weakself deleteAddress];
        
    }];
    
    
    
}

//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//éæ©å°åº
            
            
            // å°åº
             BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
             addressPickerView.pickerMode = BRAddressPickerModeArea;
             addressPickerView.title = @"è¯·éæ©å°åº";
             
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
            
        case 1:{//è®¾ç½®é»è®¤
            
            sender.selected = !sender.selected;
            
        }
            break;
        case 2:{//èº«ä»½è¯æ­£é¢
            
            self.selectedImgView = self.frontImgView;
            
            [self.view endEditing:YES];
            
            
            [self.photoActionSheet showInView:self.view];
            
        }
            break;
            
        case 3:{//èº«ä»½è¯åé¢
            
            self.selectedImgView = self.backImgView;
            
            [self.view endEditing:YES];
            
            [self.photoActionSheet showInView:self.view];

        }
            break;
            
        case 4:{//æ°å»º
            
            [self saveAddress];
            
        }
            break;
            
        case 5:{//éæ°ä¸ä¼ 
            
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

//ç»é¡µé¢ä¸çåå®¹èµå¼
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
      "name" : "åç"
    }*/
    
    self.isAuthenedNameStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
    
    self.nameTfd.text = self.isAuthenedNameStr;
    
    self.phoneTfd.text = [NSString stringWithFormat:@"%@",dic[@"mobile"]];
    
    //çå¸åº
    self.provinceIdStr = [NSString stringWithFormat:@"%@",dic[@"provinceId"]];
    
    self.provinceNameStr = [AddressManager getProvinceName:self.provinceIdStr];
    
    
    self.cityIdStr = [NSString stringWithFormat:@"%@",dic[@"cityId"]];
    
    self.cityNameStr = [AddressManager getCityName:self.cityIdStr];
    
        
    self.areaIdStr = [dic stringWithKey:@"areaId"];
    
    self.areaNameStr = [AddressManager getAreaName:self.areaIdStr];
    
    
    self.areaTfd.text = [NSString stringWithFormat:@"%@%@%@",self.provinceNameStr,self.cityNameStr,self.areaNameStr];
    
    
    self.detailAddressTfd.text = [dic stringWithKey:@"address"];
    
        
//    self.postCodeTfd.text =  [dic stringWithKey:@"postalCode"];
    
    //èº«ä»½è¯å·
    self.isAuthenedIdentityStr = [dic stringWithKey:@"personCard"];
    
    self.identityTfd.text = self.isAuthenedIdentityStr;
    
//    self.setDefaultBtn.selected = [dic[@"isDefault"] boolValue];
    
    self.setDefaultBtn.selected = [[dic stringWithKey:@"isDefault"] boolValue];
    
    
    //æ¯å¦å·²è®¤è¯
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
        return NO; // å½å textField ä¸å¯ç¼è¾ï¼å¯ä»¥ååºç¹å»äºä»¶
    }else {
       
        return YES;
    }
}

#pragma mark - å¤çç¼è¾äºä»¶
- (void)handlerTextFieldSelect:(UITextField *)textField{
    
    kWeakSelf(self)
    // å°åº
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
    addressPickerView.pickerMode = BRAddressPickerModeArea;
    addressPickerView.title = @"è¯·éæ©å°åº";
    
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


#pragma mark - âââââââ ç½ç»è¯·æ± ââââââââ

//è·åå°åè¯¦æ
-(void)getAddressDetail:(NSString *)addressIdStr{
    
    
    NSDictionary *dic = @{
        
        @"id":addressIdStr
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_address_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"è·åå°åè¯¦æï¼%@",[responseObject description]);
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            //ä¿å­å°åè¯¦ææ°æ®
            self.addressDetailDic = responseObjectModel.data;
            
            [self setDataForView:responseObjectModel.data];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
        
    }];
    
    
}


//å é¤å°å
-(void)deleteAddress{
    
    NSDictionary *dic = @{
        
        @"id":self.addressIdStr
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_address_delete parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"å é¤å°åï¼%@",[responseObject description]);
        
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
        
        DLog(@"å é¤å°åï¼%@",[responseObject description]);
        
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

//ä¿å­å°å
-(void)saveAddress{
    
    if (![self.nameTfd.text isAvailableName]) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è¯·è¾å¥æ­£ç¡®çå§å")];
        
        return;
        
    }/*else if (![self.postCodeTfd.text isPostCode]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è¯·è¾å¥æ­£ç¡®çé®æ¿ç¼ç ")];
        
        return;
        
    }*/else if (![self.identityTfd.text isIdentityCard]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è¯·è¾å¥æ­£ç¡®çèº«ä»½è¯å·")];
        
        return;
        
    }else if (![self.phoneTfd.text isPhone] && ![self.phoneTfd.text isHongKongPhone]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è¯·è¾å¥æ­£ç¡®çææºå·")];
        
        return;
        
    }else if ([self.areaTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è¯·éæ©å°åº")];
        
        return;
        
    }else if ([self.detailAddressTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è¯·å¡«åè¯¦ç»å°å")];
        
        return;
        
    }
    
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    switch (self.type) {
        case editAddress:{//ç¼è¾
            
            /*
            //å½åªæ¯ç¼è¾å§ååèº«ä»½è¯çææ¬æ²¡æä¸ä¼ çæ¶åè¿è¡ä¸æ¬¡æ ¡éª
            if ((![self.isAuthenedNameStr isEqualToString:self.nameTfd.text] || ![self.isAuthenedIdentityStr isEqualToString:self.identityTfd.text]) && !self.isReupload) {
                
                XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
                
                popView.tipsLB.text = XMFLI(@"è¯·æ¨æ ¸å¯¹å¡«åçèº«ä»½è¯å·ç åå§åä¸ä¸ä¼ çèº«ä»½è¯ç§çæ¯å¦ä¸è´");
                
                
                [popView show];
                
                return;;
            }*/
            
            
        
        
            //æ¯å¦å·²è®¤è¯
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
                    
                    [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è·¨å¢ååè¯·ä¸ä¼ èº«ä»½è¯ç§ç")];
                    
                    
                    return;
                    
                }else if ((![self.nameTfd.text isEqualToString:[self.ocrFrontDic stringWithKey:@"realName"]]) || ![self.identityTfd.text isEqualToString:[self.ocrFrontDic stringWithKey:@"idCardNo"]]){
                    
                    XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
                    
                    popView.tipsLB.text = XMFLI(@"è¯·æ¨æ ¸å¯¹å¡«åçèº«ä»½è¯å·ç åå§åä¸ä¸ä¼ çèº«ä»½è¯ç§çæ¯å¦ä¸è´");
                    
                    
                    [popView show];
                    
                    return;;
                }
                
                [dic addEntriesFromDictionary:editDic];
                
                //å å¥æ­£åé¢å¾ç
                [dic setValue:[self.ocrBackDic stringWithKey:@"ocrBackIdx"] forKey:@"ocrBackIdx"];
                
                [dic setValue:[self.ocrFrontDic stringWithKey:@"ocrFrontIdx"] forKey:@"ocrFrontIdx"];
                
            }
            
        }
            
            break;
            
        case addAddress:{//æ·»å 
            
            
            NSString *ocrFrontIdxStr = [self.ocrFrontDic stringWithKey:@"ocrFrontIdx"];
            
            NSString *ocrBackIdxStr = [self.ocrBackDic stringWithKey:@"ocrBackIdx"];
            
            if ((ocrFrontIdxStr.length <= 0) || ocrBackIdxStr.length <= 0) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è·¨å¢ååè¯·ä¸ä¼ èº«ä»½è¯ç§ç")];
                
                
                return;
                
            }else if ((![self.nameTfd.text isEqualToString:[self.ocrFrontDic stringWithKey:@"realName"]]) || ![self.identityTfd.text isEqualToString:[self.ocrFrontDic stringWithKey:@"idCardNo"]]){
                
                XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
                
                popView.tipsLB.text = XMFLI(@"è¯·æ¨æ ¸å¯¹å¡«åçèº«ä»½è¯å·ç åå§åä¸\nä¸ä¼ çèº«ä»½è¯ç§çæ¯å¦ä¸è´");
                
                
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
            
            [MBProgressHUD showSuccess:XMFLI(@"æå") toView:kAppWindow];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:kAppWindow];
            
        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
    
}


#pragma mark - âââââââ WCLActionSheetDelegate ââââââââ
- (void)actionImageSheet:(WCLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.photoActionSheet) {
        
        switch (buttonIndex) {
            case 0:{
                
                [self takePhoto];
                
            }
                
                break;
                
            case 1:{
                
                // åç¬çéç§ç
                [self pushPhotoTZImagePickerController];
            }
                
                break;
                
            default:
                break;
        }
        
     
        
    }
}


// å¼¹åºç¸åéæ©å¨
- (void)pushPhotoTZImagePickerController
{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    
    imagePickerVc.allowTakePicture = YES;                     // å¨åé¨æ¾ç¤ºæç§æé®
    // 3. è®¾ç½®æ¯å¦å¯ä»¥éæ©è§é¢/å¾ç/åå¾
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.showSelectedIndex = YES;
    //imagePickerVc.allowPickingGif = self.allowPickingGifSwitch.isOn;
    //imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch.isOn; // æ¯å¦å¯ä»¥å¤éè§é¢
    if(@available(iOS 13.0,*)){
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        
}


#pragma mark - TZImagePickerControllerDelegate

#pragma mark -  éæ©ç¸ååè°
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
   
    UIImage *editedImage = [photos firstObject];

    if (self.selectedImgView == self.frontImgView) {
        //æ­£é¢
            
        [self dealWithFrontImage:editedImage];
        
        
    }else if (self.selectedImgView == self.backImgView){//åé¢
        
        
        [self dealWithBackImage:editedImage];
        
        
    }
    
}



//èº«ä»½è¯æ­£é¢ä¸ä¼ å¾ç
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
    
    //è®¾ç½®è¯·æ±å¤´
     [manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
    
    
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@",XMF_BASE_URL,URL_wx_auth_idcard_front];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [manager POST:requestUrlStr parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*å¾ççæ ¼å¼ æ¯MultipartFile  post åå­å«files*/
        
        
//        NSData *imageData = UIImageJPEGRepresentation(image, 0.25);

        
        UIImage *wcImage = [image wcSessionCompress];
        
        NSData *imageData = UIImageJPEGRepresentation(wcImage, 0.1);
        
        
        DLog(@"å¾çåç¼©åçå¤§å°ï¼%lu KB",[imageData length]/1000);

    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        /*
         æ­¤æ¹æ³åæ°ï¼
         1ãè¦ä¸ä¼ ç[äºè¿å¶æ°æ®]
         2ãå¯¹åºåå°ä¸å¤çæä»¶ç[å­æ®µâfilesâ]
         3ãè¦ä¿å­å¨æå¡å¨ä¸ç[æä»¶å]
         4ãä¸ä¼ æä»¶ç[mimeType]
         
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [hud hideAnimated:YES];
        
        //dataè½¬json
//        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    

        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        
        DLog(@"ä¸ä¼ æ­£é¢ï¼%@",responseDic);
        
        XMFResponseModel *responseModel = [XMFResponseModel yy_modelWithDictionary:responseObject];
    
        if (responseModel.code == XMFHttpReturnCodeSuccess){
            
            
            self.ocrFrontDic = responseModel.data;
            
            
            NSString  *imgURL = [NSString stringWithFormat:@"%@",responseModel.data[@"pictureUrl"]];
        
            [self setFrontImageViewWithURL:imgURL];
            
            
            //å¾çèµå¼
//            [self.frontImgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"icon_shiming_touxiang"]];
            
            //å§å
//            self.nameTfd.text = [NSString stringWithFormat:@"%@",[self.ocrFrontDic objectForKey:@"realName"]];
            
            
            //èº«ä»½è¯å·
//            self.identityTfd.text = [NSString stringWithFormat:@"%@",[self.ocrFrontDic objectForKey:@"idCardNo"]];
            
            
        }else{
            
                        
            [MBProgressHUD showError:responseDic[@"message"] toView:self.view];
            
        }
        
        
        DLog(@"ä¸ä¼ æå:%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [hud hideAnimated:YES];

        DLog(@"failureï¼%@", error);
        
        //æå°éè¯¯ä¿¡æ¯
        if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
            NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
            DLog(@"å¤´åä¸ä¼ çéè¯¯ä¿¡æ¯ï¼%@",str);
        }
        
    }];
    
    
}


//ç»èº«ä»½è¯æ­£é¢èµå¼
-(void)setFrontImageViewWithURL:(NSString *)imgURL{
    
    //å¾çèµå¼
    [self.frontImgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"icon_shiming_touxiang"]];
    
}



//èº«ä»½è¯èé¢ä¸ä¼ å¾ç
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
        
        //è®¾ç½®è¯·æ±å¤´
         [manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
        
        
        NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@",XMF_BASE_URL,URL_wx_auth_idcard_back];
        
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
        
        [manager POST:requestUrlStr parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            /*å¾ççæ ¼å¼ æ¯MultipartFile  post åå­å«files*/
            
            
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.25);
            
            UIImage *wcImage = [image wcSessionCompress];
            
            
            NSData *imageData = UIImageJPEGRepresentation(wcImage, 0.1);

            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            /*
             æ­¤æ¹æ³åæ°ï¼
             1ãè¦ä¸ä¼ ç[äºè¿å¶æ°æ®]
             2ãå¯¹åºåå°ä¸å¤çæä»¶ç[å­æ®µâfilesâ]
             3ãè¦ä¿å­å¨æå¡å¨ä¸ç[æä»¶å]
             4ãä¸ä¼ æä»¶ç[mimeType]
             
             */
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
            
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            [hud hideAnimated:YES];
            
            //dataè½¬json
    //        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        

            NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
            
            
            DLog(@"ä¸ä¼ åé¢ï¼%@",responseDic);
            
            XMFResponseModel *responseModel = [XMFResponseModel yy_modelWithDictionary:responseObject];
        
            if (responseModel.code == XMFHttpReturnCodeSuccess){
                
                self.ocrBackDic = responseModel.data;
                
                NSString  *imgURL = [NSString stringWithFormat:@"%@",responseModel.data[@"pictureUrl"]];
            
                //ç»èº«ä»½è¯åé¢èµå¼
                [self setBackImageViewWithURL:imgURL];
                
                
            }else{
                
                            
                [MBProgressHUD showError:responseDic[@"message"] toView:self.view];
                
            }
            
            
            DLog(@"ä¸ä¼ æå:%@",responseObject);
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
            [hud hideAnimated:YES];

            DLog(@"failureï¼%@", error);
            
            //æå°éè¯¯ä¿¡æ¯
            if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
                NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
                DLog(@"å¤´åä¸ä¼ çéè¯¯ä¿¡æ¯ï¼%@",str);
            }
            
        }];
        
        
}


//ç»èº«ä»½è¯åé¢èµå¼
-(void)setBackImageViewWithURL:(NSString *)imgURL{
    
            
    //ç»èé¢å¾çèµå¼
    [self.backImgView sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"icon_shiming_guohuimian"]];
            
}



#pragma mark - âââââââæµè¯ç¸æº ââââââââ
#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // æ ç¸æºæé åä¸ä¸ªåå¥½çæç¤º
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"æ æ³ä½¿ç¨ç¸æº" message:@"è¯·å¨iPhoneç""è®¾ç½®-éç§-ç¸æº""ä¸­åè®¸è®¿é®ç¸æº" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"åæ¶" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"è®¾ç½®" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, é²æ­¢ç¨æ·é¦æ¬¡æç§æç»æææ¶ç¸æºé¡µé»å±
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // æç§ä¹åè¿éè¦æ£æ¥ç¸åæé
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // å·²è¢«æç»ï¼æ²¡æç¸åæéï¼å°æ æ³ä¿å­æçç§ç
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"æ æ³è®¿é®ç¸å" message:@"è¯·å¨iPhoneç""è®¾ç½®-éç§-ç¸å""ä¸­åè®¸è®¿é®ç¸å" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"åæ¶" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"è®¾ç½®" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // æªè¯·æ±è¿ç¸åæé
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// è°ç¨ç¸æº
- (void)pushImagePickerController {
    // æåå®ä½
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
        
        //æ·»å ææè§é¢
//        [mediaTypes addObject:(NSString *)kUTTypeMovie];
      
        //æ·»å ææç§ç
       [mediaTypes addObject:(NSString *)kUTTypeImage];
        
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        DLog(@"æ¨¡æå¨ä¸­æ æ³æå¼ç§ç¸æº,è¯·å¨çæºä¸­ä½¿ç¨");
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
            // åå§å¾çå¯ä»¥æ ¹æ®ç§ç¸æ¶çè§åº¦æ¥æ¾ç¤ºï¼ä½UIImageæ æ³å¤å®ï¼äºæ¯åºç°è·åçå¾çä¼åå·¦è½¬ï¼ï¼åº¦çç°è±¡ã
            // ä»¥ä¸ä¸ºè°æ´å¾çè§åº¦çé¨å
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // image=ç«æ­£è¿çå¾ç
            
            
        }
        
        
        // save photo and get asset / ä¿å­å¾çï¼è·åå°asset
        [[TZImageManager manager] savePhotoWithImage:image meta:meta location:self.location completion:^(PHAsset *asset, NSError *error){
            if (error) {
                
                DLog(@"å¾çä¿å­å¤±è´¥ %@",error);
                
            } else {
                
                DLog(@"å¾çä¿å­æå");
                
                [self refreshCollectionViewWithAddedAsset:asset image:image];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    
    
    if (self.selectedImgView == self.frontImgView) {
        //æ­£é¢
        
        [self dealWithFrontImage:image];
        
        
    }else if (self.selectedImgView == self.backImgView){//åé¢
        
        
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
        // set appearance / æ¹åç¸åéæ©é¡µçå¯¼èªæ å¤è§
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



#pragma mark - âââââââ æå è½½ ââââââââ
- (WCLActionSheet *)photoActionSheet
{
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[WCLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:XMFLI(@"åæ¶") destructiveButtonTitle:XMFLI(@"æç§") otherButtonTitles:XMFLI(@"ä»ç¸åéæ©"), nil];
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
