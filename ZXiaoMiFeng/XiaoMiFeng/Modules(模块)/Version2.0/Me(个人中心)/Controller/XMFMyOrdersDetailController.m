//
//  XMFMyOrdersDetailController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/10.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersDetailController.h"
#import "XMFMyOrdersListCell.h"//cell
#import "XMFMyOrdersDetailHeaderView.h"//头部view
#import "XMFMyOrdersDetailFooterView.h"//尾部view
//#import "XMFMyOrdersDetailModel.h"//订单详情总model
#import "XMFMyOrdersListModel.h"//我的订单总model
#import "XMFMyOrdersListFooterCell.h"//操作的cell
#import "XMFMyOrdersListFooterModel.h"//操作的model
#import "XMFOrdersLogisticsModel.h"//物流信息的model
#import "CountDown.h"//倒计时
#import "XMFMyOrdersPopView.h"//订单单按钮弹窗
#import "XMFMyDeliveryAddressController.h"//选择地址页面
#import "XMFOrdersLogisticsController.h"//查看物流
#import "XMFMyDeliveryAddressModel.h"//地址model
#import "XMFOrderRefundController.h"//申请退款
#import "XMFOrderRateController.h"//立即评价
#import "XMFOrdersPayModel.h"//去付款的model
#import "XMFOrderPayResultController.h"//支付结果页
#import "XMFGoodsDetailViewController.h"//商品详情
#import "UITableView+ZFTableViewSnapshot.h"//tableView截图
#import <TYSnapshotScroll.h>//截长图


@interface XMFMyOrdersDetailController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,XMFMyOrdersDetailHeaderViewDelegate,XMFCommonPopViewDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleLB;

/** 截图 */
@property (weak, nonatomic) IBOutlet UIButton *screenshotBtn;



/** 订单列表 */
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 按钮的列表 */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

/** 底部的view */
@property (weak, nonatomic) IBOutlet UIView *bottomView;


/** 底部view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

/** 底部的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomSpace;

/** 补充身份信息 */
@property (weak, nonatomic) IBOutlet UIButton *addIdentityBtn;

/** 头部view */
@property (nonatomic, strong) XMFMyOrdersDetailHeaderView *headerView;

/** 尾部view */
@property (nonatomic, strong) XMFMyOrdersDetailFooterView *footerView;


/** 订单id */
@property (nonatomic, copy) NSString *orderIdStr;

/** 订单详情model */
@property (nonatomic, strong) XMFMyOrdersListModel *orderDetailModel;


/** 操作的数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFMyOrdersListFooterModel *> *dataSourceArr;

/** 物流数据model */
@property (nonatomic, strong) XMFOrdersLogisticsModel *logisticsModel;


/** 倒计时 */
@property (strong, nonatomic)  CountDown *countDownForBtn;

/** 限制区域的提示弹框 */
@property (nonatomic, strong) XMFCommonPopView *restrictedAreaPopView;


@end

@implementation XMFMyOrdersDetailController


-(instancetype)initWithOrderId:(NSString *)orderId{
    
    self = [super init];
    
    if (self) {
        
        self.orderIdStr = orderId;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}

-(void)setupUI{
    
//    self.topBgViewbgColor = UIColorFromRGB(0xF7CF20);
//    
//    self.naviTitle = XMFLI(@"订单详情");
    
    self.topViewHeight.constant = kTopHeight;
    
    self.titleLB.text = XMFLI(@"订单详情");
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    // line 跟滚动方向相同的间距
    flowLayout.minimumLineSpacing = 12;
    
    // item 跟滚动方向垂直的间距
    flowLayout.minimumInteritemSpacing = 0;
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
    self.myCollectionView.collectionViewLayout = flowLayout;
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    
    self.myCollectionView.showsHorizontalScrollIndicator = NO;
    
    //从右向左对齐
    self.myCollectionView.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFMyOrdersListFooterCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFMyOrdersListFooterCell class])];
    

    
//    [self getOrderDetail];
    
    [self getOrderQueryTrack];
    
    
    //底部安全间距
    self.bottomViewBottomSpace.constant = kSAFE_AREA_BOTTOM;
    
}


