//
//  XMFHomeViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeViewController.h"
#import "SGPagingView.h"//标题滚动视图
#import "XMFHomeSonViewController.h"//子控制器
#import "XMFHomeHeaderView.h"//头部视图
#import "XMFSacanViewController.h"//扫一扫
#import "XMFGoodsClassifyModel.h"//商品分类的model
#import "XMFSearchViewController.h"//搜索界面
#import "XMFMilkTypeGoodsTipsView.h"//奶粉提示弹窗




@interface XMFHomeViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate,XMFHomeHeaderViewDelegate>

//滚动文字view
@property (nonatomic, strong) SGPageTitleView *pageTitleView;

//页面内容view
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@property (nonatomic, strong) XMFHomeHeaderView *headerView;

//商品分类的数据数组
@property (nonatomic, strong) NSMutableArray <XMFGoodsClassifyModel *>*goodsClassifyArr;

//商品分类的名称数组
@property (nonatomic, strong) NSMutableArray<NSString *> *goodsClassifyTitleArr;

//奶粉弹窗
@property (nonatomic, strong) XMFMilkTypeGoodsTipsView *    milkTipsView;


@property (nonatomic, copy) NSString *name;



@end

@implementation XMFHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];


}


-(void)setupUI{
    
    self.topBgViewbgColor = UIColorFromRGB(0xF7CF20);
          
    self.noneBackNaviTitle = @" ";

    
//    [self setupPageView];
    
    kWeakSelf(self)
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"暂无相关数据")
                                                          btnTitleStr:@"点击重试"
                                                        btnClickBlock:^{
        
                            [weakself getAllGoodsClassify];
                                                                }];
    
    emptyView.autoShowEmptyView = NO;
    
    
    self.view.ly_emptyView = emptyView;
    
    
    //先获取商品类型
    [self getAllGoodsClassify];
    
    
    //先判断是否在登陆状态
    if (UserInfoModel.token.length > 0) {
        
          [self getGoodscount];
        
    }
    
    
    //只有当没有数据的时候才请求
    if (![AddressManager isContainsAddressInfo]) {
        
         [self getRegionTree];
    }
    
    
    //接收商品列表发送刷新页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsListNoticeRefresh:) name:KPost_HomeSonVc_Notice_HomeSonVc_Refresh object:nil];
    
    //接收登录状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    //接收页面滚动的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShow:) name:KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow object:nil];
    
    //检测更新
    [[ZFAppUpdateManager sharedManager] checkAppUpdate:UpdateAuto];
    
}




//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - ——————— 接收通知 ————————

//列表刷新
-(void)goodsListNoticeRefresh:(NSNotification *)info{
    
    
    [self getGoodscount];
    
    
}

//页面滚动
-(void)isShow:(NSNotification *)info{
    
    BOOL isShow = [info.object boolValue];
    
    
    self.pageTitleView.hidden = isShow;
    
    self.headerView.hidden = !isShow;
    
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    
    BOOL loginSuccess = [notification.object boolValue];
    
    
    if (loginSuccess) {
        
       [self getGoodscount];
        
        //只有当没有数据的时候才请求
        if (![AddressManager isContainsAddressInfo]) {
            
             [self getRegionTree];
        }
        
    }else{
        
         XMFBaseUseingTabarController *tabBarVC = (XMFBaseUseingTabarController *)self.tabBarController;
         AxcAE_TabBarItem *item = tabBarVC.axcTabBar.tabBarItems[GlobalManager.getShoppingCartIndex];
        
         // 为0是否自动隐藏
         item.badgeLabel.automaticHidden = YES;
         
         item.badge =  @"";
        
    }
    
    
}


//创建和设置滚动栏
- (void)setupPageView {
    
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 64;
    } else {
        pageTitleViewY = 88;
    }
    
//    NSArray *titleArr = @[@"母婴", @"美妆", @"数码", @"洗护", @"食品", @"日用"];
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    
    configure.showBottomSeparator = NO;
    configure.indicatorStyle = SGIndicatorStyleFixed;
    configure.indicatorFixedWidth = 16;
    configure.indicatorColor = UIColorFromRGB(0x333333);
    configure.indicatorHeight = 2;
    configure.indicatorCornerRadius = 1;
    configure.indicatorToBottomDistance = 2;
    configure.titleColor = UIColorFromRGBA(0x333333, 0.9);
    configure.titleFont = [UIFont systemFontOfSize:17.f];
    configure.titleSelectedColor = UIColorFromRGB(0x333333);
    configure.titleSelectedFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:17.f];
