//
//  XMFMyOrdersListController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/28.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersListController.h"
#import "XMFMyOrdersListCell.h"//cell
#import "XMFMyOrdersListHeaderView.h"//组头view
#import "XMFMyOrdersListFooterView.h"//组尾view
#import "XMFMyOrdersListModel.h"//我的订单总model
#import "XMFMyOrdersListFooterModel.h"//组尾view操作按钮的model
#import "XMFMyOrdersListFooterCell.h"//组尾view操作的cell
#import "XMFMyOrdersPopView.h"//订单单按钮弹窗
#import "XMFMyOrdersDetailController.h"//订单详情
#import "XMFMyDeliveryAddressController.h"//选择地址页面
#import "XMFOrdersLogisticsController.h"//查看物流
#import "XMFMyDeliveryAddressModel.h"//地址model
#import "XMFOrderRefundController.h"//申请退款
#import "XMFOrderRateController.h"//立即评价
#import "XMFOrdersPayModel.h"//去付款的model
#import "XMFOrderPayResultController.h"//支付结果页


@interface XMFMyOrdersListController ()<UITableViewDelegate,UITableViewDataSource,XMFMyOrdersListFooterViewDelegate,XMFMyOrdersListHeaderViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, assign) NSInteger cellNum;

/** 订单信息 0:全部订单, 1:待付款, 2:待发货, 3:待收货, 4:已完成 */
@property (nonatomic, assign) myAllOrdersJumpFromType showType;

/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

