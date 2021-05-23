//
//  XMFOrderRateController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderRateController.h"
#import "XMFOrderRateCell.h"//商品评价cell
#import "XMFMyOrdersListModel.h"//我的订单总model
#import "XMFOrderRateFooterView.h"//尾部view
#import "YYStarView.h"//星星view
#import "XMFMyOrdersPopView.h"//订单单按钮弹窗


#import <MobileCoreServices/MobileCoreServices.h>


@interface XMFOrderRateController ()<UITableViewDelegate,UITableViewDataSource,XMFOrderRateCellDelegate,WCLActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate,XMFOrderRateFooterViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;

/** 订单model */
@property (nonatomic, strong) XMFMyOrdersListModel *listModel;

/** 尾部view */
@property (nonatomic, strong) XMFOrderRateFooterView *footerView;

/** 选中的评论cell */
@property (nonatomic, strong) XMFOrderRateCell *selectedRateCell;

/*** 选择器 **/
@property (nonatomic, strong) WCLActionSheet *photoActionSheet;

/*** 选择图片数组 **/
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@property (nonatomic, strong) NSMutableArray *selectedPhotosAssets;

/** 评价类型 */
@property (nonatomic, assign) orderRateType rateType;

@property (strong, nonatomic) CLLocation *location;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@end

@implementation XMFOrderRateController

-(instancetype)initWithListModel:(XMFMyOrdersListModel *)listModel orderRateType:(orderRateType)type{
    
    
    if (self = [super init]) {
                
        self.listModel = listModel;
        
        self.rateType = type;
    }
    
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

-(void)setupUI{
    
    if (self.rateType == soonComment) {
        
        self.naviTitle = XMFLI(@"立即评价");
        
        self.footerView.anonymousBtn.hidden = NO;
        
    }else{
        
        self.naviTitle = XMFLI(@"追加评价");
        
        self.footerView.anonymousBtn.hidden = YES;

    }
    
    
    self.view.backgroundColor = UIColorFromRGB(0xF3F3F5);
    
    [self.view addSubview:self.myTableView];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(kTopHeight);
        
        make.left.right.bottom.equalTo(self.view);
        
    }];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrderRateCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFOrderRateCell class])];
    
    
    self.myTableView.tableFooterView = self.footerView;
    
    self.footerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要

    //防止刷新抖动
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;
    
    
    //防止数据复用
    for (__strong XMFMyOrdersListGoodsListModel *goodsListModel in self.listModel.goodsList) {
        
        goodsListModel.star = 0;
        
        goodsListModel.content = @"";
        
        [goodsListModel.picUrlsArr removeAllObjects];
        
        [goodsListModel.selectedPhotos removeAllObjects];
        
        [goodsListModel.selectedPhotosAssets removeAllObjects];
        
        goodsListModel.wordsCountNum = 0;

        
    }
    
    [self.myTableView reloadData];
    
}

#pragma mark - ——————— tableView的数据源和代理方法 ————————

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.listModel.goodsList.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFOrderRateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFOrderRateCell class])];
    
    /*
     
     不复用cell
     
//    XMFOrderRateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFOrderRateCell class]) forIndexPath:indexPath];
    
    
    NSString *identifier = [NSString stringWithFormat:@"%zd",indexPath.row];;
    
    
    XMFOrderRateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [XMFOrderRateCell XMFLoadFromXIB];
        
        [cell setValue:identifier forKey:@"reuseIdentifier"];
   
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }*/
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    [self setModelOfCell:cell atIndexPath:indexPath];
    
    return cell;
    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(self)
    
    
    return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFOrderRateCell class]) configuration:^(XMFOrderRateCell *cell) {
         
         
         [weakself setModelOfCell:cell atIndexPath:indexPath];
           
     }];
    
//    return 300;
    
}

-(void)setModelOfCell:(XMFOrderRateCell *)cell atIndexPath:(NSIndexPath *)indexPath{

    
    cell.cellRow = indexPath.row;
    
    XMFMyOrdersListGoodsListModel *goodsListModel = self.listModel.goodsList[indexPath.row];
    
    //传入页面的评论类型
    goodsListModel.rateType = self.rateType;
    
    cell.goodsListModel = goodsListModel;
    
    
}

