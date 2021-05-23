//
//  XMFConfirmOrderController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFConfirmOrderController.h"
#import "XMFConfirmOrderCell.h"//确认订单cell
#import "XMFConfirmOrderFooterView.h"//头部view
#import "XMFConfirmOrderHeaderView.h"//底部view
#import "XMFConfirmOrderSectionHeaderView.h"//组头view
#import "XMFConfirmOrderSectionFooterView.h"//组尾view
#import "XMFConfirmOrderModel.h"//订单确认总model
#import "XMFMyDeliveryAddressController.h"//地址列表
#import "XMFMyDeliveryAddressModel.h"//地址的model
#import "XMFOrdersPayModel.h"//去付款的model
#import "XMFOrderPayResultController.h"//支付结果页
#import "XMFMyAllOrdersController.h"//我的订单
#import "XMFAddAddressController.h"//填写地址
#import "XMFCommonPicPopView.h"//图片文本提示框



@interface XMFConfirmOrderController ()<UITableViewDelegate,UITableViewDataSource,XMFConfirmOrderHeaderViewDelegate,XMFCommonCustomPopViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 底部view */
@property (weak, nonatomic) IBOutlet UIView *bottomView;


/** 商品总数 */
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLB;


/** 合计 */
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLB;

/** 去付款 */
@property (weak, nonatomic) IBOutlet UIButton *payBtn;


/** tableview的头部view */
@property (nonatomic, strong) XMFConfirmOrderHeaderView *headerView;

/** tableview的底部view */
@property (nonatomic, strong) XMFConfirmOrderFooterView *footerView;

/** 选中的商品id数组 */
@property (nonatomic, strong) NSArray *cartGoodsIdArr;

/** 商品确认总model */
@property (nonatomic, strong) XMFConfirmOrderModel *ordersModel;

/** 订单确认来源 */
@property (nonatomic, assign) confirmOrderType type;

/** 自定义补充照片弹框 */
@property (nonatomic, strong) XMFCommonCustomPopView *customPopView;

/** 地址列表数组 */
@property (nonatomic, strong) NSMutableArray<XMFMyDeliveryAddressModel *> *addressDataArr;

/** 是否是编辑地址 */
@property (nonatomic, assign) BOOL isEditAddress;


/** 蜜蜂国际选中的商品数组 */
@property (nonatomic, strong) NSArray *goodsListArr;


@end

@implementation XMFConfirmOrderController


-(instancetype)initWithCartId:(NSArray *)cartIdsArr listArr:(NSArray *_Nullable)listArr confirmOrderModel:(XMFConfirmOrderModel *_Nullable)confirmOrderModel confirmOrderType:(confirmOrderType)fromType{
    
    self = [super init];
    
    if (self) {
        
        self.cartGoodsIdArr = cartIdsArr;
        
        self.goodsListArr = listArr;
        
        self.type = fromType;
        
        self.ordersModel = confirmOrderModel;
    }
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    

    self.naviTitle = XMFLI(@"订单结算");
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.showsVerticalScrollIndicator = NO;

    
    //获取默认地址
    [self getAddressList];
    
    
    //只有当没有数据的时候才请求
    if (![AddressManager isContainsAddressInfo]){
        
        [self getRegionTree];
    }
    
    
    if (self.type == fromGoodsDetailVc) {
        
        
        self.headerView.orderModel = self.ordersModel;
        
        
        self.myTableView.tableHeaderView = self.headerView;
        
        self.headerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
        
        
        self.footerView.orderModel = self.ordersModel;
        
        self.myTableView.tableFooterView = self.footerView;
        
        self.footerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
        
        [self.myTableView reloadData];
        
        
        self.bottomView.hidden = NO;
        
        self.goodsCountLB.text = [NSString stringWithFormat:@"共%@件",self.ordersModel.goodsCount];
        
        
        NSMutableAttributedString *totalMoneyStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:UIColorFromRGB(0xFB4D44) upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18.f] lowerStr:[NSString removeSuffix:self.ordersModel.totalPrice] lowerColor:UIColorFromRGB(0xFB4D44) lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18.f]];
        
        
        NSMutableAttributedString *allTotalMoneyStr = [[NSMutableAttributedString alloc]initWithString:@"合计："];
        
        [allTotalMoneyStr appendAttributedString:totalMoneyStr];
        
        
        self.totalMoneyLB.attributedText = allTotalMoneyStr;
        
        
        
    }else{
        
        //获取确认订单详情
        [self getConfirmOrderInfo];
        
    }
    
    
    //接收地址列表发送过来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressChange:) name:KPost_MyDeliveryAddressVc_Notice_ConfirmOrderVc_IsRefresh object:nil];
    

}

