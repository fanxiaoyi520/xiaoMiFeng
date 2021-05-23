//
//  XMFOrdersCommentController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersCommentController.h"
#import "XMFOrdersCommentCell.h"
#import "XMFOrdersCommentFooterView.h"
#import "XMFOrdersCellModel.h"//订单列表model
#import "XMFOrdersDetailModel.h"//订单详情model
#import "XMFOrdersCommentUploadModel.h"//评论上传的model



@interface XMFOrdersCommentController ()<UITableViewDelegate,UITableViewDataSource,XMFOrdersCommentCellDelegate,WCLActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>


@property (nonatomic, strong) UITableView *myTableView;


@property (nonatomic, strong) XMFOrdersCommentFooterView *footerView;


//订单列表model
@property (nonatomic, strong) XMFOrdersCellModel *orderModel;

//订单详情model
@property (nonatomic, strong) XMFOrdersDetailModel *detailModel;

/*** 选择器 **/
@property (nonatomic, strong) WCLActionSheet *photoActionSheet;

/*** 选择图片数组 **/
@property (nonatomic, strong) NSMutableArray *selectedPhotos;

@property (nonatomic, strong) NSMutableArray *selectedPhotosAssets;

//选中的评论cell
@property (nonatomic, strong) XMFOrdersCommentCell *selectedCommentCell;

//评论上传内容数据数组
@property (nonatomic, strong) NSMutableArray <XMFOrdersCommentUploadModel *>*commentUploadModelArr;

//数据数组
@property (nonatomic, strong) NSMutableArray *datasourceArr;


@end

@implementation XMFOrdersCommentController

-(instancetype)initWithModel:(XMFOrdersCellModel *)ordersModel{
    
    if (self = [super init]) {
        
        self.orderModel = ordersModel;
        
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"发表评价");
    
    self.view.backgroundColor = UIColorFromRGB(0xF3F3F5);
    
    [self.view addSubview:self.myTableView];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(kTopHeight);
        
        make.left.right.bottom.equalTo(self.view);
        
    }];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrdersCommentCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFOrdersCommentCell class])];

    
    
    [self getNewData];
    
}

#pragma mark - ——————— tableView的数据源和代理方法 ————————

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return self.detailModel.orderGoods.count;
    
    return self.datasourceArr.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFOrdersCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFOrdersCommentCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    [self setModelOfCell:cell atIndexPath:indexPath];
    
    return cell;
    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 354;
    
}


-(void)setModelOfCell:(XMFOrdersCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
//    cell.goodsModel = self.detailModel.orderGoods[indexPath.row];
    
    cell.goodsModel = self.datasourceArr[indexPath.row];
    
    cell.cellRow = indexPath.row;
    
}


#pragma mark - ——————— XMFOrdersCommentCell的代理方法 ————————

//点击cell
-(void)commentAddImgCellOnXMFOrdersCommentCellDidSelect:(XMFOrdersCommentCell *)commentCell commentAddImgCell:(XMFOrdersCommentAddImgCell *)commentAddImgCell atCommentCellRow:(NSInteger)row atCommentAddImgCellIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.photoActionSheet showInView:self.view];
    
    
}

//点击添加图片
-(void)buttonsOnXMFOrdersCommentCellDidClick:(XMFOrdersCommentCell *)commentCell{
    
    self.selectedCommentCell = commentCell;
    
     [self.photoActionSheet showInView:self.view];
    
}


//点击删除图片
-(void)buttonsIncommentAddImgCellOnXMFOrdersCommentCellDidSelect:(XMFOrdersCommentCell *)commentCell atCommentCellRow:(NSInteger)row atCommentAddImgCellIndexPath:(NSIndexPath *)indexPath{

    NSMutableArray *cellSelectedPhotos = commentCell.selectedPhotos;
    
     [cellSelectedPhotos removeObjectAtIndex:indexPath.row];

     commentCell.selectedPhotos = cellSelectedPhotos;
    
    [commentCell.selectedPhotosAssets removeObjectAtIndex:indexPath.row];
}


//评论框的内容发生了改变
-(void)textViewOnXMFOrdersCommentCellDidChange:(XMFOrdersCommentCell *)cell atCommentCellRow:(NSInteger)row textView:(UITextView *)textView{
    
    
    XMFOrdersCommentUploadModel *uploadModel = self.commentUploadModelArr[row];
    
    uploadModel.content = textView.text;
    
    DLog(@"评论内容：%@",uploadModel.content);
    
}