-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    /** 订单状态（101: '未付款’,102: '用户取消’,103: '系统取消’,109: '付款失败’,201: '已付款’, 202: '申请退款’, 203: '已退款’, 204: '已付款（退款失败）’, 209: '退款中’,301: '已发货’,401: '用户收货’, 402: ‘系统收货’ 409: '待评价’） */
    
    
    if ([self.orderDetailModel.orderStatus isEqualToString:@"301"] || [self.orderDetailModel.orderStatus isEqualToString:@"401"]  || [self.orderDetailModel.orderStatus isEqualToString:@"402"] || [self.orderDetailModel.orderStatus isEqualToString:@"409"]) {
        
        self.screenshotBtn.hidden = NO;
        
        [self.screenshotBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:4.f];

        
    }else{
        
        self.screenshotBtn.hidden = YES;
    }
    
    
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//返回
            
            [self popAction];

            
        }
            break;
            
        case 1:{//截图
            
            /*
            CGSize size = self.myTableView.bounds.size;
            
            UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
            
            CGRect rect = self.myTableView.frame;
            
            [self.myTableView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
            
            UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
            */
            
            
            /*
            CGPoint orginalContentOffset = self.myTableView.contentOffset;
            
            
            UIImage * snapshotImage = [self.myTableView zf_tableViewSnapshot];

            ///结束之后滚动原来
            self.myTableView.contentOffset = orginalContentOffset;
            
            UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
             
             */
            
            
            
            
            [TYSnapshotScroll screenSnapshot:self.myTableView finishBlock:^(UIImage *snapShotImage) {
                    //doSomething
                
                UIImageWriteToSavedPhotosAlbum(snapShotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                
                
                }];
             
            

            /*
            UIImage * snapshotImage = [self.myTableView takeSnapshotOfVisibleContent];
            
            UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
             */
            
            /*
            [self.myTableView asyncTakeSnapshotOfFullContent:^(UIImage * _Nullable image) {
                
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                
            }];*/
            
        }
            break;
            
        case 2:{//补充身份信息
            
            [MBProgressHUD showOnlyTextToView:self.view title:@"等待完善，暂时不要继续"];
            
            
            //updateAddress
            
            XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
            
            VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
                
                
                [weakself postOrderUpdateOrderAddress:self.orderDetailModel.keyId addressModel:addressModel];
                
            };
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
            
            
            
            
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}





//参数1:图片对象
//参数2:成功方法绑定的target
//参数3:成功后调用方法
//参数4:需要传递信息(成功后调用方法的参数)
//UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    
    if(error){
        
        msg = @"保存图片失败" ;
        
        [MBProgressHUD showError:XMFLI(@"保存失败，请先获取相册权限") toView:kAppWindow];

        
    }else{
        
        msg = @"保存图片成功" ;
        
        [MBProgressHUD showSuccess:XMFLI(@"保存成功") toView:kAppWindow];
        
    }
}


#pragma mark - ——————— UITableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    return self.orderDetailModel.goodsList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFMyOrdersListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFMyOrdersListCell class]) owner:nil options:nil] firstObject];;
    }
        

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    cell.detailGoodsModel = self.orderDetailModel.goodsList[indexPath.row];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KScaleWidth(112);
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XMFMyOrdersListGoodsListModel *goodsListModel = self.orderDetailModel.goodsList[indexPath.row];
    
    
    XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:goodsListModel.goodsId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}


