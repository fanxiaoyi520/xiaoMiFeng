//
//  XMFHomeSonController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/12.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeSonController.h"
#import "XMFHomeAllGoodsCell.h"//首页推荐cell
#import "XMFHomePartGoodsCell.h"//子分类cell
#import "XMFHomeDoctorCell.h"//博士版cell
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFHomeGoodsCellModel.h"//商品cell的model
#import "XMFHomeGoodsClassifyModel.h"//商品分类model
#import "XMFGoodsDetailViewController.h"//商品详情
#import "XMFSelectGoodsTypeView.h"//商品属性弹框
#import "XMFHomeGoodsPropertyModel.h"//商品属性的model
#import "XMFGoodsSpecInfoModel.h"//商品规格model
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model


@interface XMFHomeSonController ()<UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout,XMFHomeDoctorCellDelegate,XMFSelectGoodsTypeViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

//布局
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *flowLayout;

//布局类型
@property (nonatomic, assign) flowLayoutType layoutType;

/** 上次Y轴偏移量 */
@property (nonatomic, assign) CGFloat lastOffSetY;

/** 回到顶部按钮 */
@property (nonatomic, strong) UIButton *backTopBtn;


/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsCellModel *> *dataSourceArr;

/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

/** 商品分类model */
@property (nonatomic, strong) XMFHomeGoodsClassifyModel *classifyModel;


/** 搜索字典 */
@property (nonatomic, strong) NSMutableDictionary *searchDic;


/** 商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;

/** 商品规格弹窗 */
@property (nonatomic, strong) XMFSelectGoodsTypeView *selectGoodsTypeView;



@end

@implementation XMFHomeSonController


-(instancetype)initWithFlowLayoutType:(flowLayoutType)type classifyModel:(XMFHomeGoodsClassifyModel *)classifyModel selectedTagDic:(NSMutableDictionary *)selectedTagDic{
    
    if (self = [super init]) {
        
        self.layoutType = type;
        
        self.classifyModel = classifyModel;

        self.searchDic = selectedTagDic;
        
    }
    
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}


-(void)setupUI{
    
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//    self.flowLayout.headerHeight = 15;
//    self.flowLayout.footerHeight = 10;
    self.flowLayout.minimumColumnSpacing = 10;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.columnCount = 2;
    
    if (self.layoutType == allGoodsType) {
        
         self.flowLayout.columnCount = 2;
        
        
    }else{
        
         self.flowLayout.columnCount = 1;
    }
    
    
    self.myCollectionView.collectionViewLayout = self.flowLayout;
    
    self.myCollectionView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeAllGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class])];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomePartGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomePartGoodsCell class])];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeDoctorCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeDoctorCell class])];
    
    
    kWeakSelf(self)
    
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"暂无相关数据")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    //设置无数据样式
    self.myCollectionView.ly_emptyView = emptyView;
    
    
    
    
    
    
    
    self.myCollectionView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
//        [weakself getGoodsClassify];
        
        [weakself getNewData];
        
        
        //刷新的block,仅在全部列表里执行
        if (self->_refreshBlock && [weakself.classifyModel.name isEqualToString:XMFLI(@"首页推荐")]) {
            self->_refreshBlock();
        }
        
        
    }];
    
    self.myCollectionView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself getMoreData];
        
    }];
      
    
    [self getNewData];
    
    
    //接收购物车发送刷新页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewData) name:KPost_CartVc_Notice_HomeVc_Refesh object:nil];
    
    //接收商品列表发送刷新页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsListNoticeRefresh:) name:KPost_HomeSonVc_Notice_HomeSonVc_Refresh object:nil];
    
    
    //接收首页筛选的通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:KPost_HomeSimpleVc_Notice_HomeSonVc_Refresh object:nil];
    
    
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