//     configure.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:17.f];
   
    //防止文字过多的排列问题
    configure.equivalence = NO;
    
    configure.titleAdditionalWidth = 30.f;
    
    
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, kStatusBarHeight, self.view.frame.size.width, 44) delegate:self titleNames:self.goodsClassifyTitleArr configure:configure];
    
    self.pageTitleView.backgroundColor = UIColorFromRGB(0xF7CF20);
    
    [self.view addSubview:_pageTitleView];
    
    //默认隐藏
    self.pageTitleView.hidden = YES;
    
    
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(kStatusBarHeight);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    
    NSMutableArray *childArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.goodsClassifyTitleArr.count; ++i) {
        
//        XMFHomeSonController *homeSonVc = [[XMFHomeSonController alloc] initWithFlowLayoutType:allGoodsType];
        
        XMFHomeSonViewController *homeSonVc = [[XMFHomeSonViewController alloc]initWithClassifyModel:self.goodsClassifyArr[i]];
        
        kWeakSelf(self)
        
        homeSonVc.headerViewShowBlock = ^(BOOL isShow) {
          
//            weakself.pageTitleView.hidden = isShow;
            
//            weakself.headerView.hidden = !isShow;
            
            //滚动与否
//            weakself.pageContentScrollView.isScrollEnabled = !isShow;
            
            
        };
        
        //刷新的block
        homeSonVc.refreshBlock = ^{
            
            [weakself getAllGoodsClassify];
            
        };
        
        
        [childArr addObject:homeSonVc];
        
    }
    
    /*
    XMFHomeSonViewController *oneVC = [[XMFHomeSonViewController alloc] init];
    XMFHomeSonViewController *twoVC = [[XMFHomeSonViewController alloc] init];
    XMFHomeSonViewController *threeVC = [[XMFHomeSonViewController alloc] init];
    XMFHomeSonViewController *fourVC = [[XMFHomeSonViewController alloc] init];
    XMFHomeSonViewController *fiveVC = [[XMFHomeSonViewController alloc] init];
    XMFHomeSonViewController *sixVC = [[XMFHomeSonViewController alloc] init];
   
    NSArray *childArr = @[oneVC, twoVC, threeVC, fourVC, fiveVC, sixVC];
     */
     
     
    /// pageContentScrollView
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    _pageContentScrollView.isAnimated = YES;
    
    //滚动与否
    self.pageContentScrollView.isScrollEnabled = NO;
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
   
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
    
    if ([self.goodsClassifyTitleArr[selectedIndex] isEqualToString:@"奶粉"]) {
        
        XMFGoodsClassifyModel *classifyModel = self.goodsClassifyArr[selectedIndex];
        
        //去掉H5的||换行符
        classifyModel.desc = [classifyModel.desc stringByReplacingOccurrencesOfString:@"||" withString:@""];
        
        
        self.milkTipsView.descTxw.text = classifyModel.desc;
        
        [self.milkTipsView show];
    }
}

- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

/// 说明：1、这里的处理是为了滚动过程中（手指未离开屏幕）点击标题再滚动造成标题与内容短暂的不一致
/// 说明：2、了解了一下市场上的 app，大致分为二种情况：一种是滚动过程中标题可以点击（网易新闻、今日头条）；另一种是滚动过程中标题不可以点击（贝贝、汽车之家）
/// 说明：3、淘宝->微淘界面（带动画）也会存在这种情况但相对来说比我处理得好；所以我只能让动画与说明：2、的后一种情况相结合来做处理（美其名也：为了用户体验）
- (void)pageContentScrollViewWillBeginDragging {
    
    _pageTitleView.userInteractionEnabled = NO;
}

- (void)pageContentScrollViewDidEndDecelerating {
    
    _pageTitleView.userInteractionEnabled = YES;
}


#pragma mark - ——————— XMFHomeHeaderView的代理方法 ————————

