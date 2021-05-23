//
//  XMFMeViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMeViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFHomeAllGoodsCell.h"//首页推荐cell
#import "XMFSettingController.h"//设置
#import "XMFSacanViewController.h"//扫一扫
#import "XMFMyCollectionViewController.h"//我的收藏
#import "XMFOrdersPayModel.h"//去付款的model
#import "XMFMyDeliveryAddressController.h"//选择地址页面
#import "XMFMineInfoViewController.h"//个人资料
#import "XMFMyAllOrdersController.h"//我的订单
#import "XMFHomeGoodsCellModel.h"//商品cell的model
#import "XMFSelectGoodsTypeView.h"//商品属性弹框
#import "XMFHomeGoodsPropertyModel.h"//商品属性的model
#import "XMFGoodsDetailViewController.h"//商品详情
#import "WXApi.h"//微信开发者
#import "XMFMyAuthenticationListController.h"//我的认证信息列表
#import "XMFGoodsSpecInfoModel.h"//商品规格model
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model

@interface XMFMeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout,XMFHomeAllGoodsCellDelegate,XMFSelectGoodsTypeViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

//昵称
@property (weak, nonatomic) IBOutlet UILabel *nicknameLB;



//订单情况
@property (weak, nonatomic) IBOutlet UIView *orderBgView;


@property (weak, nonatomic) IBOutlet GZCAlignButton *pendingPayBtn;


@property (weak, nonatomic) IBOutlet GZCAlignButton *pendingDeliveryBtn;


@property (weak, nonatomic) IBOutlet GZCAlignButton *pendingReceiptBtn;


@property (weak, nonatomic) IBOutlet GZCAlignButton *pendingRebuyBtn;

//功能模块
@property (weak, nonatomic) IBOutlet UIView *functionBgView;


@property (weak, nonatomic) IBOutlet GZCAlignButton *addressBtn;


@property (weak, nonatomic) IBOutlet GZCAlignButton *authenBtn;



@property (weak, nonatomic) IBOutlet GZCAlignButton *collectionBtn;


@property (weak, nonatomic) IBOutlet GZCAlignButton *walletBtn;


@property (weak, nonatomic) IBOutlet GZCAlignButton *contactBtn;


//推荐工具

@property (weak, nonatomic) IBOutlet UIView *platformBgView;


@property (weak, nonatomic) IBOutlet UIView *xmfChargeView;


@property (weak, nonatomic) IBOutlet UIView *xmfCateringView;



@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;

//布局
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *flowLayout;

@property (nonatomic, assign) NSInteger cellNum;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsCellModel *> *dataSourceArr;


/** 商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;

/** 商品规格弹窗 */
@property (nonatomic, strong) XMFSelectGoodsTypeView *selectGoodsTypeView;



@end

@implementation XMFMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    

    CGFloat cornerRadius = 6.f;
    
    [self.orderBgView cornerWithRadius:cornerRadius];
    
    [self.functionBgView cornerWithRadius:cornerRadius];
    
    [self.platformBgView cornerWithRadius:cornerRadius];
    
    [self.avatarImgView cornerWithRadius:self.avatarImgView.height/2.0];

}



-(void)setupUI{
    
    //防止设置了myScrollView顶到状态栏但是没到的问题
    if (@available(iOS 11.0, *)) {
        
        self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //    self.flowLayout.headerHeight = 15;
    //    self.flowLayout.footerHeight = 10;
    self.flowLayout.minimumColumnSpacing = 10;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.columnCount = 2;
    
    self.myCollectionView.collectionViewLayout = self.flowLayout;
    
    self.myCollectionView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeAllGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class])];
    
    self.myCollectionView.scrollEnabled = NO;
    
    self.myCollectionView.showsVerticalScrollIndicator = NO;

//    kWeakSelf(self)
    
