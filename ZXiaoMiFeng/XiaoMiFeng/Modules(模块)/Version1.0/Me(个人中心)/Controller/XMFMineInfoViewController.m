//
//  XMFMineInfoViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMineInfoViewController.h"

//头像选择
#import "MYActionSheetViewController.h"
#import "MYImagePicker.h"

//日历
#import "WHUCalendarPopView.h"

//修改密码
#import "XMFSetPwdViewController.h"


@interface XMFMineInfoViewController ()<MYImagePickerDelegate,WCLActionSheetDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

@property (weak, nonatomic) IBOutlet UITextField *nickNameTfd;

@property (weak, nonatomic) IBOutlet UITextField *genderTfd;


@property (weak, nonatomic) IBOutlet UITextField *birthdayTfd;

//生日日历
@property (nonatomic, strong) WHUCalendarPopView *calenderPopView;

//头像链接
@property (nonatomic, copy) NSString *avatarImgURL;

//性别类型
@property (nonatomic, assign) NSInteger genderNum;


@end

@implementation XMFMineInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.avatarImgView cornerWithRadius:self.avatarImgView.height/2];
    
}

-(void)setupUI{
    
    self.topSpace.constant = kNavBarHeight;
    
    self.naviTitle = XMFLI(@"个人资料");
    
    //限制位数
    [self.nickNameTfd setValue:@30 forKey:@"LimitInput"];
    
    [self addRightItemWithTitle:XMFLI(@"保存") action:@selector(rightBtnDidClick:)];
    
    
    if (![UserInfoModel.avatarUrl nullToString]) {
        
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:UserInfoModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"icon_me_touxiang"]];
    }
    
    self.avatarImgURL = UserInfoModel.avatarUrl;
    
    
    /* 1.0 版本
    if (![UserInfoModel.nickName nullToString]) {
        
        self.nickNameTfd.text = UserInfoModel.nickName;
    }
    
    if (![UserInfoModel.gender nullToString]) {
        
        //1男 2女
        if ([UserInfoModel.gender isEqualToString:@"1"]) {
            
            self.genderTfd.text = @"男";
            
            
        }else if ([UserInfoModel.gender isEqualToString:@"2"]){
            
            self.genderTfd.text = @"女";
  
            
        }
        
        self.genderNum = [UserInfoModel.gender integerValue];
        
    
    }
    
    if (![UserInfoModel.birthDay nullToString]) {
        
        self.birthdayTfd.text = UserInfoModel.birthDay;
    }*/
    
      /* 2.0 版本 */
      if (![UserInfoModel.userNikeName nullToString]) {
          
          self.nickNameTfd.text = UserInfoModel.userNikeName;
      }
      
      if (![UserInfoModel.userGender nullToString]) {
          
          //1男 2女
          if ([UserInfoModel.userGender isEqualToString:@"1"]) {
              
              self.genderTfd.text = @"男";
              
              
          }else if ([UserInfoModel.userGender isEqualToString:@"2"]){
              
              self.genderTfd.text = @"女";
    
              
          }
          
          self.genderNum = [UserInfoModel.userGender integerValue];
          
      
      }
      
      if (![UserInfoModel.userBirthday nullToString]) {
          
          self.birthdayTfd.text = UserInfoModel.userBirthday;
      }
    
}

//右边“保存”按钮
-(void)rightBtnDidClick:(UIButton *)button{
    

    /*
    if ([UserInfoModel.avatarUrl nullToString] && [self.avatarImgURL nullToString]) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请上传头像")];
        
        return;
        
    }else if (![UserInfoModel.avatarUrl nullToString] && [self.avatarImgURL nullToString]){
        
        self.avatarImgURL = UserInfoModel.avatarUrl;
        
    }else if ([self.nickNameTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请输入昵称")];
        
        return;
        
    }else if ([self.genderTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请选择性别")];
        
        return;
        
    }*/
  
  /*
    //获取生日的时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
   
    NSDate *birthDate = [formatter dateFromString:self.birthdayTfd.text];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([birthDate timeIntervalSince1970]*1000)];
    */
    
    
    if ([self.nickNameTfd.text nullToString]){
        
        [MBProgressHUD showOnlyTextToView:[kApplication.windows lastObject] title:XMFLI(@"请输入昵称")];
        
        return;
        
    }
    
    [self.view endEditing:YES];
    
    NSDictionary *dic = @{
        
        @"userBirthday":self.birthdayTfd.text,
        
        @"userAvatar":self.avatarImgURL,
                
        @"userNikeName":self.nickNameTfd.text,
        
        @"userGender":@(self.genderNum)
        
        
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_user_update parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"修改个人资料：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self popAction];
            
            if (self->_modifyUserInfoBlock) {
                self->_modifyUserInfoBlock();
            }
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
    
    
}


//1.0版本更新资料方法
-(void)version1Save{
    
    NSDictionary *dic = @{
         
         @"birthDay":self.birthdayTfd.text,
         
         @"headImg":self.avatarImgURL,
         
         @"agentNo":UserInfoModel.agentNo,
         
         @"nickName":self.nickNameTfd.text,
         
         @"gender":@(self.genderNum)
         
         
     };
     
     [MBProgressHUD showOnlyLoadToView:self.view];
     
     [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_oauth_modifyUserInfo parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
         
         DLog(@"修改个人资料：%@",[responseObject description]);
         
         [MBProgressHUD hideHUDForView:self.view];
         
         if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
             
             [self popAction];
             
             if (self->_modifyUserInfoBlock) {
                 self->_modifyUserInfoBlock();
             }
             
         }else{
             
             
         }
         
     } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
         
         [MBProgressHUD hideHUDForView:self.view];
         
     }];
    
}

