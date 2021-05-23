//
//  XMFSearchViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSearchViewController.h"
#import "XMFSearchHeaderView.h"
#import "XMFSearchCollectionView.h"
#import "XMFSearchViewModel.h"
#import "XMFSearchFlowLayout.h"
#import "XMFHomeCell.h"
#import "XMFGoodsListModel.h"//商品列表的model
#import "XMFGoodsDetailController.h"//商品详情
#import "XMFChooseGoodsTypeView.h"//商品规格选择弹框
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDatailInfoModel.h"//商品详情信息的model
#import "XMFGoodsDatailProductListModel.h"//商品规格总数model
#import "XMFOrderConfirmController.h"//订单确认
#import "XMFShoppingCartModel.h"//购物车model
#import "XMFHomeSonViewController.h"
#import "XMFShoppingCartGoodModel.h"//购物车商品model



@interface XMFSearchViewController ()<XMFSearchHeaderViewDelegate,historyDelegate,UITableViewDelegate,UITableViewDataSource,XMFHomeCellDelegate,XMFChooseGoodsTypeViewDelegate>{
    NSInteger row;
}


/*! 搜索框 */
@property(nonatomic,strong)XMFSearchHeaderView *searchBar;
/*! 搜索历史视图 */
@property(nonatomic,strong)XMFSearchCollectionView *searchCollectionView;
/*! 布局 */
@property(nonatomic,strong)XMFSearchFlowLayout *searchFlowLayout;
/*! SearchViewModel */
@property(nonatomic,strong)XMFSearchViewModel *searchModel;
/*! 搜索历史label */
@property(nonatomic,strong)UILabel  *oldLabel;
/*! 垃圾桶 */
@property(nonatomic,strong)UIButton *wastebutton;
/*! 数据源 */
@property(nonatomic,strong)NSMutableArray *dataArray;


//搜索结果

//搜索商品结果列表
@property (nonatomic, strong) UITableView *myTableView;

//搜索商品数据数组
@property (nonatomic, strong) NSMutableArray <XMFGoodsListModel *> *dataSourceArr;

//当前页码
@property (nonatomic, assign) NSInteger currentPage;

//搜索关键词
@property (nonatomic, copy) NSString *searchStr;

//点击了+号的cell
@property (nonatomic, strong) XMFHomeCell *selectedCell;

//购物车数据model
@property (nonatomic, strong) XMFShoppingCartModel *shoppingCartModel;


@end

@implementation XMFSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //防止设置了myScrollView顶到状态栏但是没到的问题
       if (@available(iOS 11.0, *)) {
           
           self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
       }
    
    
    
    [self baseSetting];
    
    // Do any additional setup after loading the view.
}

#pragma mark --- baseSetting

#warning 若控制位置不正确根据实际情况微调 这里有的不是自动布局


- (void)baseSetting{
    
    self.view.backgroundColor = KWhiteColor;
    
    
    self.topBgViewbgColor = UIColorFromRGB(0xF7CF20);
          
    self.noneBackNaviTitle = @" ";
    
    [self.view addSubview:self.searchBar];
    
    _searchModel = [[XMFSearchViewModel alloc]init];
   
    [self.view addSubview:self.oldLabel];
    
    [self.view addSubview:self.searchCollectionView];
   
    [self.view addSubview:self.wastebutton];
    
    [self wasteButtonFrame];
    
   
}

#pragma mark---懒加载
- (XMFSearchHeaderView *)searchBar{
    if (!_searchBar) {
        _searchBar = [[XMFSearchHeaderView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, KScreenWidth, kNavBarHeight)];
        _searchBar.XMFSearchHeaderViewDelegate = self;
    }
    return _searchBar;
}

#warning tabbar为rootViewController 下面不加64
- (XMFSearchCollectionView *)searchCollectionView{
    if (!_searchCollectionView) {
         row = [_searchModel rowForCollection:[_searchModel readHistory]];
        NSLog(@"row = %li",(long)row);
        _searchFlowLayout = [[XMFSearchFlowLayout alloc]init];
//        _searchCollectionView = [[SearchCollectionView alloc]initWithFrame:CGRectMake(0, 110, kScreenWidth, (row * 45)+64) collectionViewLayout:_searchFlowLayout array:[[_searchModel readHistory] mutableCopy]];
        
        _searchCollectionView = [[XMFSearchCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.oldLabel.frame), KScreenWidth, KScreenHeight - CGRectGetMaxY(self.oldLabel.frame)) collectionViewLayout:_searchFlowLayout array:[[_searchModel readHistory] mutableCopy]];
    
       
        _searchCollectionView.historyDelegate = self;
    }
    return _searchCollectionView;
}

