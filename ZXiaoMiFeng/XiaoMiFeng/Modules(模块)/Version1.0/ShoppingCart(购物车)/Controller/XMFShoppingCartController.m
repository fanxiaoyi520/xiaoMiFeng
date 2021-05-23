//
//  XMFShoppingCartController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingCartController.h"
#import "XMFCartHeaderView.h"//组头view
#import "XMFCartCell.h"//cell
#import "XMFShoppingCartModel.h"//购物车model
#import "XMFShoppingCartTotalModel.h"//购物车金额等数量model
#import "XMFShoppingCartGoodModel.h"//购物车商品model
#import "XMFShopCartModel.h"//购物车多层级model
#import "XMFOrderConfirmController.h"//订单确认
#import "XMFGoodsPartPayPopView.h"//商品分开结算提示






@interface XMFShoppingCartController ()<UITableViewDelegate,UITableViewDataSource,XMFCartHeaderViewDelegate,XMFCartCellDelegate,XMFGoodsPartPayPopViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

//底部View
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;


//全选
@property (weak, nonatomic) IBOutlet UIButton *chooseAllBtn;

//合计
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLB;


//结算和删除
@property (weak, nonatomic) IBOutlet UIButton *caculateAndDeleteBtn;

//购物车model
@property (nonatomic, strong) XMFShoppingCartModel *cartModel;

//购物车多层级model
@property (nonatomic, strong) XMFShopCartModel *shopCartModel;

/** 记录选中的cell*/
@property (nonatomic,strong)NSMutableArray *selectedCellArr;

/** 删除block*/
@property (nonatomic, copy) void (^deleteSelectedCell)(void);

/** 编辑的状态*/
@property (nonatomic,assign)BOOL  isEditor;

//选中的商品进行分类
@property (nonatomic, strong) NSMutableArray *selectGoodsPartArr;

//选中商品的数量数组
@property (nonatomic, strong) NSMutableArray *selectGoodsCountArr;

@end

@implementation XMFShoppingCartController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}


-(void)setupUI{
    
    self.topSpace.constant = kNavBarHeight;
    
    self.noneBackNaviTitle = @"购物车";
    
    [self addRightItemWithTitle:@"编辑" selectedTitle:@"完成" action:@selector(rightBtnDidClick:) titleColor:UIColorFromRGB(0x666666)];
    
    //默认隐藏
    self.rightBtn.hidden = YES;
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    kWeakSelf(self)
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_cart_cartplace"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"购物车是空的~")
                                                          btnTitleStr:XMFLI(@"逛一逛")
                                                        btnClickBlock:^{
        
        
        XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
        
        //防止tabbar位置变动，遍历子控制器并选中
        for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
            
            UIViewController *firstVc = navVc.viewControllers[0];
            
            if ([firstVc  isKindOfClass:[XMFHomeViewController class]]) {
                
                NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                
                tabBarVc.selectedIndex = index;
                
            }
            
            
        }
        

    }];
    
    emptyView.autoShowEmptyView = NO;
    
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    
    emptyView.detailLabTextColor = UIColorFromRGB(0x999999);
    
    emptyView.detailLabFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:16.f];
    
    emptyView.detailLabMargin = 10.f;
    
    emptyView.actionBtnCornerRadius = 5.f;
    
    emptyView.actionBtnBackGroundColor = UIColorFromRGB(0xF7CF21);
    
    emptyView.actionBtnFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:18.f];
    
    emptyView.actionBtnTitleColor = UIColorFromRGB(0x333333);
    
    emptyView.actionBtnWidth = 150.f;
    
    emptyView.actionBtnHeight = 44.f;
    
    emptyView.actionBtnMargin = 30.f;
    
    //设置无数据样式
    self.myTableView.ly_emptyView = emptyView;
    
//    self.view.ly_emptyView = emptyView;
    
    //防止跳动
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;
    
    self.myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [weakself getGoodscount];
        
        [weakself getCartIndex];
        
    }];
    
    [self getGoodscount];
    
    [self getCartIndex];
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingCart) name:KPost_HomeSonVc_Notice_ShoppingcartVc_Refresh object:nil];
    
    //接收登录状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - ——————— 通知的方法 ————————
-(void)refreshShoppingCart{
    
    
    [self getGoodscount];
    
    [self getCartIndex];
    
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    
    BOOL loginSuccess = [notification.object boolValue];
    
    
    if (loginSuccess) {
        
        [self getGoodscount];
        
        [self getCartIndex];
        
    }else{
       
        self.shopCartModel = nil;
        
        [self.myTableView ly_startLoading];
        
        [self.myTableView reloadData];
        
        [self.myTableView ly_endLoading];
        
        self.bottomView.hidden = YES;
        
        self.bottomViewHeight.constant = 0.f;
        
        self.rightBtn.hidden = YES;
        
        
        
        XMFBaseUseingTabarController *tabBarVC = (XMFBaseUseingTabarController *)self.tabBarController;
        //            AxcAE_TabBarItem *item = tabBarVC.axcTabBar.currentSelectItem; // 因为已经到这个页面，说明就是当前的选项卡item
        AxcAE_TabBarItem *item = tabBarVC.axcTabBar.tabBarItems[GlobalManager.getShoppingCartIndex];
        // 为0是否自动隐藏
        item.badgeLabel.automaticHidden = YES;
        
        item.badge = @"";
        
    }
    
    
}