#pragma mark ————— 地址发生了改变 —————
- (void)addressChange:(NSNotification *)notification{
    
    XMFMyDeliveryAddressModel *model = [[XMFMyDeliveryAddressModel alloc]init];
    
    self.headerView.addressModel = model;
    
    //按钮是否置灰取决于地址是否可以用
    self.payBtn.enabled = !model.unusable;
}



-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
//    [self.payBtn cornerWithRadius:5.f];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.ordersModel.childOrderList.count;;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    XMFConfirmOrderChildOrderListModel *childModel = self.ordersModel.childOrderList[section];
    
    
    return childModel.goodsList.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFConfirmOrderCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFConfirmOrderCell class]) owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    XMFConfirmOrderChildOrderListModel *childModel = self.ordersModel.childOrderList[indexPath.section];
    
    cell.goodsListModel = childModel.goodsList[indexPath.row];
    
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return KScaleWidth(141);
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    XMFConfirmOrderSectionHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFConfirmOrderSectionHeaderView class]) owner:nil options:nil] firstObject];
    
    headerView.childOrderListModel = self.ordersModel.childOrderList[section];
        
    
    return headerView;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 48;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    

    if ([self.ordersModel.isSplit boolValue]) {
        
        XMFConfirmOrderSectionFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFConfirmOrderSectionFooterView class]) owner:nil options:nil] firstObject];

        footerView.childOrderListModel = self.ordersModel.childOrderList[section];

        
        return footerView;
        
    }else{
        
        return nil;
    }
     
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([self.ordersModel.isSplit boolValue]) {
    
        return 38;
        
    }else{
        
        return 0.01;
    }
    
    
}




//去付款
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    static NSTimeInterval time = 0.0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    //限制用户点击按钮的时间间隔大于1秒钟
    
    if (currentTime - time < 0.75) {
        
        //大于这个时间间隔就处理
        
        return;
        
    }
    
    time = currentTime;
    
    kWeakSelf(self)
    
    
    //为空或者等于0
    if (self.headerView.addressModel.addressId.length <= 0) {
        
        
        [XMFAlertController acWithTitle:XMFLI(@"提示") msg:XMFLI(@"您还没有选择收货地址，现在去选择收货地址吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"取消") confirmAction:^(UIAlertAction * _Nonnull action) {
            
            
            XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
            
            VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
                
                weakself.headerView.addressModel = addressModel;
                
                //按钮是否置灰取决于地址是否可以用
                weakself.payBtn.enabled = !addressModel.unusable;
                
                if (!addressModel.verified) {
                    
                    [weakself.customPopView show];
                }
                
            };

            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
            
        }];
        
        
        return;
        
    }
    
    //判断地址有没有认证过
    if(!self.headerView.addressModel.verified){
        
        
        [self.customPopView show];
        
        return;
        
    }
    
    
    [self getOrderSubmitApp];
    
    
    
}

#pragma mark - ——————— XMFConfirmOrderHeaderView的代理方法 ————————
-(void)tapGestureOnXMFConfirmOrderHeaderViewDidTap:(XMFConfirmOrderHeaderView *)headerView tapView:(UIView *)tapView{
    
    kWeakSelf(self)
    
    switch (tapView.tag) {
        case 0:{//选择或者添加收件人
            
            
            XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
            
            VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
            
                weakself.headerView.addressModel = addressModel;
                
                //按钮是否置灰取决于地址是否可以用
                weakself.payBtn.enabled = !addressModel.unusable;
                
            };
            
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            break;
            
        case 1:{//添加收件人信息
            
          
          
        }
            break;
            
        default:
            break;
    }
    

    
    
}