- (void)dealloc {
    
    self.myCollectionView.delegate = nil;
    self.myCollectionView.dataSource = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


#pragma mark - ——————— 通知方法 ————————
-(void)goodsListNoticeRefresh:(NSNotification *)info{
    
    if (info.object != self) {
        //如果是当前页就不刷新了
        
        NSDictionary *dic = info.userInfo;
        
        NSString *nameStr = [NSString stringWithFormat:@"%@",dic[@"name"]];
        
        if (![nameStr isEqualToString:self.classifyModel.name] && [self.classifyModel.name isEqualToString:XMFLI(@"首页推荐")]) {
            //在全部页面之外点击加减,全部列表刷新
            
            [self getNewData];
            
        }else if ([nameStr isEqualToString:XMFLI(@"首页推荐")] && ![self.classifyModel.name isEqualToString:@"全部"]){
            
            //在全部页面内点击加减,其它列表刷新
            
            [self getNewData];
            
        }
        
    }
    

}


//筛选通知方法
-(void)refreshData:(NSNotification *)info{
  
    NSDictionary *dic = info.userInfo;
    
    DLog(@"筛选数据：%@",dic);
    
    
    XMFHomeGoodsClassifyModel *classifyModel = dic[@"classifyModel"];
    
    if ([classifyModel.classifyId isEqualToString:self.classifyModel.classifyId]) {
        
        self.searchDic = dic[@"selectedTagDic"];

        [self getNewData];
        
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
    
    switch (self.layoutType) {
            
        case allGoodsType:{
            
            
            XMFHomeAllGoodsCell *allGoodsCell = (XMFHomeAllGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class]) forIndexPath:indexPath];
            
            
            return allGoodsCell;
            
        }
            break;
            
        case doctorType:{
            
            XMFHomeDoctorCell *doctorCell = (XMFHomeDoctorCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeDoctorCell class]) forIndexPath:indexPath];
            
            doctorCell.cellItem = indexPath.item;
            
            doctorCell.model = self.dataSourceArr[indexPath.item];
            
            
            doctorCell.delegate = self;
            
            
            return doctorCell;
            
            
        }
            break;
            
        default:{
            
            XMFHomePartGoodsCell *partGoodsCell = (XMFHomePartGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomePartGoodsCell class]) forIndexPath:indexPath];
            
            
            return partGoodsCell;
            
        }
            break;
    }

    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
   
    XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
    
    XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:model.goodsId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
}

#pragma mark - ——————— CHTCollectionViewDelegateWaterfallLayout ————————

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (self.layoutType) {
        case allGoodsType:{
            
            return CGSizeMake((KScreenW - 30)/2.0, 1.44 *((KScreenW - 30)/2.0));

            
        }
            break;
            
        case doctorType:{
            
            return CGSizeMake(KScreenW - 20, 325);

        }
            break;
            
        default:{
            
            return CGSizeMake(KScreenW - 20, 137);

            
        }
            break;
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.lastOffSetY = scrollView.contentOffset.y;
    
    
     DLog(@"偏移的self.lastOffSetY：%f",self.lastOffSetY);

    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
 
   
    //动态计算高度，这里说只要滚动就显示回到顶部按钮，如果-scrollView.frame.size.heigh就是滚动距离超过一个屏幕的时候就会显示
//    CGFloat gap = self.scrollView.contentOffset.y - scrollView.frame.origin.y;
    
    
    /*
    CGFloat gap = scrollView.contentOffset.y - self.lastOffSetY;
    
    DLog(@"下拉的gap：%f",gap);
    
    if (gap < 10) {//向下滚动
        
        //发送通知告知首页要不要显示头部view
        KPostNotification(KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow, @(YES), nil)
        
        
     }else{//向上滚动
 
         
         //发送通知告知首页要不要显示头部view
         KPostNotification(KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow, @(NO), nil)
       
    }*/
    
    
    
    if(scrollView.contentOffset.y > 0){//向上滚动
        
        //发送通知告知首页要不要显示头部view
        KPostNotification(KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow, @(NO), nil)
        
    }else{
        
        //发送通知告知首页要不要显示头部view
        KPostNotification(KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow, @(YES), nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    //回到顶部
    //动态计算高度，这里说只要滚动就显示回到顶部按钮，如果-scrollView.frame.size.heigh就是滚动距离超过一个屏幕的时候就会显示
    CGFloat backTopBtnGap = scrollView.contentOffset.y - scrollView.frame.origin.y;
    
    if (backTopBtnGap < 50) {
        
        //设置小于0隐藏
        self.backTopBtn.hidden = YES;
    }else{
        
        //设置大于0显示
        self.backTopBtn.hidden = NO;
    }
    
    
}

#pragma mark - ——————— XMFHomeDoctorCell ————————
-(void)buttonsOnXMFHomeDoctorCellDidClick:(XMFHomeDoctorCell *)cell button:(UIButton *)button{
    
    
    NSIndexPath *selectedIndexPath = [self.myCollectionView indexPathForCell:cell];

    
    
    switch (button.tag) {
        case 0:{//减
            
            //先检查登录状态
            if (UserInfoModel.token.length == 0) {
                
                [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:self];
                
                return;
                
            }
            
            
            if ([cell.model.cartNum integerValue] <= 0){
                
                cell.model.cartNum = @"0";
                
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"亲,实在不能再少了")];
                
                
            }else{
                

//                [self getGoodsSpecification:cell.model.goodsId doctorCell:cell goodsName:cell.model.goodsName isAdd:NO];
                
                [self getGoodsSpecInfo:cell.model.goodsId doctorCell:cell button:button indexPath:selectedIndexPath isAdd:NO];
                
                
                
            }
            
            
        }
            break;
            
        case 1:{//加
            
//            [self getGoodsSpecification:cell.model.goodsId doctorCell:cell goodsName:cell.model.goodsName isAdd:YES];
            
            [self getGoodsSpecInfo:cell.model.goodsId doctorCell:cell button:button indexPath:selectedIndexPath isAdd:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma mark - ——————— XMFSelectGoodsTypeView的代理方法 ————————

//规格点击的方法
-(void)selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView goodsId:(NSString *)goodsId{
    
    [self getGoodsDetail:goodsId];
    
}


#pragma mark - ——————— 网络请求 ————————
//获取商品
-(void)getNewData{
    
    [self.myCollectionView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    /*
    orderType    integer($int32)
    排序 0-按销量 1-综合排序

    pageNo    integer($int32)
    页码

    pageSize    integer($int32)
    每页条数
     */
    
    
    NSDictionary *dic = @{
                
        @"classify":self.classifyModel.classifyId,
        
        @"pageNo":@(self.currentPage),
        
        @"pageSize":@(10),
        
        @"isMainGoods":@(YES)
        
    };
    
//    DLog(@"token:%@",UserInfoModel.token);
    
    [self.searchDic addEntriesFromDictionary:dic];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self.myCollectionView ly_startLoading];

    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_goods_search parameters:self.searchDic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"首页商品：%@",[responseObject description]);
        
        [hud hideAnimated:YES];

        [self.view hideErrorPageView];
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self.dataSourceArr removeAllObjects];
            
            NSArray *dataArr = responseObjectModel.data[@"dataList"];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFHomeGoodsCellModel *model = [XMFHomeGoodsCellModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
            }
            
            
            [self.myCollectionView reloadData];
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getNewData];
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    
        [self.myCollectionView.mj_header endRefreshing];
        
        [self.myCollectionView ly_endLoading];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        [self.myCollectionView.mj_header endRefreshing];

        [self.myCollectionView ly_endLoading];

        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getNewData];


        }];

    }];
    
    
}

