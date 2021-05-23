//
//  XMFAuthenticationController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/28.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAuthenticationController.h"

//图片选择
#import "MYActionSheetViewController.h"
#import "MYImagePicker.h"

#import "UIView+WaterMark.h"//文字水印


@interface XMFAuthenticationController ()<MYImagePickerDelegate,WCLActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

/** 身份信息背景view */
@property (weak, nonatomic) IBOutlet UIView *identityInfoBgView;

/** 身份信息背景view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *identityInfoBgViewHeight;



@property (weak, nonatomic) IBOutlet UITextField *nameTfd;

@property (weak, nonatomic) IBOutlet UITextField *identityTfd;


@property (weak, nonatomic) IBOutlet UIImageView *frontImgView;


@property (weak, nonatomic) IBOutlet UIButton *frontBtn;


@property (weak, nonatomic) IBOutlet UIImageView *backImgView;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

/** 选中的图片 */
@property (nonatomic, strong) UIImageView *selectedImgView;


/*** 选择器 **/
@property (nonatomic, strong) WCLActionSheet *photoActionSheet;

/** 正面身份证的识别id */
@property (nonatomic, copy) NSString *ocrIdxStr;


@end

@implementation XMFAuthenticationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"实名认证");
    
    self.identityInfoBgView.hidden = YES;
    
    self.identityInfoBgViewHeight.constant = 0.f;
    
    
//    [self.frontImgView addWaterMarkText:@"仅供海关清关使用" WithTextColor:UIColorFromRGB(0x302F2B) WithFont:[UIFont systemFontOfSize:8.f]];
    
}


-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    
    [self.frontImgView cornerWithRadius:14.f];
    
    [self.backImgView cornerWithRadius:14.f];
    
    [self.submitBtn cornerWithRadius:self.submitBtn.height/2];
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//身份证正面
            
            self.selectedImgView = self.frontImgView;
            
            [self.view endEditing:YES];
            
            [self.photoActionSheet showInView:self.view];

            
            /*
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
            */
            
            
            
        }
            break;
            
        case 1:{//身份证反面
            
            self.selectedImgView = self.backImgView;
            
            [self.view endEditing:YES];
            
            [self.photoActionSheet showInView:self.view];
            
            /*
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
             */
            
        }
            break;
            
        case 2:{//提交
            
            
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
    
   
    if (self.selectedImgView == self.frontImgView) {
        //正面
        
        [self dealWithImage:editedImage];

        
    }else if (self.selectedImgView == self.backImgView){//反面
        
        
        [self dealWithBackImage:editedImage];
        
        
    }
    
    
    
}




#pragma mark - ——————— WCLActionSheetDelegate ————————
- (void)actionImageSheet:(WCLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.photoActionSheet) { // 单独的选照片
        
        [self pushPhotoTZImagePickerController];
        
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
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos{
   
    
    UIImage *editedImage = [photos firstObject];
    
    if (self.selectedImgView == self.frontImgView) {
        //正面
        
//        [self dealWithImage:editedImage];
        
        [self dealWithFrontImage:editedImage];
        
        
    }else if (self.selectedImgView == self.backImgView){//反面
        
        
        [self dealWithBackImage:editedImage];
        
        
    }
    
    
}


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
        
        
        [hud hideAnimated:YES];
        
        //data转json
//        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    

        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        XMFResponseModel *responseModel = [XMFResponseModel yy_modelWithDictionary:responseObject];
    
        if (responseModel.code == XMFHttpReturnCodeSuccess){
            
            NSString  *imgURL = [NSString stringWithFormat:@"%@",responseModel.data[@"pictureUrl"]];
        
//            [goodsListModel.picUrlsArr addObject:imgURL];
            
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




- (void)dealWithImage:(UIImage *)image{
    
    self.frontImgView.image = image;
    
    self.identityInfoBgView.hidden = NO;
    
    self.identityInfoBgViewHeight.constant = 96.f;
    
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);

    NSString * imageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    //base64字符串转UIImage图片：

//    NSData *ImageData = [[NSData alloc] initWithBase64EncodedString:ImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

//    UIImage *testImage = [UIImage imageWithData:ImageData];
    
    
//    self.avatarImgView.image = testImage;

    
    
    //base64编码处理图片
    NSString *encodedImageStr = [UIImageJPEGRepresentation(image, 0.2) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
   //后台无法直接解析需要把字符“\r\n”全部去掉
//    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];


    //后台要求拼接参数
//    NSString *base64Str = [NSString stringWithFormat:@"image/png;base64,%@",encodedImageStr];
    
    NSDictionary *dic = @{
      
        @"imageContent":imageStr,
        
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_idcard_front parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"上传正面图片：shang%@",[responseObject description]);
        
        [hud hideAnimated:YES];

        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
//            self.avatarImgURL = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    
    
    
}


- (void)dealWithBackImage:(UIImage *)image{
    
    self.backImgView.image = image;
    
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0f);

    NSString * ImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];

    //base64字符串转UIImage图片：

//    NSData *ImageData = [[NSData alloc] initWithBase64EncodedString:ImageStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

//    UIImage *testImage = [UIImage imageWithData:ImageData];
    
    
//    self.avatarImgView.image = testImage;

    
    
    //base64编码处理图片
    NSString *encodedImageStr = [UIImageJPEGRepresentation(image, 0.2) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
   //后台无法直接解析需要把字符“\r\n”全部去掉
    encodedImageStr = [encodedImageStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];


    //后台要求拼接参数
//    NSString *base64Str = [NSString stringWithFormat:@"image/png;base64,%@",encodedImageStr];
    
    NSDictionary *dic = @{
      
        @"imageContent":encodedImageStr,
        
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_idcard_back parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"上传背面图片：shang%@",[responseObject description]);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
//            self.avatarImgURL = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}


//提交身份信息
-(void)submitIDCardInfo{
    
    
    if (![self.nameTfd.text nullToString]) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请填写真实姓名")];
        
        return;
        
    }else if (![self.identityTfd.text isIdentityCard]){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请填写对应身份证号")];
        
        return;
        
    }
    
    
    NSDictionary *dic = @{
        
        @"realName":self.nameTfd.text,
        
        @"idCardNo":self.identityTfd.text,
        
        @"ocrIdx":self.ocrIdxStr
        
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_auth_ocr_idcard_save parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"保存身份证信息：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


#pragma mark - ——————— 懒加载 ————————
- (WCLActionSheet *)photoActionSheet{
    
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[WCLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:XMFLI(@"取消") destructiveButtonTitle:nil otherButtonTitles:XMFLI(@"拍照与相册"), nil];
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