#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFMyOrdersListFooterCell *footerCell = (XMFMyOrdersListFooterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFMyOrdersListFooterCell class]) forIndexPath:indexPath];

    footerCell.footerModel = self.dataSourceArr[indexPath.item];
    
    return footerCell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
    
    XMFMyOrdersListFooterCell *cell = (XMFMyOrdersListFooterCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    kWeakSelf(self)
      
      switch (cell.footerModel.handleOptionNum) {
          case 0:{//confirm
              
              XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
              
              popView.tipsLB.text = XMFLI(@"确认收货后，交易完成哦~");
              
              popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                  
                  if (button.tag == 0) {//确认
                      
                      [weakself postOrderConfirm:self.orderDetailModel.keyId];
                      
                  }
                  
              };
              
              [popView show];
              
              
              
          }
              break;
          case 1:{//queryTrack
              
              XMFOrdersLogisticsController  *VCtrl = [[XMFOrdersLogisticsController alloc]initWithOrderListModel:self.orderDetailModel];
              
              [self.navigationController pushViewController:VCtrl animated:YES];
              
          }
              break;
          case 2:{//cancel
              
              XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
              
              popView.tipsLB.text = XMFLI(@"确认取消订单吗?");
              
              popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
              
                  if (button.tag == 0) {//确认
                      
                      [weakself getOrderCancel:self.orderDetailModel.keyId];
                      
                  }
                  
              };
              
              [popView show];
              
          }
              break;
          case 3:{//remind
              
              [self getOrderRemain:self.orderDetailModel.keyId];
              
              
          }
              break;
          case 4:{//comment
              
              XMFOrderRateController  *VCtrl = [[XMFOrderRateController alloc]initWithListModel:self.orderDetailModel orderRateType:soonComment];
              
              VCtrl.submitCommentBlock = ^(orderRateType type) {
                  
                  
                  XMFMyOrdersListModel *orderModel = self.orderDetailModel;
                  
                  orderModel.orderStatus = @"401";
                  
                  [orderModel.handleOption setValue:@(NO) forKey:@"comment"];
                  
                  [orderModel.handleOption setValue:@(YES) forKey:@"appendComment"];
                  
                  //刷新底部列表
                  [weakself reloadMyCollectionView:weakself.orderDetailModel];
                  
                  //操作返回block
                  if (self->_myOrdersDetailBlock) {
                      self->_myOrdersDetailBlock(self.orderDetailModel);
                  }
                  
                  
              };
              
              [self.navigationController pushViewController:VCtrl animated:YES];
              
          }
              break;
          case 5:{//delete
              
              [self getOrderDeleteOrder:self.orderDetailModel.keyId];
              
          }
              break;
          case 6:{//pay
              
              [self postOrderPay:self.orderDetailModel.keyId];
          }
              break;
          case 7:{//updateAddress
              
              XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
              
              VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
                  
                  
                  /*
                  //是否修改了地址
                  weakself.orderDetailModel.isUpdateAddress = YES;
                  
                  weakself.orderDetailModel.consignee = addressModel.name;
                  
                  weakself.orderDetailModel.mobile = addressModel.mobile;
                  
                  weakself.orderDetailModel.address = [NSString stringWithFormat:@"%@%@%@%@",[AddressManager getProvinceName:addressModel.provinceId],[AddressManager getCityName:addressModel.cityId],[AddressManager getAreaName:addressModel.areaId],addressModel.address];
                  
                  weakself.headerView.detailModel = weakself.orderDetailModel;
                  */
                  
                  [weakself postOrderUpdateOrderAddress:self.orderDetailModel.keyId addressModel:addressModel];
                  
              };
              
              
              [self.navigationController pushViewController:VCtrl animated:YES];
              
          }
              break;
          case 8:{//extendConfirm
              
           
              [self getOrderExtendConfirm:self.orderDetailModel.keyId];
              
              
          }
              break;
          case 9:{//rebuy
              

              
          }
              break;
          case 10:{//appendComment
              
              XMFOrderRateController  *VCtrl = [[XMFOrderRateController alloc]initWithListModel:self.orderDetailModel orderRateType:addComment];
              
              VCtrl.submitCommentBlock = ^(orderRateType type) {
                  
                  XMFMyOrdersListModel *orderModel = weakself.orderDetailModel;
                  
                  [orderModel.handleOption setValue:@(NO) forKey:@"appendComment"];
                  
                  //刷新底部列表
                  [weakself reloadMyCollectionView:weakself.orderDetailModel];
                  
                  //操作返回block
                  if (self->_myOrdersDetailBlock) {
                      self->_myOrdersDetailBlock(self.orderDetailModel);
                  }
                  
              };
              
              [self.navigationController pushViewController:VCtrl animated:YES];
              
          }
              break;
          case 11:{//refund
              
              XMFOrderRefundController  *VCtrl = [[XMFOrderRefundController alloc]initWithListModel:self.orderDetailModel];
              
              VCtrl.orderRefundBlock = ^{
                  
                  XMFMyOrdersListModel *orderModel = weakself.orderDetailModel;
                  
                  orderModel.orderStatus = @"202";
                  
                  [orderModel.handleOption setValue:@(NO) forKey:@"refund"];
                  
                  [orderModel.handleOption setValue:@(YES) forKey:@"cancelRefund"];
                  
                  [orderModel.handleOption setValue:@(NO) forKey:@"updateAddress"];
                  
                  [orderModel.handleOption setValue:@(NO) forKey:@"remind"];

                  
                  //刷新底部列表
                  [weakself reloadMyCollectionView:weakself.orderDetailModel];
                  
                  weakself.headerView.detailModel = weakself.orderDetailModel;

                  
                  //操作返回block
                  if (self->_myOrdersDetailBlock) {
                      self->_myOrdersDetailBlock(self.orderDetailModel);
                  }
                  
                  
              };
              
              [self.navigationController pushViewController:VCtrl animated:YES];
              
          }
              break;
          case 12:{//cancelRefund
              
              [self getOrderCancelRefund:self.orderDetailModel.keyId];
              
          }
              break;
          case 13:{//addCart
              
              [MBProgressHUD showOnlyTextToView:self.view title:@"加入购物车，等待后台接口"];
          }
              break;
              
          case 14:{//contact
              
              XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
              
              VCtrl.urlStr = @"https://im.7x24cc.com/phone_webChat.html?accountId=N000000013029&chatId=6aded8fa-f405-4371-8aba-c982f8fb7f8d";
              
              [self.navigationController pushViewController:VCtrl animated:YES];
              
          }
              break;

          default:
              break;
      }
      
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KScaleWidth(100), self.myCollectionView.height);

}


#pragma mark - ——————— XMFMyOrdersDetailHeaderView的代理方法 ————————
-(void)viewsOnXMFGoodsDetailHeaderViewDidTap:(XMFMyOrdersDetailHeaderView *)headerView tapView:(UIView *)tapView{

    //查看物流
    XMFOrdersLogisticsController  *VCtrl = [[XMFOrdersLogisticsController alloc]initWithOrderListModel:self.orderDetailModel];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}