//    self.myScrollView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        [weakself getRecommendGoods];
//
//        [weakself getUserInfo];
//
//        [weakself getMyOrdersCount];
//
//        [weakself.myScrollView.mj_header endRefreshing];
//
//    }];
    
    /*
    self.myScrollView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.cellNum += 5;
        
        self.myCollectionViewHeight.constant = ((self.cellNum - 1)/2 + 1) * (1.44 *((KScreenW - self.cellNum)/2.0)+ 10);
        
        [self.myCollectionView reloadData];
        
        [self.myScrollView.mj_footer endRefreshing];
        
    }];*/
    
    
    [self getRecommendGoods];
    
    
    [self getUserInfo];
    
    
    [self getMyOrdersCount];
    
    
    //接收登录状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    //接收刷新页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KPost_Anyone_Notice_MeVc_Refesh object:nil];
    
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.xmfChargeView addGestureRecognizer:tap];
    
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.xmfCateringView addGestureRecognizer:tap1];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


//手势绑定方法
-(void)tapAction:(UIGestureRecognizer *)gesture{
    
   
    
    UIView *tapView = (UIView *)gesture.view;
    
    if (tapView == self.xmfChargeView) {
        
        
//        [MBProgressHUD showOnlyTextToView:self.view title:@"小蜜充"];
        
        if ([WXApi isWXAppInstalled]) { //先判断是否安装微信
            WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
            launchMiniProgramReq.userName = @"gh_8386143de856";  //拉起的小程序的username-原始ID
            launchMiniProgramReq.path = @"pages/index/index";    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
            launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
            [WXApi sendReq:launchMiniProgramReq completion:nil];
            
        }else{
            
            //提示用户没有安装微信，不能拉起小程序
        
            //小蜜充香港H5网页（与小程序不互通）

            XMFProductViewController  *productVC = [[XMFProductViewController alloc]init];
            
            productVC.urlStr = @"https://sdbbh5.xmfstore.com/";
            
            [self.navigationController pushViewController:productVC animated:YES];
            
        }
        
        
    }else if (tapView == self.xmfCateringView){
        
        
//        if ([WXApi isWXAppInstalled]) {
        if (0) {
            
            WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
            launchMiniProgramReq.userName = @"gh_c318955b3348";  //拉起的小程序的username-原始ID
            launchMiniProgramReq.path = nil;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
            launchMiniProgramReq.miniProgramType = WXMiniProgramTypePreview; //拉起小程序的类型
            [WXApi sendReq:launchMiniProgramReq completion:nil];
            
            
        }else{
            
            
            /*
            //小蜜蜂餐饮
            XMFProductViewController  *productVC = [[XMFProductViewController alloc]init];
            
            productVC.urlStr = @"https://dc.xmfstore.com/dingzuo-h5/#/home";
            
            XMFBaseNavigationController *productNaviVc = [[XMFBaseNavigationController alloc]initWithRootViewController:productVC];
            
            //模态的方式铺满全屏
            productNaviVc.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:productNaviVc animated:YES completion:nil];
            */
            
            //小蜜蜂餐饮
            XMFProductViewController  *productVC = [[XMFProductViewController alloc]init];
            
            productVC.urlStr = @"https://dc.xmfstore.com/dingzuo-h5/#/home";
            
            [self.navigationController pushViewController:productVC animated:YES];
        

        }
        
    }
    
    
}

//调起小程序的回调方法
-(void)onResp:(BaseResp *)resp{
    
     if ([resp isKindOfClass:[WXLaunchMiniProgramResp class]]){
         
         WXLaunchMiniProgramResp *smallPro = (WXLaunchMiniProgramResp *)resp;
         
          NSString *string = smallPro.extMsg;
          // 对应JsApi navigateBackApplication中的extraData字段数据
         
         DLog(@"小程序回调：%@",string);
         
     }
}


#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    
    
    
    BOOL loginSuccess = [notification.object boolValue];
    
//    NSDictionary  *responseObjectDic = notification.userInfo;

    
    if (loginSuccess) {
        
        /*
        NSDictionary *userInfoDic = responseObjectDic[@"data"][@"userInfoBaseVo"];
        
        //保存用户信息
        [UserInfoManager updateUserInfo:userInfoDic];
        
        //单独保存token
        [UserInfoManager updateValue:responseObjectDic[@"data"][@"token"] forKey:@"token"];
        
        //单独保存tokenExpire
        [UserInfoManager updateValue:responseObjectDic[@"tokenExpire"] forKey:@"tokenExpire"];
         */
        
        
        DLog(@"token:%@",UserInfoModel.token);
        
                
        
        [self getUserInfo];
        
        
        [self getMyOrdersCount];
        
        
        
    }else{
        
        if ([UserInfoManager isContainsUserInfo]) {
            
            //移除缓存
            [UserInfoManager removeUserInfo];
            
        }
    
       
        [self setDataForView];

        
    }
    
    //只要登录状态发生了改变都要重新获取信息
    [self getRecommendGoods];

    
    
}