#pragma mark - ——————— 网络请求 ————————
//购物车商品总数
-(void)getGoodscount{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_cart_goodscount parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物车商品总数：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
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
            
            [MBProgressHUD showOnlyTextToView:self.view title:responseObjectModel.kerrmsg];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


//购物车查询
-(void)getCartIndex{
    
    
    [self.myTableView ly_startLoading];
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_cart_index parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"购物车：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
    
        [self.selectedCellArr removeAllObjects];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
            //重新对数据进行编排
            
            NSMutableDictionary *dataMutableDic = [NSMutableDictionary dictionaryWithDictionary:responseObjectModel.data];
            
            
            NSMutableArray *cartListArr = [NSMutableArray arrayWithArray:dataMutableDic[@"cartList"]];
            
            NSMutableArray *newCartList = [[NSMutableArray alloc]init];
            
            for (int i = 0; i < cartListArr.count; i ++) {
                
                
                NSDictionary *dicFori = cartListArr[i];
                
                NSMutableArray *tempArray = [@[] mutableCopy];

                [tempArray addObject:dicFori];
                
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
                
                
                for (int j = i+1; j < cartListArr.count; j ++) {
                    
                    
                    NSDictionary *dicForj = cartListArr[j];
                    
                    //获取地区
                    NSString *regionForj = [NSString stringWithFormat:@"%@",dicForj[@"shipmentRegion"]];
                    
                    NSString *regionFori = [NSString stringWithFormat:@"%@",dicFori[@"shipmentRegion"]];
                    
                    //根据地区相同进行分组
                    if([regionFori isEqualToString:regionForj]){
                        
                        //设置地区
                        [tempDic setValue:regionForj forKey:@"shipmentRegion"];
                        
                        [tempArray addObject:dicForj];
                        
                        [cartListArr removeObjectAtIndex:j];
                        j -= 1;
                        
                        
                    }
                    
                }

                [tempDic setValue:tempArray forKey:@"cartMiddleList"];

                [newCartList addObject:tempDic];
                
//                [newCartList addObject:tempArray];
                
            }
 
            
            [dataMutableDic setValue:newCartList forKey:@"cartNewList"];
            
            
            self.shopCartModel = [XMFShopCartModel yy_modelWithDictionary:dataMutableDic];
            
            [self.myTableView reloadData];
            
            //保存选中的商品
            [self getSelectedGoods];
            

            //计算价格
            [self caculateTotalMoney];
            

            
        }else{
            
            [MBProgressHUD showOnlyTextToView:self.view title:responseObjectModel.kerrmsg];
            
        }
        
        [self.myTableView.mj_header endRefreshing];
        
        [self.myTableView ly_endLoading];
        
        //显示占位与否
        if (self.shopCartModel.cartNewList.count == 0) {
            
//            [self.view ly_showEmptyView];
            
            self.bottomView.hidden = YES;
            
            self.bottomViewHeight.constant = 0.f;
            
            self.rightBtn.hidden = YES;

            
            
        }else{
            
//            [self.view ly_hideEmptyView];
            
            self.bottomView.hidden = NO;
            
            self.bottomViewHeight.constant = 44.f;
            
            self.rightBtn.hidden = NO;

            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myTableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [self.myTableView ly_endLoading];
        
        //显示占位与否
        if (self.shopCartModel.cartNewList.count == 0) {
            
            //            [self.view ly_showEmptyView];
            
            self.bottomView.hidden = YES;
            
            self.bottomViewHeight.constant = 0.f;
            
            self.rightBtn.hidden = YES;
            
        }else{
            
            //            [self.view ly_hideEmptyView];
            
            self.bottomView.hidden = NO;
            
            self.bottomViewHeight.constant = 44.f;
            
            self.rightBtn.hidden = NO;
            
        }
        
    }];
    
 
    
}



//选中/取消选中购物清单
-(void)getChooseOrCancelGoods:(XMFCartCell *)cell{
    
    //注意isChecked这里需要上传与现在情况相反的
    NSDictionary *dic = @{
        
        @"isChecked":[NSString stringWithFormat:@"%@",cell.detailModel.isChoose ? @"0":@"1"],
        
        @"productIds":@[cell.detailModel.productId]
        
        
    };
    
    
    [MBProgressHUD showLoadToView:self.view title:XMFLI(@"加载中...")];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_checked parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"选中/取消选中购物清单：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            [self chooseOrCancelShopCartGood:cell];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
    
    
    
}

