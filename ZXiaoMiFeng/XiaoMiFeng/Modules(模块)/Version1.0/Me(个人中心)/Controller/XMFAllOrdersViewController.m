//
//  XMFAllOrdersViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAllOrdersViewController.h"
#import "XMFOrdersCell.h"
#import "XMFOrdersHeaderView.h"
#import "XMFOrdersFooterView.h"
#import "XMFOrdersHeaderFooterView.h"//footerview组尾类的view
#import "XMFOrdersCellModel.h"
#import "XMFOrdersDetailController.h"//订单详情
#import "XMFOrdersCommentController.h"//发表评价
#import "XMFOrdersPayModel.h"//去付款的model
#import "XMFOrderPayResultController.h"//支付结果页


@interface XMFAllOrdersViewController ()<UITableViewDelegate,UITableViewDataSource,XMFOrdersFooterViewDelegate,XMFOrdersHeaderFooterViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;


//数据数组
@property (nonatomic, strong) NSMutableArray <XMFOrdersCellModel *>*dataSourceArr;

//当前页码
@property (nonatomic, assign) NSInteger currentPage;

//订单类型
@property (nonatomic, assign) ordersShowType showType;

@end

@implementation XMFAllOrdersViewController


-(instancetype)initWithOrdersShowType:(ordersShowType)showType{
    
    if (self = [super init]) {
        
        self.showType = showType;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupUI];
    
}


-(void)setupUI{
    
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil];
    
    
    [self.view addSubview:self.myTableView];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.edges.equalTo(self.view);
        
    }];
    
    
    //注册组尾view
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrdersHeaderFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([XMFOrdersHeaderFooterView class])];
    
    
    [self getNewData];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - notification

-(void)acceptMsg:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    
    NSInteger type = [userInfo[@"showType"] integerValue];
    
    NSInteger statusType = [userInfo[@"statusType"] integerValue];
    
    /**
     
     备注：当在待收货页面点击确认收货，刷新待评价页面
     self.showType == pendingComment && type == pendingReceipt
     
     */
    
    if ((self.showType == 0 && type != 0) || (self.showType == pendingComment && type == pendingReceipt)) {
        
        //当在其它页面操作时候，只有全部订单列表刷新
        
        [self getNewData];
        
        
    }else if(self.showType != 0 && self.showType == statusType && self.showType != type){
        
       //当在全部订单列表页面操作时候，只有其它对应订单状态的页面刷新
        
        [self getNewData];
        
    }
    
    
    
    /*
    if (self.showType == statusType && self.showType != 0) {
        
        //在全部订单里面操作：只有当showType状态和statusType订单状态相等且不是全部订单页面的时候刷新
        
        
        [self getNewData];
        
    }else if (self.showType != statusType && self.showType == 0){
        
        //在其它订单里面操作：只有当showType状态和statusType订单状态不相等且是全部订单页面的时候刷新
        
         [self getNewData];
    }*/
    
    
}

#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataSourceArr.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    XMFOrdersCellModel *model = self.dataSourceArr[section];
    
    return model.goodsList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrdersCell class]) owner:nil options:nil] firstObject];;
    }
        

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    XMFOrdersCellModel *model = self.dataSourceArr[indexPath.section];
    
    cell.goodListModel = model.goodsList[indexPath.row];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KScaleWidth(79);
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    XMFOrdersHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrdersHeaderView class]) owner:nil options:nil] firstObject];;
    
    headerView.orderModel = self.dataSourceArr[section];
    
    
    return headerView;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 58;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    XMFOrdersHeaderFooterView *footerView = (XMFOrdersHeaderFooterView *)[self.myTableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([XMFOrdersHeaderFooterView class])];
    
    footerView.delegate = self;
    
    [self setModelOfFooterView:footerView atInSection:section];

    
    return footerView;
    
    
    /*
    XMFOrdersFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFOrdersFooterView class]) owner:nil options:nil] firstObject];;
    
    footerView.orderModel = self.dataSourceArr[section];
    
    footerView.sectionNum = section;
    
    footerView.delegate = self;
    
    
    return footerView;
     
     */
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
//    return 58;
    