/** 订单列表数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFMyOrdersListModel *> *dataSourceArr;





@end

@implementation XMFMyOrdersListController

-(instancetype)initWithFromType:(myAllOrdersJumpFromType)fromType{
    
    self = [super init];
    
    if (self) {
        
        self.showType = fromType;
    }
    
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupUI];

}



-(void)setupUI{
    

 
    [self.view addSubview:self.myTableView];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.edges.equalTo(self.view);
        
    }];
    
    
    //防止刷新抖动
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;
    
    [self getNewData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil];
 
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - notification

-(void)acceptMsg:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSInteger type = [userInfo[@"showType"] integerValue];
    
    if (type != self.showType) {
        //只要不是当前页面就刷新
        
        [self getNewData];
        
    }

    
}


#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSourceArr.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    XMFMyOrdersListModel *listModel = self.dataSourceArr[section];
    
    return listModel.goodsList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFMyOrdersListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFMyOrdersListCell class]) owner:nil options:nil] firstObject];;
    }
        

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    XMFMyOrdersListModel *listModel = self.dataSourceArr[indexPath.section];
    
    cell.goodsListModel = listModel.goodsList[indexPath.row];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return KScaleWidth(112);
    
    return 112;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    XMFMyOrdersListHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFMyOrdersListHeaderView class]) owner:nil options:nil] firstObject];;
    
    headerView.listModel = self.dataSourceArr[section];
    
    headerView.headerViewSection = section;
    
    headerView.delegate = self;
    
    return headerView;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 48;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    XMFMyOrdersListFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFMyOrdersListFooterView class]) owner:nil options:nil] firstObject];;
    
    footerView.listModel = self.dataSourceArr[section];
    
    
    footerView.footerViewSection = section;
    
    
    footerView.delegate = self;
    
    
    return footerView;
     
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 105;
    
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFMyOrdersListModel *listModel = self.dataSourceArr[indexPath.section];
    
    XMFMyOrdersDetailController  *VCtrl = [[XMFMyOrdersDetailController alloc]initWithOrderId:listModel.keyId];
    
    kWeakSelf(self)
    
    VCtrl.myOrdersDetailBlock = ^(XMFMyOrdersListModel * _Nonnull listModel) {
        
        [weakself getNewData];
        
    };
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
}

#pragma mark - ——————— XMFMyOrdersListFooterView的代理方法 ————————
-(void)cellOnXMFMyOrdersListFooterViewDidSelected:(XMFMyOrdersListFooterView *)footerView cell:(XMFMyOrdersListFooterCell *)cell{
    
    
//    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%d",cell.footerModel.handleOptionNum] toView:self.view];
    
    kWeakSelf(self)
    
    switch (cell.footerModel.handleOptionNum) {
        case 0:{//confirm
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"确认收货后，交易完成哦~");
            
            popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                if (button.tag == 0) {//确认
                    
                    [weakself postOrderConfirm:footerView.listModel.keyId inSection:footerView.footerViewSection];
                    
                }
                
            };
            
            [popView show];
            
            
            
        }
            break;
        case 1:{//queryTrack
            
            XMFOrdersLogisticsController  *VCtrl = [[XMFOrdersLogisticsController alloc]initWithOrderListModel:footerView.listModel];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 2:{//cancel
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"确认取消订单吗?");
            
            popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
            
                if (button.tag == 0) {//确认
                    
                    [weakself getOrderCancel:footerView.listModel.keyId inSection:footerView.footerViewSection];
                    
                }
                
            };
            
            [popView show];
            
        }
            break;
        case 3:{//remind
            
            [self getOrderRemain:footerView.listModel.keyId inSection:footerView.footerViewSection];
            
            
        }
            break;
        case 4:{//comment
            
            XMFOrderRateController  *VCtrl = [[XMFOrderRateController alloc]initWithListModel:footerView.listModel orderRateType:soonComment];
            
            VCtrl.submitCommentBlock = ^(orderRateType type) {
                
                
                XMFMyOrdersListModel *orderModel = weakself.dataSourceArr[footerView.footerViewSection];
                
                orderModel.orderStatus = @"401";
                
                [orderModel.handleOption setValue:@(NO) forKey:@"comment"];
                
                [orderModel.handleOption setValue:@(YES) forKey:@"appendComment"];
                
                //本地刷新组
                
                [UIView performWithoutAnimation:^{
                    
                    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:footerView.footerViewSection];
                    [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 5:{//delete

            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"确认删除此笔订单?");
            
            popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                if (button.tag == 0) {//确认
                    
                    [weakself getOrderDeleteOrder:footerView.listModel.keyId inSection:footerView.footerViewSection];
                    
                }
                
            };
            
            [popView show];
            
        }
            break;
        case 6:{//pay
            
            [self postOrderPay:footerView.listModel.keyId inSection:footerView.footerViewSection];
        }
            break;
        case 7:{//updateAddress
            
            XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
            
            VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
                
                [weakself postOrderUpdateOrderAddress:footerView.listModel.keyId inSection:footerView.footerViewSection addressModel:addressModel];
                
            };
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 8:{//extendConfirm
            
            
             [self getOrderExtendConfirm:footerView.listModel.keyId inSection:footerView.footerViewSection];
            
            
            
        }
            break;
        case 9:{//rebuy
            

            
        }
            break;
        case 10:{//appendComment
            
            XMFOrderRateController  *VCtrl = [[XMFOrderRateController alloc]initWithListModel:footerView.listModel orderRateType:addComment];
            
            VCtrl.submitCommentBlock = ^(orderRateType type) {
                
                XMFMyOrdersListModel *orderModel = weakself.dataSourceArr[footerView.footerViewSection];
                
                [orderModel.handleOption setValue:@(NO) forKey:@"appendComment"];
                
                //本地刷新组
                
                [UIView performWithoutAnimation:^{
                    
                    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:footerView.footerViewSection];
                    [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                }];
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 11:{//refund
            
            XMFOrderRefundController  *VCtrl = [[XMFOrderRefundController alloc]initWithListModel:footerView.listModel];
            
            VCtrl.orderRefundBlock = ^{
                
                XMFMyOrdersListModel *orderModel = weakself.dataSourceArr[footerView.footerViewSection];
                
                orderModel.orderStatus = @"202";
                
                [orderModel.handleOption setValue:@(NO) forKey:@"refund"];
                [orderModel.handleOption setValue:@(YES) forKey:@"cancelRefund"];

                
                //本地刷新组
                
                [UIView performWithoutAnimation:^{
                    
                    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:footerView.footerViewSection];
                    [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 12:{//cancelRefund
            
            [self getOrderCancelRefund:footerView.listModel.keyId inSection:footerView.footerViewSection];
            
        }
            break;
        case 13:{//addCart
            
            [MBProgressHUD showOnlyTextToView:self.view title:@"加入购物车，等待后台接口"];
        }
            break;
        default:
            break;
    }
    
    
    
    
    
}


//补充信息的按钮点击
-(void)buttonsOnXMFMyOrdersListFooterViewDidClick:(XMFMyOrdersListFooterView *)footerView button:(UIButton *)button{
    
    
    kWeakSelf(self)
    
    //updateAddress
    
    XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
    
    VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
        
        [weakself postOrderUpdateOrderAddress:footerView.listModel.keyId inSection:footerView.footerViewSection addressModel:addressModel];
        
    };
    
    
    [self.navigationController pushViewController:VCtrl animated:YES];
}



#pragma mark - ——————— XMFMyOrdersListHeaderView的代理方法 ————————
-(void)buttonsOnXMFMyOrdersListHeaderViewDidClick:(XMFMyOrdersListHeaderView *)headerView button:(UIButton *)button{
    

    
    kWeakSelf(self)
    
    XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
    
    popView.tipsLB.text = XMFLI(@"确认删除此笔订单?");
    
    popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
        
        if (button.tag == 0) {//确认
            
            [weakself getOrderDeleteOrder:headerView.listModel.keyId inSection:headerView.headerViewSection];
            
        }
        
    };
    
    [popView show];
    
    
}


#pragma mark - ——————— 网络请求 ————————
-(void)getNewData{
    
    
    [self.myTableView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    NSDictionary *dic = @{
        
        @"pageNum":@(self.currentPage),
        
        @"pageSize":@(10),
        
        @"showType":@(self.showType)
        
    };
    
    [self.myTableView ly_startLoading];
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self showGIFImageView];

    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"订单类型：%zd 订单数据：%@ ",self.showType,[responseObject description]);
        
//        [hud hideAnimated:YES];
        
        [self hideGIFImageView];

        [self.view hideErrorPageView];
        
        [self.view hideServerErrorPageView];
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *listArr = responseObjectModel.data[@"list"];
            
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dic in listArr) {
                
                XMFMyOrdersListModel *model = [XMFMyOrdersListModel yy_modelWithDictionary:dic];
                
                model.remark = @"拒绝退款啦";
                
                [self.dataSourceArr addObject:model];
            }
            
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getNewData];
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

        }
        
        [self.myTableView.mj_header endRefreshing];
        
        
        [self.myTableView reloadData];
        
        
        [self.myTableView ly_endLoading];
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];
        
        [self hideGIFImageView];

        
         [self.myTableView.mj_header endRefreshing];
        
         [self.myTableView ly_endLoading];

        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getNewData];


        }];
        
    }];
    
    
    
}


-(void)getMoreData{
    
    self.currentPage += 1;
    
    NSDictionary *dic = @{
        
        @"pageNum":@(self.currentPage),
        
        @"pageSize":@(10),
        
        @"showType":@(self.showType)
        
    };
    
    

    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"订单类型：%zd 订单数据：%@ ",self.showType,[responseObject description]);
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *listArr = responseObjectModel.data[@"list"];
            
            
            for (NSDictionary *dic in listArr) {
                
                XMFMyOrdersListModel *model = [XMFMyOrdersListModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
            }
            
            
            if (listArr.count < 10) {
                
                [self.myTableView.mj_footer endRefreshingWithNoMoreData];

                
            }else{
                
                [self.myTableView.mj_footer endRefreshing];

            }
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
            [self.myTableView.mj_footer endRefreshing];


        }
        
    
        [self.myTableView reloadData];
        
            
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
         [self.myTableView.mj_footer endRefreshing];

        
    }];
    
    
}


//确认收货
-(void)postOrderConfirm:(NSString *)orderIdStr inSection:(NSInteger)section{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_confirm parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"确认收货：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            //进入订单评价页面
            XMFOrderRateController  *VCtrl = [[XMFOrderRateController alloc]initWithListModel:self.dataSourceArr[section] orderRateType:soonComment];
            
            VCtrl.submitCommentBlock = ^(orderRateType type) {
                
                //发送通知是否刷新页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType)}];
                
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
            
            
            if (self.showType == fromPendingReceipt) {//当在待收货页面时
                
                [self.dataSourceArr removeObjectAtIndex:section];
                
                //防止取消到最后一个不显示无数据的占位
                [self.myTableView ly_startLoading];
                
                [self.myTableView reloadData];
                
                [self.myTableView ly_endLoading];
            
            
            }else{//当在全部订单页面时
                
                XMFMyOrdersListModel *orderModel = self.dataSourceArr[section];
                
                orderModel.orderStatus = @"409";
                
                [orderModel.handleOption setValue:@(NO) forKey:@"confirm"];
                
               [orderModel.handleOption setValue:@(YES) forKey:@"comment"];
            
                
                //本地刷新组
                
                [UIView performWithoutAnimation:^{
                    
                    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                    [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                
                
            }
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType)}];
        
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    
    
}


//用户延长收货时间
-(void)getOrderExtendConfirm:(NSString *)orderIdStr inSection:(NSInteger)section{
    
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
            
            XMFMyOrdersListModel *orderModel = self.dataSourceArr[section];
            
            
            [orderModel.handleOption setValue:@(NO) forKey:@"extendConfirm"];
                        
            
            //本地刷新组
            
            [UIView performWithoutAnimation:^{
                
                NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType)}];
            
            
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
-(void)getOrderCancel:(NSString *)orderIdStr inSection:(NSInteger)section{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_cancel parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"取消订单：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            if (self.showType == fromPendingPay) {//当在待付款页面时
                
                [self.dataSourceArr removeObjectAtIndex:section];
                
                //防止取消到最后一个不显示无数据的占位
                [self.myTableView ly_startLoading];
                
                [self.myTableView reloadData];
                
                [self.myTableView ly_endLoading];
                
                
            }else{//挡在全部订单页面时
                
                XMFMyOrdersListModel *orderModel = self.dataSourceArr[section];
                
                orderModel.orderStatus = @"102";
                
                [orderModel.handleOption setValue:@(NO) forKey:@"cancel"];
                
                [orderModel.handleOption setValue:@(NO) forKey:@"updateAddress"];
                
                [orderModel.handleOption setValue:@(NO) forKey:@"pay"];
                
                [orderModel.handleOption setValue:@(YES) forKey:@"delete"];
                            
                
                //本地刷新组
                
                [UIView performWithoutAnimation:^{
                    
                    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                    [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                
                
            }
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType)}];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}

//用户提醒发货
-(void)getOrderRemain:(NSString *)orderIdStr inSection:(NSInteger)section{
    
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
            XMFMyOrdersListModel *orderModel = self.dataSourceArr[section];
            
            [orderModel.handleOption setValue:@(NO) forKey:@"remind"];
            
            
            //本地刷新组
            
            [UIView performWithoutAnimation:^{
                
                NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            }];
                
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType)}];
             */
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}