#pragma mark - ——————— XMFCommonPopView的代理方法 ————————
-(void)buttonsOnXMFCommonPopViewDidClick:(XMFCommonPopView *)popView button:(UIButton *)button{
    
    kWeakSelf(self)
    
    if (popView == self.restrictedAreaPopView) {
        
        
        switch (button.tag) {
            case 0:{//修改地址
                
                
                XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
                
                VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
                
                    
                    [weakself postOrderUpdateOrderAddress:self.orderDetailModel.keyId addressModel:addressModel];
                    
                };
                
                
                [self.navigationController pushViewController:VCtrl animated:YES];
                
                
            }
                break;
                
            case 1:{//取消订单
                
                XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
                
                popView.tipsLB.text = XMFLI(@"确认取消订单吗?");
                
                popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                    if (button.tag == 0) {//确认
                        
                        [weakself getOrderCancel:self.orderDetailModel.keyId];
                        
                    }
                    
                };
                
                [popView show];
                
            }
                break;
                
            default:
                break;
        }
        
        
        
        
        
    }
    
    
}


#pragma mark - ——————— 网络请求 ————————

//获取订单详情
-(void)getOrderDetail{
    
    NSDictionary *dic = @{
        
        @"orderId":self.orderIdStr
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"订单详情：%@",responseObject);
        
        [hud hideAnimated:YES];

        [self.view hideErrorPageView];
        
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            self.orderDetailModel = [XMFMyOrdersListModel yy_modelWithDictionary:responseObjectModel.data];

            
            //赋值
            [self setDataForView];
            
            //注意detailModel不能与logisticsModel更换位置，因为在logisticsModel用到了detailModel
            self.headerView.detailModel = self.orderDetailModel;
            
            //物流信息赋值
            self.headerView.logisticsModel = self.logisticsModel;
            
            
            self.myTableView.tableHeaderView = self.headerView;
             
             self.headerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
            
            self.footerView.detailModel = self.orderDetailModel;
             
             self.myTableView.tableFooterView = self.footerView;
             
             self.footerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
            
            [self.myTableView reloadData];
            
            
            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
            
            //补充身份信息按钮
            self.addIdentityBtn.hidden = !self.orderDetailModel.oldFlag;
            
            self.myCollectionView.hidden = self.orderDetailModel.oldFlag;
        
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getOrderDetail];
                
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getOrderDetail];


        }];
    }];
    
}

//获取商品物流信息
-(void)getOrderQueryTrack{
    
    NSDictionary *dic = @{
        
        @"orderId":self.orderIdStr
        
    };
    
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_queryTrack parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"物流轨迹：%@",responseObject);
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            self.logisticsModel = [XMFOrdersLogisticsModel yy_modelWithDictionary:responseObjectModel.data];
            
//            self.headerView.logisticsModel = self.logisticsModel;
            
           
            
        }else{
            
//            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
      
        }
        
         [self getOrderDetail];
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
                
    }];
    
    
}


//为headerView赋值
-(void)setDataForView{
    
    /**
     订单状态（101: '未付款’,102: '用户取消’,103: '系统取消’,104:支付确认中,109: '付款失败’,201: '已付款’, 202: '申请退款’, 203: '已退款’, 204: '已付款（退款失败）’, 209: '退款中’,301: '已发货’,401: '用户收货’, 402: ‘系统收货’ 409: '待评价’）
     
     */
    switch ([self.orderDetailModel.orderStatus integerValue]) {
        case 101:
            
        case 104://订单处理中
            
        {

            
            //倒计时
            _countDownForBtn = [[CountDown alloc] init];
            
            
            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *addtimeDate = [formater dateFromString:self.orderDetailModel.addTime];
            
            //30分钟后的NSDate
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            
            [comps setMinute:30];
            
            NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            NSDate *finishDate = [calender dateByAddingComponents:comps toDate:addtimeDate options:0];
            
            //当前时间的NSDate
            NSDate* currentDate = [NSDate date];
            
            NSString *currentTimeString = [formater stringFromDate:currentDate];
            
            NSDate *startDate = [formater dateFromString:currentTimeString];
            
            if ([self.orderDetailModel.orderStatus integerValue] == 104) {
                
                [self orderProcessingStartWithStartDate:startDate finishDate:finishDate];
                
            }else{
                
                //开始倒计时
                [self startWithStartDate:startDate finishDate:finishDate];
            }
            

            
        }
            break;
            
        default:
            break;
    }
    
}


//确认收货
-(void)postOrderConfirm:(NSString *)orderIdStr{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_confirm parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"确认收货：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
        
            XMFMyOrdersListModel *orderModel = self.orderDetailModel;
            
            orderModel.orderStatus = @"409";
            
            [orderModel.handleOption setValue:@(NO) forKey:@"confirm"];
            
            [orderModel.handleOption setValue:@(YES) forKey:@"comment"];
            
            
          
            
            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
                
        
            self.headerView.detailModel = self.orderDetailModel;
            
            
            //操作返回block
            if (self->_myOrdersDetailBlock) {
                self->_myOrdersDetailBlock(self.orderDetailModel);
            }
            
            
            //进入订单评价页面
            XMFOrderRateController  *VCtrl = [[XMFOrderRateController alloc]initWithListModel:self.orderDetailModel orderRateType:soonComment];
            
            VCtrl.submitCommentBlock = ^(orderRateType type) {
                
               //操作返回block
               if (self->_myOrdersDetailBlock) {
                   self->_myOrdersDetailBlock(self.orderDetailModel);
               }
                
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
}


//用户延长收货时间
-(void)getOrderExtendConfirm:(NSString *)orderIdStr{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_extendConfirm parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"延长收货：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            //3天就直接提示成功
            
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
            
            XMFMyOrdersListModel *orderModel = self.orderDetailModel;
            
            
            [orderModel.handleOption setValue:@(NO) forKey:@"extendConfirm"];

            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
            
            //自动收货延长7天时间
            self.orderDetailModel.autoConfirmTime = [DateUtils getDate:self.orderDetailModel.autoConfirmTime day:7];
            
            self.headerView.detailModel = self.orderDetailModel;

            
        }else if (responseObjectModel.code == 222){
            //不是3天就提示弹框
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"距离结束时间3天才可申请延长收货哦~");
            
            [popView show];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}

