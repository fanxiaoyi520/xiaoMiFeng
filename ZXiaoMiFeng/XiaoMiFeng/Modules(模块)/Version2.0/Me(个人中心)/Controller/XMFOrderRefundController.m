//
//  XMFOrderRefundController.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/9/11.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFOrderRefundController.h"
#import "XMFOrdersCommentAddImgCell.h"
#import "XMFMyOrdersListModel.h"//ๆ็่ฎขๅๆปmodel
#import "XMFMyOrdersPopView.h"//่ฎขๅๅๆ้ฎๅผน็ช


@interface XMFOrderRefundController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMFOrdersCommentAddImgCellDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,WCLActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UITextField *reasonTfd;

@property (weak, nonatomic) IBOutlet UILabel *amountLB;


@property (weak, nonatomic) IBOutlet UILabel *moblieLB;


@property (weak, nonatomic) IBOutlet UITextView *contentTxw;


@property (weak, nonatomic) IBOutlet UIButton *addImgBtn;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

/** ๅญๆฐ */
@property (weak, nonatomic) IBOutlet UILabel *wordsCountLB;

/** ้ไธญ็ๅพ็ */
@property (nonatomic, strong) NSMutableArray<UIImage *> *selectedPhotos;

@property (nonatomic, strong) NSMutableArray *selectedPhotosAssets;

/*** ้ๆฉๅจ **/
@property (nonatomic, strong) WCLActionSheet *photoActionSheet;



/** ๅพ็ๆฐ็ป */
@property (nonatomic, strong) NSMutableArray *picUrlsArr;

/** ้ๆฌพๅๅ  */
@property (nonatomic, assign) NSInteger type;

/** ่ฎขๅmodel */
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
    
    self.naviTitle = XMFLI(@"็ณ่ฏท้ๆฌพ");
    
    // ๆฐดๅนณๆนๅ็้ด่ท
     _flowLayout.minimumLineSpacing = 0 ;
     
     // ๅ็ดๆนๅ็้ด่ท
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
     
     
     self.contentTxw.zw_placeHolder = XMFLI(@"่ฏทๆจ่ฏฆ็ปๅกซๅ็ณ่ฏท่ฏดๆ๏ผๅฟๅกซ๏ผ");
     
     self.contentTxw.delegate = self;
     
     
     //้ป่ฎค้ซๅบฆไธบ0
     self.myCollectionViewHeight.constant = 0.f;
    
    
     [self setDataForView:self.listModel];
    
}


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//้ๆฉๅๅ 
            
            NSMutableArray *actionSheetItems = [@[FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"ๅคๆใ้ๆ")),FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"ไธๆณ่ฆ")),FSActionSheetTitleItemMake(FSActionSheetTypeNormal, XMFLI(@"ๅถไป"))] mutableCopy];
            FSActionSheet *actionSheet = [[FSActionSheet alloc] initWithTitle:@"" cancelTitle:XMFLI(@"ๅๆถ") items:actionSheetItems];
            // ๅฑ็คบๅนถ็ปๅฎ้ๆฉๅ่ฐ
            [actionSheet showWithSelectedCompletion:^(NSInteger selectedIndex) {
                FSActionSheetItem *item = actionSheetItems[selectedIndex];
                
                weakself.type = selectedIndex + 1;
                
                weakself.reasonTfd.text = item.title;
                                
                
            }];
        }
            break;
            
        case 1:{//ๆทปๅ ๅพ็
            
            [self.photoActionSheet showInView:self.view];
            
        }
            break;
            
        case 2:{//ๆไบค็ณ่ฏท
            
            if (self.type < 1) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"่ฏท้ๆฉ้ๆฌพๅๅ ")];
                
                return;
                
            }else if(self.contentTxw.text.length == 0){
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"่ฏทๅกซๅ็ณ่ฏท่ฏดๆ")];
                
                return;
            }
            
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"็ณป็ปๅฎกๆ ธ้่ฟๅ๏ผ\n1-7ไธชๅทฅไฝๆฅๅๅ่ทฏ้ๅ");
            
            popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                if (button.tag == 0) {//็กฎ่ฎค
                    
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

//ไธบ้กต้ข่ตๅผ
-(void)setDataForView:(XMFMyOrdersListModel *)listModel{
    
    self.amountLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:listModel.actualPrice]];
    
    self.moblieLB.text = listModel.mobile;
    
    
}


#pragma mark - โโโโโโโ collectionView็ไปฃ็ๆนๆณๅๆฐๆฎๆบ โโโโโโโโ

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


#pragma mark - โโโโโโโ XMFOrdersCommentAddImgCell็ไปฃ็ๆนๆณ โโโโโโโโ

//ๅ ้คๅพ็็ๆ้ฎ
-(void)buttonsOnXMFOrdersCommentAddImgCellDidClick:(XMFOrdersCommentAddImgCell *)cell button:(UIButton *)button{
    
    
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    NSMutableArray *cellSelectedPhotos = self.selectedPhotos;
    
     [cellSelectedPhotos removeObjectAtIndex:indexPath.row];

    self.selectedPhotos = cellSelectedPhotos;
    
    [self.selectedPhotosAssets removeObjectAtIndex:indexPath.row];
    
    [self.picUrlsArr removeObjectAtIndex:indexPath.row];
    
    [self.myCollectionView reloadData];
    
    
}




#pragma mark - โโโโโโโ UITextView็ไปฃ็ๆนๆณ โโโโโโโโ

-(void)textViewDidChange:(UITextView *)textView{
    
    //ๅฎๆถ็ป่ฎกๅญๆฐ
    if (textView.text.length <= 70) {
        
        self.wordsCountLB.text = [NSString stringWithFormat:@"%zd/70", textView.text.length];
    }else{
        
        [MBProgressHUD showError:XMFLI(@"ๆๅค่พๅฅ70ไธชๅญ") toView:kAppWindow];
        
        return;
    }
    
    
}