//刷新个人中心的数据
-(void)refreshData{
    
    [self getMyOrdersCount];

    
    [self getRecommendGoods];
    

}


//页面上的角标按钮被点击
- (IBAction)alignButtonsOnViewDidClick:(GZCAlignButton *)sender {
    
    
//    [MBProgressHUD showSuccess:sender.title toView:self.view];

    kWeakSelf(self);
    
    switch (sender.tag) {
        case 0:{//待付款
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFMyAllOrdersController  *VCtrl = [[XMFMyAllOrdersController alloc]initWithFromType:fromPendingPay];
                
                VCtrl.myAllOrdersBackBlock = ^{
                    
                    [weakself getMyOrdersCount];
                };
                
                [self.navigationController pushViewController:VCtrl animated:YES];
            }
            
        }
            break;
        case 1:{//待发货
            
            if (UserInfoModel.token.length == 0) {
                  
                  [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                  
              }else{
                  
                  XMFMyAllOrdersController  *VCtrl = [[XMFMyAllOrdersController alloc]initWithFromType:fromPendingDelivery];
                  
                  VCtrl.myAllOrdersBackBlock = ^{
                      
                      [weakself getMyOrdersCount];
                  };
                  
                  [self.navigationController pushViewController:VCtrl animated:YES];
              }
            
        }
            break;
        case 2:{//待收货
            
            if (UserInfoModel.token.length == 0) {
                  
                  [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                  
              }else{
                  
                  XMFMyAllOrdersController  *VCtrl = [[XMFMyAllOrdersController alloc]initWithFromType:fromPendingReceipt];
                  
                  VCtrl.myAllOrdersBackBlock = ^{
                      
                      [weakself getMyOrdersCount];
                  };
                  
                  [self.navigationController pushViewController:VCtrl animated:YES];
              }
            
        }
            break;
        case 3:{//已完成
            
            if (UserInfoModel.token.length == 0) {
                  
                  [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                  
              }else{
                  
                  XMFMyAllOrdersController  *VCtrl = [[XMFMyAllOrdersController alloc]initWithFromType:fromPendingRebuy];
                  
                  VCtrl.myAllOrdersBackBlock = ^{
                      
                      [weakself getMyOrdersCount];
                  };
                  
                  [self.navigationController pushViewController:VCtrl animated:YES];
              }
            
        }
            break;
        case 4:{//查看全部订单
            
            if (UserInfoModel.token.length == 0) {

                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFMyAllOrdersController  *VCtrl = [[XMFMyAllOrdersController alloc]initWithFromType:fromPengingDefault];
                
                VCtrl.myAllOrdersBackBlock = ^{
                    
                    [weakself getMyOrdersCount];
                };
                
                [self.navigationController pushViewController:VCtrl animated:YES];
            }
            
            
        }
            break;
        case 5:{//收货地址
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]initWithJumpFromType:fromMeVc];
                
                [self.navigationController pushViewController:VCtrl animated:YES];
                
                
            }
            
            
        }
            break;
            
        case 6:{//实名认证
            
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFMyAuthenticationListController  *VCtrl = [[XMFMyAuthenticationListController alloc]init];
                
                [self.navigationController pushViewController:VCtrl animated:YES];
                
                
            }
            
            
            
        }
            break;
            
        case 7:{//我的收藏
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                XMFMyCollectionViewController  *VCtrl = [[XMFMyCollectionViewController alloc]init];
                
                [self.navigationController pushViewController:VCtrl animated:YES];
                
                
            }
            

            
        }
            break;
        case 8:{//我的钱包
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                [self postSDKWalletInfo];
                
            }
            
            
        }
            break;
        case 9:{//联系客服
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = @"https://im.7x24cc.com/phone_webChat.html?accountId=N000000013029&chatId=6aded8fa-f405-4371-8aba-c982f8fb7f8d";
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            break;
            
        
            
        default:
            break;
    }
    
    
}