//全选的：选中/取消选中购物清单
-(void)getSelecteALLChooseOrCancelGoods:(XMFShopCartDetailModel *)detailModel isSelected:(BOOL)isSelected{
    
    //注意isChecked这里需要上传与现在情况相反的
    NSDictionary *dic = @{
        
        @"isChecked":@(isSelected),
        
        @"productIds":@[detailModel.productId]
        
        
    };
    
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_checked parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"全选的：选中/取消选中购物清单：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
    
    
    
}


//删除购物车商品
-(void)getDeleteShopCartGoods{
    
    //获取选中的商品id
    NSMutableArray *selectedCellIdArr = [[NSMutableArray alloc]init];
    
    for (XMFShopCartDetailModel *detailModel in self.selectedCellArr) {
        
        [selectedCellIdArr addObject:detailModel.productId];
        
    }
    
    
    
    NSDictionary *dict = @{
        
        @"productIds":selectedCellIdArr
        
    };
    
    [MBProgressHUD showLoadToView:self.view title:XMFLI(@"删除中...")];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_delete parameters:dict success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"删除商品：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
            //把选中删除的数据从本地数据中也删除
            for (XMFShopCartMiddleModel *middleModel in self.shopCartModel.cartNewList) {
                
                
                for (XMFShopCartDetailModel *detailModel in self.selectedCellArr) {
                    
                    BOOL isContain = [middleModel.cartMiddleList containsObject:detailModel];
                    
                    //如果包含就删除
                    if (isContain) [middleModel.cartMiddleList removeObject:detailModel];
                    
                }
                
            }
            
            
            
            //删除本地记录的数据
            if (self.deleteSelectedCell) {
                
            
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    self.deleteSelectedCell();
                    
                    [MBProgressHUD hideHUDForView:self.view];
                    
                    //显示占位与否
                    if (self.shopCartModel.cartNewList.count == 0) {
                        
                        self.bottomView.hidden = YES;
                        
                        self.bottomViewHeight.constant = 0.f;
                        
                        self.rightBtn.hidden = YES;
                        
                        //删除没有数据的时候右上角按钮恢复编辑
                        [self rightBtnDidClick:self.rightBtn];
                        
                    }else{
                        
                        
                        self.bottomView.hidden = NO;
                        
                        self.bottomViewHeight.constant = 44.f;
                        
                        self.rightBtn.hidden = NO;
                    
                        
                    }
                    
                    [self.myTableView ly_startLoading];
                
                    [self.myTableView reloadData];
                    
                    [self.myTableView ly_endLoading];
                    
                });
            }
            
            
            //清空选中的数据
            [self.selectedCellArr removeAllObjects];
            
            //计算价格
            [self caculateTotalMoney];
            
            //获取购物车商品总数
            [self getGoodscount];
            
            //通知首页的子商品列表进行刷新
            KPostNotification(KPost_CartVc_Notice_HomeSonVc_Refesh, nil, nil);
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view];
            
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
         [MBProgressHUD hideHUDForView:self.view];
        
    }];
    
    
}

//修改购物车商品
-(void)updateShopCart:(XMFCartCell *)cell isAdd:(BOOL)isAdd{
    
    
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    
    //刷新添加的商品
    XMFShopCartDetailModel *detailModel = self.shopCartModel.cartNewList[indexPath.section].cartMiddleList[indexPath.row];
    
    NSString *goodsNumber;
    
    if (isAdd) {
        
        goodsNumber = [NSString stringWithFormat:@"%zd",[detailModel.number integerValue] + 1];
        
        //最多5个
        if ([goodsNumber integerValue] > [detailModel.limitBuyNum integerValue]){
            
            [MBProgressHUD showOnlyTextToView:self.view title:[NSString stringWithFormat:@"亲，该商品订单单笔限购%@件",detailModel.limitBuyNum]];
            
            return;
        }
        
        
        
    }else{
        
        goodsNumber = [NSString stringWithFormat:@"%zd",[detailModel.number integerValue] - 1];
        
        
        if ([goodsNumber integerValue] <= 0){
                        
            [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"亲,实在不能再少了")];
            
            return;
        }
        
    }
    

    
    
    //获取角标

    XMFBaseUseingTabarController *tabBarVC = (XMFBaseUseingTabarController *)self.tabBarController;
    AxcAE_TabBarItem *item = tabBarVC.axcTabBar.currentSelectItem; // 因为已经到这个页面，说明就是当前的选项卡item
    // 为0是否自动隐藏
    item.badgeLabel.automaticHidden = YES;
    
    __block  NSInteger  badgeValueNum = [item.badge integerValue];
    
    
    NSDictionary *dic = @{
        
        @"productId":cell.detailModel.productId,
        
        @"goodsId":cell.detailModel.goodsId,
        
        @"number":goodsNumber,
        
        @"id":cell.detailModel.cartId
        
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_update parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
       
        
        DLog(@"修改购物车商品数量：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            detailModel.number = goodsNumber;
           
            
            [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            //设置角标
            if (isAdd) {
               
                badgeValueNum++;
                
                item.badge = [NSString stringWithFormat:@"%zd",badgeValueNum];
                
                
            }else{
               
                badgeValueNum--;
                
                if (badgeValueNum <= 0) {
                    
                    badgeValueNum = 0;
                    
                    item.badge = @"";
                    
                    
                }else{
                    
                    
                    item.badge = [NSString stringWithFormat:@"%zd",badgeValueNum];;
    
                    
                }
                
                
            }
            
            //如果是选中的才重新计算价格
            if (detailModel.isChoose) {
                
                [self caculateTotalMoney];
            }
            
            //通知首页的子商品列表进行刷新
            KPostNotification(KPost_CartVc_Notice_HomeSonVc_Refesh, nil, nil);
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
    
}


//先请求订单确认页面接口防止商品异常
-(void)getOrderConfirmInfo{

    
    NSDictionary *dic =@{
        
        @"cartId":@"0",
        @"addressId":@"0",
        @"couponId":@"0",
        @"grouponRulesId":@"0"
        
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_cart_checkout parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"订单确认：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            XMFOrderConfirmController  *VCtrl = [[XMFOrderConfirmController alloc]initWithCartId:@"0"];
            
            //支付回调
            VCtrl.cartPayBlock = ^{
              
                [self getGoodscount];
                
                [self getCartIndex];
                
            };
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }else if (responseObjectModel.kerrno == 504){//绑定手机
            
            [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
            //异常的时候刷新界面
            [self getGoodscount];
            
            [self getCartIndex];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
    }];
    
    
    
}



#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.shopCartModel.cartNewList.count;
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    XMFShopCartMiddleModel *middleModel = [self.shopCartModel.cartNewList objectAtIndex:section];
    
    return middleModel.cartMiddleList.count;
    
//    return self.cartModel.cartList.count;
    
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFCartCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFCartCell class]) owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    
    
    XMFShopCartMiddleModel *middleModel = [self.shopCartModel.cartNewList objectAtIndex:indexPath.section];
    
    XMFShopCartDetailModel *detailModel = middleModel.cartMiddleList[indexPath.row];
    
    cell.detailModel = detailModel;

    cell.middleModel = middleModel;
    
    cell.cartModel = self.shopCartModel;
    
    