//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//头像
            
            MYActionSheetViewController *asvc = [MYActionSheetViewController ActionSheetViewController];
            MYSheetAction *cancelAction = [MYSheetAction actionWithTitle:@"取消" hander:nil];
            [asvc addCancelAction:cancelAction];
            MYSheetAction *cameraAction = [MYSheetAction actionWithTitle:@"拍照" hander:^(MYSheetAction *action) {
                DLog(@"拍照");
                MYImagePicker *imagePicker = [MYImagePicker sharedInstance];
                imagePicker.delegate = self;
                //[imagePicker showOriginalImagePickerWithType:ImagePickerCamera InViewController:self];
                [imagePicker showImagePickerWithType:ImagePickerCamera InViewController:self Scale:0.80];
            }];
            [asvc addAction:cameraAction];
            MYSheetAction *photoAction = [MYSheetAction actionWithTitle:@"从相册中选择" hander:^(MYSheetAction *action) {
                DLog(@"从相册中选择");
                MYImagePicker *imagePicker = [MYImagePicker sharedInstance];
                imagePicker.delegate = self;
                //[imagePicker showOriginalImagePickerWithType:ImagePickerPhoto InViewController:self];
                [imagePicker showImagePickerWithType:ImagePickerPhoto InViewController:self Scale:0.80];
            }];
            [asvc addAction:photoAction];
            [asvc presentWith:self animated:YES completion:nil];
            
            
        }
            break;
        case 1:{//性别
            
            WCLActionSheet *genderSheet = [[WCLActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
            
            [genderSheet showInView:self.view];
            
            
        }
            break;
        case 2:{//生日
        
            [self.calenderPopView show];
            
        }
            break;
        case 3:{//修改密码
            
            XMFSetPwdViewController  *VCtrl = [[XMFSetPwdViewController alloc]initWithType:resetPwd];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma mark - MYImagePickerDelegate
- (void)imagePickerDidCancel:(MYImagePicker *)imagePicker{
    
}
- (void)imagePicker:(MYImagePicker *)imagePicker didFinished:(UIImage *)editedImage{
    
    [self dealWithImage:editedImage];
    
}

- (void)dealWithImage:(UIImage *)image{
    
    self.avatarImgView.image = image;
    

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
    
    
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@",XMF_BASE_URL,URL_uploadPic];
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [manager POST:requestUrlStr parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*图片的格式 是MultipartFile  post 名字叫files*/
        
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        
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
        
        
        [MBProgressHUD hideHUDForView:self.view];
        
        //data转json
        //        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        XMFResponseModel *responseModel = [XMFResponseModel yy_modelWithDictionary:responseObject];
        
        if (responseModel.code == XMFHttpReturnCodeSuccess){
            
           self.avatarImgURL = [NSString stringWithFormat:@"%@",responseModel.data[@"url"]];
            

        }else{
            
            
            [MBProgressHUD showError:responseDic[@"message"] toView:self.view];
            
        }
        
        
        DLog(@"上传成功:%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [MBProgressHUD hideHUDForView:self.view];
        
        DLog(@"failure：%@", error);
        
        //打印错误信息
        if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
            NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
            DLog(@"头像上传的错误信息：%@",str);
        }
        
    }];
    
        

    
    
}

//1.0版本上传头像图片
- (void)dealWithImageVersion1:(UIImage *)image{
    
    self.avatarImgView.image = image;
    
    /*
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);

    NSString * ImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    //base64字符串转UIImage图片：

    NSData *ImageData = [[NSData alloc] initWithBase64EncodedString:ImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

    UIImage *testImage = [UIImage imageWithData:ImageData];
    
    
    self.avatarImgView.image = testImage;
    */
    
    //base64编码处理图片
    NSString *encodedImageStr = [UIImageJPEGRepresentation(image, 0.2) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
   //后台无法直接解析需要把字符“\r\n”全部去掉
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];


    //后台要求拼接参数
    NSString *base64Str = [NSString stringWithFormat:@"image/png;base64,%@",encodedImageStr];
    
    NSDictionary *dic = @{
      
        @"imgStr":base64Str,
        
        @"type":@"jpg"
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_storage_saveimg parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"上传图片：shang%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            self.avatarImgURL = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


#pragma mark - ——————— WCLActionSheetDelegate ————————

-(void)actionImageSheet:(WCLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:{//男
            
            DLog(@"男");
            self.genderTfd.text = @"男";
            
            self.genderNum = buttonIndex + 1;
            
        }
            
            break;
            
        case 1:{//女
            
             DLog(@"女");
            
            self.genderTfd.text = @"女";
            
            self.genderNum = buttonIndex + 1;
            
        }
            
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - ——————— 懒加载 ————————
-(WHUCalendarPopView *)calenderPopView{
    
    if (_calenderPopView == nil) {
        _calenderPopView = [[WHUCalendarPopView alloc] init];
        
        kWeakSelf(self)
        
        _calenderPopView.onDateSelectBlk = ^(NSDate *date) {
            
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSString *dateString = [format stringFromDate:date];
//            NSLog(@"%@",dateString);
            
            weakself.birthdayTfd.text = dateString;
            
        };
    }
    return _calenderPopView;
    
    
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
