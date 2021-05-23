//
//  XMFHomeSonViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/16.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeSonViewController.h"
#import "XMFHomeCell.h"
#import "XMFGoodsClassifyModel.h"//商品分类的model
#import "XMFGoodsListModel.h"//商品列表的model
#import "XMFChooseGoodsTypeView.h"//商品规格选择弹框
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDatailInfoModel.h"//商品详情信息的model
#import "XMFGoodsDatailProductListModel.h"//商品规格总数model
#import "XMFShoppingCartModel.h"//购物车model
#import "XMFShoppingCartGoodModel.h"//购物车商品model
#import "XMFGoodsDetailController.h"//商品详情
#import "XMFOrderConfirmController.h"//订单确认


@interface XMFHomeSonViewController ()<UITableViewDelegate,UITableViewDataSource,XMFHomeCellDelegate,XMFChooseGoodsTypeViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

//上次Y轴偏移量
@property (nonatomic, assign) CGFloat lastOffSetY;


@property (nonatomic, strong) XMFGoodsClassifyModel *classifyModel;

//当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray<XMFGoodsListModel *> *dataSourceArr;

//购物车数据model
@property (nonatomic, strong) XMFShoppingCartModel *shoppingCartModel;

//点击了+号的cell
@property (nonatomic, strong) XMFHomeCell *selectedCell;

//回到顶部按钮
@property (nonatomic, strong) UIButton *backTopBtn;


@end

@implementation XMFHomeSonViewController



-(instancetype)initWithClassifyModel:(XMFGoodsClassifyModel *)model{
    
    
    if (self = [super init]) {
        
        self.classifyModel = model;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.showsVerticalScrollIndicator = NO;
    
     //初始化一个无数据的emptyView 點擊重試
        LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                                 titleStr:@""
                                                                detailStr:XMFLI(@"暂无相关数据")
                                                              btnTitleStr:@""
                                                            btnClickBlock:^{
                                                               
                                                            }];
        
        emptyView.autoShowEmptyView = NO;
        
        //设置无数据样式
        self.myTableView.ly_emptyView = emptyView;
    
        //防止刷新抖动
        self.myTableView.estimatedRowHeight = 0;
        self.myTableView.estimatedSectionHeaderHeight = 0;
        self.myTableView.estimatedSectionFooterHeight = 0;
    
    
        kWeakSelf(self)
        
        self.myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
            
           //先判断是否在登陆状态
            if (UserInfoModel.token.length == 0) {
                
                 [weakself getNewData];
                
            }else{
                
                [weakself getCartIndex:refreshData goodsCell:nil];
            }
            
            //刷新的block,仅在全部列表里执行
            if (self->_refreshBlock && [weakself.classifyModel.name isEqualToString:XMFLI(@"全部")]) {
                self->_refreshBlock();
            }
            
        }];
        
        self.myTableView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakself getMoreData];
            
        }];
    
    
    //先判断是否在登陆状态
    if (UserInfoModel.token.length == 0) {
        
        [self getNewData];
        
    }else{
        
        [self getCartIndex:refreshData goodsCell:nil];
    }
    
    
    //接收登录状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    //接收购物车发送刷新页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:KPost_CartVc_Notice_HomeSonVc_Refesh object:nil];
    
    //接收商品列表发送刷新页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsListNoticeRefresh:) name:KPost_HomeSonVc_Notice_HomeSonVc_Refresh object:nil];
    
    
    //回到顶部布局
    [self.view addSubview:self.backTopBtn];
    self.backTopBtn.hidden = YES;
    [self.backTopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.mas_equalTo(self.view).offset(-15);
        
        //适配不同版本的iOS系统
        if (@available(iOS 11.0, *)) {
            
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-15);
            
        } else {
            // Fallback on earlier versions
            
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-15);
        }
       }];
    
}


//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    
    BOOL loginSuccess = [notification.object boolValue];
    
    
    if (loginSuccess) {
        
        [self getCartIndex:refreshData goodsCell:nil];
        
    }else{
        
        //给数量的model置空
        self.shoppingCartModel = nil;
       
        [self getNewData];
        
    }
    
    
}

#pragma mark - ——————— 刷新页面 ————————

-(void)refreshData{
    
    [self getCartIndex:refreshData goodsCell:nil];
    
}