//页面上的按钮点击方法
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
//    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%zd",sender.tag] toView:self.view];
    
    switch (sender.tag) {
        case 0:{//头像
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }else{
                
                 DLog(@"缓存的token：%@",UserInfoModel.token);
                
                XMFMineInfoViewController  *VCtrl = [[XMFMineInfoViewController alloc]init];
                
                kWeakSelf(self)
                
                VCtrl.modifyUserInfoBlock = ^{
                    
                    [weakself getUserInfo];
                    
                };
                
                
                [self.navigationController pushViewController:VCtrl animated:YES];
                
                return;
                
            }
            
            
            
        }
            break;
            
        case 1:{//扫一扫
            
            [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
                
                if (granted) {
                    
                    XMFSacanViewController  *VCtrl = [[XMFSacanViewController alloc]init];
                    
                    [self.navigationController pushViewController:VCtrl animated:YES];
                    
                }else{
                    
                     [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相机权限，是否前往设置修改权限" cancel:@"取消" setting:@"设置"];
                }
                
                
            }];

            
            
        }
            break;
            
        case 2:{//设置
            
            XMFSettingController  *VCtrl = [[XMFSettingController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFHomeAllGoodsCell *allGoodsCell = (XMFHomeAllGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class]) forIndexPath:indexPath];
    
    allGoodsCell.recommendModel = self.dataSourceArr[indexPath.item];
    
    allGoodsCell.cellItem = indexPath.item;
    
    allGoodsCell.delegate = self;
    
    
    return allGoodsCell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
//    [collectionView reloadData];
    
    
    XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
    
    XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:model.goodsId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}

#pragma mark - ——————— CHTCollectionViewDelegateWaterfallLayout ————————

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((KScreenW - 30)/2.0, 1.44 *(KScreenW /2.0));

    
}

#pragma mark - ——————— XMFHomeAllGoodsCell的代理方法 ————————
-(void)buttonsOnXMFHomeAllGoodsCellDidClick:(XMFHomeAllGoodsCell *)cell button:(UIButton *)button{
    
    NSIndexPath *selectedIndexPath = [self.myCollectionView indexPathForCell:cell];
    
//    [self getGoodsSpecification:cell.recommendModel.goodsId button:button goodsName:cell.recommendModel.goodsName indexPath:selectedIndexPath];

    //先判断是否是组合商品
    if (cell.recommendModel.isGroupGoods) {
        
        
        [self getGoodsSpecInfo:cell.recommendModel.goodsId button:button indexPath:selectedIndexPath];
        
        
    }else{
        
        
        [self getCartAdd:cell.recommendModel.productId goodsNum:@"1" button:button indexPath:selectedIndexPath];
        
    }
    
    
}



#pragma mark - ——————— XMFSelectGoodsTypeView的代理方法 ————————

//规格点击的方法
-(void)selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView goodsId:(NSString *)goodsId{
    
    
    [self getGoodsDetail:goodsId];
    
    
}



#pragma mark - ——————— 网络请求 ————————

