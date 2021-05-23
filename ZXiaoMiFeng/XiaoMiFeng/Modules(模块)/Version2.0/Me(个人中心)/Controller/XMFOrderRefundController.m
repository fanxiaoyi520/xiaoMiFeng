//
//  XMFOrderRefundController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/11.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderRefundController.h"
#import "XMFOrdersCommentAddImgCell.h"
#import "XMFMyOrdersListModel.h"//我的订单总model
#import "XMFMyOrdersPopView.h"//订单单按钮弹窗


@interface XMFOrderRefundController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMFOrdersCommentAddImgCellDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,WCLActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UITextField *reasonTfd;

@property (weak, nonatomic) IBOutlet UILabel *amountLB;


@property (weak, nonatomic) IBOutlet UILabel *moblieLB;


@property (weak, nonatomic) IBOutlet UITextView *contentTxw;


@property (weak, nonatomic) IBOutlet UIButton *addImgBtn;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

/** 字数 */
@property (weak, nonatomic) IBOutlet UILabel *wordsCountLB;

/** 选中的图片 */
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedPhotos;

@property (nonatomic, strong) NSMutableArray *selectedPhotosAssets;

/*** 选择器 **/
@property (nonatomic, strong) WCLActionSheet *photoActionSheet;



/** 图片数组 */
@property (nonatomic, strong) NSMutableArray *picUrlsArr;

/** 退款原因 */
@property (nonatomic, assign) NSInteger type;

/** 订单model */
@property (nonatomic, strong) XMFMyOrdersListModel *listModel;



@end

@implementation XMFOrderRefundController


-(instancetype)initWithListModel:(XMFMyOrdersListModel *)listModel{
    
    
    if (self = [super init]) {
                
        self.listModel = listModel;
    }
    
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"申请退款");
    
    // 水平方向的间距
     _flowLayout.minimumLineSpacing = 0 ;
     
     // 垂直方向的间距
     _flowLayout.minimumInteritemSpacing = 0;
     
     _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     
     _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
     
     if (@available (iOS 11.0,*)) {
         
         self.myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     }
     
    self.myCollectionView.delegate = self;
     
     self.myCollectionView.dataSource = self;
     
     //    _myCollectionView.pagingEnabled = YES;
     
     [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrdersCommentAddImgCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFOrdersCommentAddImgCell class])];
     
     
     self.contentTxw.zw_placeHolder = XMFLI(@"请您详细填写申请说明（必填）");
     
     self.contentTxw.delegate = self;
     
     
     //默认高度为0
     self.myCollectionViewHeight.constant = 0.f;
    
    
     [self setDataForView:self.listModel];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//选择原因
            
            NSMutableArray *actionSheetItems = [@[FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"多拍、错拍")),FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"不想要")),FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"其他"))] mutableCopy];
            FSActionSheet *actionSheet = [[FSActionSheet alloc] initWithTitle:@"" cancelTitle:XMFLI(@"取消") items:actionSheetItems];
            // 展示并绑定选择回调
            [actionSheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
                FSActionSheetItem *item = actionSheetItems[selectedIndex];
                
                weakself.type = selectedIndex + 1;
                
                weakself.reasonTfd.text = item.title;
                                
                
            }];
        }
            break;
            
        case 1:{//添加图片
            
            [self.photoActionSheet showInView:self.view];
            
        }
            break;
            
        case 2:{//提交申请
            
            if (self.type < 1) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请选择退款原因")];
                
                return;
                
            }else if(self.contentTxw.text.length == 0){
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请填写申请说明")];
                
                return;
            }
            
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"系统审核通过后，\n1-7个工作日内原路退回");
            
            popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                if (button.tag == 0) {//确认
                    
                    [weakself postOrderRefund];

                    
                }
                
            };
            
            [popView show];
            
        
            
        }
            break;
            
        default:
            break;
    }
    
  
    
    
}

//为页面赋值
-(void)setDataForView:(XMFMyOrdersListModel *)listModel{
    
    self.amountLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:listModel.actualPrice]];
    
    self.moblieLB.text = listModel.mobile;
    
    
}