#pragma mark - ——————— XMFOrderRateCell的代理方法 ————————
//添加图片
-(void)buttonsOnXMFOrderRateCellDidClick:(XMFOrderRateCell *)rateCell{
    
    
    [self.view endEditing:YES];
    
    self.selectedRateCell = rateCell;
    
    
    [self.photoActionSheet showInView:self.view];
    
}


//删除图片
-(void)buttonsIncommentAddImgCellOnXMFOrderRateCellDidSelect:(XMFOrderRateCell *)rateCell atRateCellRow:(NSInteger)row atCommentAddImgCellIndexPath:(NSIndexPath *)indexPath{
    
    
    XMFMyOrdersListGoodsListModel *listModel = self.listModel.goodsList[row];
    
    [listModel.selectedPhotos removeObjectAtIndex:indexPath.item];
    
    [listModel.selectedPhotosAssets removeObjectAtIndex:indexPath.item];
    
//    [listModel.picUrlsArr removeObjectAtIndex:indexPath.item];
    
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    
 
    //重新上传一次，防止删除的数据和留下的数据不一样
    
      //先清除以前的数据
      [listModel.picUrlsArr removeAllObjects];
      
      for (UIImage *image in listModel.selectedPhotos) {
          
          [self dealWithImage:image goodsListModel:listModel];
          
      }
    
}

//评论内容发生改变
-(void)textViewOnXMFOrderRateCellDidChange:(XMFOrderRateCell *)rateCell atRateCellRow:(NSInteger)row textView:(UITextView *)textView{
    
    XMFMyOrdersListGoodsListModel *goodsModel = self.listModel.goodsList[row];
    
    goodsModel.content = textView.text;

    goodsModel.wordsCountNum = textView.text.length;
    
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

//星星数量发生了改变
-(void)starViewOnXMFOrderRateCellDidClick:(XMFOrderRateCell *)rateCell atRateCellRow:(NSInteger)row starView:(YYStarView *)starView{
    
    NSInteger starNum = starView.starScore;
    
    XMFMyOrdersListGoodsListModel *goodsModel = self.listModel.goodsList[row];
    
    goodsModel.star = starNum;
    
    
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - ——————— XMFOrderRateFooterView的代理方法 ————————
-(void)buttonsOnXMFOrderRateFooterViewDidClick:(XMFOrderRateFooterView *)footerView button:(UIButton *)button{
    
    
    switch (button.tag) {
        case 0:{//匿名评论
            
            button.selected = !button.selected;
            
        }
            
            break;
            
        case 1:{//提交
            
            
            if (self.rateType == soonComment) {//立即评价
                
                
                //首先遍历看看是否有填写完整的
                
                
                
                for (XMFMyOrdersListGoodsListModel *listModel in self.listModel.goodsList) {
                    
                    if ((listModel.star > 0) && (listModel.content.length > 0) && (listModel.picUrlsArr.count > 0)) {//可以提交评价了
                        
                        
                        [self postSoonComment];
                        
                        return;
                        
                        
                    }else{
                        
                        [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"请您完善评价信息，至少给1个宝贝打分，填填评价，上传一张评价图片")];
                    }
                    
                    
                }
                
                
                /*
                //然后再遍历看看是否有填写部分的，进行相关提示
                for (XMFMyOrdersListGoodsListModel *listModel in self.listModel.goodsList) {
                    
                    if((listModel.star > 0) || (listModel.content.length > 0) || (listModel.picUrlsArr.count > 0)){
                        //可以进行无数据提示了
                        
                        if (listModel.star == 0) {
                            
                            [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"请给商品打分")];
                            
                        }else if (listModel.content.length == 0){
                            
                            [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"填填评价吧~")];
                            
                        }else if (listModel.picUrlsArr.count == 0){
                            [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"评价图片最少1张")];
                            
                        }
                        
                        
                    }else{
                        
                        [hud hideAnimated:YES];
                        
                        [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"请您完善评价信息，至少给1个宝贝打分，填填评价，上传一张评价图片")];
                    }
                    
                    
                }*/
                
                
            }else{//追加评价
                
                
                
                //首先遍历看看是否有填写完整的
                for (XMFMyOrdersListGoodsListModel *listModel in self.listModel.goodsList) {
                    
                    if ((listModel.content.length > 0) && (listModel.picUrlsArr.count > 0)) {//可以提交评价了
                        
                        [self postAddComment];
                        
                        return;
                        
                        
                    }else{
                        
                        [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"请您完善追加评价信息，至少上传一张图片")];
                    }
                    
                    
                }
                
                
                /*
                //然后再遍历看看是否有填写部分的，进行相关提示
                for (XMFMyOrdersListGoodsListModel *listModel in self.listModel.goodsList) {
                    
                    if((listModel.content.length > 0) || (listModel.picUrlsArr.count > 0)){
                        //可以进行无数据提示了
                        if (listModel.content.length == 0){
                            
                            [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"填填评价吧~")];
                            
                        }else if (listModel.picUrlsArr.count == 0){
                            
                            [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"评价图片最少1张")];
                            
                        }
                        
                        
                    }else{
                        
                        [hud hideAnimated:YES];
                        
                        [MBProgressHUD  showOnlyTextToView:self.view title:XMFLI(@"请您完善追加评价信息，至少上传一张图片")];
                    }
                    
                    
                }*/
                
                
                
                
                
            }
            
            
        }
            
            break;
            
        default:
            break;
    }
    
    
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
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:10 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:self.selectedRateCell];
    
    XMFMyOrdersListGoodsListModel *listModel = self.listModel.goodsList[indexPath.row];
    
    imagePickerVc.selectedAssets = listModel.selectedPhotosAssets; // 目前已经选中的图片数组
    
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
    
    //给评论cell的图片赋值