//我的钱包
-(void)postSDKWalletInfo{
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_wallet_sdkwalletinfo parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
            
            DLog(@"我的钱包：%@",[responseObject description]);
            
            if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
                
                XMFOrdersPayModel *moneyModel = [XMFOrdersPayModel yy_modelWithDictionary:responseObjectModel.data];
                
                NSDictionary *dic = @{
                    @"merId": moneyModel.merId,
                    @"mcc": moneyModel.mcc,
                    @"orderNo": [DateUtils getCurrentDateWithFormat:@"yyyyMMddHHmmss"],
                    @"notifyUrl": moneyModel.notifyUrl,
                    @"realIp": [[IPToolManager sharedManager] currentIPAddress:YES],
                    @"service": @"1",
                    @"subject": @"1",
                    @"phoneSystem":@"Ios",
                    @"userId": @"1",
                    @"version": moneyModel.version,
                    @"txnAmt": @"1",
                    @"language": [XMFGlobalManager getGlobalManager].getCurrentLanguage,
                    @"registerCountryCode": moneyModel.registerCountryCode,
                    @"registerMobile": moneyModel.registerMobile,//@"13927495764"
                    @"txnCurr": @"1",
                    @"purchaseType":@"TRADE",//TRADE
                    @"amount": @"1",
    //                @"countryCode":moneyModel.countryCode,
                    @"countryCode":[[XMFGlobalManager getGlobalManager]getCountryCodeStr],
                    @"isSendPurchase":@"1",
                    @"AES_Key":moneyModel.aesKey,
                    @"md5_salt":moneyModel.md5,
                    @"urlStr":ZDPaySDK_URL
                };
             
                [[ZDPay_OrderSureModel sharedSingleten] setModelProcessingDic:dic];
                
                ZDPay_MyWalletViewController *vc = [ZDPay_MyWalletViewController new];
                
                vc.orderModel = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
                
                vc.walletType = WalletType_binding;
                
                [self.navigationController pushViewController:vc animated:YES];
                
                
                
            }else if (responseObjectModel.code == 504){//绑定手机
                
                [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

                
            }else{
                
                [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
                
            }
            
        } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
    /*
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_wallet_sdkwalletinfo parameters:@{} success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"我的钱包：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            XMFOrdersPayModel *moneyModel = [XMFOrdersPayModel yy_modelWithDictionary:responseObjectModel.data];
            
            NSDictionary *dic = @{
                @"merId": moneyModel.merId,
                @"mcc": moneyModel.mcc,
                @"orderNo": [DateUtils getCurrentDateWithFormat:@"yyyyMMddHHmmss"],
                @"notifyUrl": moneyModel.notifyUrl,
                @"realIp": [[IPToolManager sharedManager] currentIPAddress:YES],
                @"service": @"1",
                @"subject": @"1",
                @"phoneSystem":@"Ios",
                @"userId": @"1",
                @"version": moneyModel.version,
                @"txnAmt": @"1",
                @"language": [XMFGlobalManager getGlobalManager].getCurrentLanguage,
                @"registerCountryCode": moneyModel.registerCountryCode,
                @"registerMobile": moneyModel.registerMobile,//@"13927495764"
                @"txnCurr": @"1",
                @"purchaseType":@"TRADE",//TRADE
                @"amount": @"1",
//                @"countryCode":moneyModel.countryCode,
                @"countryCode":[[XMFGlobalManager getGlobalManager]getCountryCodeStr],
                @"isSendPurchase":@"1",
                @"AES_Key":moneyModel.aesKey,
                @"md5_salt":moneyModel.md5,
                @"urlStr":ZDPaySDK_URL
            };
         
            [[ZDPay_OrderSureModel sharedSingleten] setModelProcessingDic:dic];
            
            ZDPay_MyWalletViewController *vc = [ZDPay_MyWalletViewController new];
            
            vc.orderModel = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
            
            vc.walletType = WalletType_binding;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }else if (responseObjectModel.kerrno == 504){//绑定手机
            
            [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    */
    
    
}



//获取推荐商品
-(void)getRecommendGoods{
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_goods_firstPageRecommend parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"首页推荐：%@",[responseObject description]);
        
//        [hud hideAnimated:YES];

        [self.view hideErrorPageView];
        
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self.dataSourceArr removeAllObjects];
            
            NSArray *dataArr = responseObject[@"data"];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFHomeGoodsCellModel *model = [XMFHomeGoodsCellModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
            }
            
            
            self.myCollectionViewHeight.constant = ((self.dataSourceArr.count - 1)/2 + 1) * (1.44 *(KScreenW /2.0) + 10);
            
            [self.myCollectionView reloadData];
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getRecommendGoods];
                
                
                [self getUserInfo];
                
                
                [self getMyOrdersCount];
                
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];


        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getRecommendGoods];
            
            
            [self getUserInfo];
            
            
            [self getMyOrdersCount];


        }];
        
    }];
    
    
}