#pragma mark - ——————— collectionView的代理方法和数据源 ————————

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.selectedPhotos.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMFOrdersCommentAddImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFOrdersCommentAddImgCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    

    cell.commentImgView.image = self.selectedPhotos[indexPath.item];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = KScreenWidth - 30;
    
    return CGSizeMake(width / 4.0, self.myCollectionView.height);
     
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    /*
    XMFOrdersCommentAddImgCell *cell = (XMFOrdersCommentAddImgCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if ([self.delegate respondsToSelector:@selector(commentAddImgCellOnXMFOrdersCommentCellDidSelect:commentAddImgCell:atCommentCellRow:atCommentAddImgCellIndexPath:)]) {
        
        [self.delegate commentAddImgCellOnXMFOrdersCommentCellDidSelect:self commentAddImgCell:cell atCommentCellRow:self.cellRow atCommentAddImgCellIndexPath:indexPath];
    }*/
    
    
}


#pragma mark - ——————— XMFOrdersCommentAddImgCell的代理方法 ————————

//删除图片的按钮
-(void)buttonsOnXMFOrdersCommentAddImgCellDidClick:(XMFOrdersCommentAddImgCell *)cell button:(UIButton *)button{
    
    
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    NSMutableArray *cellSelectedPhotos = self.selectedPhotos;
    
     [cellSelectedPhotos removeObjectAtIndex:indexPath.row];

    self.selectedPhotos = cellSelectedPhotos;
    
    [self.selectedPhotosAssets removeObjectAtIndex:indexPath.row];
    
    [self.picUrlsArr removeObjectAtIndex:indexPath.row];
    
    [self.myCollectionView reloadData];
    
    
}




#pragma mark - ——————— UITextView的代理方法 ————————

-(void)textViewDidChange:(UITextView *)textView{
    
    //实时统计字数
    if (textView.text.length <= 70) {
        
        self.wordsCountLB.text = [NSString stringWithFormat:@"%zd/70", textView.text.length];
    }else{
        
        [MBProgressHUD showError:XMFLI(@"最多输入70个字") toView:kAppWindow];
        
        return;
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
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = self.selectedPhotosAssets; // 目前已经选中的图片数组
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
   
    // PHAsset
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedPhotosAssets = [NSMutableArray arrayWithArray:assets];
    
    
    //当没有选中图片的时候
    if (self.selectedPhotos.count == 0) {
        
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
        self.myCollectionViewHeight.constant = (KScreenWidth - 30)/4.0;
        
    }
    
    [self.myCollectionView reloadData];
    
    
    //先清除以前的数据
    
    [self.picUrlsArr removeAllObjects];
    
    
    for (UIImage *image in self.selectedPhotos) {
        
        [self dealWithImage:image];
    }
        
    
}


#pragma mark - ——————— 网络请求 ————————

//上传图片
- (void)dealWithImage:(UIImage *)image{
    
    
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
            
            NSString  *imgURL = [NSString stringWithFormat:@"%@",responseModel.data[@"url"]];
        
            [self.picUrlsArr addObject:imgURL];
            
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

//申请退款
-(void)postOrderRefund{
    
    if (self.type < 1) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请选择退款原因")];
        
        return;
        
    }else if(self.contentTxw.text.length == 0){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请填写申请说明")];
        
        return;
    }
    
    NSDictionary *dic = @{
        
        @"amount":self.listModel.actualPrice,
        
        @"mobile":self.listModel.mobile,
        
        @"orderId":self.listModel.keyId,
        
        @"picUrls":self.picUrlsArr,
        
        @"reason":self.contentTxw.text,
        
        @"type":@(self.type),
        
        
        
    };
    

    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_refund parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"申请退款：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"已提交申请待商家确认");
            
            popView.popViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                 [self popAction];
            };
            
            
            [popView show];
            
            
            if (self->_orderRefundBlock) {
                self->_orderRefundBlock();
            }

        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
    
}

#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray *)picUrlsArr{
    
    if (_picUrlsArr == nil) {
        _picUrlsArr = [[NSMutableArray alloc] init];
    }
    return _picUrlsArr;
}

- (WCLActionSheet *)photoActionSheet
{
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[WCLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:XMFLI(@"拍照与相册"), nil];
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