//    cell.model = self.cartModel.cartList[indexPath.row];
    
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    XMFCartHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFCartHeaderView class]) owner:nil options:nil] firstObject];
    
    headerView.section = section;
    
    headerView.delegate = self;
    
     XMFShopCartMiddleModel *middleModel = [self.shopCartModel.cartNewList objectAtIndex:section];
    
    //不知什么原因暂时没能成功解析到地区，在请求数据的时候已经赋值
    middleModel.shipmentRegion = [middleModel.cartMiddleList firstObject].shipmentRegion;
    
    headerView.middleModel = middleModel;
   
    
    return headerView;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 55;
    
    
}


//UITableview处理section的不悬浮一起滚动，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 55;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - ——————— XMFCartCell的代理方法 ————————
-(void)buttonsOnXMFCartCellDidClick:(XMFCartCell *)cell button:(UIButton *)button{
    
    switch (button.tag) {
        case 0:{//选择
            
            [self.selectedCellArr removeAllObjects];
            
            [self getChooseOrCancelGoods:cell];
            
            
        }
            break;
        case 1:{//减
            
            [self updateShopCart:cell isAdd:NO];
            
        }
            break;
        case 2:{//加
            
//            [self getGoodsDetail:cell];
 
            [self updateShopCart:cell isAdd:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


//选中或者取消商品选择
-(void)chooseOrCancelShopCartGood:(XMFCartCell *)cell{
    
    
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    
    
    /** cell 的 section*/
    NSInteger section = indexPath.section;
    
    //  cDmodel.isChoose = !cDmodel.isChoose;
    
      XMFShopCartMiddleModel *middleModel = self.shopCartModel.cartNewList[section];
    
    
     XMFShopCartDetailModel *detailModel = middleModel.cartMiddleList[indexPath.row];
    
    
    //先判断section，然后再判断row
    if (middleModel.isChoose) {
        
        /** 如果之前区头是选中的*/
        
        BOOL isContain = [middleModel.recordCdModelSelected containsObject:detailModel];
        
        if (isContain) [middleModel.recordCdModelSelected removeObject:detailModel];
        
    }
    
    //判断row是否是选中的
    if (!detailModel.isChoose) {
        
        detailModel.isChoose = YES;
        
        BOOL isContain = [middleModel.recordCdModelSelected containsObject:detailModel];
        
        if (!isContain){
            
            [middleModel.recordCdModelSelected addObject:detailModel];
            
        }
        
    }else{
        
        detailModel.isChoose = NO;
        
        [middleModel.recordCdModelSelected removeObject:detailModel];
        
    }
    
    BOOL isEqual = middleModel.recordCdModelSelected.count == middleModel.cartMiddleList.count;
    //判断一个区的cell是否全部选中，如果全选，则让属于该cell的区头也选中
    if (isEqual) {
        
        [self ShoppingCarHeaderViewChooseBtnDidClickSection:section];
        
        //判断是否全选
        [self addModel:middleModel JudgeSectionSelectedAll:self.shopCartModel.recordArr isChoose:isEqual];
        
        
    }else{
        
        //否则，区头就没有选中
        middleModel.isChoose = NO;
        
        //判断是否全选
        [self addModel:middleModel JudgeSectionSelectedAll:self.shopCartModel.recordArr isChoose:isEqual];
    }
    
    
    //计算总价格
    [self caculateTotalMoney];
    
    [self.myTableView reloadData];
    
    
    
    
}

#pragma mark - ——————— XMFCartHeaderView的代理方法 ————————
-(void)buttonsOnXMFCartHeaderViewDidClick:(XMFCartHeaderView *)headerView button:(UIButton *)button section:(NSInteger)section{
    
    kWeakSelf(self)
    
    switch (button.tag) {
        case 0:{//组头选择
            
//            button.selected = !button.selected;
            
            
            //清空所有选中的
//            [self.selectedCellArr removeAllObjects];

            [self ShoppingCarHeaderViewChooseBtnDidClickSection:section];
            
            
            /*
            XMFShopCartMiddleModel *middleModel = self.shopCartModel.cartNewList[section];
            
            //循环遍历进行商品的选中与取消选中
            [middleModel.cartMiddleList enumerateObjectsUsingBlock:^(XMFShopCartDetailModel  *_Nonnull detailModel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                
                [weakself getSelecteALLChooseOrCancelGoods:detailModel isSelected:button.selected];
                
            }];*/
            
            
           
            
        }
            break;
            
        case 1:{//更多
                
                
        }
            break;
            
        default:
            break;
    }
    
    
}


//组头里面的选择按钮被点击
-(void)ShoppingCarHeaderViewChooseBtnDidClickSection:(NSInteger)section{
    
    XMFShopCartMiddleModel *middleModel = self.shopCartModel.cartNewList[section];
       
       // 区  是否全选
       [self addOrRemoveModel:middleModel isChoose:!middleModel.isChoose];
       
       //所有cell是否  全选
       [self addModel:middleModel JudgeSectionSelectedAll:self.shopCartModel.recordArr isChoose:!middleModel.isChoose];
       
       //反选
       middleModel.isChoose = !middleModel.isChoose;

       /** 计算总价格*/
       [self caculateTotalMoney];
       
       [self.myTableView reloadData];
    
    
    
}


// 区  选中 (区选中--->区中的cell全部选中)
-(void)addOrRemoveModel:(XMFShopCartMiddleModel *)middleModel isChoose:(BOOL)isChoose{
    
    kWeakSelf(self)
    
    if (isChoose) {
        
        //区中的所有cell都选中
        [middleModel.cartMiddleList enumerateObjectsUsingBlock:^(XMFShopCartDetailModel  *_Nonnull detailModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            /** 所有的cell选中*/
            detailModel.isChoose = YES;
            
            BOOL isContain = [middleModel.recordCdModelSelected containsObject:detailModel];
            
            if (!isContain) [middleModel.recordCdModelSelected addObject:detailModel];
            
            //对每个商品进行选中接口请求
            [weakself getSelecteALLChooseOrCancelGoods:detailModel isSelected:YES];

        }];
        
        
        
    }else{
        
        [middleModel.cartMiddleList enumerateObjectsUsingBlock:^(XMFShopCartDetailModel  *_Nonnull detailModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            detailModel.isChoose = NO;
            
            [middleModel.recordCdModelSelected removeObject:detailModel];
            
            //对每个商品进行取消选中接口请求
            [weakself getSelecteALLChooseOrCancelGoods:detailModel isSelected:NO];
            
        }];
        
       
    }
    

    
}

//选中section，或者单个选择中row，cell是否已经全部选中
-(void)addModel:(XMFShopCartMiddleModel *)middleModel JudgeSectionSelectedAll:(NSMutableArray *)recodArr isChoose:(BOOL)isChoose{
    
    BOOL isContain = [recodArr containsObject:middleModel];
    
    if (isChoose) {
        
        if (!isContain)  [recodArr addObject:middleModel];
        
    }else{
        
        if (isContain) [recodArr removeObject:middleModel];
    }
    
    
}

/** 计算总价*/
-(void)caculateTotalMoney{
    
    
    
    // 循环遍历  将所有选中的cell 添加到数组中
       for (XMFShopCartMiddleModel *middleModel in self.shopCartModel.cartNewList) {
           
           
           [middleModel.cartMiddleList enumerateObjectsUsingBlock:^(XMFShopCartDetailModel  *_Nonnull detailModel, NSUInteger idx, BOOL * _Nonnull stop) {
               
               
                BOOL isContain = [self.selectedCellArr containsObject:detailModel];
               
               //所有选中的cell
               if (detailModel.isChoose) {
                   
                   
                   if (!isContain) [self.selectedCellArr addObject:detailModel];
                   
               }else{
                   
                   //没有选中的，如果包含就删除
                   if (isContain) [self.selectedCellArr removeObject:detailModel];
                   
               }
               
           }];
           
       }
       
       double sum = 0;
       double value = 0 ;

       
       for (XMFShopCartDetailModel *detailModel  in self.selectedCellArr) {
           
           value = [detailModel.price doubleValue]*[detailModel.number integerValue];
           
            //taxFlag:是否包税，1包含，0不包含
           if (![detailModel.taxFlag boolValue]) {
               
            value = value + [detailModel.taxes doubleValue]*[detailModel.number integerValue];
               
           }
           
           
           DLog(@"物品价格：%@",detailModel.price);
           
           DLog(@"物品数量：%@",detailModel.number);
           
           DLog(@"物品合计价格：%f",value);
           
           sum = sum+value;
       }
    
    
      NSString *sumStr =  [NSString stringWithFormat:@"%f",sum];
       
//       self.totalMoneyLB.text = [NSString stringWithFormat:@"合计：HK$%@",[NSString removeSuffix:sumStr]];
    
    NSMutableAttributedString *totalMoneyStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:UIColorFromRGB(0xFB4D44) upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:13.f] lowerStr:[NSString removeSuffix:sumStr] lowerColor:UIColorFromRGB(0xFB4D44) lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18.f]];
    
    
    NSMutableAttributedString *allTotalMoneyStr = [[NSMutableAttributedString alloc]initWithString:@"合计："];
    
    [allTotalMoneyStr appendAttributedString:totalMoneyStr];
    
    
    self.totalMoneyLB.attributedText = allTotalMoneyStr;
      
    
       
       if (self.shopCartModel.recordArr.count == self.shopCartModel.cartNewList.count) {
           
           DLog(@"全选");
           
           [self confirmSelectedAllCell];
           
       }else{
           
           DLog(@"没有全选");
           
           [self confirmSelectedSingleOrMoreCell];
       }
    
    
    //结算按钮显示选中的数量
    if (!self.isEditor) {
        

    
        //没有选中就置灰
        if (self.selectedCellArr.count == 0) {
            
            [self.caculateAndDeleteBtn setTitle:XMFLI(@"去结算") forState:UIControlStateNormal];
            
            self.caculateAndDeleteBtn.enabled = NO;
            
            self.caculateAndDeleteBtn.backgroundColor = UIColorFromRGB(0xcccccc);
            
        }else{
            
            
            NSInteger goodsSumNum = 0;
            
            for (XMFShopCartDetailModel *detailModel in self.selectedCellArr) {
                
                goodsSumNum += [detailModel.number integerValue];
                
            }
            
            [self.caculateAndDeleteBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",goodsSumNum] forState:UIControlStateNormal];
            
            self.caculateAndDeleteBtn.enabled = YES;
            
            self.caculateAndDeleteBtn.backgroundColor = UIColorFromRGB(0xFB4D44);
        }

    
    }else{
        
        
         [self.caculateAndDeleteBtn setTitle:XMFLI(@"删除") forState:UIControlStateNormal];
        
        self.caculateAndDeleteBtn.enabled = YES;
        
        self.caculateAndDeleteBtn.backgroundColor = UIColorFromRGB(0xFB4D44);
        
        
    }
    
    
       
       //删除
    __weak XMFShoppingCartController *vc = self;
       
       self.deleteSelectedCell = ^{
           

           for (XMFShopCartMiddleModel *middleModel in vc.shopCartModel.cartNewList) {
               
               [middleModel.cartMiddleList removeObjectsInArray:middleModel.recordCdModelSelected];
               
            
               //下次刷新之前，移除之前的数据
               [middleModel.recordCdModelSelected removeAllObjects];
               
               
           }
           
           [vc.shopCartModel.cartNewList removeObjectsInArray:vc.shopCartModel.recordArr];
           
           //下次刷新之前，移除之前的数据
           [vc.shopCartModel.recordArr removeAllObjects];
           
       };
 
    
}

/** 全选*/
-(void)confirmSelectedAllCell{
    /*
    [self.chooseAllBtn setTitle:@" 全选" forState:UIControlStateNormal];
    [self.chooseAllBtn setImage:[UIImage imageNamed:@"icon_cart_seletcted"] forState:UIControlStateNormal];
    self.chooseAllBtn.selected = YES;
     */
    
    self.chooseAllBtn.selected = YES;
    
    
}

/** 取消全选*/
-(void)confirmSelectedSingleOrMoreCell{
    /*
    [self.chooseAllBtn setTitle:@" 全选" forState:UIControlStateNormal];
    [self.chooseAllBtn setImage:[UIImage imageNamed:@"icon_cart_seletct"] forState:UIControlStateNormal];
    self.chooseAllBtn.selected = NO;
     */
    
    self.chooseAllBtn.selected = NO;
    
    
}


//获取初始化接口返回来数据时候的选中的model赋值给self.shopCartModel进行保存
-(void)getSelectedGoods{
    
    
    //获取选中的model
    for (XMFShopCartMiddleModel *middleModel in self.shopCartModel.cartNewList) {
        
        
        for (XMFShopCartDetailModel *detailModel in middleModel.cartMiddleList) {
            
            
            //判断row是否是选中的
            if (detailModel.isChoose) {
                
                
                BOOL isContain = [middleModel.recordCdModelSelected containsObject:detailModel];
                
                if (!isContain){
                    
                    [middleModel.recordCdModelSelected addObject:detailModel];
                    
                }
                
            }
            
            BOOL isEqual = middleModel.recordCdModelSelected.count == middleModel.cartMiddleList.count;
            //判断一个区的cell是否全部选中，如果全选，则让属于该cell的区头也选中
            if (isEqual) {
                
                
                //判断是否全选
                [self addModel:middleModel JudgeSectionSelectedAll:self.shopCartModel.recordArr isChoose:isEqual];
                
                
            }else{
                
                //否则，区头就没有选中
                middleModel.isChoose = NO;
                
                //判断是否全选
                [self addModel:middleModel JudgeSectionSelectedAll:self.shopCartModel.recordArr isChoose:isEqual];
            }
            
            
        }
        
        
    }
    
}

#pragma mark - ——————— 顶部右上角 - 编辑、完成 ————————

//右边按钮绑定的方法
-(void)rightBtnDidClick:(UIButton *)button{
    
//    button.selected = !button.selected;
    
    if (!self.isEditor) {
        
        [self.caculateAndDeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        
        self.isEditor = YES;
        
                
        
    }else{
        
        
//        [self.caculateAndDeleteBtn setTitle:@"结算" forState:UIControlStateNormal];
        
        NSInteger goodsSumNum = 0;
        
        for (XMFShopCartDetailModel *detailModel in self.selectedCellArr) {
            
            goodsSumNum += [detailModel.number integerValue];
            
        }
        
        [self.caculateAndDeleteBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",goodsSumNum] forState:UIControlStateNormal];
 
        
        self.isEditor = NO;
    }
    
    
    button.selected = self.isEditor;
    
    //删除的时候不显示合计价格
    self.totalMoneyLB.hidden = self.isEditor;

   
    [self.myTableView reloadData];
}


#pragma mark - ——————— 按钮拖线方法 ————————

- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (sender.tag) {
            
        case 0:{//全选
            
            sender.selected = !sender.selected;

            
            //所有的区数
            NSInteger count =  self.shopCartModel.cartNewList.count;
            
            if (sender.selected) {
                
                //遍历所有的区头，让区头选中
                for (int i = 0; i<count; i++) {
                    
                    XMFShopCartMiddleModel *middleModel = self.shopCartModel.cartNewList[i];
                  
                    middleModel.isChoose = NO;
                  
                    [self ShoppingCarHeaderViewChooseBtnDidClickSection:i];
                }
                
            }else{
                
                for (int i = 0; i<count; i++) {
                    
                    XMFShopCartMiddleModel *middleModel = self.shopCartModel.cartNewList[i];
                   
                    middleModel.isChoose = YES;
                   
                    [self ShoppingCarHeaderViewChooseBtnDidClickSection:i];
                }
            }
            
            
            [self.myTableView reloadData];
            
        
 
            // 循环遍历  将所有选中的cell 添加到数组中
            for (XMFShopCartMiddleModel *middleModel in self.shopCartModel.cartNewList) {
                
                //循环遍历进行商品的选中与取消选中
                [middleModel.cartMiddleList enumerateObjectsUsingBlock:^(XMFShopCartDetailModel  *_Nonnull detailModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    
                    //本地修改商品的选中与否
                    detailModel.isChoose = sender.selected;
                    
                    
                    [weakself getSelecteALLChooseOrCancelGoods:detailModel isSelected:sender.selected];
                    
                }];
                
            }
            
           
            //把以前选中的商品全部清除
            [self.selectedCellArr removeAllObjects];
            
            [self caculateTotalMoney];
            
        }
            
            break;
            
        case 1:{//结算和删除
            
            if (self.selectedCellArr.count == 0) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请选择商品")];
                
                return;
            }
            
            
            if ([sender.titleLabel.text isEqualToString:@"删除"]) {
                
                
                //删除
                
                [XMFAlertController acWithTitle:XMFLI(@"提示") msg:[NSString stringWithFormat:@"确定要删除这%zd种商品吗？",self.selectedCellArr.count] confirmBtnTitle:XMFLI(@"确定") cancleBtnTitle:XMFLI(@"取消") confirmAction:^(UIAlertAction * _Nonnull action) {
                    
                     [weakself getDeleteShopCartGoods];
                    
                }];
                
 

            }else{

                DLog(@"结算");
                
                //切记只能复制一份出去而非赋值出去
                NSMutableArray *selectedCellTempArr = [self.selectedCellArr mutableCopy];
                
                [self.selectGoodsPartArr removeAllObjects];
                
                [self.selectGoodsCountArr removeAllObjects];
    
                
                //第一层
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    DLog("开始");
                    
                    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

                    //对选中的不同地区数据进行分类
                    for (int i = 0; i < selectedCellTempArr.count; i ++) {
                        
                        
                        XMFShopCartDetailModel *detailModeli = selectedCellTempArr[i];
                        
                        NSMutableArray *tempArray = [@[] mutableCopy];
                        
                        [tempArray addObject:detailModeli];
                    
                        
                        //数量
                       __block NSInteger goodsCount = [detailModeli.number integerValue];
                        
                        
                        
                        //第二层
                        dispatch_async(dispatch_get_global_queue(0, 0), ^{
                            
                         dispatch_semaphore_t sema2 = dispatch_semaphore_create(0);

                            for (int j = i+1; j < selectedCellTempArr.count; j ++) {
                                
                                XMFShopCartDetailModel *detailModelj = selectedCellTempArr[j];
                                
                                NSString *regionFori = detailModeli.shipmentRegion;
                                
                                NSString *regionForj = detailModelj.shipmentRegion;
                                
                                //根据地区相同进行分组
                                if([regionFori isEqualToString:regionForj]){
                                    
                                    
                                    [tempArray addObject:detailModelj];
                                    
                                    goodsCount += [detailModelj.number integerValue];
                                    
                                    [selectedCellTempArr removeObjectAtIndex:j];
                                    
                                    j -= 1;
                                 
                                    
                                }
                                
                                
                                dispatch_semaphore_signal(sema2);
                                
                                
                                 dispatch_semaphore_wait(sema2, DISPATCH_TIME_FOREVER);
                                
                            }
                            
                            
                            dispatch_semaphore_signal(sema);
                            
                            
                        });
                        
                        
                         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
                        
                        [self.selectGoodsPartArr addObject:tempArray];
                        
                        //商品数量
                        [self.selectGoodsCountArr addObject:@(goodsCount)];
                    
                    }

                    
                    DLog(@"结束");
                    
                    //回到主线程弹出提示框
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        //当只有一种类型的时候就直接跳转，如果有多种类型的时候就弹框提示
                        if (self.selectGoodsPartArr.count == 1) {
                            
                             [self getOrderConfirmInfo];
                            
                        }else{
                            
                            XMFGoodsPartPayPopView *popView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsPartPayPopView class]) owner:nil options:nil] firstObject];
                            
                            popView.selectedGoodsCountArr = [self.selectGoodsCountArr mutableCopy];
                            
                            popView.selectedGoodsArr = [self.selectGoodsPartArr mutableCopy];
                            
                            popView.delegate = self;
                            
                            
                            [popView show];
                            
                        }


                    });
                    
                    
                });
                
                
                
               
                
                
                

 
                