//用户取消订单
-(void)getOrderCancel:(NSString *)orderIdStr{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_cancel parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"取消订单：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
           
            
            XMFMyOrdersListModel *orderModel = self.orderDetailModel;
            
            orderModel.orderStatus = @"102";
            
            [orderModel.handleOption setValue:@(NO) forKey:@"cancel"];
            
            [orderModel.handleOption setValue:@(NO) forKey:@"pay"];
            
            [orderModel.handleOption setValue:@(NO) forKey:@"updateAddress"];
            
            [orderModel.handleOption setValue:@(YES) forKey:@"delete"];
            
            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
            
            self.headerView.detailModel = self.orderDetailModel;
            
                
        //操作返回block
        if (self->_myOrdersDetailBlock) {
            self->_myOrdersDetailBlock(self.orderDetailModel);
        }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}

//用户提醒发货
-(void)getOrderRemain:(NSString *)orderIdStr{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_remain parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"提醒发货：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"已提醒商家发货，请耐心等待");
            
            
            [popView show];
            
            
            
            /*
            XMFMyOrdersListModel *orderModel = self.orderDetailModel;
            
            [orderModel.handleOption setValue:@(NO) forKey:@"remind"];
            
            
            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
            
            //操作返回block
            if (self->_myOrdersDetailBlock) {
                self->_myOrdersDetailBlock(self.orderDetailModel);
            }*/
                
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}