-(void)buttonsOnXMFHomeHeaderViewDidClick:(XMFHomeHeaderView *)headerView button:(UIButton *)button{
    
    switch (button.tag) {
        case 0:{//扫一扫
            
            XMFSacanViewController  *VCtrl = [[XMFSacanViewController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 1:{//搜索
            
             XMFSearchViewController *VCtrl = [[XMFSearchViewController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
           
           
            
        }
            break;
        case 2:{//个人中心
            
            XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
            
            //防止tabbar位置变动，遍历子控制器并选中
            for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
        
                UIViewController *firstVc = navVc.viewControllers[0];
            
                if ([firstVc  isKindOfClass:[XMFMineViewController class]]) {
                    
                    NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                    
                    tabBarVc.selectedIndex = index;
                    
                }
                
                
            }
            
           
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
}



#pragma mark - ——————— 网络请求 ————————

//获取所有商品分类
-(void)getAllGoodsClassify{

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_classify_all parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"获取所有商品分类:%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            //删除所有数据
            [self.goodsClassifyTitleArr removeAllObjects];
            
            [self.goodsClassifyArr removeAllObjects];
            
            
            NSArray *itemsArr = responseObjectModel.data[@"items"];
            
            //人工加入全部
            [self.goodsClassifyTitleArr addObject:@"全部"];
            
            XMFGoodsClassifyModel *allTypeModel = [[XMFGoodsClassifyModel alloc]init];
            
            allTypeModel.classifyId = @"";
            
            allTypeModel.name = @"全部";
            
            [self.goodsClassifyArr addObject:allTypeModel];
            
            
            for (NSDictionary *dict in itemsArr) {
                
                XMFGoodsClassifyModel *model = [XMFGoodsClassifyModel yy_modelWithDictionary:dict];
                
                [self.goodsClassifyTitleArr addObject:model.name];
                
                [self.goodsClassifyArr addObject:model];
            }
            
            [self.view ly_hideEmptyView];
            
            //获取首页数据
//            [self getHomeIndex];
            
            //设置标题滚动栏
            [self setupPageView];
            
            
            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
            
            //当占位图在的时候就不显示了
            if (!self.view.ly_emptyView.isHidden) {
                
                 [self.view ly_showEmptyView];
            }

        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        //当占位图在的时候就不显示了
         if (!self.view.ly_emptyView.isHidden) {
             
              [self.view ly_showEmptyView];
         }
        
    }];

    
    

}


//首页请求
-(void)getHomeIndex{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_home_index parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"首页数据：%@",[responseObject description]);
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
        
    }];
    
    
}

//购物车商品总数:设置购物车的未读数
-(void)getGoodscount{
    
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_cart_goodscount parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物车商品总数：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSString *goodsCountStr = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
            XMFBaseUseingTabarController *tabBarVC = (XMFBaseUseingTabarController *)self.tabBarController;
            AxcAE_TabBarItem *item = tabBarVC.axcTabBar.tabBarItems[GlobalManager.getShoppingCartIndex];
           
            // 为0是否自动隐藏
            item.badgeLabel.automaticHidden = YES;
            
            //防止数量小于等于0
            if ([goodsCountStr integerValue] <= 0) {
                
                goodsCountStr = @"";
            }
            
            item.badge = goodsCountStr;
            
            
            
            
            /*
            //获取购物车控制器
               XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
               
               //防止tabbar位置变动，遍历子控制器并选中
               for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                   
                   UIViewController *firstVc = navVc.viewControllers[0];
                   
                   if ([firstVc  isKindOfClass:[XMFShoppingCartController class]]) {
                       
                      
                       navVc.tabBarItem.badgeValue = [goodsCountStr integerValue] <= 0 ? nil: goodsCountStr;
                       
                       
                   }
                   
                   
               }
             */
            
           
            
        }else{
            
            [MBProgressHUD showOnlyTextToView:self.view title:responseObjectModel.kerrmsg];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
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

#pragma mark - ——————— 判断两个数组是否相同 ————————

- (BOOL)array:(NSArray *)array1 isEqualTo:(NSArray *)array2 {
    if (array1.count != array2.count) {
        return NO;
    }
    for (NSString *str in array1) {
        if (![array2 containsObject:str]) {
            return NO;
        }
    }
    return YES;
    
}


#pragma mark - ——————— 懒加载 ————————


-(NSMutableArray<NSString *> *)goodsClassifyTitleArr{
    
    if (_goodsClassifyTitleArr == nil) {
        _goodsClassifyTitleArr = [[NSMutableArray alloc] init];
    }
    return _goodsClassifyTitleArr;
    
}

-(NSMutableArray<XMFGoodsClassifyModel *> *)goodsClassifyArr{
    
    if (_goodsClassifyArr == nil) {
        _goodsClassifyArr = [[NSMutableArray alloc] init];
    }
    return _goodsClassifyArr;
    
    
}

-(XMFHomeHeaderView *)headerView{
    
    if (_headerView == nil) {
        
        _headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFHomeHeaderView class]) owner:nil options:nil] firstObject];
        _headerView.delegate = self;
    }
    return _headerView;
    
    
}


-(XMFMilkTypeGoodsTipsView *)milkTipsView{
    
    if (_milkTipsView == nil) {
        _milkTipsView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFMilkTypeGoodsTipsView class]) owner:nil options:nil] firstObject];;
    }
    return _milkTipsView;
    
    
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