//                [self getOrderConfirmInfo];
            
                
            }
                
            
    
                
        }
                
            break;
            
        default:
            break;
    }
    
}


#pragma mark - ——————— XMFGoodsPartPayPopView的代理方法 ————————
-(void)buttonsOnXMFGoodsPartPayPopViewDidClick:(XMFGoodsPartPayPopView *)popView selectedButton:(UIButton *)button{
    
    //把选中商品model在选中的数组里面删掉
    [self.selectedCellArr removeObjectsInArray:self.selectGoodsPartArr[button.tag]];
    
    //把没有选中的商品model重置为不选中
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
     
        DLog(@"开始");
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        
        for (XMFShopCartDetailModel *detailModel in self.selectedCellArr) {
           
               //注意isChecked这里需要上传与现在情况相反的
               NSDictionary *dic = @{
                   
                   @"isChecked":@(NO),
                   
                   @"productIds":@[detailModel.productId]
                   
                   
               };
               
               
               
               [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_checked parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
                   
                   
                   DLog(@"全选的：选中/取消选中购物清单：%@",[responseObject description]);
                   
                   [MBProgressHUD hideHUDForView:self.view];
                   
                   if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
                       
                       
                       dispatch_semaphore_signal(sema);

                       
                   }else{
                       
                       [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
                       
                   }
                   
                   
                   
               } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
                   
                   [MBProgressHUD hideHUDForView:self.view];
                   
               }];
            
               
             dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

               
           }
           
  
         DLog(@"结束");
        
        
        //回到主线程调用方法
        dispatch_async(dispatch_get_main_queue(), ^{

           [self getOrderConfirmInfo];


        });
        
        
    });
    
   
    
    
}



#pragma mark - ——————— 懒加载 ————————

-(NSMutableArray *)selectedCellArr{
    
    if (_selectedCellArr == nil) {
        _selectedCellArr = [NSMutableArray array];
    }
    return _selectedCellArr;
}

-(NSMutableArray *)selectGoodsPartArr{

    if (_selectGoodsPartArr == nil) {
        _selectGoodsPartArr = [[NSMutableArray alloc] init];
    }
    return _selectGoodsPartArr;
    
}


-(NSMutableArray *)selectGoodsCountArr{
    
    if (_selectGoodsCountArr == nil) {
        _selectGoodsCountArr = [[NSMutableArray alloc] init];
    }
    return _selectGoodsCountArr;
    
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