//    self.selectedRateCell.selectedPhotos = self.selectedPhotos;
    
//    self.selectedRateCell.selectedPhotosAssets = self.selectedPhotosAssets;
    
    
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:self.selectedRateCell];
    
    XMFMyOrdersListGoodsListModel *listModel = self.listModel.goodsList[indexPath.row];
    
    listModel.selectedPhotos = self.selectedPhotos;
    
    listModel.selectedPhotosAssets = self.selectedPhotosAssets;
    
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    
    //先清除以前的数据
    [listModel.picUrlsArr removeAllObjects];
    
    
    for (UIImage *image in self.selectedPhotos) {
        
        [self dealWithImage:image goodsListModel:listModel];
        
    }
    
    /*
    for (int i = 0; i < self.selectedPhotos.count; ++i) {
        
        UIImage *image = self.selectedPhotos[i];
        
        [self dealWithImage:image goodsListModel:listModel];
    }*/
    
    
}


#pragma mark - ——————— 网络请求 ————————
//上传图片
- (void)dealWithImage:(UIImage *)image goodsListModel:(XMFMyOrdersListGoodsListModel *)goodsListModel{
    
    
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
        
            [goodsListModel.picUrlsArr addObject:imgURL];
            
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


//立即评价类型的时候：提交评价
-(void)postSoonComment{
    
    NSMutableArray *goodsCommentArr = [[NSMutableArray alloc]init];
    
    //model中是否有属性，然后再决定是否加入其它内容
    BOOL isHasContent = NO;
    
    for (XMFMyOrdersListGoodsListModel *listModel in self.listModel.goodsList) {
        
        NSMutableDictionary *goodsCommentDic = [[NSMutableDictionary alloc]init];
        
        //星星
        if (listModel.star > 0) {
            
            [goodsCommentDic setValue:@(listModel.star) forKey:@"star"];
            
            isHasContent = YES;
            
        }
        
        //内容
        if (listModel.content.length > 0) {
             
            [goodsCommentDic setValue:listModel.content forKey:@"content"];
            
             isHasContent = YES;
             
         }
        
        
        //图片
        if (listModel.picUrlsArr.count > 0) {
            
             [goodsCommentDic setValue:listModel.picUrlsArr forKey:@"picUrls"];
            
             isHasContent = YES;
        }
        
        
        //判断是否有内容
        if (isHasContent) {
            

            //拼接商品规格
            NSString *specStr = [NSString string];
            for (NSString *str in listModel.specifications) {
                
                if ([str isEqualToString:[listModel.specifications firstObject]]) {
                    
                    specStr = str;
                    
                }else{
                    
                    specStr = [NSString stringWithFormat:@"%@,%@",specStr,str];
                    
                }
                

            }
            
            [goodsCommentDic setValue:specStr forKey:@"specifications"];
    
            [goodsCommentDic setValue:listModel.productId forKey:@"valueId"];
            
            
        }
        
        
        //是否是匿名
        [goodsCommentDic setValue:@(self.footerView.anonymousBtn.selected) forKey:@"anonymous"];
        
        //不管有无内容都要加入
        [goodsCommentDic setValue:listModel.keyId forKey:@"orderGoodsId"];
        
        [goodsCommentArr addObject:goodsCommentDic];
        
        
        isHasContent = NO;
        
        DLog(@"商品参数：%@",[goodsCommentDic description]);
    }
    


    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_comment_addComment parameters:goodsCommentArr success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"添加评论：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            if (self->_submitCommentBlock) {
                self->_submitCommentBlock(self.rateType);
            }
            

            [self popAction];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
    
    
    
}


