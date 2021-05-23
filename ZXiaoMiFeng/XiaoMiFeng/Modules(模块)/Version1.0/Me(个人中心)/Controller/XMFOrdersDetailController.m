//
//  XMFOrdersDetailController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/18.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersDetailController.h"
#import "XMFOrdersDetailHeaderView.h"
#import "XMFOrdersDetailCell.h"
#import "XMFOrdersDetailFooterView.h"
#import "XMFOrdersCellModel.h"//订单列表model
#import "XMFOrdersDetailModel.h"//订单详情model
#import "XMFLogisticsController.h"//物流详情
#import "CountDown.h"//倒计时
#import "XMFOrdersCommentController.h"//发表评价
#import "XMFOrdersPayModel.h"//去付款的model
#import "XMFOrderPayResultController.h"//支付结果页




@interface XMFOrdersDetailController ()<UITableViewDelegate,UITableViewDataSource,XMFOrdersDetailHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//底部View
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;


//右边按钮
@property (weak, nonatomic) IBOutlet UIButton *rightSonBtn;

//左边按钮
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;


@property (nonatomic, strong) XMFOrdersDetailHeaderView *headerView;


@property (nonatomic, strong) XMFOrdersDetailFooterView *footerView;

//订单列表model
@property (nonatomic, strong) XMFOrdersCellModel *orderModel;

//订单详情model
@property (nonatomic, strong) XMFOrdersDetailModel *detailModel;

//倒计时
@property (strong, nonatomic)  CountDown *countDownForBtn;

//是否是当前页面本地设置为可评价
@property (nonatomic, assign) BOOL isCurrentSetComment;


@end

@implementation XMFOrdersDetailController


-(instancetype)initWithModel:(XMFOrdersCellModel *)ordersModel{
    
    if (self = [super init]) {
        
        self.orderModel = ordersModel;
        
//        self.headerView.ordersCellModel = ordersModel;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)dealloc{

    [_countDownForBtn destoryTimer];
    
    DLog(@"%s dealloc",object_getClassName(self));
}

-(void)setupUI{
    
//    self.topBgViewbgColor = UIColorFromRGB(0xF7CF20);
        
    self.naviTitle = XMFLI(@"订单详情");
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    
    [self getOrderDetail];
    
}


//页面上的按钮被点击:左右两个按钮
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (self.orderModel.statusType) {
        case pendingPay:{//待付款
            
            if (sender.tag == 0) {
                //去付款
                                
                [self postOrderPay:sender];
                
                
            }else{
                
                //取消订单
                
                [XMFAlertController acWithTitle:XMFLI(@"取消订单") msg:XMFLI(@"确定要取消此订单吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"再想想") confirmAction:^(UIAlertAction * _Nonnull action) {
                    
                    [weakself postOrderCancel:sender];
                    
                }];
                
                
            }
            
            
        }
            break;
        case pendingDelivery:{//待发货
            
            [XMFAlertController acWithTitle:XMFLI(@"退款确认") msg:XMFLI(@"好货不等人，您确定要申请退款吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"再想想") confirmAction:^(UIAlertAction * _Nonnull action) {
                
                [weakself postOrderRefund:sender];
                
            }];
            
            
            
            
        }
            break;
        case pendingReceipt:{//待收货
            
            [self postOrderConfirm:sender];
            
        }
            break;
        case pendingComment:{//待评价
            
            XMFOrdersCommentController  *VCtrl = [[XMFOrdersCommentController alloc]initWithModel:self.orderModel];
            
            VCtrl.addCommentSuccessBlock = ^{
                
                //只有当不是当前页面设置为可评价后才回调，避免闪退
                if (!weakself.isCurrentSetComment) {
                    
                    //block回调
                    if (self->_ordersDetailSuccessBlock) {
                        
                        self->_ordersDetailSuccessBlock(sender.tag);
                    }
                    
                }
                
                //处理底部
                weakself.rightSonBtn.hidden = YES;
                
                weakself.leftBtn.hidden = YES;
                
                weakself.bottomView.hidden = YES;
                
                weakself.bottomViewHeight.constant = 0.f;
                
                
                //当前页面处理
                weakself.orderModel.handleOption.comment = NO;
                
                weakself.orderModel.handleOption.orderDelete = YES;
                
                weakself.orderModel.handleOption.rebuy = YES;
                
                weakself.orderModel.statusType  = pendingRebuy;
                
                weakself.headerView.modifyOrdersCellModel = weakself.orderModel;
                
                weakself.detailModel.orderInfo.orderStatusText = XMFLI(@"已收货");
                
//                weakself.headerView.detailModel = weakself.detailModel;
                
                weakself.headerView.infoModel = weakself.detailModel.orderInfo;
                

                
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.detailModel.orderGoods.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFOrdersDetailCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrdersDetailCell class]) owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.goodsModel = self.detailModel.orderGoods[indexPath.row];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

#pragma mark - ——————— 网络请求 ————————
-(void)getOrderDetail{
    
    NSDictionary *dic = @{
        
        @"orderId":self.orderModel.orderId
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"订单详情：%@",[responseObject description]);
        
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            self.detailModel = [XMFOrdersDetailModel yy_modelWithDictionary:responseObjectModel.data];
            
             if ([self.detailModel.orderInfo.orderStatusText isEqualToString:@"缺货"]){
                 
                //待进货（缺货）
                self.detailModel.statusType = pengdingStock;
                
                
            }else if (self.detailModel.orderInfo.handleOption.pay && self.detailModel.orderInfo.handleOption.cancel){
                
                //待付款
                
                self.detailModel.statusType = pendingPay;
                
            }else if (self.detailModel.orderInfo.handleOption.refund || [self.detailModel.orderInfo.orderStatusText isEqualToString:@"已付款"]){
                
                //待发货
                self.detailModel.statusType = pendingDelivery;
                
            }else if (self.detailModel.orderInfo.handleOption.confirm) {
                
                //待收货
                self.detailModel.statusType = pendingReceipt;
                
            }else if (self.detailModel.orderInfo.handleOption.comment){
                
                //待评价
                self.detailModel.statusType = pendingComment;
                
                
            }else if (self.detailModel.orderInfo.handleOption.rebuy && self.detailModel.orderInfo.handleOption.orderDelete){
                //待重买
                
                self.detailModel.statusType = pendingRebuy;
                
            }else{//默认，或者全部为false
                
                self.detailModel.statusType = pendingDefault;
            }
               
            
            //为页面赋值
            [self setDataForView];
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];

        
    }];
    
    
}