//获取更多商品
-(void)getMoreData{
    
       
    self.currentPage += 1;
    
    /*
    orderType    integer($int32)
    排序 0-按销量 1-综合排序

    pageNo    integer($int32)
    页码

    pageSize    integer($int32)
    每页条数
     */
    
    
    NSDictionary *dic = @{
        
        
        @"classify":self.classifyModel.classifyId,

        @"pageNo":@(self.currentPage),
        
        @"pageSize":@(10),
        
        @"isMainGoods":@(YES)
        
    };
    
    
    [self.searchDic addEntriesFromDictionary:dic];
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_goods_search parameters:self.searchDic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"首页商品：%@",[responseObject description]);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObjectModel.data[@"dataList"];
             
             for (NSDictionary *dic in dataArr) {
                 
                 XMFHomeGoodsCellModel *model = [XMFHomeGoodsCellModel yy_modelWithDictionary:dic];
                 
                 [self.dataSourceArr addObject:model];
             }
             
            
            //判断数据是否已经请求完了
            if (dataArr.count < 10) {
                
                [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                [self.myCollectionView.mj_footer endRefreshing];
                
            }
             
            [self.myCollectionView reloadData];

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
            [self.myCollectionView.mj_footer endRefreshing];

        }
    
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myCollectionView.mj_footer endRefreshing];
        
        [hud hideAnimated:YES];

        
    }];
    
    
}