//用户发起退款申请
-(void)postOrderRefund:(NSString *)orderIdStr{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_refund parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"用户发起退款申请：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"已提交申请待商家确认");
            
            
            [popView show];
            
            
            XMFMyOrdersListModel *orderModel = self.orderDetailModel;
            
            orderModel.orderStatus = @"202";
            
            [orderModel.handleOption setValue:@(NO) forKey:@"refund"];
            
            [orderModel.handleOption setValue:@(YES) forKey:@"cancelRefund"];
            
            [orderModel.handleOption setValue:@(NO) forKey:@"updateAddress"];
            
            [orderModel.handleOption setValue:@(NO) forKey:@"remind"];
            
            
            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
            
            
            self.headerView.detailModel = self.orderDetailModel;
            
            
            //操作返回block
            if (self->_myOrdersDetailBlock) {
                self->_myOrdersDetailBlock(self.orderDetailModel);
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}

//用户取消退款
-(void)getOrderCancelRefund:(NSString *)orderIdStr{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_cancelRefund parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"用户取消退款：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
            
            XMFMyOrdersListModel *orderModel = self.orderDetailModel;
            
            orderModel.orderStatus = @"201";

            
            [orderModel.handleOption setValue:@(NO) forKey:@"cancelRefund"];
            
            [orderModel.handleOption setValue:@(YES) forKey:@"refund"];
            
            [orderModel.handleOption setValue:@(YES) forKey:@"updateAddress"];
            
            [orderModel.handleOption setValue:@(YES) forKey:@"remind"];

            
            
            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
            
            
            self.headerView.detailModel = self.orderDetailModel;
                
                
            //操作返回block
            if (self->_myOrdersDetailBlock) {
                self->_myOrdersDetailBlock(self.orderDetailModel);
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}

//用户删除订单
-(void)getOrderDeleteOrder:(NSString *)orderIdStr{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_deleteOrder parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"用户删除订单：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
            
                
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}


//修改收货地址
-(void)postOrderUpdateOrderAddress:(NSString *)orderIdStr addressModel:(XMFMyDeliveryAddressModel *)addressModel{
    
    
    NSDictionary *dic = @{
        
        @"addressId":addressModel.addressId,
        @"orderId":orderIdStr,
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_updateOrderAddress parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"修改地址：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            //是否修改了地址
            self.orderDetailModel.isUpdateAddress = YES;
            
            self.orderDetailModel.consignee = addressModel.name;
            
            self.orderDetailModel.mobile = addressModel.mobile;
            
            self.orderDetailModel.address = [NSString stringWithFormat:@"%@%@%@%@",[AddressManager getProvinceName:addressModel.provinceId],[AddressManager getCityName:addressModel.cityId],[AddressManager getAreaName:addressModel.areaId],addressModel.address];
            
            
            //下面是补充身份特定需要的
            self.orderDetailModel.oldFlag = NO;
            
            //补充身份信息按钮
            self.addIdentityBtn.hidden = !self.orderDetailModel.oldFlag;
            
            self.myCollectionView.hidden = self.orderDetailModel.oldFlag;
            
            
            self.headerView.detailModel = self.orderDetailModel;
            
            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
            
            
            //操作返回block
            if (self->_myOrdersDetailBlock) {
                self->_myOrdersDetailBlock(self.orderDetailModel);
            }
            
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}




//去付款
-(void)postOrderPay:(NSString *)orderIdStr{
    
    NSDictionary *dic = @{
        
        @"orderId":orderIdStr,
        @"prepayEnv":@"IOS"

        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_prepayapp parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"准备付款:%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            //通知首页列表进行刷新
              KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
            
            
            
            XMFOrdersPayModel *payModel = [XMFOrdersPayModel yy_modelWithDictionary:responseObjectModel.data];
            
            //字符串转字典
            NSData *jsonData = [[responseObjectModel.data stringWithKey:@"popup"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *popupDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    
            
            payModel.popup = [XMFOrdersPayPopupModel yy_modelWithDictionary:popupDic];
            
            
            NSDictionary *dic = @{
                @"merId": payModel.merId,
                @"desc": payModel.desc,
                @"mcc": payModel.mcc,
                @"orderNo": payModel.orderNo,
                @"notifyUrl": payModel.notifyUrl,
                @"realIp": [[IPToolManager sharedManager]currentIPAddress:YES],
                @"referUrl": payModel.referUrl,
                @"service": @"1",
                @"subAppid": @"wx53a612d04b9e1a22",
                @"subject": payModel.subject,
                @"timeExpire": payModel.timeExpire,
                @"phoneSystem":@"Ios",
                @"userId": payModel.userId,
                @"version": payModel.version,
                @"txnAmt": payModel.txnAmt,
                @"language": [XMFGlobalManager getGlobalManager].getCurrentLanguage,
                @"registerCountryCode": payModel.registerCountryCode,
                @"registerMobile": payModel.registerMobile,
                @"txnCurr": payModel.txnCurr,
                @"purchaseType":@"TRADE",
                @"isSendPurchase":@"1",
                @"amount":payModel.txnAmt,
                //                @"countryCode":payModel.countryCode,
                @"countryCode":[[XMFGlobalManager getGlobalManager]getCountryCodeStr],
                @"merchantid":@"merchant.testhk.qtopay.cn.ZDPaySDK",
                @"payTimeout": @"20200427094403",
                @"txnTime": @"20200427094403",//@"txnTime": @"20200427094403",
                @"currencyCode":@"HKD",
                @"BeeMall":payModel.merName,
                @"AES_Key":payModel.aesKey,
                @"md5_salt":payModel.md5,
                @"urlStr":ZDPaySDK_URL,
                @"associate_domain":Associate_domainLinks,
                
                @"isPopup":payModel.popup.isPopup,
                @"title":payModel.popup.title,
                @"massage":payModel.popup.massage,
                @"payInst":AlipayArea

            };
            
            
            [[ZDPay_OrderSureModel sharedSingleten] setModelProcessingDic:dic];
            
            ZDPay_OrderSureViewController *vc = [ZDPay_OrderSureViewController new];
            vc.orderModel = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
            
            
            [vc ZDPay_PaymentResultCallbackWithCompletionBlock:^(id  _Nonnull responseObject) {
                
                
                NSMutableDictionary *responseMutDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                
                [responseMutDic setValue:payModel.txnCurr forKey:@"txnCurr"];
                
                [responseMutDic setValue:payModel.txnAmt forKey:@"txnAmt"];
                
                [responseMutDic setValue:orderIdStr forKey:@"orderId"];

                
                
                [self payResult:responseMutDic  viewController:vc];
                
            }];
            
            //               vc.hidesBottomBarWhenPushed = YES;
            
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }else if (responseObjectModel.code == 504){//绑定手机
            
            [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

            
        }else if(responseObjectModel.code == XMFHttpReturnRestrictedArea){//区域限制发货的状态
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            self.restrictedAreaPopView = popView;
            
            popView.delegate = self;
            
            popView.tipsLB.text = XMFLI(@"该地区无货");
            
            [popView.sureBtn setTitle:XMFLI(@"修改地址") forState:UIControlStateNormal];
            
            [popView.cancelBtn setTitle:XMFLI(@"取消订单") forState:UIControlStateNormal];
            
            
            [popView show];
            
 
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    
    
    
}


//支付结果
-(void)payResult:(id)responseObject viewController:(ZDPay_OrderSureViewController *)vc{
    
    
    DLog(@"responseObject支付结果:%@",responseObject);
    
    
    /*
    responseObject:{
      "message" : "支付成功",
      "data" : "支付成功",
      "code" : "1000"
    }*/
    
    
    /**
       海外支付SDK回掉给客户端code及message的具体含义
       code 1000 支付成功
       code 2000 支付失败
       code 3000 支付取消
       code 5000 由商户主动发起交易状态查询
       code 9000 没有支付直接返回app端返回的code(按返回键)
    */
    
    NSString *codeStr = [NSString stringWithFormat:@"%@",responseObject[@"code"]];
    
    NSString *messageStr = [NSString stringWithFormat:@"%@",responseObject[@"message"]];
    
    [MBProgressHUD showError:messageStr toView:self.view];
    
    if ([codeStr isEqualToString:@"1000"]) {
        
  
            
        XMFMyOrdersListModel *orderModel = self.orderDetailModel;
        
        orderModel.orderStatus = @"201";
        
        //付款和取消按钮不显示
        [orderModel.handleOption setValue:@(NO) forKey:@"pay"];
        
        [orderModel.handleOption setValue:@(NO) forKey:@"cancel"];
        
        //申请退款和修改地址按钮显示
        [orderModel.handleOption setValue:@(YES) forKey:@"refund"];
        [orderModel.handleOption setValue:@(YES) forKey:@"updateAddress"];
        
        
        //刷新底部列表
        [self reloadMyCollectionView:self.orderDetailModel];
        
        
        self.headerView.detailModel = self.orderDetailModel;
        
        
        //操作返回block
        if (self->_myOrdersDetailBlock) {
            self->_myOrdersDetailBlock(self.orderDetailModel);
        }
        
        
        
        //跳转到支付成功结果页
        XMFOrderPayResultController  *VCtrl = [[XMFOrderPayResultController alloc]initWithPayInfoDic:[responseObject copy] jumpFromType:payResultJumpFromOrdersVc];

        
        [self.navigationController pushViewController:VCtrl animated:YES];

        
    }else{
        
        //支付取消
               
        [vc.navigationController  popViewControllerAnimated:YES];
        
    }
    
    //if([codeStr isEqualToString:@"3000"] || [codeStr isEqualToString:@"9000"])

    
}






#pragma mark - ——————— 倒计时 ————————

//此方法用两个NSDate对象做参数进行倒计时
-(void)startWithStartDate:(NSDate *)strtDate finishDate:(NSDate *)finishDate{
    
    __weak __typeof(self) weakSelf= self;
    [_countDownForBtn countDownWithStratDate:strtDate finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
//        NSLog(@"second = %li",second);
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        
        if (totoalSecond == 0) {
            
            weakSelf.headerView.orderTipsLB.text = XMFLI(@"已超时");
            
            weakSelf.bottomView.hidden = YES;
            
            weakSelf.bottomViewHeight.constant = 0.f;
            
            
        }else{
            //请在00天00时23分44秒内付款
            //超时订单将自动关闭
            
           NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
            
            //小时
            //    hoursStr = [NSString stringWithFormat:@"%d",hours];
            if (hour < 10) {
                
                hoursStr = [NSString stringWithFormat:@"0%zd",hour];
                
            }else{
                
                hoursStr = [NSString stringWithFormat:@"%zd",hour];
                
            }
            //分钟
            if(minute < 10){
                
                minutesStr = [NSString stringWithFormat:@"0%zd",minute];
                
            }else{
                
                minutesStr = [NSString stringWithFormat:@"%zd",minute];
            }
            //秒
            if(second < 10){
                
                secondsStr = [NSString stringWithFormat:@"0%zd", second];
                
            }else{
                
                secondsStr = [NSString stringWithFormat:@"%zd",second];
            }
            
            
            
            
            NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@",hoursStr,minutesStr,secondsStr];
            
            NSMutableAttributedString *consigneeInfoStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:timeStr upperColor:UIColorFromRGB(0xFB4D44) upperFont:[UIFont systemFontOfSize:15.f] lowerStr:XMFLI(@" 内未付款自动关闭") lowerColor:UIColorFromRGB(0x333333) lowerFont:[UIFont systemFontOfSize:15.f]];
                  
              weakSelf.headerView.orderTipsLB.attributedText = consigneeInfoStr;
            
            
//            weakSelf.headerView.orderTipsLB.text = [NSString stringWithFormat:@"%zd天%zd时%zd分%zd秒内未付款自动关闭",day,hour,minute,second];
            
            
        }
        
        }];
}


//订单处理中的倒计时
-(void)orderProcessingStartWithStartDate:(NSDate *)strtDate finishDate:(NSDate *)finishDate{
    
    __weak __typeof(self) weakSelf= self;
    [_countDownForBtn countDownWithStratDate:strtDate finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
//        NSLog(@"second = %li",second);
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        
        if (totoalSecond == 0) {
            
            weakSelf.headerView.orderTipsLB.text = XMFLI(@"请联系客服");
            
            weakSelf.bottomView.hidden = NO;
            
            weakSelf.bottomViewHeight.constant = 56.f;
            
            
            XMFMyOrdersListModel *orderModel = self.orderDetailModel;
            
            
            [orderModel.handleOption setValue:@(YES) forKey:@"contact"];
            
            
            //刷新底部列表
            [self reloadMyCollectionView:self.orderDetailModel];
            
            
        }else{
            //请在00天00时23分44秒内付款
            //超时订单将自动关闭
            
           NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
            
            //小时
            //    hoursStr = [NSString stringWithFormat:@"%d",hours];
            if (hour < 10) {
                
                hoursStr = [NSString stringWithFormat:@"0%zd",hour];
                
            }else{
                
                hoursStr = [NSString stringWithFormat:@"%zd",hour];
                
            }
            //分钟
            if(minute < 10){
                
                minutesStr = [NSString stringWithFormat:@"0%zd",minute];
                
            }else{
                
                minutesStr = [NSString stringWithFormat:@"%zd",minute];
            }
            //秒
            if(second < 10){
                
                secondsStr = [NSString stringWithFormat:@"0%zd", second];
                
            }else{
                
                secondsStr = [NSString stringWithFormat:@"%zd",second];
            }
            
            
            
            
            NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@",hoursStr,minutesStr,secondsStr];
            
            NSMutableAttributedString *consigneeInfoStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:timeStr upperColor:UIColorFromRGB(0xFB4D44) upperFont:[UIFont systemFontOfSize:15.f] lowerStr:XMFLI(@" 内未处理，请联系客服") lowerColor:UIColorFromRGB(0x333333) lowerFont:[UIFont systemFontOfSize:15.f]];
                  
              weakSelf.headerView.orderTipsLB.attributedText = consigneeInfoStr;
            
            
            
        }
        
        }];
}






#pragma mark - ——————— 刷新底部的按钮 ————————
-(void)reloadMyCollectionView:(XMFMyOrdersListModel *)listModel{
    
    [self.dataSourceArr removeAllObjects];

    
    //遍历字典
    NSArray<NSString *> *allKeysArr = [self.orderDetailModel.handleOption allKeys];
    
    for (int i = 0; i < allKeysArr.count; ++i) {
        
        BOOL value = [[self.orderDetailModel.handleOption objectForKey:allKeysArr[i]] boolValue];
        
        if (value) {
            
            NSString *key = allKeysArr[i];
            
            
            XMFMyOrdersListFooterModel *footerModel = [[XMFMyOrdersListFooterModel alloc]init];
            
            
            footerModel.handleOption = key;
            
            
            HandleOptionInfo handleInfo = [GlobalManager getHandleOptionForKey:key];
            
            footerModel.name = handleInfo.handleOptionName;
            
            footerModel.handleOptionNum = handleInfo.index;
            
           
            //当不为删除和再次购买的时候才加入数组
            if (![key isEqualToString:@"delete"] && ![key isEqualToString:@"rebuy"] &&  ![key isEqualToString:@"addCart"]) {
                
                [self.dataSourceArr addObject:footerModel];
                
            }
            
            
            
        }
        
        
    }
    

    
    /**
        
        思路：
        1、先创建一个空数组
        2、把上面遍历出来的数组再用一个不可变数组接收，因为一边遍历的时候边修改数组是会报错的；
        3、查看遍历出来的数组与需要特定的文字对比，加入到临时数组中，并删除原来数组中的元素；
        4、最后把遍历剩下的数组内容加到临时数组中去；
        5、最后把临时数组中的数据赋值到数组中去。
        搞定！
        
        
        
        */

       NSMutableArray *tempArr = [[NSMutableArray alloc]init];
       
       NSArray *dataSourceTempArr = [NSArray arrayWithArray:self.dataSourceArr];
       
       for (XMFMyOrdersListFooterModel *footerModel in dataSourceTempArr) {
           
          if ([footerModel.handleOption isEqualToString:@"confirm"] || [footerModel.handleOption isEqualToString:@"comment"] || [footerModel.handleOption isEqualToString:@"cancelRefund"] || [footerModel.handleOption isEqualToString:@"remind"] || [footerModel.handleOption isEqualToString:@"pay"] || [footerModel.handleOption isEqualToString:@"appendComment"]) {
              
              [tempArr addObject:footerModel];
              
              [self.dataSourceArr removeObject:footerModel];
              
              
          }
           
           
       }
       
       
       [tempArr addObjectsFromArray:self.dataSourceArr];
       
      
       self.dataSourceArr = tempArr;
       

    if (!listModel.oldFlag) {
        
        if (self.dataSourceArr.count > 0) {
            //当至少有一个按钮的时候
            
            [self.myCollectionView reloadData];
            
            
        }else{
            //当没有一个按钮的时候
            self.bottomView.hidden = YES;
            
            self.bottomViewHeight.constant = 0.f;
            
        }
        
    }
  
}



#pragma mark - ——————— 懒加载 ————————
-(XMFMyOrdersDetailHeaderView *)headerView{
    
    if (_headerView == nil) {
        _headerView = [XMFMyOrdersDetailHeaderView XMFLoadFromXIB];
        _headerView.delegate = self;
    }
    return _headerView;
    
}

-(XMFMyOrdersDetailFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [XMFMyOrdersDetailFooterView XMFLoadFromXIB];
    }
    return _footerView;
}


-(NSMutableArray<XMFMyOrdersListFooterModel *> *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
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