//用户发起退款申请
-(void)postOrderRefund:(NSString *)orderIdStr inSection:(NSInteger)section{
    
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
            
            
            XMFMyOrdersListModel *orderModel = self.dataSourceArr[section];
            
            orderModel.orderStatus = @"202";
            
            [orderModel.handleOption setValue:@(NO) forKey:@"refund"];
            
            
            
            //本地刷新组
            
            [UIView performWithoutAnimation:^{
                
                NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType)}];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}

//用户取消退款
-(void)getOrderCancelRefund:(NSString *)orderIdStr inSection:(NSInteger)section{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_cancelRefund parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"用户取消退款：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
            
            XMFMyOrdersListModel *orderModel = self.dataSourceArr[section];
            
            orderModel.orderStatus = @"201";

            
            [orderModel.handleOption setValue:@(NO) forKey:@"cancelRefund"];
            
            [orderModel.handleOption setValue:@(YES) forKey:@"refund"];
            
            [orderModel.handleOption setValue:@(YES) forKey:@"updateAddress"];
            
            
            //本地刷新组
            
            [UIView performWithoutAnimation:^{
                
                NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            }];
                
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType)}];
                
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}

//用户删除订单
-(void)getOrderDeleteOrder:(NSString *)orderIdStr inSection:(NSInteger)section{
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_deleteOrder parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"用户删除订单：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
            
            [self.dataSourceArr removeObjectAtIndex:section];
            
            //防止取消到最后一个不显示无数据的占位
            [self.myTableView ly_startLoading];
            
            [self.myTableView reloadData];
            
            [self.myTableView ly_endLoading];
            
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_MyOrdersListVc_Notice_MyOrdersListVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType)}];
                
                
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}