//获取商品数量
-(void)getCartNum{
    
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_cart_num parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品数量：%@",responseObject);
        
        
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


/*
//获取商品规格
-(void)getGoodsSpecification:(NSString *)goodsId doctorCell:(XMFHomeDoctorCell *)cell goodsName:(NSString *)name isAdd:(BOOL)isAdd{
    
    
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
            
            
            if (isAdd) {//加购物车
                
                //再区分多规格与否
                if (model.goodsProducts.count == 1) {
                    
                    
                    [self getCartAdd:[model.goodsProducts firstObject] goodsNum:@"1" doctorCell:cell isAdd:isAdd];
                    
                    
                }else{
                    
                    XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                    
                    typeView.propertyModel = model;
                    
                    typeView.selectGoodsTypeBlock = ^(XMFHomeGoodsPropertyProductsModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                        
                        [self getCartAdd:productModel goodsNum:selectedGoodCount doctorCell:cell isAdd:isAdd];
                        
                    };
                    
                    [typeView show];
                    
                }
                
                
                
                
            }else{//减购物车
                
                //再区分多规格与否
                if (model.goodsProducts.count == 1) {
                    
                    
                    [self getCartAdd:[model.goodsProducts firstObject] goodsNum:@"-1" doctorCell:cell isAdd:isAdd];
                    
                    
                }else{
                    //跳转到购物车
                    XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
                    
                    //防止tabbar位置变动，遍历子控制器并选中
                    for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                        
                        UIViewController *firstVc = navVc.viewControllers[0];
                        
                        if ([firstVc  isKindOfClass:[XMFShoppingCartViewController class]]) {
                            
                            NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                            
                            tabBarVc.selectedIndex = index;
                            
                        }
                        
                        
                    }
                    
                   
                }
                
                
            }
        
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
}*/


//添加或者减少购物车
-(void)getCartAdd:(NSString *)productId goodsNum:(NSString *)numStr doctorCell:(XMFHomeDoctorCell *)cell isAdd:(BOOL)isAdd{

    //购物车增加就传入增加的数量，减就传-1
    
    NSDictionary *dic = @{
        
        @"num":numStr,
        @"productId":productId,
        @"returnCartInfo":@(YES)
    };
    
    NSIndexPath *addIndexPath = [self.myCollectionView indexPathForCell:cell];


//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物车加数量：%@",responseObject);
        
//        [hud hideAnimated:YES];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            //刷新添加的商品
            XMFHomeGoodsCellModel *model = self.dataSourceArr[addIndexPath.row];
            
            model.cartNum = [NSString stringWithFormat:@"%zd",[model.cartNum integerValue] + [numStr integerValue]];
            
            
            [self.myCollectionView reloadItemsAtIndexPaths:@[addIndexPath]];
            
            
            if (isAdd) {
                //只有添加才加提示语
                
                [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            }
            

            
//            [self getCartNum];
            
            //发送通知告诉购物车刷新
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            
            //发送通知商品列表刷新（object把self自己传递出去）
            KPostNotification(KPost_HomeSonVc_Notice_HomeSonVc_Refresh, self, @{@"name":self.classifyModel.name})
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];

    }];
    

}


//2.1版本：获取规格相关信息
-(void)getGoodsSpecInfo:(NSString *)goodsId doctorCell:(XMFHomeDoctorCell *)cell button:(UIButton *)button indexPath:(NSIndexPath *)indexPath isAdd:(BOOL)isAdd{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail_specInfo parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品规格：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFHomeGoodsCellModel *selectedModel = self.dataSourceArr[indexPath.item];
            
            if ([responseObject[@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"] isEqual:[NSNull null]]) {
                
               //先对数据进行一次判空，避免出现商品不是上架状态的异常状态
                                
                if (isAdd) {
                    //数据为空加的时候
                    
                    [self getCartAdd:selectedModel.productId goodsNum:@"1" doctorCell:cell isAdd:isAdd];
                    
                }else{
                    
                    //数据为空减的时候
                    
                    [self getCartAdd:selectedModel.productId goodsNum:@"-1" doctorCell:cell isAdd:isAdd];
                }
                

                
            }else{
                
                if (isAdd) {
                    //多规格加的时候
                    
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
                    
                    
//                    typeView.detailModel = self.detailModel;
                    
                    //每次都需要重新创建防止数据重用
                    self.selectGoodsTypeView = typeView;
                    
                    
                    [self getGoodsDetail:selectedModel.goodsId];
                    
                    typeView.selectGoodsSpecInfoBlock = ^(NSString * _Nonnull goodsId, NSString * _Nonnull selectedGoodCount) {
                        
                        
//                        [self getCartAdd:self.detailModel.productId goodsNum:selectedGoodCount button:button indexPath:indexPath];
                        
                        [self getCartAdd:self.detailModel.productId goodsNum:selectedGoodCount doctorCell:cell isAdd:isAdd];
                        
                        
                    };
                    
                    

                    
                    
                    [typeView show];
                    
                    
                }else{
                    
                    //多规格减的时候,跳转到购物车
                    XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
                    
                    //防止tabbar位置变动，遍历子控制器并选中
                    for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                        
                        UIViewController *firstVc = navVc.viewControllers[0];
                        
                        if ([firstVc  isKindOfClass:[XMFShoppingCartViewController class]]) {
                            
                            NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                            
                            tabBarVc.selectedIndex = index;
                            
                        }
                        
                        
                    }
                    
                   
                }
                
                
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




#pragma mark - ——————— 回到顶部 ————————
- (void)backScrollToTop{
    
//    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [self.myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    

}


#pragma mark - ——————— 懒加载 ————————

-(NSMutableDictionary *)searchDic{
    
    if (_searchDic == nil) {
        _searchDic = [[NSMutableDictionary alloc] init];
    }
    return _searchDic;
    
    
}


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