#pragma mark - ——————— XMFCommonCustomPopView的代理方法 ————————
-(void)buttonsOnXMFCommonCustomPopViewDidClick:(XMFCommonCustomPopView *)popView button:(UIButton *)button{
    
    kWeakSelf(self)
    
    switch (button.tag) {
        case 0:{//右边：补充身份信息
            
            self.isEditAddress = YES;
            
            XMFAddAddressController  *VCtrl = [[XMFAddAddressController alloc]initWithType:editAddress addressId:self.headerView.addressModel.addressId];
              
              kWeakSelf(self)
              
              VCtrl.addAddressBlock = ^{
                  
                  [weakself getAddressList];
                  
                  
              };
              
              [self.navigationController pushViewController:VCtrl animated:YES];
            
            
            
        }
            
            break;
            
        case 1:{//左边：更改收货地址
            
            XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
            
            VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
            
                weakself.headerView.addressModel = addressModel;
                
                //按钮是否置灰取决于地址是否可以用
                 weakself.payBtn.enabled = !addressModel.unusable;
                
                if (!addressModel.verified) {
                    
                    [weakself.customPopView show];
                }
                
            };
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            
            break;
            
        default:
            break;
    }
    
    
    
}


#pragma mark - ——————— 网络请求 ————————
//获取确认订单页面的信息
-(void)getConfirmOrderInfo{
    
    
    NSDictionary *dic = @{
        
        @"cartIds":self.cartGoodsIdArr,
        
        @"list":self.goodsListArr
        
    };
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self showGIFImageView];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_commitApp parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取确认订单页面的信息:%@",responseObject);
        
//        [hud hideAnimated:YES];
        
        [self hideGIFImageView];

        [self.view hideErrorPageView];
        
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            self.ordersModel = [XMFConfirmOrderModel yy_modelWithDictionary:responseObjectModel.data];
            
            self.headerView.orderModel = self.ordersModel;
            
            
            self.myTableView.tableHeaderView = self.headerView;
            
            self.headerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
            
            
            self.footerView.orderModel = self.ordersModel;
                        
            self.myTableView.tableFooterView = self.footerView;
            
            self.footerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
            
            [self.myTableView reloadData];
            
            
            self.bottomView.hidden = NO;
            
            self.goodsCountLB.text = [NSString stringWithFormat:@"共%@件",self.ordersModel.goodsCount];
            
            
            NSMutableAttributedString *totalMoneyStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:UIColorFromRGB(0xFB4D44) upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18.f] lowerStr:[NSString removeSuffix:self.ordersModel.totalPrice] lowerColor:UIColorFromRGB(0xFB4D44) lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18.f]];
            
            
            NSMutableAttributedString *allTotalMoneyStr = [[NSMutableAttributedString alloc]initWithString:@"合计："];
            
            [allTotalMoneyStr appendAttributedString:totalMoneyStr];
            
            
            self.totalMoneyLB.attributedText = allTotalMoneyStr;
            
            
            
//            self.totalMoneyLB.text = [NSString stringWithFormat:@"合计：HK$ %@",self.ordersModel.totalPrice];
            
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getConfirmOrderInfo];
                
            }];
            
        }else if (responseObjectModel.code == 408){
            //库存不足
            XMFCommonPicPopView *popView = [XMFCommonPicPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"手慢啦，商品库存不足…");
            
            popView.popViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                [self popAction];
                
            };
            
            [popView show];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];

        [self hideGIFImageView];

        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getConfirmOrderInfo];


        }];

        
    }];
    
}


//获取行政区域
-(void)getRegionTree{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_region_tree parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"行政区域：%@",[responseObject description]);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
            
            [AddressManager updateAddressInfo:dic];
            
            
            
 
        }else{
            
            
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];

    
}