//修改收货地址
-(void)postOrderUpdateOrderAddress:(NSString *)orderIdStr inSection:(NSInteger)section addressModel:(XMFMyDeliveryAddressModel *)addressModel{
    
    
    NSDictionary *dic = @{
        
        @"addressId":addressModel.addressId,
        @"orderId":orderIdStr,
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_updateOrderAddress parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"修改地址：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
            
            //以下刷新是补充身份信息按钮需要的操作
            XMFMyOrdersListModel *orderModel = self.dataSourceArr[section];
            

            orderModel.oldFlag = NO;
            
            //本地刷新组
            
            [UIView performWithoutAnimation:^{
                
                NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            }];
                
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
}




//去付款
-(void)postOrderPay:(NSString *)orderIdStr inSection:(NSInteger)section{
    
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
//              KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
            
            
            
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

                
                [self payResult:responseMutDic inSection:section viewController:vc];
                
            }];
            
            //               vc.hidesBottomBarWhenPushed = YES;
            
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
            
        }else if (responseObjectModel.code == 504){//绑定手机
            
            [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

            
        }else if(responseObjectModel.code == XMFHttpReturnRestrictedArea){//区域限制发货的状态
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"该地区无货");
            
            [popView.sureBtn setTitle:XMFLI(@"修改地址") forState:UIControlStateNormal];
            
            [popView.cancelBtn setTitle:XMFLI(@"取消订单") forState:UIControlStateNormal];
            
            
            popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                if (button.tag == 0) {//修改地址
                    
                    XMFMyDeliveryAddressController  *VCtrl = [[XMFMyDeliveryAddressController alloc]init];
                    
                    VCtrl.selectedAddressBlock = ^(XMFMyDeliveryAddressModel * _Nonnull addressModel) {
                        
                        [self postOrderUpdateOrderAddress:orderIdStr inSection:section addressModel:addressModel];
                        
                    };
                    
                    
                    [self.navigationController pushViewController:VCtrl animated:YES];
                    
                
                    
                }else if(button.tag == 1){//取消订单
                    
                    
                    XMFCommonPopView *cancelPopView = [XMFCommonPopView XMFLoadFromXIB];
                    
                    cancelPopView.tipsLB.text = XMFLI(@"确认取消订单吗?");
                    
                    cancelPopView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                    
                        if (button.tag == 0) {//确认
                            
                            [self getOrderCancel:orderIdStr inSection:section];
                            
                        }
                        
                    };
                    
                    [cancelPopView show];
                    
                    
                }
                
                
            };
            
            
            [popView show];
            
 
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    
    
    
}