- (UILabel *)oldLabel{
    
//    if (!_oldLabel&&[_searchModel readHistory].count>0) {
        
    if (!_oldLabel) {
        
        _oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, kTopHeight + 20, 100, 20)];
        _oldLabel.text = @"最近搜索";
        _oldLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:15.f];
        _oldLabel.textColor = UIColorFromRGB(0x999999);
    }
    return _oldLabel;
}

- (UIButton *)wastebutton{
//    if (!_wastebutton&&[_searchModel readHistory].count>0) {
    if (!_wastebutton) {
        
        _wastebutton = [[UIButton alloc]initWithFrame:CGRectZero];
        
//        _wastebutton = [[UIButton alloc]initWithFrame:CGRectMake(-44, kTopHeight + 20, 44, 20)];
    
        [_wastebutton setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
        
        [_wastebutton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wastebutton;
    
}


-(UITableView *)myTableView{
    
    if (_myTableView == nil) {
                
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, KScreenHeight - kTopHeight) style:UITableViewStylePlain];
        _myTableView.backgroundColor = KWhiteColor;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.backgroundColor = self.view.backgroundColor;
        
        //初始化一个无数据的emptyView
        LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                                 titleStr:@""
                                                                detailStr:XMFLI(@"暂无相关数据")
                                                              btnTitleStr:@""
                                                            btnClickBlock:^{
            
        }];
        
        emptyView.autoShowEmptyView = NO;
        
        //设置无数据样式
        _myTableView.ly_emptyView = emptyView;
        
        kWeakSelf(self)
        
        _myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
            
            
//            [weakself getNewData];
            
            //先判断是否在登陆状态
            if (UserInfoModel.token.length == 0) {
                
                 [weakself getNewData];
                
            }else{
                
                [weakself getCartIndex:refreshData goodsCell:nil];
            }
            
        }];
        
        _myTableView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            [weakself getMoreData];
            
        }];
        
        
    }
    return _myTableView;
    
    
}

#pragma mark --- 布局

- (void)wasteButtonFrame{
    __weak typeof(self) weakSelf = self;
    [_wastebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(kTopHeight + 20);
        make.right.equalTo(weakSelf.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(44, 20));
    }];
}


/*! 新增历史搜索 */
- (void)searchWithStr:(NSString *)text{
    /*! 保存历史数据 */
    if ([_searchModel readHistory].count==0) {
        [self reloadView:text];
        [self.view addSubview:self.oldLabel];
        [self.view addSubview:self.wastebutton];
        [self wasteButtonFrame];
    }else{
        [self reloadView:text];
    }
    [self search:text];
}
- (void)reloadView :(NSString *)text{
    [_searchModel saveHistory:text];
    _searchCollectionView.dataArray = [[_searchModel readHistory] mutableCopy];
    [self updataFrame];
    [_searchCollectionView reloadData];
}

#pragma mark --- XMFSearchHeaderViewDelegate
-(void)buttonsOnXMFSearchHeaderView:(XMFSearchHeaderView *)headerView button:(UIButton *)button{
    
    switch (button.tag) {
        case 0:{//返回
            
             [self popAction];
        }
            break;
            
        case 1:{//取消
            
            
             [self popAction];
            
            /*
            //判断是否包含tableview
            if ([self.view.subviews containsObject:self.myTableView]) {
                
                
                //移除
                [self.myTableView removeFromSuperview];
                
                //添加
                [self.view addSubview:self.oldLabel];
                [self.view addSubview:self.wastebutton];
                [self wasteButtonFrame];
                [self.view addSubview:self.searchCollectionView];
                
                
            }else{
                
                [self popAction];

                
            }*/

            
        }
            break;
            
        default:
            break;
    }
    
   
    
    
}

#warning tabbar为rootViewController 下面不加64

- (void)updataFrame{
    row = [_searchModel rowForCollection:[_searchModel readHistory]];
//    _searchCollectionView.frame = CGRectMake(0, 110, KScreenWidth, (row * 45)+64);
//    _searchCollectionView.frame = CGRectMake(0, 110, KScreenWidth, KScreenHeight);
}





#pragma mark-----------------搜索

/*! 搜索关键词 */
- (void)search:(NSString *)text{
    DLog(@"开始搜索%@",text);
    
    self.searchStr = text;
    
    //移除最近搜索、删除和关键词列表
    [self.oldLabel removeFromSuperview];
    [self.wastebutton removeFromSuperview];
    [self.searchCollectionView removeFromSuperview];
    
    //添加商品列表
    [self.view addSubview:self.myTableView];
    
    
//    [self getNewData];
    
    //先判断是否在登陆状态
    if (UserInfoModel.token.length == 0) {
        
        [self getNewData];
        
    }else{
        
        [self getCartIndex:refreshData goodsCell:nil];
    }
    
}


#pragma mark --- historyDelegate


