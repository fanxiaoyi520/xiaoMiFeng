//
//  XMFHomeSimpleController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeSimpleController.h"
#import "XMFHomeSearchView.h"//顶部搜索框
#import "SGPagingView.h"//标题滚动视图
#import "XMFHomeSonController.h"//子控制器
#import "XMFHomeGoodsClassifyModel.h"//商品分类model
#import "XMFHomeSearchController.h"//搜索
#import "XMFHomeTitleBgView.h"//滚动标题背景view
#import "XMFHomeGoodsFilterView.h"//筛选



#import "UIView+Visibility.h"

@interface XMFHomeSimpleController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate,XMFHomeSearchViewDelegate,XMFHomeSearchViewDelegate,XMFHomeGoodsFilterViewDelegate>

//滚动文字view
@property (nonatomic, strong) SGPageTitleView *pageTitleView;

//页面内容view
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

//顶部搜索框
@property (nonatomic, strong) XMFHomeSearchView *searchView;

/** 滚动标题背景view */
@property (nonatomic, strong) XMFHomeTitleBgView *titleBgView;

/** 筛选view */
@property (nonatomic, strong) XMFHomeGoodsFilterView *filterView;


//子控制器的布局方式
@property (nonatomic, assign) flowLayoutType sonViewLayType;

/** 商品分类数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsClassifyModel *> *goodsClassifyArr;

//商品分类的名称数组
@property (nonatomic, strong) NSMutableArray<NSString *> *goodsClassifyTitleArr;

/** 当前选中标题按钮下标，默认为 0 */
@property (nonatomic, assign) NSInteger titleSelectedIndex;

/** 选中的条件字典 */
@property (nonatomic, strong) NSMutableDictionary *selectedTagDic;


/** 商品分类model */
@property (nonatomic, strong) XMFHomeGoodsClassifyModel *selectedClassifyModel;


@end

@implementation XMFHomeSimpleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self setupUI];
}

-(void)setupUI{
    
    self.topBgViewbgColor = UIColorFromRGB(0xF7CF20);
          
    self.noneBackNaviTitle = @" ";

        
    kWeakSelf(self)
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"暂无相关数据")
                                                          btnTitleStr:@"点击重试"
                                                        btnClickBlock:^{
        
                            [weakself getGoodsClassify];
                                                                }];
    
    emptyView.autoShowEmptyView = NO;
    
    
    self.view.ly_emptyView = emptyView;
    
    
    //先获取商品类型
    [self getGoodsClassify];

    
    //接收页面滚动的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isShow:) name:KPost_HomeSonVc_Notice_HomeVc_SubviewsIsShow object:nil];
    
   
    
    //检测更新
    [[ZFAppUpdateManager sharedManager] checkAppUpdate:UpdateAuto];
    
    
    //每次都请求防止后台会修改数据
    [self getRegionTree];
    
    //先判断是否在登陆状态
    if (UserInfoModel.token.length > 0) {
        
//        [self getCartNum];
        
    }
    
}

//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - ——————— 接收通知 ————————


//页面滚动
-(void)isShow:(NSNotification *)info{
    
    BOOL isShow = [info.object boolValue];
    
//    self.pageTitleView.hidden = isShow;
//
//    self.searchView.hidden = !isShow;
    
   
//    [self.pageTitleView setVisible:isShow animated:YES];
    
    
    [self.titleBgView setVisible:isShow animated:YES];
    
    
    [self.searchView setVisible:!isShow animated:YES];

    
}



//创建和设置滚动栏
- (void)setupPageView {
    
    kWeakSelf(self)
    
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        pageTitleViewY = 64;
    } else {
        pageTitleViewY = 88;
    }
    
//    NSArray *titleArr = @[@"首页推荐",@"母婴", @"美妆", @"数码", @"洗护", @"食品", @"日用"];
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
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 88, 44) delegate:self titleNames:self.goodsClassifyTitleArr configure:configure];
    
    self.pageTitleView.backgroundColor = UIColorFromRGB(0xF7CF20);
    
//    [self.view addSubview:_pageTitleView];
    
    //默认隐藏
//    self.pageTitleView.hidden = YES;
    
    [self.titleBgView addSubview:self.pageTitleView];
    
    [self.view addSubview:self.titleBgView];
    
    //默认隐藏
    self.titleBgView.hidden = YES;
    
    [self.titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
           
           make.top.mas_offset(kStatusBarHeight);
           make.left.mas_offset(0);
           make.right.mas_offset(0);
           make.height.mas_equalTo(44);
           
       }];
    

    
    
    [self.view addSubview:self.searchView];
    
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_offset(kStatusBarHeight);
        make.left.mas_offset(0);
        make.right.mas_offset(0);
        make.height.mas_equalTo(44);
        
    }];
    
    
    NSMutableArray *childArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.goodsClassifyTitleArr.count; ++i) {
        
        
        self.sonViewLayType = doctorType;
        
        
        //如果前面有选中条件把前面选中的条件传入进去
        NSMutableDictionary *selectedTagDic;
        
 
        XMFHomeGoodsClassifyModel *classifyModel = self.goodsClassifyArr[i];
        
        if ([classifyModel.classifyId isEqualToString:self.selectedClassifyModel.classifyId]) {
            
            selectedTagDic = self.selectedTagDic;

        }
        
        
        XMFHomeSonController *homeSonVc = [[XMFHomeSonController alloc] initWithFlowLayoutType:self.sonViewLayType classifyModel:classifyModel selectedTagDic:selectedTagDic];
       
        
        homeSonVc.refreshBlock = ^{
            
            //先获取商品类型
            [weakself getGoodsClassify];
            
        };
        

        [childArr addObject:homeSonVc];
        
    }
    
  

     
     
    /// pageContentScrollView
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - kTopHeight;
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, kTopHeight, self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    _pageContentScrollView.isAnimated = YES;
    
    //滚动与否
    self.pageContentScrollView.isScrollEnabled = NO;
    
}

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    
    //获取选中的标题下标
    self.titleSelectedIndex = selectedIndex;
   
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
    
 
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