-(void)goodsListNoticeRefresh:(NSNotification *)info{
    
    
    NSDictionary *dic = info.userInfo;
    
    NSString *nameStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
    
    if (![nameStr isEqualToString:self.classifyModel.name] && [self.classifyModel.name isEqualToString:@"全部"]) {
        //在全部页面之外点击加减,全部列表刷新
        
        [self getCartIndex:refreshData goodsCell:nil];
        
    }
//    else if ([nameStr isEqualToString:self.classifyModel.name] && ![self.classifyModel.name isEqualToString:@"全部"]){
        
    else if ([nameStr isEqualToString:@"全部"] && ![self.classifyModel.name isEqualToString:@"全部"]){
        
        //在全部页面内点击加减,其它列表刷新
        
        [self getCartIndex:refreshData goodsCell:nil];
        
    }
    
    
}

#pragma mark - ——————— 网络请求 ————————
-(void)getNewData{
    
    [self.myTableView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    
    NSDictionary *dict = @{
        
        @"size":@(10),
        
        @"page":@(self.currentPage),
        
        @"classifyId":self.classifyModel.classifyId
        
        
    };
    
    
    [self.myTableView ly_startLoading];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_goods_list parameters:dict success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"商品列表:%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSArray *goodsListArr = responseObjectModel.data[@"goodsList"];
           
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dict in goodsListArr) {
                
                XMFGoodsListModel *model = [XMFGoodsListModel yy_modelWithDictionary:dict];
                
                [self.dataSourceArr addObject:model];
                
            }
            
            
            
            //通过循环遍历购物车数据进行id对比然后给商品数量赋值
            if (self.shoppingCartModel.cartList.count > 0) {
                
                //循环获取购物车商品
                for (XMFShoppingCartGoodModel *goodModel in self.shoppingCartModel.cartList) {
                    
                    
                    for (XMFGoodsListModel *listModel in self.dataSourceArr) {
                        
                        
                        if ([goodModel.goodsId isEqualToString:listModel.goodId]) {
                            
                            listModel.number = goodModel.number;
                        }

                    }
                    
                }
                
            }

        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        [self.myTableView.mj_header endRefreshing];
        
        [self.myTableView reloadData];
        
        [self.myTableView ly_endLoading];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myTableView.mj_header endRefreshing];
        
        [self.myTableView ly_endLoading];
        
    }];
    
    
}


-(void)getMoreData{
    
    self.currentPage += 1;
    
    NSDictionary *dict = @{
           
           @"size":@(10),
           
           @"page":@(self.currentPage),
           
           @"classifyId":self.classifyModel.classifyId
           
           
       };
       
              
       [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_goods_list parameters:dict success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
           
           DLog(@"商品列表:%@",[responseObject description]);
           
           if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
               
               
               NSArray *goodsListArr = responseObjectModel.data[@"goodsList"];
               
               
               for (NSDictionary *dict in goodsListArr) {
                   
                   XMFGoodsListModel *model = [XMFGoodsListModel yy_modelWithDictionary:dict];
                   
                   [self.dataSourceArr addObject:model];
                   
               }
               
               if (self.shoppingCartModel.cartList.count > 0) {
                   
                   //循环获取购物车商品
                   for (XMFShoppingCartGoodModel *goodModel in self.shoppingCartModel.cartList) {
                       
                       
                       for (XMFGoodsListModel *listModel in self.dataSourceArr) {
                           
                           
                           if ([goodModel.goodsId isEqualToString:listModel.goodId]) {
                               
                               listModel.number = goodModel.number;
                           }
                           
                           
                       }
                       
                       
                   }
                   
                   
               }
               
            
               //判断数据是否已经请求完了
               if (goodsListArr.count < 10) {
                   
                   [self.myTableView.mj_footer endRefreshingWithNoMoreData];
                   
               }else{
                   
                   [self.myTableView.mj_footer endRefreshing];
                   
               }
               
               
           }else{
               
               [self.myTableView.mj_footer endRefreshing];
               
               [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
           }
           
           [self.myTableView reloadData];
           
           
       } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
           
           [self.myTableView.mj_footer endRefreshing];
           
           
       }];
    
    
}