/*! 删除搜索历史 */
- (void)delete :(NSString *)text
{
//    ! 删除沙盒数据
    [_searchModel deleteHistory:text];
    /*! 刷新本地视图 */
    [_searchCollectionView.dataArray removeObject:text];
    /*! 是否删除垃圾桶和label */
    [self deleteOther];
    [_searchCollectionView reloadData];
}
/*! 移除控件 */
- (void)deleteOther {
    if ([_searchModel readHistory].count==0) {
//        [_oldLabel removeFromSuperview];
//        [_wastebutton removeFromSuperview];
    }
//    [self updataFrame];
}
/*! cell选中搜索 */
- (void)select :(NSString *)text{
    
    //成为焦点
    [self.searchBar.textField becomeFirstResponder];
    
    //给搜索输入框赋值
    self.searchBar.textField.text = text;
    
    //失去焦点
    [self.searchBar.textField resignFirstResponder];
    
    //是否隐藏搜索框占位
    [self.searchBar isHiddenLabel:self.searchBar.textField];
    
    [self search:text];
}

#pragma mark  ---- 垃圾桶按钮删除历史记录

- (void)deleteAll{
    
    /*! 删除所有历史记录 */
    [self.searchModel deleteHistory:@""];
    
    [self deleteOther];
    
    [self.searchCollectionView.dataArray removeAllObjects];
    
    [self.searchCollectionView reloadData];
    
    /*
    
    kWeakSelf(self)

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"亲,确定清空吗?要三思啊" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 删除所有历史记录
        [weakself.searchModel deleteHistory:@""];
        
        [weakself deleteOther];
        
        [weakself.searchCollectionView.dataArray removeAllObjects];
        
        [weakself.searchCollectionView reloadData];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    */
}

#pragma mark---网络判断

- (void)netWork:(NSString *)text{
    NSInteger status =  [[NSUserDefaults standardUserDefaults]integerForKey:@"ZDNet"];
    /*! 有网的结果 */
    if (status==1||status==2) [self haveNet:text];
    /*! 没有网的结果 */
    else [self NotNet:text];
}
/*! 有网搜索 */
- (void)haveNet:(NSString *)text{
    
}
/*! 没网 */
- (void)NotNet:(NSString *)text{
    
}

#pragma mark - ——————— 网络请求 ————————
-(void)getNewData{
    
    [self.myTableView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    
    NSDictionary *dict = @{
        
        @"size":@(10),
        
        @"page":@(self.currentPage),
        
        @"goodsName":self.searchStr
        
        
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
           
           @"goodsName":self.searchStr
           
           
       };
       
              
       [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_goods_list parameters:dict success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
           
           DLog(@"商品列表:%@",[responseObject description]);
           
           if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
               
               NSArray *goodsListArr = responseObjectModel.data[@"goodsList"];
            
               
               for (NSDictionary *dict in goodsListArr) {
                   
                   XMFGoodsListModel *model = [XMFGoodsListModel yy_modelWithDictionary:dict];
                   
                   [self.dataSourceArr addObject:model];
                   
               }
               
               
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


//获取商品详情
-(void)getGoodsDetail:(XMFHomeCell *)cell{
    
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
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
         [MBProgressHUD hideHUDForView:self.view];
        
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
            
           
            //通知首页的子商品列表进行刷新
            KPostNotification(KPost_CartVc_Notice_HomeSonVc_Refesh, nil, nil)
            
            //发送通知商品列表容器首页控制器刷新
            KPostNotification(KPost_HomeSonVc_Notice_HomeSonVc_Refresh, nil, nil)
    
            
            
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
            
            //通知首页的子商品列表进行刷新
            KPostNotification(KPost_CartVc_Notice_HomeSonVc_Refesh, nil, nil)
            
            //发送通知商品列表容器首页控制器刷新
            KPostNotification(KPost_HomeSonVc_Notice_HomeSonVc_Refresh, nil, nil)
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


#pragma mark - ——————— tableview的数据源和代理方法 ————————
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static  NSString *identifier = @"cell";
    
    XMFHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFHomeCell class]) owner:nil options:nil] firstObject];
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


#pragma mark - ——————— XMFHomeCell的代理方法 ————————

-(void)buttonsOnXMFHomeCellDidClick:(XMFHomeCell *)cell button:(UIButton *)button{

    
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
                
                
                [self getCartIndex:updateCart goodsCell:cell];
                
            }
            
          
            
        }
            break;
            
        case 1:{//加
            
            if ([cell.model.number integerValue] >= 5) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"亲,此商品加入购物车数量已达上限")];
                
            }else{
                
                [self getGoodsDetail:cell];
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

#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray<XMFGoodsListModel *> *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        
        _dataSourceArr = [[NSMutableArray alloc] init];
        
    }
    return _dataSourceArr;
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