//追加评价类型的时候：提交评价
-(void)postAddComment{
    
    NSMutableArray *goodsCommentArr = [[NSMutableArray alloc]init];
    
    //model中是否有属性，然后再决定是否加入其它内容
    BOOL isHasContent = NO;
    
    for (XMFMyOrdersListGoodsListModel *listModel in self.listModel.goodsList) {
        
        NSMutableDictionary *goodsCommentDic = [[NSMutableDictionary alloc]init];
        
        
        //内容
        if (listModel.content.length > 0) {
             
            [goodsCommentDic setValue:listModel.content forKey:@"content"];
            
             isHasContent = YES;
             
         }
        
        
        //图片
        if (listModel.picUrlsArr.count > 0) {
            
             [goodsCommentDic setValue:listModel.picUrlsArr forKey:@"picUrls"];
            
             isHasContent = YES;
        }
        
        
        //判断是否有内容
        if (isHasContent) {
            
        
            [goodsCommentDic setValue:listModel.productId forKey:@"valueId"];
            
            
        }
        
        //不管有无内容都要加入
        [goodsCommentDic setValue:listModel.keyId forKey:@"orderGoodsId"];
        
        
        [goodsCommentArr addObject:goodsCommentDic];

        
        
        isHasContent = NO;
        
        
    }
    


    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_comment_appendComment parameters:goodsCommentArr success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"追加评论：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            if (self->_submitCommentBlock) {
                self->_submitCommentBlock(self.rateType);
            }
            
            XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"提交评价成功，待系统审核\n回首页再逛逛吧~");
            
            popView.popViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                [self popAction];

                
            };
            
            [popView show];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
    
    
    
}



#pragma mark - ——————— 懒加载 ————————

-(UITableView *)myTableView{
    
    if (_myTableView == nil) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _myTableView.backgroundColor = UIColorFromRGB(0xF3F3F5);
        
        /*
         
        kWeakSelf(self)
        
        _myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakself getNewData];
            
        }];*/
        
        
       
        
    }
    return _myTableView;
    
}

-(XMFOrderRateFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [XMFOrderRateFooterView XMFLoadFromXIB];
        _footerView.delegate = self;
    }
    return _footerView;
    
    
}

- (WCLActionSheet *)photoActionSheet
{
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[WCLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:XMFLI(@"取消") destructiveButtonTitle:XMFLI(@"拍照") otherButtonTitles:XMFLI(@"从相册选择"), nil];
    }
    return _photoActionSheet;
}


-(NSMutableArray *)selectedPhotos{

    if (_selectedPhotos == nil) {
        _selectedPhotos = [[NSMutableArray alloc] init];
    }
    return _selectedPhotos;
    
}

-(NSMutableArray *)selectedPhotosAssets{
    
    if (_selectedPhotosAssets == nil) {
        _selectedPhotosAssets = [[NSMutableArray alloc] init];
    }
    return _selectedPhotosAssets;
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
        NSDictionary *meta = [info objectForKey:UIImagePickerControllerMediaMetadata];
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
    
    // PHAsset

    [self.selectedPhotos addObject:image];
    [self.selectedPhotosAssets addObject:asset];
    
    
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:self.selectedRateCell];
    
    XMFMyOrdersListGoodsListModel *listModel = self.listModel.goodsList[indexPath.row];
    
    listModel.selectedPhotos = self.selectedPhotos;
    
    listModel.selectedPhotosAssets = self.selectedPhotosAssets;
    
    [self.myTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    
    //上传
    [self dealWithImage:image goodsListModel:listModel];
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