//获取用户信息
-(void)getUserInfo{
    
    
//    NSDictionary *dic = @{
//
//        @"X-Beemall-Token":UserInfoModel.token
//
//    };
    
    [self showGIFImageView];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_auth_user_info parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取个人信息：%@",responseObject);
        
        [self hideGIFImageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            //取出备用
            NSString *tokenStr = UserInfoModel.token;
            
            NSString *tokenExpireStr = UserInfoModel.tokenExpire;
            
            NSInteger skinType = UserInfoModel.skinType;
            
            
            //保存个人信息
            [UserInfoManager updateUserInfo:responseObjectModel.data];
            
            
            //单独保存token
            [UserInfoManager updateValue:tokenStr forKey:@"token"];
            
            //单独保存tokenExpire
            [UserInfoManager updateValue:tokenExpireStr forKey:@"tokenExpire"];
            
            
            //设置数据
            [self setDataForView];
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self hideGIFImageView];

        
    }];
    
    
    
    
}


//为页面设置数据
-(void)setDataForView{
    
    
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:UserInfoModel.userAvatar] placeholderImage:[UIImage imageNamed:@"icon_mine_touxiang"]];
    
    //防止后台没有nickname返回
    if (UserInfoModel.userNikeName.length == 0 && UserInfoModel.token.length == 0) {
        
        self.nicknameLB.text = XMFLI(@"立即登录");
        
        self.pendingPayBtn.badge = nil;
        self.pendingDeliveryBtn.badge = nil;
        self.pendingReceiptBtn.badge = nil;
        self.pendingRebuyBtn.badge = nil;

        
    }else{
        
        self.nicknameLB.text = UserInfoModel.userNikeName;
    }
    
}


//获取用户订单统计
-(void)getMyOrdersCount{
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_orderCount parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"用户订单统计：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            /**
             
             "data" : {
                "unPay" : 93,
                "unShip" : 51,
                "unConfirm" : 5,
                "complete" : 57
              }
             
             */
    
            
            [self setDataForOrderCountButton:self.pendingPayBtn orderCountStr:[responseObjectModel.data stringWithKey:@"unPay"]];
            
            [self setDataForOrderCountButton:self.pendingDeliveryBtn orderCountStr:[responseObjectModel.data stringWithKey:@"unShip"]];
            
            [self setDataForOrderCountButton:self.pendingReceiptBtn orderCountStr:[responseObjectModel.data stringWithKey:@"unConfirm"]];
            
            [self setDataForOrderCountButton:self.pendingRebuyBtn orderCountStr:[responseObjectModel.data stringWithKey:@"complete"]];
 
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
    
}


//设置订单数量按钮
-(void)setDataForOrderCountButton:(GZCAlignButton *)pendingBtn  orderCountStr:(NSString *)countStr{
    
    if ([countStr integerValue] > 99) {
        
        pendingBtn.badge = @"99+";
        
    }else if((0 < [countStr integerValue]) && ([countStr integerValue] < 99)){
        
        pendingBtn.badge = countStr;
        
    }else{
        
        pendingBtn.badge = nil;
    }
    
}


/*
//获取商品规格
-(void)getGoodsSpecification:(NSString *)goodsId button:(UIButton *)button goodsName:(NSString *)name indexPath:(NSIndexPath *)indexPath{

    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
        
    };
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goodsProductSpec parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"商品规格：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            XMFHomeGoodsPropertyModel *model = [XMFHomeGoodsPropertyModel yy_modelWithDictionary:responseObjectModel.data];
            
            //人工加入商品名称
            model.goodsName = name;
            
            if (model.goodsProducts.count == 1) {
                
                
                [self getCartAdd:[model.goodsProducts firstObject] goodsNum:@"1" button:button indexPath:indexPath];

                
                
            }else{
                
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                typeView.propertyModel = model;
                
                typeView.delegate = self;
                
                typeView.selectGoodsTypeBlock = ^(XMFHomeGoodsPropertyProductsModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                    
                    [self getCartAdd:productModel goodsNum:selectedGoodCount button:button indexPath:indexPath];

                    
                };
                
                [typeView show];
                
            }

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
}*/


