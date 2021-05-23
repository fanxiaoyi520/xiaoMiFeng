//
//  XMFOrderConfirmController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/30.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrderConfirmController.h"
#import "XMFOrderConfirmHeaderView.h"//头部view
//#import "XMFOrderConfirmCell.h"//cell
#import "XMFOrderInfoConfirmCell.h"//确认订单cell
#import "XMFOrderCheckedGoodsListModel.h"//确认订单cell的model
#import "XMFOrderConfirmFooterView.h"//尾部view
#import "XMFOrderConfirmModel.h"//订单确认model
#import "XMFAddressListController.h"//选择地址页面
#import "XMFOrdersPayModel.h"//去付款的model
#import "BRAddressModel.h"//地址model
#import "XMFMyOrdersController.h"//我的订单
#import "XMFAddressListModel.h"//地址model
#import "XMFOrderPayResultController.h"//支付结果页


@interface XMFOrderConfirmController ()<UITableViewDelegate,UITableViewDataSource,XMFOrderConfirmHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLB;


@property (nonatomic, strong) XMFOrderConfirmHeaderView *headerView;


@property (nonatomic, strong) XMFOrderConfirmFooterView *footerView;

@property (nonatomic, strong) XMFOrderConfirmModel *orderConfirmModel;

//购物车id
@property (nonatomic, copy) NSString *cartIdStr;

//地址id
@property (nonatomic, copy) NSString *addressIdStr;


@end

@implementation XMFOrderConfirmController

-(instancetype)initWithCartId:(NSString *)cartId{
    
    if (self = [super init]) {
        
        self.cartIdStr = cartId;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}


-(void)setupUI{
    
    
    self.topSpace.constant = kNavBarHeight;

    self.naviTitle = @"订单确认";
    
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    
        
    [self getOrderConfirmInfo:NO];
    
    
    //只有当没有数据的时候才请求
    if (![AddressManager isContainsAddressInfo]) {
        
         [self getRegionTree];
    }
    
    
}

-(void)popAction{
    
    [super popAction];
    
    if (_cartPayBlock) {
        _cartPayBlock();
    }
    
    
}

#pragma mark - ——————— 网络请求 ————————

-(void)getOrderConfirmInfo:(BOOL)isRefresh{

    
    NSDictionary *dic =@{
        @"cartId":self.cartIdStr,
        @"addressId":@"0",
        @"couponId":@"0",
        @"grouponRulesId":@"0"
        
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_cart_checkout parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"订单确认：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            self.orderConfirmModel = [XMFOrderConfirmModel yy_modelWithDictionary:responseObjectModel.data];
            
            if ([self.orderConfirmModel.checkedAddress.addressId isEqualToString:@"0"] && !isRefresh) {
                
                
                
                [XMFAlertController acWithTitle:XMFLI(@"提示") msg:XMFLI(@"您还没有选择收货地址，现在去选择收货地址吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"取消") confirmAction:^(UIAlertAction * _Nonnull action) {
                    
                    
                    XMFAddressListController  *VCtrl = [[XMFAddressListController alloc]initWithJumpType:jumpFromOrderConfirmVcToAddressList];
                    
                   
                    
                    VCtrl.selectedAddressBlock = ^(XMFAddressListModel * _Nonnull addressListModel) {
                        
                        self.headerView.addressListModel = addressListModel;
                        
                        self.addressIdStr = addressListModel.addressId;
                        
                    };
                    
                    
                    [self.navigationController pushViewController:VCtrl animated:YES];
                    
                   
                    
                }];
                
            }
        
            
            self.headerView.headerModel = self.orderConfirmModel;
            
            self.addressIdStr = self.orderConfirmModel.checkedAddress.addressId;
            
            self.footerView.footerModel = self.orderConfirmModel;
            
            self.myTableView.tableHeaderView = self.headerView;
            
            self.headerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
            
            
            self.myTableView.tableFooterView = self.footerView;
            
            self.footerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
            
            
            [self.myTableView reloadData];
            
            self.totalMoneyLB.text = [NSString stringWithFormat:@"应付款：HK$%@",[NSString removeSuffix:self.orderConfirmModel.orderTotalPrice]];
            
            
        }else if (responseObjectModel.kerrno == 504){//绑定手机
            
            [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
    
    
    
}


//获取行政区域
-(void)getRegionTree{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_region_tree parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"行政区域：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
            
            [AddressManager updateAddressInfo:dic];
            
            
            
 
        }else{
            
            
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];

    
}



#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.orderConfirmModel.checkedGoodsList.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFOrderInfoConfirmCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrderInfoConfirmCell class]) owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.goodListModel = self.orderConfirmModel.checkedGoodsList[indexPath.row];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return 115;
    
    return 241;
    
}


/*
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    XMFOrderConfirmHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrderConfirmHeaderView class]) owner:nil options:nil] firstObject];
    
    
    return headerView;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 120;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView = [[UIView alloc]init];
    
    return footerView;;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.01;
    
}
 
 */

#pragma mark - ——————— XMFOrderConfirmHeaderView的代理方法 ————————
-(void)tapGestureOnXMFOrderConfirmHeaderViewDidTap:(XMFOrderConfirmHeaderView *)headerView{
    
    XMFAddressListController  *VCtrl = [[XMFAddressListController alloc]initWithJumpType:jumpFromOrderConfirmVcToAddressList];
    
    kWeakSelf(self)
    
    VCtrl.selectedAddressBlock = ^(XMFAddressListModel * _Nonnull addressListModel) {
      
        weakself.headerView.addressListModel = addressListModel;
        
        weakself.addressIdStr = addressListModel.addressId;
        
    };
    
    VCtrl.addressHasChangedBlock = ^{
      
        [weakself getOrderConfirmInfo:YES];
        
    };
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}


//去付款按钮被点击
- (IBAction)payBtnDidClick:(UIButton *)sender{
    
    
    
    static NSTimeInterval time = 0.0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    //限制用户点击按钮的时间间隔大于1秒钟
    
    if (currentTime - time < 0.75) {
        
        //大于这个时间间隔就处理
        
        return;
        
    }
    
    time = currentTime;
    
    
    /*
    if ([self.orderConfirmModel.orderTotalPrice floatValue] > 5000) {
        
        [XMFAlertController acWithTitle:XMFLI(@"提示") message:XMFLI(@"根据相关政策，购买跨境商品，单次金额不能大于5000元。") confirmBtnTitle:XMFLI(@"知道了") confirmAction:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        return;
        
    };*/
    
    
    
    
    //为空或者等于0
    if ([self.addressIdStr nullToString] || [self.addressIdStr isEqualToString:@"0"]) {
        
        
        [XMFAlertController acWithTitle:XMFLI(@"提示") msg:XMFLI(@"您还没有选择收货地址，现在去选择收货地址吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"取消") confirmAction:^(UIAlertAction * _Nonnull action) {
            
            
            XMFAddressListController  *VCtrl = [[XMFAddressListController alloc]initWithJumpType:jumpFromOrderConfirmVcToAddressList];
            
            
            
            VCtrl.selectedAddressBlock = ^(XMFAddressListModel * _Nonnull addressListModel) {
                
                self.headerView.addressListModel = addressListModel;
                
                self.addressIdStr = addressListModel.addressId;
                
            };
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
            
        }];
        
        
        return;
        
    }
    

    
   /* {"addressId":2336,"cartId":5868,"couponId":0,"detailAddress":"天津天津市宝坻区31"}
    */
    
    NSDictionary *dic = @{
        
        @"addressId":self.addressIdStr,
        
        @"cartId":self.cartIdStr,
        
        @"couponId":@"0",
        
        @"detailAddress":self.headerView.addressLB.text,
        
        @"leavingMessage":self.footerView.messageTxW.text
        
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_submitApp parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"提交订单：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            //发送通知告诉购物车刷新
            
            KPostNotification(KPost_HomeSonVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            //通知首页的子商品列表进行刷新
              KPostNotification(KPost_CartVc_Notice_HomeSonVc_Refesh, nil, nil)
            
            
            XMFOrdersPayModel *payModel = [XMFOrdersPayModel yy_modelWithDictionary:responseObjectModel.data];
            
            
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
                @"associate_domain":Associate_domainLinks
            };
            
            
            [[ZDPay_OrderSureModel sharedSingleten] setModelProcessingDic:dic];
            
            ZDPay_OrderSureViewController *vc = [ZDPay_OrderSureViewController new];
            vc.orderModel = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
            
            
            [vc ZDPay_PaymentResultCallbackWithCompletionBlock:^(id  _Nonnull responseObject) {
                
                
                NSMutableDictionary *responseMutDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                
                [responseMutDic setValue:payModel.txnCurr forKey:@"txnCurr"];
                
                [responseMutDic setValue:payModel.txnAmt forKey:@"txnAmt"];
                
                
                [self payResult:responseMutDic];
                
            }];
            
//               vc.hidesBottomBarWhenPushed = YES;
                   
                   
            [self.navigationController pushViewController:vc animated:YES];
                   

                   
             }else{
                   
                   
                   [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
                   
            }
        
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];

        
    }];
    
    
}