//购物车查询
-(void)getCartIndex:(getCartIndexType)type goodsCell:(XMFHomeCell * _Nullable)cell{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_cart_index parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"购物车：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            self.shoppingCartModel = [XMFShoppingCartModel yy_modelWithJSON:responseObjectModel.data];
            
            switch (type) {
                case refreshData:{//刷新数据
                    
                     [self getNewData];
                    
                }
                    break;
                    
                case updateCart:{//减少商品
                    
                    [self reduceCart:cell];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
           
            
            
        [self.myTableView reloadData];
            
 
            
        }else{
            
            [MBProgressHUD showOnlyTextToView:self.view title:responseObjectModel.kerrmsg];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
     
        
    }];
    
 
    
}


//获取商品详情
-(void)getGoodsDetail:(XMFHomeCell *)cell isAdd:(BOOL)isAdd{
    
    kWeakSelf(self)
    
    NSDictionary *dic = @{
        
        @"id":cell.model.goodId
        
    };
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_goods_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"商品详情：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            XMFGoodsDatailModel *detailModel = [XMFGoodsDatailModel yy_modelWithDictionary:responseObjectModel.data];
            
            
            //先判断是加还是减
            if (isAdd) {
                
                
                if (detailModel.productList.count > 1) {//当有多个规格的时候
                    
                    
                    //给选中的cell赋值
                    self.selectedCell = cell;
                    
                    
                    XMFChooseGoodsTypeView *typeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFChooseGoodsTypeView class]) owner:nil options:nil] firstObject];
                    
                    typeView.delegate = self;

                    typeView.chooseType = goodsListAddCart;
                    
                    detailModel.goodsChooseType = goodsListAddCart;
                    
                    typeView.model = detailModel;
                    
                    /*
                    //选择的商品
                    typeView.ChooseGoodsTypeBlock = ^(XMFGoodsDatailProductListModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                        
                        
                        [weakself addCart:cell productModel:productModel goodsCount:selectedGoodCount];
                        
                        
                    };*/
                    
                    
                    
                    [typeView show];
                    
                    
                    
                }else{
                    
                    
                    [self addCart:cell productModel:detailModel.productList[0] goodsCount:@"1"];
                    
                    
                }
                
            
                
            }else{//是减
                
                if (detailModel.productList.count > 1) {//当有多个规格的时候,跳转到购物车
                    
                    XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
                    
                    //防止tabbar位置变动，遍历子控制器并选中
                    for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                        
                        UIViewController *firstVc = navVc.viewControllers[0];
                        
                        if ([firstVc  isKindOfClass:[XMFShoppingCartController class]]) {
                            
                            NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                            
                            tabBarVc.selectedIndex = index;
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                }else{
                    
                    [self getCartIndex:updateCart goodsCell:cell];
                }
                
                
            }
            
        
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
         [MBProgressHUD hideHUDForView:self.view];
        
    }];
    
    
}