//添加或者减少购物车
-(void)getCartAdd:(NSString *)productId goodsNum:(NSString *)numStr button:(UIButton *)button indexPath:(NSIndexPath *)indexPath{


    
    NSDictionary *dic = @{
        
        @"num":numStr,
        @"productId":productId,
        @"returnCartInfo":@(YES)
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物车加数量：%@",responseObject);
        
        [hud hideAnimated:YES];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            button.selected = YES;
            
            
            //一定要处理本地数据防止页面滑动出现复用问题
            XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
            
            model.cartNum = [NSString stringWithFormat:@"%zd",[model.cartNum integerValue] + [numStr integerValue]];

        
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
//            [self getCartNum];
            
            //发送通知告诉购物车刷新
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
    
            
            //通知首页列表进行刷新
              KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    

}

//获取商品数量
-(void)getCartNum{
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_cart_num parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品数量：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSString *goodsCountStr = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
            XMFBaseUseingTabarController *tabBarVC = (XMFBaseUseingTabarController *)self.tabBarController;
            //            AxcAE_TabBarItem *item = tabBarVC.axcTabBar.currentSelectItem; // 因为已经到这个页面，说明就是当前的选项卡item
            AxcAE_TabBarItem *item = tabBarVC.axcTabBar.tabBarItems[GlobalManager.getShoppingCartIndex];
            // 为0是否自动隐藏
            item.badgeLabel.automaticHidden = YES;
            
            //防止数量小于等于0
            if ([goodsCountStr integerValue] <= 0) {
                
                goodsCountStr = @"";
            }
            
            item.badge = goodsCountStr;
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
    
}


//2.1版本：获取规格相关信息
-(void)getGoodsSpecInfo:(NSString *)goodsId button:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail_specInfo parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品规格：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFHomeGoodsCellModel *selectedModel = self.dataSourceArr[indexPath.item];
            
            if ([responseObject[@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"] isEqual:[NSNull null]]) {
               //先对数据进行一次判空，避免出现商品不是上架状态的异常状态
                
//                XMFHomeGoodsCellModel *seletedModel = self.dataSourceArr[indexPath.item];
                
                
                [self getCartAdd:selectedModel.productId goodsNum:@"1" button:button indexPath:indexPath];
                
                
                
            }else{
                
                
                /*
                //把列表的model转换为商品详情的model
                NSDictionary *dic = [selectedModel yy_modelToJSONObject];
                
                
                self.detailModel = [XMFHomeGoodsDetailModel yy_modelWithDictionary:dic];
                 
                 */
                
                

                XMFGoodsSpecInfoModel *model = [XMFGoodsSpecInfoModel yy_modelWithDictionary:responseObjectModel.data];
                
                model.goodsId = goodsId;
                
                
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                
                typeView.delegate = self;
                
                
                typeView.specInfoModel = model;
                
                
//                typeView.detailModel = self.detailModel;
                
                //每次都需要重新创建防止数据重用
                self.selectGoodsTypeView = typeView;
                
                
                [self getGoodsDetail:selectedModel.goodsId];
                
                
                typeView.selectGoodsSpecInfoBlock = ^(NSString * _Nonnull goodsId, NSString * _Nonnull selectedGoodCount) {
                    
                    
                    [self getCartAdd:self.detailModel.productId goodsNum:selectedGoodCount button:button indexPath:indexPath];
                    
                    
                };
                
                

                
                
                [typeView show];
                
                
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
    }];
    

    
}


//获取商品详情的数据
-(void)getGoodsDetail:(NSString *)goodsId{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
    };
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"商品详情：%@",responseObject);
        
//        [hud hideAnimated:YES];
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self setDataForView:responseObjectModel.data];

        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];
        

    }];
    
}

//为页面上的控件赋值
-(void)setDataForView:(NSDictionary *)detailDic{
    

    XMFHomeGoodsDetailModel *detailModel = [XMFHomeGoodsDetailModel yy_modelWithDictionary:detailDic];
    
    
    self.detailModel = detailModel;
    
    
    //规格弹窗的数据
    self.selectGoodsTypeView.detailModel = detailModel;
    
  
    
}


#pragma mark - ——————— 懒加载 ————————
-(CHTCollectionViewWaterfallLayout *)flowLayout{
    
    if (_flowLayout == nil) {
        
        _flowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    }
    return _flowLayout;
    
}

-(NSMutableArray<XMFHomeGoodsCellModel *> *)dataSourceArr{
    
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