//    return 83;
    
    kWeakSelf(self)
    
    //组尾的动态高度
    return [self.myTableView fd_heightForHeaderFooterViewWithIdentifier:NSStringFromClass([XMFOrdersHeaderFooterView class]) configuration:^(XMFOrdersHeaderFooterView *headerFooterView) {
        
        [weakself setModelOfFooterView:headerFooterView atInSection:section];
        
        
    }];
    
}


//给footerview赋值
-(void)setModelOfFooterView:(XMFOrdersHeaderFooterView *)footerView atInSection:(NSInteger)section{
    
    footerView.orderModel = self.dataSourceArr[section];
    
    footerView.sectionNum = section;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFOrdersCellModel *model = self.dataSourceArr[indexPath.section];
    
    XMFOrdersDetailController  *VCtrl = [[XMFOrdersDetailController alloc]initWithModel:model];
    
     kWeakSelf(self)
    
    VCtrl.ordersDetailSuccessBlock = ^(NSInteger buttonTag) {
      
        switch (model.statusType) {
            case pendingPay:{//待付款：取消订单和去付款
                
                if (buttonTag == 0) {
                    //去付款
                    
//                    [MBProgressHUD showOnlyTextToView:self.view title:@"去付款"];
                    
                    [self getNewData];
                    
                    
                    
                }else{
                    //取消订单
                    
                    //发送通知是否刷新页面
                    [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(weakself.showType),@"statusType":@(model.statusType)}];
                    
                    
                    if (weakself.showType == pendingPay) {//待付款时，当前页面
                        
                        [weakself.dataSourceArr removeObjectAtIndex:indexPath.section];
                        
                        //防止取消到最后一个不显示无数据的占位
                        [weakself.myTableView ly_startLoading];
                        
                        [weakself.myTableView reloadData];
                        
                        [weakself.myTableView ly_endLoading];
                        
                    }else{//全部订单页面
                        
                        XMFOrdersCellModel *orderModel = weakself.dataSourceArr[indexPath.section];
                        
                        orderModel.orderStatusText = XMFLI(@"已取消");
                        
                    
                         orderModel.handleOption.pay = NO;
                         
                         orderModel.handleOption.cancel = NO;
                         
                         orderModel.handleOption.orderDelete = YES;
                        
                        
                        orderModel.statusType = pendingDelete;
                        
                        //本地刷新组
                        
                        [UIView performWithoutAnimation:^{
                            
                            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
                            [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                        }];
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
            }
                break;
            case pendingDelivery:{//待发货：可以退款
                
                //发送通知是否刷新页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(weakself.showType),@"statusType":@(model.statusType)}];
                
                
                if (weakself.showType == pendingDelivery) {//待发货时
                    
                    [weakself.dataSourceArr removeObjectAtIndex:indexPath.section];
                    
                    //防止取消到最后一个不显示无数据的占位
                    [weakself.myTableView ly_startLoading];
                    
                    [weakself.myTableView reloadData];
                    
                    [weakself.myTableView ly_endLoading];
                    
                    
                    
                }else{//全部订单页面
                    
                    XMFOrdersCellModel *orderModel = weakself.dataSourceArr[indexPath.section];
                    
                    orderModel.orderStatusText = XMFLI(@"已申请退款");
                    
                    orderModel.handleOption.refund = NO;
                    
                    
                    orderModel.statusType = pendingDefault;
                    
                    
                    //本地刷新组
                    
                    [UIView performWithoutAnimation:^{
                        
                        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
                        
                        [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                    
                }
                
     
                
            }
                break;
            case pendingReceipt:{//待收货：确认收货
               
                //发送通知是否刷新页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType),@"statusType":@(model.statusType)}];
                
                
                if (weakself.showType == pendingReceipt) {//待收货时
                    
                    [weakself.dataSourceArr removeObjectAtIndex:indexPath.section];
                    
                    //防止取消到最后一个不显示无数据的占位
                    [weakself.myTableView ly_startLoading];
                    
                    [weakself.myTableView reloadData];
                    
                    [weakself.myTableView ly_endLoading];
                    
                    
                    
                }else{//全部订单页面
                    
                    XMFOrdersCellModel *orderModel = weakself.dataSourceArr[indexPath.section];
                    
                    orderModel.orderStatusText = XMFLI(@"待评价");
                    
                    orderModel.handleOption.confirm = NO;
                    
                    orderModel.handleOption.comment = YES;
                    
                    orderModel.statusType = pendingComment;
                    
                    //本地刷新组
                    
                    [UIView performWithoutAnimation:^{
                        
                        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
                        [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                    
                }
                
  
                
            }
                break;
            case pendingComment:{//待评价：去评价
                
                //发送通知是否刷新页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(weakself.showType),@"statusType":@(model.statusType)}];
                
                
                if (weakself.showType == pendingComment) {//待评价时，当前页面
                    
                    [weakself.dataSourceArr removeObjectAtIndex:indexPath.section];
                    
                    //防止取消到最后一个不显示无数据的占位
                    [weakself.myTableView ly_startLoading];
                    
                    [weakself.myTableView reloadData];
                    
                    [weakself.myTableView ly_endLoading];
                    
                }else{//全部订单页面
                    
                    XMFOrdersCellModel *orderModel = weakself.dataSourceArr[indexPath.section];
                    
                    orderModel.orderStatusText = XMFLI(@"已收货");
                    
                    orderModel.handleOption.comment = NO;
                    
                    orderModel.handleOption.rebuy = YES;
                    
                    orderModel.handleOption.orderDelete = YES;
                    
                    orderModel.statusType = pendingRebuy;
                    
                    //本地刷新组
                    
                    [UIView performWithoutAnimation:^{
                        
                        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:indexPath.section];
                        [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                    
                }
                
                
                
                
            }
                break;
                
            default:
                break;
        }
        
        
        
        
        
        
        
        
        
        
        
    };
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}


#pragma mark - ——————— 网络请求 ————————
-(void)getNewData{

    [self.myTableView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    NSDictionary *dic = @{
        
        @"page":@(self.currentPage),
        
        @"size":@(10),
        
        @"showType":@(self.showType)
        
    };
    
    [self.myTableView ly_startLoading];

    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"类型：%zd 全部订单：%@ ",self.showType,[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObjectModel.data[@"data"];
            
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                DLog(@"数据字典：%@",dic);
                
                XMFOrdersCellModel *model = [XMFOrdersCellModel yy_modelWithDictionary:dic];
                
                if (model.handleOption.pay && model.handleOption.cancel){
                    
                     //待付款
       
                     model.statusType = pendingPay;
                    
                }else if (model.handleOption.refund){
                    
                    //待发货
                     model.statusType = pendingDelivery;
                    
                }else if (model.handleOption.confirm) {
                    
                    //待收货
                    model.statusType = pendingReceipt;
                    
                }else if (model.handleOption.comment){
                    
                    //待评价
                    model.statusType = pendingComment;
                    
                    
                }else if (model.handleOption.rebuy && model.handleOption.orderDelete){
                    //待重买
                    
                    model.statusType = pendingRebuy;
                    
                }else if ([model.orderStatusText isEqualToString:@"缺货"]){
                    //待进货（缺货）
                    model.statusType = pengdingStock;
                    
                    
                }else{//默认，或者全部为false
                    
                     model.statusType = pendingDefault;
                }
                
                
                [self.dataSourceArr addObject:model];
            }
            
          
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        [self.myTableView.mj_header endRefreshing];

        
        [self.myTableView reloadData];
        
        
        [self.myTableView ly_endLoading];
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
         [self.myTableView.mj_header endRefreshing];
        
         [self.myTableView ly_endLoading];
    }];
    
    
}

-(void)getMoreData{
    
    self.currentPage += 1;
    
    NSDictionary *dic = @{
        
        @"page":@(self.currentPage),
        
        @"size":@(10),
        
        @"showType":@(self.showType)
        
    };
      
      
      [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
          
          DLog(@"全部订单%@",[responseObject description]);
          
          if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
              
              NSArray *dataArr = responseObjectModel.data[@"data"];
              
              
              for (NSDictionary *dic in dataArr) {
                  
                  XMFOrdersCellModel *model = [XMFOrdersCellModel yy_modelWithDictionary:dic];
                  
                  
                  if (model.handleOption.pay && model.handleOption.cancel){
                      
                      //待付款
                      
                      model.statusType = pendingPay;
                      
                  }else if (model.handleOption.refund){
                      
                      //待发货
                      model.statusType = pendingDelivery;
                      
                  }else if (model.handleOption.confirm) {
                      
                      //待收货
                      model.statusType = pendingReceipt;
                      
                  }else if (model.handleOption.comment){
                      
                      //待评价
                      model.statusType = pendingComment;
                      
                      
                  }else if (model.handleOption.rebuy && model.handleOption.orderDelete){
                      //待重买
                      
                      model.statusType = pendingRebuy;
                      
                  }else if ([model.orderStatusText isEqualToString:@"缺货"]){
                      //待进货（缺货）
                      model.statusType = pengdingStock;
                      
                      
                  }else{//默认，或者全部为false
                      
                       model.statusType = pendingDefault;
                  }
                
                  
                  [self.dataSourceArr addObject:model];
              }
              
              
              //判断数据是否已经请求完了
              if (dataArr.count < 10) {
                  
                  [self.myTableView.mj_footer endRefreshingWithNoMoreData];
                  
              }else{
                  
                  [self.myTableView.mj_footer endRefreshing];
                  
              }
              
            
              
          }else{
              
              [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
          }
          
          [self.myTableView reloadData];
          
          
          
      } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
          
           [self.myTableView.mj_footer endRefreshing];
         
      }];
    
    
}


//取消订单
-(void)postOrderCancel:(NSString *)orderIdStr inSection:(NSInteger)section ordersStatusType:(ordersStatusType)statusType{
    
    NSDictionary *dic = @{
        
        @"orderId":orderIdStr
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_cancel parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"取消订单：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType),@"statusType":@(statusType)}];
            
            
            if (self.showType == pendingPay) {//待付款时，当前页面
                
                [self.dataSourceArr removeObjectAtIndex:section];
                
                //防止取消到最后一个不显示无数据的占位
                [self.myTableView ly_startLoading];
                
                [self.myTableView reloadData];
                
                [self.myTableView ly_endLoading];
  
            }else{//全部订单页面
                
                XMFOrdersCellModel *orderModel = self.dataSourceArr[section];
                
                orderModel.orderStatusText = XMFLI(@"已取消");
                
                /*
                orderModel.handleOption.pay = NO;
                
                orderModel.handleOption.cancel = NO;
                
                orderModel.handleOption.orderDelete = YES;
                 */
                
                orderModel.statusType = pendingDelete;
                
                //本地刷新组
                
                [UIView performWithoutAnimation:^{
                    
                    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                    [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                
            }
 
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
    
}


//申请退款
-(void)postOrderRefund:(NSString *)orderIdStr inSection:(NSInteger)section ordersStatusType:(ordersStatusType)statusType{
    
    NSDictionary *dic = @{
        
        @"orderId":orderIdStr
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_refund parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"申请退款：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {

            
            [XMFAlertController acWithTitle:XMFLI(@"提交成功") message:XMFLI(@"退款申请成功，我们会在2个工作日内为您办理退款程序，请您保持电话畅通") confirmBtnTitle:XMFLI(@"知道了") confirmAction:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            
            if (self.showType == pendingDelivery) {//待发货时
                
                [self.dataSourceArr removeObjectAtIndex:section];
                
                //防止取消到最后一个不显示无数据的占位
                [self.myTableView ly_startLoading];
                
                [self.myTableView reloadData];
                
                [self.myTableView ly_endLoading];
            
                
                
            }else{//全部订单页面
                
                XMFOrdersCellModel *orderModel = self.dataSourceArr[section];
                
                orderModel.orderStatusText = XMFLI(@"已申请退款");
                
                orderModel.handleOption.refund = NO;
                
                orderModel.statusType = pendingDefault;
                
                
                //本地刷新组
                
                [UIView performWithoutAnimation:^{
                    
                    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                    [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                
            }
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType),@"statusType":@(statusType)}];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
            //防止拣货成功了没有刷新界面
            [self getNewData];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}

//确认收货
-(void)postOrderConfirm:(NSString *)orderIdStr inSection:(NSInteger)section ordersStatusType:(ordersStatusType)statusType{
    
    NSDictionary *dic = @{
        
        @"orderId":orderIdStr
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_confirm parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"确认收货：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {

            if (self.showType == pendingReceipt) {//待收货时
                
                [self.dataSourceArr removeObjectAtIndex:section];
                
                //防止取消到最后一个不显示无数据的占位
                [self.myTableView ly_startLoading];
                
                [self.myTableView reloadData];
                
                [self.myTableView ly_endLoading];
            
                
                
            }else{//全部订单页面
                
                XMFOrdersCellModel *orderModel = self.dataSourceArr[section];
                
                orderModel.orderStatusText = XMFLI(@"待评价");
                
                orderModel.handleOption.confirm = NO;
                
                orderModel.handleOption.comment = NO;
                
                orderModel.statusType = pendingComment;
                
                //本地刷新组
                
                [UIView performWithoutAnimation:^{
                    
                    NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:section];
                    [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                }];
                
                
            }
            
            //发送通知是否刷新页面
            [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(self.showType),@"statusType":@(statusType)}];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
            [self getNewData];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


//去付款
-(void)postOrderPay:(NSString *)orderIdStr inSection:(NSInteger)section ordersStatusType:(ordersStatusType)statusType{
    
    
    NSDictionary *dic = @{
        
        
        @"orderId":orderIdStr
        
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
//                   @"countryCode":payModel.countryCode,
                   @"countryCode":[[XMFGlobalManager getGlobalManager]getCountryCodeStr],
                   @"merchantid":@"merchant.testhk.qtopay.cn.ZDPaySDK",
                   @"payTimeout": @"20200427094403",
                   @"txnTime": @"20200427094403",
                   @"currencyCode":@"HKD",
                   @"BeeMall":payModel.merName,
                   @"AES_Key":payModel.aesKey,
                   @"md5_salt":payModel.md5,
                   @"urlStr":ZDPaySDK_URL,
                   @"associate_domain":Associate_domainLinks,
               };
            
            
 
            [[ZDPay_OrderSureModel sharedSingleten] setModelProcessingDic:dic];
            
            ZDPay_OrderSureViewController *vc = [ZDPay_OrderSureViewController new];
            vc.orderModel = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
                        
            [vc ZDPay_PaymentResultCallbackWithCompletionBlock:^(id  _Nonnull responseObject) {
                
                NSMutableDictionary *responseMutDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                
                [responseMutDic setValue:payModel.txnCurr forKey:@"txnCurr"];
                
                [responseMutDic setValue:payModel.txnAmt forKey:@"txnAmt"];
                
                
                [self payResult:responseMutDic inSection:section viewController:vc];
                
            }];
            
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
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
        
        
        if (self.showType == pendingPay) {//待付款时，当前页面
            
            if (self.dataSourceArr.count > 0 &&  self.dataSourceArr.count < section) {
                
                [self.dataSourceArr removeObjectAtIndex:section];

            }
            
            
            //防止取消到最后一个不显示无数据的占位
            [self.myTableView ly_startLoading];
            
            [self.myTableView reloadData];
            
            [self.myTableView ly_endLoading];
            
        }else{//全部订单页面
            
            XMFOrdersCellModel *orderModel = self.dataSourceArr[section];
            
            orderModel.orderStatusText = XMFLI(@"已付款");
            
             orderModel.handleOption.pay = NO;
             
             orderModel.handleOption.cancel = NO;
             
             orderModel.handleOption.refund = YES;
             
            
            orderModel.statusType = pendingDelivery;
            
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




#pragma mark - ——————— XMFOrdersFooterView的代理方法 ————————
-(void)buttonsOnXMFOrdersFooterViewDidClick:(XMFOrdersFooterView *)footerView button:(UIButton *)button{
    
    static NSTimeInterval time = 0.0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    //限制用户点击按钮的时间间隔大于1秒钟
    
    if (currentTime - time < 0.5) {
        
        //大于这个时间间隔就处理
                   
       return;
        
        
    }
    
    time = currentTime;
    
    
    kWeakSelf(self)

    switch (footerView.orderModel.statusType) {
        case pendingPay:{//待付款
        
            if (button.tag == 0) {
                //去付款

//                [MBProgressHUD showOnlyTextToView:self.view title:@"去付款"];
                
                [self postOrderPay:footerView.orderModel.orderId inSection:footerView.sectionNum ordersStatusType:footerView.orderModel.statusType];
                
                
            }else{
                //取消订单
                
                [XMFAlertController acWithTitle:XMFLI(@"取消订单") msg:XMFLI(@"确定要取消此订单吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"再想想") confirmAction:^(UIAlertAction * _Nonnull action) {
                    
                    [weakself postOrderCancel:footerView.orderModel.orderId inSection:footerView.sectionNum ordersStatusType:footerView.orderModel.statusType];
                    
                }];
                
                
            }
            
            
        }
            break;
        case pendingDelivery:{//待发货
            
            [XMFAlertController acWithTitle:XMFLI(@"退款确认") msg:XMFLI(@"好货不等人，您确定要申请退款吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"再想想") confirmAction:^(UIAlertAction * _Nonnull action) {
                
                [weakself postOrderRefund:footerView.orderModel.orderId inSection:footerView.sectionNum ordersStatusType:footerView.orderModel.statusType];
                
            }];
            
            
            
            
        }
            break;
        case pendingReceipt:{//待收货
            
            [self postOrderConfirm:footerView.orderModel.orderId inSection:footerView.sectionNum ordersStatusType:footerView.orderModel.statusType];
            
        }
            break;
        case pendingComment:{//待评价
            
            XMFOrdersCommentController  *VCtrl = [[XMFOrdersCommentController alloc]initWithModel:footerView.orderModel];
            
            VCtrl.addCommentSuccessBlock = ^{
                
                //发送通知是否刷新页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(weakself.showType),@"statusType":@(footerView.orderModel.statusType)}];
                
                
                if (weakself.showType == pendingComment) {//待评价时，当前页面
                    
                    
                    [weakself.dataSourceArr removeObjectAtIndex:footerView.sectionNum];
                    
                    //防止取消到最后一个不显示无数据的占位
                    [weakself.myTableView ly_startLoading];
                    
                    [weakself.myTableView reloadData];
                    
                    [weakself.myTableView ly_endLoading];
                     
                    
//                    [weakself getNewData];
                    
                }else{//全部订单页面
                    
                    XMFOrdersCellModel *orderModel = weakself.dataSourceArr[footerView.sectionNum];
                    
                    orderModel.orderStatusText = XMFLI(@"已收货");
                    
                    orderModel.handleOption.comment = NO;
                    
                    orderModel.handleOption.rebuy = YES;
                    
                    orderModel.handleOption.orderDelete = YES;
                    
                    //本地刷新组
                    
                    [UIView performWithoutAnimation:^{
                        
                        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:footerView.sectionNum];
                        [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                    
                }
                
                
                
                
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            break;
            
        default:
            break;
    }
    

    
    
}

#pragma mark - ——————— XMFOrdersHeaderFooterView的代理方法 ————————
-(void)buttonsOnXMFOrdersHeaderFooterViewDidClick:(XMFOrdersHeaderFooterView *)footerView button:(UIButton *)button{
    
    static NSTimeInterval time = 0.0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    //限制用户点击按钮的时间间隔大于1秒钟
    
    if (currentTime - time < 0.5) {
        
        //大于这个时间间隔就处理
                   
       return;
        
        
    }
    
    time = currentTime;
    
    
    kWeakSelf(self)

    switch (footerView.orderModel.statusType) {
        case pendingPay:{//待付款
        
            if (button.tag == 0) {
                //去付款

//                [MBProgressHUD showOnlyTextToView:self.view title:@"去付款"];
                
                [self postOrderPay:footerView.orderModel.orderId inSection:footerView.sectionNum ordersStatusType:footerView.orderModel.statusType];
                
                
            }else{
                //取消订单
                
                [XMFAlertController acWithTitle:XMFLI(@"取消订单") msg:XMFLI(@"确定要取消此订单吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"再想想") confirmAction:^(UIAlertAction * _Nonnull action) {
                    
                    [weakself postOrderCancel:footerView.orderModel.orderId inSection:footerView.sectionNum ordersStatusType:footerView.orderModel.statusType];
                    
                }];
                
                
            }
            
            
        }
            break;
        case pendingDelivery:{//待发货
            
            [XMFAlertController acWithTitle:XMFLI(@"退款确认") msg:XMFLI(@"好货不等人，您确定要申请退款吗？") confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"再想想") confirmAction:^(UIAlertAction * _Nonnull action) {
                
                [weakself postOrderRefund:footerView.orderModel.orderId inSection:footerView.sectionNum ordersStatusType:footerView.orderModel.statusType];
                
            }];
            
            
            
            
        }
            break;
        case pendingReceipt:{//待收货
            
            [self postOrderConfirm:footerView.orderModel.orderId inSection:footerView.sectionNum ordersStatusType:footerView.orderModel.statusType];
            
        }
            break;
        case pendingComment:{//待评价
            
            XMFOrdersCommentController  *VCtrl = [[XMFOrdersCommentController alloc]initWithModel:footerView.orderModel];
            
            VCtrl.addCommentSuccessBlock = ^{
                
                //发送通知是否刷新页面
                [[NSNotificationCenter defaultCenter] postNotificationName:KPost_AllOrdersVc_Notice_AllOrdersVc_IsRefresh object:nil userInfo:@{@"showType":@(weakself.showType),@"statusType":@(footerView.orderModel.statusType)}];
                
                
                if (weakself.showType == pendingComment) {//待评价时，当前页面
                    
                    
                    [weakself.dataSourceArr removeObjectAtIndex:footerView.sectionNum];
                    
                    //防止取消到最后一个不显示无数据的占位
                    [weakself.myTableView ly_startLoading];
                    
                    [weakself.myTableView reloadData];
                    
                    [weakself.myTableView ly_endLoading];
                     
                    
//                    [weakself getNewData];
                    
                }else{//全部订单页面
                    
                    XMFOrdersCellModel *orderModel = weakself.dataSourceArr[footerView.sectionNum];
                    
                    orderModel.orderStatusText = XMFLI(@"已收货");
                    
                    orderModel.handleOption.comment = NO;
                    
                    orderModel.handleOption.rebuy = YES;
                    
                    orderModel.handleOption.orderDelete = YES;
                    
                    //本地刷新组
                    
                    [UIView performWithoutAnimation:^{
                        
                        NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:footerView.sectionNum];
                        [weakself.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    
                    
                }
                
                
                
                
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            break;
            
        default:
            break;
    }
    

    
    
}


#pragma mark - ——————— 懒加载 ————————
-(UITableView *)myTableView{
    
    if (_myTableView == nil) {
    
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        //初始化一个无数据的emptyView 點擊重試
        LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_me_wudd"
                                                                 titleStr:@""
                                                                detailStr:XMFLI(@"您还没有相关订单")
                                                              btnTitleStr:@""
                                                            btnClickBlock:^{
            
        }];
        
        emptyView.autoShowEmptyView = NO;
        
        //设置无数据样式
        _myTableView.ly_emptyView = emptyView;
        
        kWeakSelf(self)
        
        _myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakself getNewData];
            
        }];
        
        
        _myTableView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakself getMoreData];
            
        }];
        
    }
    return _myTableView;
    
}



-(NSMutableArray<XMFOrdersCellModel *> *)dataSourceArr{
    
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