//支付结果
-(void)payResult:(id)responseObject inSection:(NSInteger)section viewController:(ZDPay_OrderSureViewController *)vc{
    
    
    
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
        
        
        if (self.showType == fromPendingPay) {//待付款时，当前页面
            
            if (self.dataSourceArr.count > 0 &&  self.dataSourceArr.count > section) {
                
                [self.dataSourceArr removeObjectAtIndex:section];

            }
            
            
            //防止取消到最后一个不显示无数据的占位
            [self.myTableView ly_startLoading];
            
            [self.myTableView reloadData];
            
            [self.myTableView ly_endLoading];
            
        }else{//全部订单页面
            
            XMFMyOrdersListModel *orderModel = self.dataSourceArr[section];
            
            orderModel.orderStatus = @"201";
            
            //付款和取消按钮不显示
            [orderModel.handleOption setValue:@(NO) forKey:@"pay"];
            
            [orderModel.handleOption setValue:@(NO) forKey:@"cancel"];
            
            //申请退款和修改地址按钮显示
            [orderModel.handleOption setValue:@(YES) forKey:@"refund"];
            [orderModel.handleOption setValue:@(YES) forKey:@"updateAddress"];
            
            
            //本地刷新组
            
            [UIView performWithoutAnimation:^{
                
                NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            }];
            
            
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




#pragma mark - ——————— 懒加载 ————————
-(UITableView *)myTableView{
    
    if (_myTableView == nil) {
    
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        //初始化一个无数据的emptyView 點擊重試
        LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_mine_order_placeholder"
                                                                 titleStr:@""
                                                                detailStr:XMFLI(@"您还没有相关订单")
                                                              btnTitleStr:@""
                                                            btnClickBlock:^{
            
        }];
        
        emptyView.autoShowEmptyView = NO;
        
        //设置无数据样式
        _myTableView.ly_emptyView = emptyView;
        
        kWeakSelf(self)
        
        
        self.cellNum = 5;
        
        _myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakself getNewData];
            
        }];
        
        
        _myTableView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakself getMoreData];
            
            self.cellNum += 5;

            
            [self.myTableView reloadData];
            
            [self.myTableView.mj_footer endRefreshing];
                   
            
        }];
        
    }
    return _myTableView;
    
}


-(NSMutableArray<XMFMyOrdersListModel *> *)dataSourceArr{
    
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