//提交订单确认去付款
-(void)getOrderSubmitApp{
    
    NSDictionary *dic = @{
        
        @"addressId":self.headerView.addressModel.addressId,
        @"cartIds":self.cartGoodsIdArr,
        
        @"leavingMessage":self.footerView.messageTxW.text,
        @"orderSn":self.ordersModel.orderSn
        
        
    };
    
    DLog(@"用户token：%@",UserInfoModel.token);
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_orderSubmitApp parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"订单确认去付款:%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSString *orderId = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
            [self gotoPayOrder:orderId];
            
            
        }else if (responseObjectModel.code == 408){
            //库存不足
            XMFCommonPicPopView *popView = [XMFCommonPicPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"手慢啦，商品库存不足…");
            
            popView.popViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                

                //库存不足的block
                if (self->_goodsStockoutBlock) {
                    self->_goodsStockoutBlock();
                }
                
                
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


//APP提交支付
-(void)gotoPayOrder:(NSString *)orderId{
    
    NSDictionary *dic = @{
        
        @"orderId":orderId,
        
        @"prepayEnv":@"IOS"
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_prepayapp parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"准备付款:%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            //发送通知告诉购物车刷新
            
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            
            //通知首页列表进行刷新
            KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
        
            
            
            //发送通知我的刷新页面
            KPostNotification(KPost_Anyone_Notice_MeVc_Refesh, nil, nil)
            
            
            
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
                
                [responseMutDic setValue:orderId forKey:@"orderId"];

                
                [self payResult:responseMutDic];
                
            }];
            
            //               vc.hidesBottomBarWhenPushed = YES;
            
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }else if (responseObjectModel.code == 504){//绑定手机
            
            [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    
    
    
}



//支付结果
-(void)payResult:(id)responseObject{
               
    DLog(@"responseObject支付结果:%@",responseObject);
    
//    [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
    
   

    
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
    
    if ([codeStr isEqualToString:@"1000"]){
        
//        if (self->_cartPayBlock) {
//            
//            self->_cartPayBlock();
//            
//        }
    
        
        XMFOrderPayResultController  *VCtrl = [[XMFOrderPayResultController alloc]initWithPayInfoDic:[responseObject copy] jumpFromType:payResultJumpFromHomeVc];
                
        
        [self.navigationController pushViewController:VCtrl animated:YES];
        
    
        
    } else{
        
        [MBProgressHUD showError:messageStr toView:self.view];
        
        
        XMFMyAllOrdersController  *VCtrl = [[XMFMyAllOrdersController alloc]initWithFromType:fromCancelPay];
         
        
        [self.navigationController pushViewController:VCtrl animated:YES];
         
    }
    
                       
}



//获取收货地址列表
-(void)getAddressList{
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self showGIFImageView];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_addresses parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"地址列表：%@",[responseObject description]);
        
//        [hud hideAnimated:YES];
        
        [self hideGIFImageView];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *addressArr = responseObject[@"data"];
            
            [self.addressDataArr removeAllObjects];
            
            for (NSDictionary *dic in addressArr) {
                
                XMFMyDeliveryAddressModel *model = [XMFMyDeliveryAddressModel yy_modelWithDictionary:dic];
                
                [self.addressDataArr addObject:model];

                if ([model.isDefault boolValue] && !self.isEditAddress) {
                    
                    self.headerView.addressModel = model;
                    
                    if (!model.verified) {
                        //如果没有认证
                        [self.customPopView show];

                    }
                    
                    //按钮是否置灰取决于地址是否可以用
                    self.payBtn.enabled = !model.unusable;
                }
            }
            
            
            if (self.isEditAddress) {
                
                for (XMFMyDeliveryAddressModel *model in self.addressDataArr) {
                    
                    //如果地址列表和之前编辑的地址是同一个就赋值
                    if ([self.headerView.addressModel.addressId isEqualToString:model.addressId]) {
                        
                        self.headerView.addressModel = model;
                    }
                    
                }
                
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];
        
        [self hideGIFImageView];

    }];
    
    
}

#pragma mark - ——————— 懒加载 ————————
-(XMFConfirmOrderHeaderView *)headerView{
    
    if (_headerView == nil) {
        _headerView = [XMFConfirmOrderHeaderView XMFLoadFromXIB];
        _headerView.delegate = self;
    }
    return _headerView;
    
}

-(XMFConfirmOrderFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [XMFConfirmOrderFooterView XMFLoadFromXIB];
    }
    return _footerView;
    
}


-(XMFCommonCustomPopView *)customPopView{
    
    if (_customPopView == nil) {
        _customPopView = [XMFCommonCustomPopView XMFLoadFromXIB];
        
        _customPopView.tipsLB.text = XMFLI(@"海关政策抽检，购买跨境进口商品需要\n上传身份证照片，仅用于海关清关。");
        
        [_customPopView.sureBtn setTitle:XMFLI(@"补充身份信息") forState:UIControlStateNormal];
        
        [_customPopView.cancelBtn setTitle:XMFLI(@"更改收货地址") forState:UIControlStateNormal];
        
        _customPopView.delegate = self;
        
    }
    return _customPopView;
    
}

-(NSMutableArray<XMFMyDeliveryAddressModel *> *)addressDataArr{
    
    if (_addressDataArr == nil) {
        _addressDataArr = [[NSMutableArray alloc] init];
    }
    return _addressDataArr;
    
}

-(NSArray *)goodsListArr{
    
    if (_goodsListArr == nil) {
        _goodsListArr = [[NSArray alloc] init];
    }
    return _goodsListArr;
    
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