//支付结果
-(void)payResult:(id)responseObject{
               
    DLog(@"responseObject支付结果:%@",responseObject);
    
     //通知个人中心刷新页面
    KPostNotification(KPost_Anyone_Notice_MeVc_Refesh, nil, nil)

    
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
        
        if (self->_cartPayBlock) {
            
            self->_cartPayBlock();
            
        }
    
        
        XMFOrderPayResultController  *VCtrl = [[XMFOrderPayResultController alloc]initWithPayInfoDic:[responseObject copy] jumpFromType:payResultJumpFromHomeVc];
                
        
        [self.navigationController pushViewController:VCtrl animated:YES];
        
    
        
    } else{
        
        [MBProgressHUD showError:messageStr toView:self.view];
        
        
         XMFMyOrdersController  *VCtrl = [[XMFMyOrdersController alloc]initWithMyOrdersJumpFromType:myOrdersJumpFromCancelPay];
         
         
         [self.navigationController pushViewController:VCtrl animated:YES];
         
    }
    
                       
}

#pragma mark - ——————— 懒加载 ————————

-(XMFOrderConfirmHeaderView *)headerView{
    
    if (_headerView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrderConfirmHeaderView class]) owner:nil options:nil] firstObject];
        _headerView.delegate = self;
    
    }
    return _headerView;
    
}

-(XMFOrderConfirmFooterView *)footerView{
    
    if (_footerView == nil) {
        
        _footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrderConfirmFooterView class]) owner:nil options:nil] firstObject];
      
    }
    
    return _footerView;
    
    
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