#pragma mark - ——————— XMFHomeSearchView的代理方法 ————————
-(void)buttonsOnXMFHomeHeaderViewDidClick:(XMFHomeSearchView *)searchView button:(UIButton *)button{
    
    switch (button.tag) {
        case 0:{//搜索
            
            XMFHomeSearchController  *VCtrl = [[XMFHomeSearchController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            
            break;
            
        case 1:{//个人中心
            
            
            XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
            
            //防止tabbar位置变动，遍历子控制器并选中
            for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
                
                UIViewController *firstVc = navVc.viewControllers[0];
                
                if ([firstVc  isKindOfClass:[XMFMeViewController class]]) {
                    
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

#pragma mark - ——————— XMFHomeGoodsFilterView的代理方法 ————————
-(void)buttonsOnXMFHomeGoodsFilterViewDidClick:(XMFHomeGoodsFilterView *)filterView button:(UIButton *)button selectedDic:(NSMutableDictionary *)selectedTagDic{
    
    DLog(@"选中的index：%zd",self.titleSelectedIndex);
    
    XMFHomeGoodsClassifyModel *classifyModel  = self.goodsClassifyArr[self.titleSelectedIndex];
    
    self.selectedClassifyModel = classifyModel;
    
    self.selectedTagDic = selectedTagDic;
    
    KPostNotification(KPost_HomeSimpleVc_Notice_HomeSonVc_Refresh, nil, (@{@"classifyModel":classifyModel,@"selectedTagDic":selectedTagDic}));

    
}

#pragma mark - ——————— 网络请求 ————————
//获取商品分类
-(void)getGoodsClassify{
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_classify_enable_list parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"商品分类数据：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObject[@"data"];
            
         
            [self getClassifyData:dataArr];
        
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
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



//商品类型数据解析
-(void)getClassifyData:(NSArray *)dataArr{
    
    
    //删除所有数据
    
    [self.goodsClassifyTitleArr removeAllObjects];
    
    [self.goodsClassifyArr removeAllObjects];
    
    
    
    XMFHomeGoodsClassifyModel *allTypeModel = [[XMFHomeGoodsClassifyModel alloc]init];
    
    allTypeModel.classifyId = @"";
    
    allTypeModel.name = @"首页推荐";
    
    
    [self.goodsClassifyArr addObject:allTypeModel];
    
    //人工加入首页推荐
    [self.goodsClassifyTitleArr addObject:allTypeModel.name];
    
    //等待for循环结束
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    
    for (NSDictionary *dic in dataArr) {
        
        
        XMFHomeGoodsClassifyModel *model = [XMFHomeGoodsClassifyModel yy_modelWithDictionary:dic];
        
        /** 类型 0-商品分类 1-跳转链接 */
        if ([model.type isEqualToString:@"0"]) {
            
            [self.goodsClassifyTitleArr addObject:model.name];
            
            [self.goodsClassifyArr addObject:model];
            
            
            dispatch_semaphore_signal(sem);
            
            
        }
        
        
        
    }
    
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        DLog(@"end");
        
        [self.view ly_hideEmptyView];
        
        
        //设置标题滚动栏
        [self setupPageView];
        
    });
    
    
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



#pragma mark - ——————— 懒加载 ————————

/*
-(XMFHomeGoodsFilterView *)filterView{
    
    if (_filterView == nil) {
        _filterView = [XMFHomeGoodsFilterView xibGoodsFilterViewFromType:fromHomeSimpleVc];
        _filterView.frame = CGRectMake(KScreenW, 0, KScreenW, KScreenH);
        _filterView.delegate = self;
        
    }
    return _filterView;
    
    
}*/

-(XMFHomeTitleBgView *)titleBgView{
    
    kWeakSelf(self)
    
    if (_titleBgView == nil) {
        _titleBgView = [XMFHomeTitleBgView XMFLoadFromXIB];
        _titleBgView.filtrateBtnBlock = ^{
            
            weakself.filterView = [XMFHomeGoodsFilterView xibGoodsFilterViewFromType:fromHomeSimpleVc];
            weakself.filterView.frame = CGRectMake(KScreenW, 0, KScreenW, KScreenH);
            weakself.filterView.delegate = weakself;
            
            [weakself.filterView show];
            
        };
    }
    return _titleBgView;
}


-(XMFHomeSearchView *)searchView{
    
    if (_searchView == nil) {
        _searchView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFHomeSearchView class]) owner:nil options:nil] firstObject];
        _searchView.delegate = self;
    }
    return _searchView;
    
}

-(NSMutableArray<XMFHomeGoodsClassifyModel *> *)goodsClassifyArr{
    
    if (_goodsClassifyArr == nil) {
        _goodsClassifyArr = [[NSMutableArray alloc] init];
    }
    return _goodsClassifyArr;
}

-(NSMutableArray<NSString *> *)goodsClassifyTitleArr{
    
    if (_goodsClassifyTitleArr == nil) {
        _goodsClassifyTitleArr = [[NSMutableArray alloc] init];
    }
    return _goodsClassifyTitleArr;
    
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