#pragma mark - ——————— 网络请求 ————————
-(void)getNewData{
    
    NSDictionary *dic = @{
        
        @"orderId":self.orderModel.orderId
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_comment_orderDetail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"订单详情：%@",[responseObject description]);
        
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
//            self.detailModel = [XMFOrdersDetailModel yy_modelWithDictionary:responseObjectModel.data];
            
            [self.datasourceArr removeAllObjects];
            
            NSArray *dataArr = responseObject[@"data"];
            
            
            for (NSDictionary *dic in dataArr) {
                
                XMFOrdersDetailOrderGoodsModel *goodsModel = [XMFOrdersDetailOrderGoodsModel yy_modelWithDictionary:dic];
                
                [self.datasourceArr addObject:goodsModel];
                
            }
            
            
            
            
            self.myTableView.tableFooterView = self.footerView;
            
            self.footerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要

            [self.myTableView reloadData];
            
            
            //为发表评论内容数据做准备
            [self.commentUploadModelArr removeAllObjects];
            
            for (XMFOrdersDetailOrderGoodsModel *goodsModel in self.datasourceArr) {
                
                
                XMFOrdersCommentUploadModel *uploadModel = [[XMFOrdersCommentUploadModel alloc]init];
                
                uploadModel.orderGoodsId = goodsModel.orderGoodsId;
                
                uploadModel.star = @"4";
                
                uploadModel.type = @"0";
                
                uploadModel.valueId = goodsModel.productId;
                
                uploadModel.content = @"";
                
                uploadModel.picUrls = [[NSMutableArray alloc]init];
                
                
                [self.commentUploadModelArr addObject:uploadModel];
                
                
            }
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        [self.myTableView.mj_header endRefreshing];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];

        [self.myTableView.mj_header endRefreshing];
        
    }];
    
    
}


//上传图片
- (void)dealWithImage:(UIImage *)image atCommentCellRow:(NSInteger)row{
    
//    self.avatarImgView.image = image;
    

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
            
           NSString  *imgURL = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
            XMFOrdersCommentUploadModel *uploadModel = self.commentUploadModelArr[row];
            
            [uploadModel.picUrls addObject:imgURL];
            
            
            
        }else{
            
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}



//发表评论
-(void)postAddComment{
    
    NSMutableArray *uploadArr = [[NSMutableArray alloc]init];
    
    
    //获取评论内容不为空的数据
    for (XMFOrdersCommentUploadModel *model in self.commentUploadModelArr) {
    
        if (![model.content nullToString]) {
            
            NSDictionary *modelDic = [model yy_modelToJSONObject];
            
            [uploadArr addObject:modelDic];
            
        }
 
        
    }
    
    
    if (uploadArr.count == 0) {
        
        [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请填写至少一个宝贝的评论内容")];
        
        return;
        
    };
    
    
    //参数直接传数组，因为后台接收的就是数组
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_comment_addComment parameters:uploadArr success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"评论成功：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
            
            //执行block并返回
            if (self->_addCommentSuccessBlock && (uploadArr.count == self.datasourceArr.count)) {
                
                self->_addCommentSuccessBlock();
            }
            
            [self popAction];
            
            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
    
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
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    imagePickerVc.selectedAssets = self.selectedCommentCell.selectedPhotosAssets; // 目前已经选中的图片数组
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
    self.selectedCommentCell.selectedPhotos = self.selectedPhotos;
    
    self.selectedCommentCell.selectedPhotosAssets = self.selectedPhotosAssets;
    
    //先清除以前的数据
    XMFOrdersCommentUploadModel *uploadModel = self.commentUploadModelArr[self.selectedCommentCell.cellRow];
    
    [uploadModel.picUrls removeAllObjects];
    
    for (UIImage *image in self.selectedPhotos) {
        
        [self dealWithImage:image atCommentCellRow:self.selectedCommentCell.cellRow];
        
    }
    
    
}


#pragma mark - ——————— 懒加载 ————————

-(NSMutableArray<XMFOrdersCommentUploadModel *> *)commentUploadModelArr{
    
    if (_commentUploadModelArr == nil) {
        _commentUploadModelArr = [[NSMutableArray alloc] init];
    }
    return _commentUploadModelArr;
    
    
}


- (WCLActionSheet *)photoActionSheet
{
    if (!_photoActionSheet) {
        
        _photoActionSheet = [[WCLActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:XMFLI(@"拍照与相册"), nil];
    }
    return _photoActionSheet;
}



-(UITableView *)myTableView{
    
    if (_myTableView == nil) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _myTableView.backgroundColor = UIColorFromRGB(0xF3F3F5);
        
        kWeakSelf(self)
        
        _myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakself getNewData];
            
        }];
        
        
       
        
    }
    return _myTableView;
    
}


-(XMFOrdersCommentFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrdersCommentFooterView class]) owner:nil options:nil] firstObject];
        
        kWeakSelf(self)
        _footerView.sureBtnBlock = ^{
            
            [weakself postAddComment];
        };
    }
    return _footerView;
    
    
}


-(NSMutableArray *)datasourceArr{
    
    
    if (_datasourceArr == nil) {
        _datasourceArr = [[NSMutableArray alloc] init];
    }
    return _datasourceArr;
    
    
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