//取消订单
-(void)postOrderCancel:(UIButton *)button{
  
    
    NSDictionary *dic = @{
        
        @"orderId":self.orderModel.orderId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_cancel parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"取消订单：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            self.rightSonBtn.hidden = YES;
            
            self.leftBtn.hidden = YES;
            
            self.bottomView.hidden = YES;
            
            self.bottomViewHeight.constant = 0.f;
            
            //block回调
            if (self->_ordersDetailSuccessBlock) {
               
                self->_ordersDetailSuccessBlock(button.tag);
            }
            
            
            
            //当前页面处理
            self.orderModel.handleOption.pay = NO;
            
            self.orderModel.handleOption.cancel = NO;
            
            self.orderModel.handleOption.orderDelete = YES;
            
            self.orderModel.statusType  = pendingDelete;
        
            self.headerView.modifyOrdersCellModel = self.orderModel;
        
            self.detailModel.orderInfo.orderStatusText = XMFLI(@"已取消");
            
//            self.headerView.detailModel = self.detailModel;
            
            self.headerView.infoModel = self.detailModel.orderInfo;
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
    
}


//申请退款
-(void)postOrderRefund:(UIButton *)button{
    
    NSDictionary *dic = @{
        
        @"orderId":self.orderModel.orderId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_refund parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"申请退款：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {

            
            [XMFAlertController acWithTitle:XMFLI(@"提交成功") message:XMFLI(@"退款申请成功，我们会在2个工作日内为您办理退款程序，请您保持电话畅通") confirmBtnTitle:XMFLI(@"知道了") confirmAction:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            //block回调
            if (self->_ordersDetailSuccessBlock) {
               
                self->_ordersDetailSuccessBlock(button.tag);
            }
            
            
            self.rightSonBtn.hidden = YES;
            
            self.leftBtn.hidden = YES;
            
            self.bottomView.hidden = YES;
            
            self.bottomViewHeight.constant = 0.f;
            

            //当前页面处理
            self.orderModel.handleOption.refund = NO;
            
            self.orderModel.handleOption.orderDelete = YES;
            
            self.orderModel.statusType  = pendingDelete;
            
            self.headerView.modifyOrdersCellModel = self.orderModel;
            
            self.detailModel.orderInfo.orderStatusText = XMFLI(@"已申请退款");;
            
//            self.headerView.detailModel = self.detailModel;
            
            self.headerView.infoModel = self.detailModel.orderInfo;
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
            [self getOrderDetail];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}



//确认收货
-(void)postOrderConfirm:(UIButton *)button{
    
    NSDictionary *dic = @{
        
        @"orderId":self.orderModel.orderId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_confirm parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"确认收货：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {

            //block回调
            if (self->_ordersDetailSuccessBlock) {
               
                self->_ordersDetailSuccessBlock(button.tag);
            }
            
            //处理底部按钮
            self.rightSonBtn.hidden = NO;
            
            self.leftBtn.hidden = YES;
            
            [self.rightSonBtn setTitle:XMFLI(@"去评价") forState:UIControlStateNormal];
            
            [self.rightSonBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
            
            
            //当前页面处理
            self.orderModel.handleOption.confirm = NO;;
            
            self.orderModel.handleOption.comment = NO;
            
            self.orderModel.handleOption.comment = YES;
            
            
            self.orderModel.statusType  = pendingComment;
            
            self.headerView.modifyOrdersCellModel = self.orderModel;
            
            self.detailModel.orderInfo.orderStatusText = XMFLI(@"待评价");
            
//            self.headerView.detailModel = self.detailModel;
            
            self.headerView.infoModel = self.detailModel.orderInfo;
            
            //当前页面设置状态为可评价
            self.isCurrentSetComment = YES;
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}

//去付款
-(void)postOrderPay:(UIButton *)button{
    
    NSDictionary *dic = @{
           
           
           @"orderId":self.orderModel.orderId
           
       };
       
       
       [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_prepayApp parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
           
           DLog(@"去付款：%@",[responseObject description]);
           
           if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
               
               //通知首页的子商品列表进行刷新
               KPostNotification(KPost_CartVc_Notice_HomeSonVc_Refesh, nil, nil);
               
               
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
//                      @"countryCode":payModel.countryCode,
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
                   
                   
                   [self payResult:responseMutDic button:button viewController:vc];
                   
               }];
               
               
               [self.navigationController pushViewController:vc animated:YES];
               
            
               
           }else{
               
               
               [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
               
           }
           
           
       } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
           
       }];
    
}


//支付结果
-(void)payResult:(id)responseObject button:(UIButton *)button viewController:(ZDPay_OrderSureViewController *)vc{
    DLog(@"responseObject详情支付页:%@",responseObject);
    
    [MBProgressHUD showSuccess:@"支付成功" toView:self.view];
    
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
        
        
        //                       [self.navigationController popToRootViewControllerAnimated:YES];
        
        //block回调
        if (self->_ordersDetailSuccessBlock) {
            
            self->_ordersDetailSuccessBlock(button.tag);
        }
        
        //跳转到支付成功结果页
        XMFOrderPayResultController  *VCtrl = [[XMFOrderPayResultController alloc]initWithPayInfoDic:[responseObject copy] jumpFromType:payResultJumpFromOrdersVc];

        
        [self.navigationController pushViewController:VCtrl animated:YES];
        
        
        
    } else{
        
        [MBProgressHUD showError:messageStr toView:self.view];
        
        //支付取消
               
        [vc.navigationController  popViewControllerAnimated:YES];
    }
    

    
    
}