#pragma mark - โโโโโโโ WCLActionSheetDelegate โโโโโโโโ
- (void)actionImageSheet:(WCLActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.photoActionSheet) { // ๅ็ฌ็้็ง็
        
        [self pushPhotoTZImagePickerController];
        
    }
}


// ๅผนๅบ็ธๅ้ๆฉๅจ
- (void)pushPhotoTZImagePickerController
{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = self.selectedPhotosAssets; // ็ฎๅๅทฒ็ป้ไธญ็ๅพ็ๆฐ็ป
    imagePickerVc.allowTakePicture = YES;                     // ๅจๅ้จๆพ็คบๆ็งๆ้ฎ
    // 3. ่ฎพ็ฝฎๆฏๅฆๅฏไปฅ้ๆฉ่ง้ข/ๅพ็/ๅๅพ
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.showSelectedIndex = YES;
    //imagePickerVc.allowPickingGif = self.allowPickingGifSwitch.isOn;
    //imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideoSwitch.isOn; // ๆฏๅฆๅฏไปฅๅค้่ง้ข
    if(@available(iOS 13.0,*)){
        imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:imagePickerVc animated:YES completion:nil];
            
        
}


#pragma mark - TZImagePickerControllerDelegate

#pragma mark -  ้ๆฉ็ธๅๅ่ฐ
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
   
    // PHAsset
    self.selectedPhotos = [NSMutableArray arrayWithArray:photos];
    self.selectedPhotosAssets = [NSMutableArray arrayWithArray:assets];
    
    
    //ๅฝๆฒกๆ้ไธญๅพ็็ๆถๅ
    if (self.selectedPhotos.count == 0) {
        
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
        self.myCollectionViewHeight.constant = (KScreenWidth - 30)/4.0;
        
    }
    
    [self.myCollectionView reloadData];
    
    
    //ๅๆธ้คไปฅๅ็ๆฐๆฎ
    
    [self.picUrlsArr removeAllObjects];
    
    
    for (UIImage *image in self.selectedPhotos) {
        
        [self dealWithImage:image];
    }
        
    
}


#pragma mark - โโโโโโโ ็ฝ็ป่ฏทๆฑ โโโโโโโโ

//ไธไผ ๅพ็
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
    
    //่ฎพ็ฝฎ่ฏทๆฑๅคด
     [manager.requestSerializer setValue:UserInfoModel.token forHTTPHeaderField:@"X-Beemall-Token"];
    
    
    NSString *requestUrlStr = [NSString stringWithFormat:@"%@%@",XMF_BASE_URL,URL_uploadPic];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [manager POST:requestUrlStr parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*ๅพ็็ๆ ผๅผ ๆฏMultipartFile  post ๅๅญๅซfiles*/
        
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        NSString *str = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        /*
         ๆญคๆนๆณๅๆฐ๏ผ
         1ใ่ฆไธไผ ็[ไบ่ฟๅถๆฐๆฎ]
         2ใๅฏนๅบๅๅฐไธๅค็ๆไปถ็[ๅญๆฎตโfilesโ]
         3ใ่ฆไฟๅญๅจๆๅกๅจไธ็[ๆไปถๅ]
         4ใไธไผ ๆไปถ็[mimeType]
         
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [hud hideAnimated:YES];
        
        //data่ฝฌjson
//        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    

        NSDictionary *responseDic = [NSDictionary dictionaryWithDictionary:responseObject];
        
        XMFResponseModel *responseModel = [XMFResponseModel yy_modelWithDictionary:responseObject];
    
        if (responseModel.code == XMFHttpReturnCodeSuccess){
            
            NSString  *imgURL = [NSString stringWithFormat:@"%@",responseModel.data[@"url"]];
        
            [self.picUrlsArr addObject:imgURL];
            
        }else{
            
                        
            [MBProgressHUD showError:responseDic[@"message"] toView:self.view];
            
        }
        
        
        DLog(@"ไธไผ ๆๅ:%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [hud hideAnimated:YES];

        DLog(@"failure๏ผ%@", error);
        
        //ๆๅฐ้่ฏฏไฟกๆฏ
        if([error.domain isEqualToString:AFURLResponseSerializationErrorDomain]){
            NSData *errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSString * str = [[NSString alloc]initWithData:errorData encoding:NSUTF8StringEncoding];
            DLog(@"ๅคดๅไธไผ ็้่ฏฏไฟกๆฏ๏ผ%@",str);
        }
        
    }];
    
    
}

//็ณ่ฏท้ๆฌพ
-(void)postOrderRefund{
    
    if (self.type < 1) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"่ฏท้ๆฉ้ๆฌพๅๅ ")];
        
        return;
        
    }else if(self.contentTxw.text.length == 0){
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"่ฏทๅกซๅ็ณ่ฏท่ฏดๆ")];
        
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
        
        DLog(@"็ณ่ฏท้ๆฌพ๏ผ%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"ๅทฒๆไบค็ณ่ฏทๅพๅๅฎถ็กฎ่ฎค");
            
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

#pragma mark - โโโโโโโ ๆๅ ่ฝฝ โโโโโโโโ
-(NSMutableArray *)picUrlsArr{
    
    if (_picUrlsArr == nil) {
        _picUrlsArr = [[NSMutableArray alloc] init];
    }
    return _picUrlsArr;
}

- (WCLActionSheet *)photoActionSheet
{
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[WCLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"ๅๆถ" destructiveButtonTitle:nil otherButtonTitles:XMFLI(@"ๆ็งไธ็ธๅ"), nil];
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