//加入购物车
-(void)addCart:(XMFHomeCell *)cell productModel:(XMFGoodsDatailProductListModel *)selectedProductModel goodsCount:(NSString *)goodsCountStr{
    
    
    
    NSDictionary *dic = @{
        
        @"goodsId":selectedProductModel.goodsId,
        
        @"number":goodsCountStr,
        
        @"productId":selectedProductModel.productId
        
        
    };
    
    
    NSIndexPath *addIndexPath = [self.myTableView indexPathForCell:cell];
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"添加购物车：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            //刷新添加的商品
            XMFGoodsListModel *model = self.dataSourceArr[addIndexPath.row];
            
            model.number = [NSString stringWithFormat:@"%zd",[model.number integerValue] + [goodsCountStr integerValue]];
            
            [self.myTableView reloadRowsAtIndexPaths:@[addIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            [MBProgressHUD showSuccess:XMFLI(@"加入购物车成功") toView:self.view];
            
            //发送通知告诉购物车刷新
          
            KPostNotification(KPost_HomeSonVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            //发送通知商品列表刷新
            KPostNotification(KPost_HomeSonVc_Notice_HomeSonVc_Refresh, nil, @{@"name":self.classifyModel.name})
    
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
}


//减少购物车
-(void)reduceCart:(XMFHomeCell *)cell{
    
    NSIndexPath *reduceIndexPath = [self.myTableView indexPathForCell:cell];
    
    
    XMFShoppingCartGoodModel *cartGoodModel;

    NSString *goodsNumber;
    
    for (XMFShoppingCartGoodModel *goodModel in self.shoppingCartModel.cartList) {
        
        
        if ([goodModel.goodsId isEqualToString:cell.model.goodId]) {
            
            cartGoodModel = goodModel;
            
            //商品数量
            goodsNumber = [NSString stringWithFormat:@"%zd",[cartGoodModel.number integerValue] - 1];
            
        }
        
    }
    
    /**
     
     {"productId":1958,"goodsId":1181543,"number":4,"id":3887}
     
     */
    
    
    
    NSDictionary *dic = @{
        
        @"productId":cartGoodModel.productId,
        
        @"goodsId":cartGoodModel.goodsId,
        
        @"number":goodsNumber,
        
        @"id":cartGoodModel.cartId
        
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_update parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
       
        
        DLog(@"减少购物车：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
            //刷新添加的商品
            XMFGoodsListModel *model = self.dataSourceArr[reduceIndexPath.row];
            
            model.number = [NSString stringWithFormat:@"%zd",[model.number integerValue] - 1];
            
            [self.myTableView reloadRowsAtIndexPaths:@[reduceIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            
           
            //发送通知告诉购物车刷新
            
            KPostNotification(KPost_HomeSonVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            //发送通知商品列表刷新
            KPostNotification(KPost_HomeSonVc_Notice_HomeSonVc_Refresh, nil, @{@"name":self.classifyModel.name})
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


//收藏或者取消收藏商品
-(void)getGoodsCollectAddOrDelete:(UIButton *)button typeView:(XMFChooseGoodsTypeView *)typeView{
    
    //类型 0商品 或 1专题
    
    NSDictionary *dic = @{
        
        @"type":@"0",
        
        @"valueId":typeView.model.info.goodsId
        
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_collect_addordelete parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"收藏或取消收藏：%@",[responseObject description]);
               
      if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
         
          button.selected = !button.selected;
          
          
          
      }else{
          
          [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
          
      }
 
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


//立即购买
-(void)postFastaddGoods:(XMFChooseGoodsTypeView *)typeView{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":typeView.selectedProductModel.goodsId,
        
        @"number":typeView.amountTfd.text,
        
        @"productId":typeView.selectedProductModel.productId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_fastadd parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"立即购买：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            //传入购物车id
            NSString *cartIdStr = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
            XMFOrderConfirmController  *VCtrl = [[XMFOrderConfirmController alloc]initWithCartId:cartIdStr];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
              //发送通知告诉购物车刷新
            
              KPostNotification(KPost_HomeSonVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            //发送通知商品列表容器首页控制器刷新
            KPostNotification(KPost_HomeSonVc_Notice_HomeSonVc_Refresh, nil, nil)
            
            
        }else if (responseObjectModel.kerrno == 504){//绑定手机
            
            [[XMFGlobalManager getGlobalManager] presentBindPhoneControllerWith:self];

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


#pragma mark - ——————— tableView的代理方法和数据源 ————————
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *identifier = @"cell";
    
    XMFHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFHomeCell class]) owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;		
    }
    
    cell.delegate = self;
    
    cell.model = self.dataSourceArr[indexPath.row];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return 292;
    
    return 307;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFGoodsListModel *model = self.dataSourceArr[indexPath.row];
    
    XMFGoodsDetailController  *VCtrl = [[XMFGoodsDetailController alloc]init];
    
    VCtrl.goodsIdStr = model.goodId;
    
    [self.navigationController pushViewController:VCtrl animated:YES];
   
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.lastOffSetY = scrollView.contentOffset.y;
    
    
     DLog(@"偏移的self.lastOffSetY：%f",self.lastOffSetY);
    
    //防止下拉至最顶的时候拖拽不释放导致顶部重叠
    if (self.lastOffSetY <= 0) {//向下滚动
        
        if (_headerViewShowBlock) {
            
            _headerViewShowBlock(YES);
            
        }
        
        
     }else{//向上滚动
         
        if (_headerViewShowBlock) {
            
            _headerViewShowBlock(NO);
            
        }
        
     }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
 
   
    //动态计算高度，这里说只要滚动就显示回到顶部按钮，如果-scrollView.frame.size.heigh就是滚动距离超过一个屏幕的时候就会显示
//    CGFloat gap = self.scrollView.contentOffset.y - scrollView.frame.origin.y;
    
    CGFloat gap = scrollView.contentOffset.y - self.lastOffSetY;
    
    DLog(@"下拉的gap：%f",gap);
    
    if (gap < 0) {//向下滚动
        
        if (_headerViewShowBlock) {
            
            _headerViewShowBlock(YES);
            
        }
        
        //发送通知告知首页要不要显示头部view
        KPostNotification(KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow, @(YES), nil)
        
        
     }else{//向上滚动
        
       if (_headerViewShowBlock) {
           
           _headerViewShowBlock(NO);
           
       }
         
         //发送通知告知首页要不要显示头部view
         KPostNotification(KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow, @(NO), nil)
       
    }
    
    
    //回到顶部
    //动态计算高度，这里说只要滚动就显示回到顶部按钮，如果-scrollView.frame.size.heigh就是滚动距离超过一个屏幕的时候就会显示
    CGFloat backTopBtnGap = self.myTableView.contentOffset.y - scrollView.frame.origin.y;
    
    if (backTopBtnGap < 50) {
        
        //设置小于0隐藏
        self.backTopBtn.hidden = YES;
    }else{
        
        //设置大于0显示
        self.backTopBtn.hidden = NO;
    }
    
    
}


#pragma mark - ——————— XMFHomeCell的代理方法 ————————

-(void)buttonsOnXMFHomeCellDidClick:(XMFHomeCell *)cell button:(UIButton *)button{
    
    
    static NSTimeInterval time = 0.0;
    
    NSTimeInterval currentTime = [NSDate date].timeIntervalSince1970;
    
    //限制用户点击按钮的时间间隔大于1秒钟
    
    if (currentTime - time < 0.5) {
        
        //大于这个时间间隔就处理
                   
       return;
        
        
    }
    
    time = currentTime;
    
    switch (button.tag) {
        case 0:{//减
            
            //先检查登录状态
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
                return;
                
            }
            
            
            if ([cell.model.number integerValue] <= 0){
                
                cell.model.number = @"0";
                
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"亲,实在不能再少了")];
                
            }else{
                
                //先获取商品详情
                [self getGoodsDetail:cell isAdd:NO];
                
            }
            
        }
            break;
        case 1:{//加入购物车
            
            if ([cell.model.number integerValue] >= 5) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"亲,此商品加入购物车数量已达上限")];
                
            }else{
                
                [self getGoodsDetail:cell isAdd:YES];
            }

            
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - ——————— XMFChooseGoodsTypeView的代理方法 ————————
-(void)buttonsOnXMFChooseGoodsTypeViewDidClick:(XMFChooseGoodsTypeView *)typeView button:(UIButton *)button{
    
    switch (button.tag) {
            
        case 2:{//确定 —— 对应 —— 立即登录
            
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
            }
            
        }
            break;
       
        case 3:{//客服
            
            [typeView hide];
            
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = @"https://im.7x24cc.com/phone_webChat.html?accountId=N000000013029&chatId=6aded8fa-f405-4371-8aba-c982f8fb7f8d";
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            break;
        case 4:{//收藏
            
            [self getGoodsCollectAddOrDelete:button typeView:typeView];
            
        }
            break;
        case 5:{//加入购物车
            
            [typeView hide];
            
            [self addCart:self.selectedCell productModel:typeView.selectedProductModel goodsCount:typeView.amountTfd.text];
            
        }
            break;
        case 6:{//立即购买
            
            [typeView hide];
            
//            [MBProgressHUD showSuccess:@"立即购买" toView:self.view];
            
            [self postFastaddGoods:typeView];
            
        }
            break;
            
        default:
            break;
    }
    
    
}

#pragma mark - ——————— 回到顶部 ————————
- (void)backScrollToTop
{
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray<XMFGoodsListModel *> *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
    
}

- (UIButton *)backTopBtn
{
    if (_backTopBtn == nil) {
        _backTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      
        _backTopBtn.size = CGSizeMake(40, 40);
        
        [_backTopBtn addTarget:self action:@selector(backScrollToTop) forControlEvents:UIControlEventTouchUpInside];
        [_backTopBtn setImage:[UIImage imageNamed:@"icon_shouye_dingbu"] forState:UIControlStateNormal];
    }
    return _backTopBtn;
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