//为页面赋值
-(void)setDataForView{
    
    
    //使用当前页面接口请求返回的数据，而不是从订单列表传递的数据
    switch (self.detailModel.statusType) {
            
        case pengdingStock:{//待进货（缺货）
            
            self.rightSonBtn.hidden = NO;
            
            self.leftBtn.hidden = YES;
            
            
            [self.rightSonBtn setTitle:XMFLI(@"申请退款") forState:UIControlStateNormal];
            
            [self.rightSonBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_quxiaodd"] forState:UIControlStateNormal];
            
        }
            break;
            
        case pendingPay:{//待付款
            
            self.rightSonBtn.hidden = NO;
            
            self.leftBtn.hidden = NO;
            
            [self.rightSonBtn setTitle:XMFLI(@"去付款") forState:UIControlStateNormal];
            
            [self.rightSonBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
            
            
            //倒计时
             _countDownForBtn = [[CountDown alloc] init];
            
            
            NSDateFormatter* formater = [[NSDateFormatter alloc] init];
                   [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                   
                   NSDate *addtimeDate = [formater dateFromString:self.detailModel.orderInfo.addTime];
                   
                   //30分钟后的NSDate
                   NSDateComponents *comps = [[NSDateComponents alloc] init];
                   
                   [comps setMinute:30];
                   
                   NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                   
                   NSDate *finishDate = [calender dateByAddingComponents:comps toDate:addtimeDate options:0];
                   
                   //当前时间的NSDate
                   NSDate* currentDate = [NSDate date];
                   
                   NSString *currentTimeString = [formater stringFromDate:currentDate];
                   
                   NSDate *startDate = [formater dateFromString:currentTimeString];
                   
                   //开始倒计时
                   [self startWithStartDate:startDate finishDate:finishDate];
            

            
        }
            break;
            
        case pendingDelivery:{//待发货
            
            
            //allocateCargoStatus：1待拣货 2拣货完成
            if ([self.detailModel.orderInfo.allocateCargoStatus isEqualToString:@"1"]) {
                
                self.rightSonBtn.hidden = NO;
                
                self.leftBtn.hidden = YES;
                
                
                [self.rightSonBtn setTitle:XMFLI(@"申请退款") forState:UIControlStateNormal];
                
                [self.rightSonBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_quxiaodd"] forState:UIControlStateNormal];
                
                
            }else if ([self.detailModel.orderInfo.allocateCargoStatus isEqualToString:@"2"]){
                
                self.rightSonBtn.hidden = YES;
                
                self.leftBtn.hidden = YES;
                
                self.bottomView.hidden = YES;
                
                self.bottomViewHeight.constant = 0.f;
                
            }
            
            
            
        }
            break;
            
        case pendingReceipt:{//待收货
            
            self.rightSonBtn.hidden = NO;
            
            self.leftBtn.hidden = YES;
            
            [self.rightSonBtn setTitle:XMFLI(@"确认收货") forState:UIControlStateNormal];
            
            [self.rightSonBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
            
        }
            break;
            
        case pendingComment:{//待评价
            
            self.rightSonBtn.hidden = NO;
            
            self.leftBtn.hidden = YES;
            
            [self.rightSonBtn setTitle:XMFLI(@"去评价") forState:UIControlStateNormal];
            
            [self.rightSonBtn setBackgroundImage:[UIImage imageNamed:@"icon_order_querendd"] forState:UIControlStateNormal];
            
        }
            break;
            
            
        default:{
            
            self.rightSonBtn.hidden = YES;
            
            self.leftBtn.hidden = YES;
            
            self.bottomView.hidden = YES;
            
            self.bottomViewHeight.constant = 0.f;
            
        }
            break;
    }
    
    
    
    //为tableview的头部view和底部View赋值
//    self.headerView.infoModel = self.detailModel.orderInfo;
    self.headerView.detailModel = self.detailModel;
    
    self.footerView.infoModel = self.detailModel.orderInfo;
    
    self.myTableView.tableHeaderView = self.headerView;
    
    self.headerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
    
    
    self.myTableView.tableFooterView = self.footerView;
    
    self.footerView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
    
    
    [self.myTableView reloadData];
    
    
}


//此方法用两个NSDate对象做参数进行倒计时
-(void)startWithStartDate:(NSDate *)strtDate finishDate:(NSDate *)finishDate{
    
    __weak __typeof(self) weakSelf= self;
    [_countDownForBtn countDownWithStratDate:strtDate finishDate:finishDate completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
//        NSLog(@"second = %li",second);
        NSInteger totoalSecond =day*24*60*60+hour*60*60 + minute*60+second;
        if (totoalSecond == 0) {
            
            weakSelf.headerView.countdownLB.text = XMFLI(@"已超时");
            
            weakSelf.headerView.countdownLB.hidden = YES;
            
            weakSelf.rightSonBtn.hidden = YES;
            
            weakSelf.leftBtn.hidden = YES;
            
            weakSelf.bottomView.hidden = YES;
            
            weakSelf.bottomViewHeight.constant = 0.f;
            
            
        }else{
            //请在00天00时23分44秒内付款
            //超时订单将自动关闭
            weakSelf.headerView.countdownLB.text = [NSString stringWithFormat:@"请在%zd天%zd时%zd分%zd秒内付款\n超时订单将自动关闭",day,hour,minute,second];
            
        }
        
        }];
}


#pragma mark - ——————— XMFOrdersDetailHeaderView的代理方法 ————————

-(void)viewOnXMFOrdersDetailHeaderViewDidTap:(XMFOrdersDetailHeaderView *)headerView{
    
    XMFLogisticsController  *VCtrl = [[XMFLogisticsController alloc]initWithOrderId:self.orderModel.orderId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}





#pragma mark - ——————— 懒加载 ————————

-(XMFOrdersDetailHeaderView *)headerView{
    
    if (_headerView == nil) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrdersDetailHeaderView class]) owner:nil options:nil] firstObject];
        
        _headerView.delegate = self;
    }
    return _headerView;
    
}

-(XMFOrdersDetailFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrdersDetailFooterView class]) owner:nil options:nil] firstObject];;
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
