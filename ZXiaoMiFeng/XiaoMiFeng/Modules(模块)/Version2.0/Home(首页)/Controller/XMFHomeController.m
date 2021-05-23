//
//  XMFHomeController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/20.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeController.h"
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFHomeAllGoodsCell.h"//首页推荐cell
#import "XMFHomePartGoodsCell.h"//子分类cell
#import "XMFGoodsDetailViewController.h"//商品详情
#import "XMFHomeGoodsCellModel.h"//商品cell的model
#import "XMFGuidePageView.h"//引导页
#import "XMFHomeSearchController.h"//搜索
#import "XMFSelectGoodsTypeView.h"//商品属性弹框
#import "XMFHomeSearchResultController.h"//搜索结果页
#import "XMFHomeGoodsPropertyModel.h"//商品属性的model
#import "XMFHomeGoodsAdModel.h"//首页轮播图广告model
#import "XMFHomeGoodsClassifyModel.h"//商品分类model
#import "XMFHomeGoodsClassifyCell.h"//商品分类的cell
#import "XMFThemeDetailController.h"//专题详情
#import "XMFLoginRemindView.h"//登录提醒view
#import "XMFGoodsSpecInfoModel.h"//商品规格model
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model




//布局的结构体
typedef enum : NSUInteger {
    twoCellsLayout,
    oneCellLayout,
} layoutType;


@interface XMFHomeController ()<UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout,UIScrollViewDelegate,SDCycleScrollViewDelegate,XMFHomeAllGoodsCellDelegate,XMFHomePartGoodsCellDelegate,XMFSelectGoodsTypeViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


@property (weak, nonatomic) IBOutlet UIView *headerView;


@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

/** 个人中心 */
@property (weak, nonatomic) IBOutlet UIButton *meBtn;

/** 切换按钮 */
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;


/** 轮播图 */
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

/** 轮播图的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cycleScrollViewHeight;


/** 商品分类collectionview */
@property (weak, nonatomic) IBOutlet UICollectionView *classifyCollectionView;

/** 分类的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *classifyCollectionViewHeight;


/** 商品分类collectionview的布局 */
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *classifyFlowLayout;

/** 全部商品collectionview */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

/** 全部商品collectionview的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;

/** 全部商品collectionview的布局 */
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *flowLayout;


/** 布局类型 */
@property (nonatomic, assign) layoutType type;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsCellModel *> *dataSourceArr;

/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

/** 商品分类数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsClassifyModel *> *goodsClassifyArr;


/** 回到顶部按钮 */
@property (nonatomic, strong) UIButton *backTopBtn;

/** 轮播图的内容数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsAdModel *> *goodsAdArr;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;


/** 登录提醒view */
@property (nonatomic, strong) XMFLoginRemindView *loginRemindView;


/** 商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;

/** 商品规格弹窗 */
@property (nonatomic, strong) XMFSelectGoodsTypeView *selectGoodsTypeView;


/** 启动图 */
@property (nonatomic, strong) XMFGuidePageView *pageView;



@end

@implementation XMFHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}


-(void)setupUI{
    
    //防止设置了myScrollView顶到状态栏但是没到的问题
    if (@available(iOS 11.0, *)) {
        
        self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
        self.myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    //添加启动图
    [kAppWindow addSubview:self.pageView];
    
    //获取引导页启动图
    [self getStartPage];
    

    //设置cell的高度
    if (self.type == twoCellsLayout) {
        
        self.cellHeight = 1.44 *(KScreenW/2.0);
        
    }else{
        
         self.cellHeight = 137;
    }
    

    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
      //    self.flowLayout.headerHeight = 15;
      //    self.flowLayout.footerHeight = 10;
      self.flowLayout.minimumColumnSpacing = 10;
      self.flowLayout.minimumInteritemSpacing = 10;
      self.flowLayout.columnCount = 2;
      
      self.myCollectionView.collectionViewLayout = self.flowLayout;
      
      self.myCollectionView.backgroundColor = UIColorFromRGB(0xF2F2F2);
          
      self.myCollectionView.delegate = self;
      
      self.myCollectionView.dataSource = self;
      
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeAllGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class])];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomePartGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomePartGoodsCell class])];
    
    
    self.myCollectionView.scrollEnabled = NO;
    
    self.myCollectionView.showsVerticalScrollIndicator = NO;
    
    
    
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
    
   
    
    kWeakSelf(self)
    
    self.myScrollView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
               
        [weakself getGoodsAdList];
        
        [weakself getGoodsClassify];
        
        [weakself getNewData];

        
    }];
    
    self.myScrollView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself getMoreData];
        
    }];
    
    
    self.myScrollView.delegate = self;
    
    
    
    //轮播图
    self.cycleScrollView.delegate = self;
    
    self.cycleScrollView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    //当前分页控件小图标颜色
    
    self.cycleScrollView.currentPageDotColor = UIColorFromRGB(0xF7CF20);
    
    //其他分页控件小图标颜色
    
    self.cycleScrollView.pageDotColor = UIColorFromRGBA(0xFFFFFF, 0.5);
    
    //自动滚动时间间隔,默认2s
    
    self.cycleScrollView.autoScrollTimeInterval = 3;
    
    //是否自动滚动, 默认YES
    
    self.cycleScrollView.autoScroll = YES;
    
    //占位图
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"icon_common_placeRect"];
    
    //轮播图片的ContentMode, 默认为UIViewContentModeScaleToFill
    
     self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    //是否无限循环,默认YES: 滚动到第四张图就不再滚动了
    
    self.cycleScrollView.infiniteLoop = YES;
    
    
    self.cycleScrollView.pageControlBottomOffset = 50;
    
    
    //设置商品分类collectionview
    self.classifyCollectionView.collectionViewLayout = self.classifyFlowLayout;
    self.classifyCollectionView.delegate = self;
    
    self.classifyCollectionView.dataSource = self;
    
    [self.classifyCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeGoodsClassifyCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeGoodsClassifyCell class])];
    
    self.classifyCollectionView.scrollEnabled = NO;
    
    self.classifyCollectionView.showsVerticalScrollIndicator = NO;
    
        
    [self getGoodsAdList];
    
    [self getGoodsClassify];
    
    [self getNewData];

    
    //先判断是否在登陆状态
    if (UserInfoModel.token.length > 0) {
        
//          [self getCartNum];
        
    }
    
    
    //每次都请求防止后台会修改数据
    [self getRegionTree];
    
    
    //接收购物车发送刷新页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewData) name:KPost_CartVc_Notice_HomeVc_Refesh object:nil];
    
    //接收登录状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    
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
    
    
    //检测更新
    [[ZFAppUpdateManager sharedManager] checkAppUpdate:UpdateAuto];
      
    
    //登录提醒view
    [self.view addSubview:self.loginRemindView];
    self.loginRemindView.hidden = UserInfoModel.token;
    [self.loginRemindView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(self.view).offset(0);
        make.height.mas_equalTo(44);
        
        //适配不同版本的iOS系统
        if (@available(iOS 11.0, *)) {
            
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
            
        } else {
            // Fallback on earlier versions
            
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);
        }
        
        
    }];

}

//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    [self.searchBtn cornerWithRadius:self.searchBtn.height/2.0];
    
    
    [self.classifyCollectionView cornerWithRadius:19.f];
    
 
    
}

//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//个人中心
            
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
            
        case 1:{//搜索
            
            XMFHomeSearchController  *VCtrl = [[XMFHomeSearchController alloc]init];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 2:{//切换
            
            sender.selected = !sender.selected;
            
            if (sender.selected) {
                
                self.type = oneCellLayout;
                
                self.flowLayout.columnCount = 1;
                
                self.cellHeight = 137;
                
                //计算高度
                self.myCollectionViewHeight.constant = self.dataSourceArr.count  * self.cellHeight;
                
            }else{
                
                self.type = twoCellsLayout;
                
                self.flowLayout.columnCount = 2;
                
                self.cellHeight = 1.44 *(KScreenW/2.0);
                
                //计算高度
                self.myCollectionViewHeight.constant = ((self.dataSourceArr.count - 1)/2 + 1) * (self.cellHeight + 10);
            }
            

            
            [self.myCollectionView reloadData];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    
    
    BOOL loginSuccess = [notification.object boolValue];
    
    self.loginRemindView.hidden = loginSuccess;
    
    //防止登录状态改变加入购物车红点
    [self getNewData];
    
}



#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == self.classifyCollectionView) {
        
        return self.goodsClassifyArr.count;
        
    }else{
        
        return self.dataSourceArr.count;

    }
    
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (collectionView == self.classifyCollectionView) {
        
        XMFHomeGoodsClassifyCell *classifyCell = (XMFHomeGoodsClassifyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeGoodsClassifyCell class]) forIndexPath:indexPath];
        

        classifyCell.classifyModel = self.goodsClassifyArr[indexPath.item];
        
        
        return classifyCell;
        
        
        
    }else{
        
        
        if (self.type == twoCellsLayout) {
               
               XMFHomeAllGoodsCell *allGoodsCell = (XMFHomeAllGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class]) forIndexPath:indexPath];
               
               allGoodsCell.cellItem = indexPath.item;
               
               allGoodsCell.recommendModel = self.dataSourceArr[indexPath.item];
               
               allGoodsCell.delegate = self;
               
               
               return allGoodsCell;
               
           }else{
               
               XMFHomePartGoodsCell *partGoodsCell = (XMFHomePartGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomePartGoodsCell class]) forIndexPath:indexPath];
               
               partGoodsCell.cellItem = indexPath.item;
               
               partGoodsCell.model = self.dataSourceArr[indexPath.item];
               
               partGoodsCell.delegate = self;
               
               return partGoodsCell;
               
           }
        
    }
    
       
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.classifyCollectionView) {
        
        
        XMFHomeGoodsClassifyModel *classifyModel = self.goodsClassifyArr[indexPath.item];
        
        
        if ([classifyModel.type isEqualToString:@"1"]) {
            
            
            //小蜜蜂产品
            XMFProductViewController  *productVC = [[XMFProductViewController alloc]init];
            
            
            productVC.urlStr = @"https://dc.xmfstore.com/dingzuo-h5/#/home";
            
            XMFBaseNavigationController *productNaviVc = [[XMFBaseNavigationController alloc]initWithRootViewController:productVC];
            
            //模态的方式铺满全屏
            productNaviVc.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:productNaviVc animated:YES completion:nil];
            
            
        }else{
            
            XMFHomeSearchResultController  *VCtrl = [[XMFHomeSearchResultController alloc]initWithKeyword:nil classifyModel:classifyModel searchFromType:fromThemeItem];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
        }
 
        
    }else{
        
         
        XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
        
        XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:model.goodsId];
        
        [self.navigationController pushViewController:VCtrl animated:YES];
    }
    
    
}

#pragma mark - ——————— CHTCollectionViewDelegateWaterfallLayout ————————

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.classifyCollectionView) {
        
        
        return CGSizeMake(self.classifyCollectionView.width/self.classifyFlowLayout.columnCount, 0.27 * self.classifyCollectionView.width);
        
        
    }else{
        
        if (self.type == twoCellsLayout) {
            
            return CGSizeMake((KScreenW - 30)/2.0, self.cellHeight);
            
        }else{
            
            return CGSizeMake(KScreenW - 20, self.cellHeight);
            
        }
        
    }
    
}


#pragma mark - ——————— XMFHomeAllGoodsCell的代理方法 ————————

-(void)buttonsOnXMFHomeAllGoodsCellDidClick:(XMFHomeAllGoodsCell *)cell button:(UIButton *)button{
    

    NSIndexPath *selectedIndexPath = [self.myCollectionView indexPathForCell:cell];

    
//    [self getGoodsSpecification:cell.recommendModel.goodsId button:button goodsName:cell.recommendModel.goodsName indexPath:selectedIndexPath];
    
    //先判断是否是组合商品
    if (cell.recommendModel.isGroupGoods) {
        
        
        [self getGoodsSpecInfo:cell.recommendModel.goodsId button:button indexPath:selectedIndexPath];
        
        
    }else{
        
        
        [self getCartAdd:cell.recommendModel.productId goodsNum:@"1" button:button indexPath:selectedIndexPath];
        
    }

    
}


#pragma mark - ——————— XMFHomePartGoodsCell的代理方法 ————————
-(void)buttonsOnXMFHomePartGoodsCellDidClick:(XMFHomePartGoodsCell *)cell button:(UIButton *)button{

    NSIndexPath *selectedIndexPath = [self.myCollectionView indexPathForCell:cell];

    
//    [self getGoodsSpecification:cell.model.goodsId button:button goodsName:cell.model.goodsName indexPath:selectedIndexPath];

    
    //先判断是否是组合商品
    if (cell.model.isGroupGoods) {
        
        
        [self getGoodsSpecInfo:cell.model.goodsId button:button indexPath:selectedIndexPath];
        
        
    }else{
        
        
        [self getCartAdd:cell.model.productId goodsNum:@"1" button:button indexPath:selectedIndexPath];
        
    }
    
    
}


#pragma mark - ——————— XMFSelectGoodsTypeView的代理方法 ————————

//规格点击的方法
-(void)selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView goodsId:(NSString *)goodsId{
    
    [self getGoodsDetail:goodsId];
    
}



#pragma mark - ——————— scrollView的代理方法 ————————

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 计算当前偏移位置
    CGFloat offsetY = scrollView.contentOffset.y;
 
    CGFloat alpha = offsetY / self.headerView.height;
       
    if (alpha >= 1.0) {
        
        alpha = 1.0;
        
    }
        
    [self.headerView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:alpha]];
    
    if (alpha <= 0) {
        
        [self.meBtn setImage:[UIImage imageNamed:@"icon_shouye_wode1"] forState:UIControlStateNormal];
        
        [self.switchBtn setImage:[UIImage imageNamed:@"icon_shouye_qiehuan11"] forState:UIControlStateNormal];
        [self.switchBtn setImage:[UIImage imageNamed:@"icon_shouye_qiehuan12"] forState:UIControlStateSelected];
        
        
    }else{
       
        [self.meBtn setImage:[UIImage imageNamed:@"icon_shouye_wode2"] forState:UIControlStateNormal];
        
        [self.switchBtn setImage:[UIImage imageNamed:@"icon_shouye_qiehuan21"] forState:UIControlStateNormal];
        [self.switchBtn setImage:[UIImage imageNamed:@"icon_shouye_qiehuan22"] forState:UIControlStateSelected];
        
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


#pragma mark - ——————— SDCycleScrollView的代理方法 ————————
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    //轮播图点击
    XMFHomeGoodsAdModel *adModel = self.goodsAdArr[index];
    
    if (adModel.topicId.length > 0){//先判断有专题id
            
//    if (![adModel.topicId nullToString]){//先判断有专题id
        
        XMFThemeDetailController  *VCtrl = [[XMFThemeDetailController alloc]initWithTopicId:adModel.topicId];
        
        [self.navigationController pushViewController:VCtrl animated:YES];
        
    
    }else if (adModel.link.length > 0){//再判断有没有链接
        
        XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
        
        VCtrl.titleStr = XMFLI(@"专题详情");
        
        VCtrl.urlStr = adModel.link;
        
        
        [self.navigationController pushViewController:VCtrl animated:YES];
        
    }
    
}

#pragma mark - ——————— 回到顶部 ————————
- (void)backScrollToTop
{
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - ——————— 网络请求 ————————

//获取顶部轮播图
-(void)getGoodsAdList{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_ad_list parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"轮播图：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObject[@"data"];
            
            NSMutableArray *urlArr = [[NSMutableArray alloc]init];
            
            [self.goodsAdArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFHomeGoodsAdModel *adModel = [XMFHomeGoodsAdModel yy_modelWithDictionary:dic];
                
                [urlArr addObject:adModel.url];
                
                [self.goodsAdArr addObject:adModel];
                
            }
            
            //获取图片尺寸
            CGSize banerImgSize = [UIImage getImageSizeWithURL:[NSURL URLWithString:[urlArr firstObject]]];
            
            //防止被除数为0导致闪退
            if (banerImgSize.width > 0) {
                
                
                self.cycleScrollViewHeight.constant = banerImgSize.height/banerImgSize.width * KScreenWidth;
            }
            
            
            self.cycleScrollView.imageURLStringsGroup = urlArr;
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
    
}


//获取商品
-(void)getNewData{
    
    [self.myScrollView.mj_footer endRefreshing];
       
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
        
        @"orderType":@(1),
        
        @"pageNo":@(self.currentPage),
        
        @"pageSize":@(10),
        
        @"isMainGoods":@(YES)
        
    };
    
//    DLog(@"token:%@",UserInfoModel.token);
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self.myCollectionView ly_startLoading];


    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_goods_search parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
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
            

            
            //计算高度
            if (self.type == twoCellsLayout) {
                
//                self.myCollectionViewHeight.constant = ((self.dataSourceArr.count - 1)/2 + 1) * (self.cellHeight + 10);
                
                self.myCollectionViewHeight.constant = ceilf(self.dataSourceArr.count/2)*(self.cellHeight + 10);
                
            }else{
                
                self.myCollectionViewHeight.constant = self.dataSourceArr.count  * (self.cellHeight + 10);
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
        
    
        [self.myScrollView.mj_header endRefreshing];
        
        [self.myCollectionView ly_endLoading];

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
        [hud hideAnimated:YES];

        [self.myScrollView.mj_header endRefreshing];
        
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
        
        @"orderType":@(1),
        
        @"pageNo":@(self.currentPage),
        
        @"pageSize":@(10),
        
        @"isMainGoods":@(YES)
        
    };
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
        
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_goods_search parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"首页商品：%@",[responseObject description]);
        
//        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObjectModel.data[@"dataList"];
             
             for (NSDictionary *dic in dataArr) {
                 
                 XMFHomeGoodsCellModel *model = [XMFHomeGoodsCellModel yy_modelWithDictionary:dic];
                 
                 [self.dataSourceArr addObject:model];
             }
             
            
            //判断数据是否已经请求完了
            if (dataArr.count < 10) {
                
                [self.myScrollView.mj_footer endRefreshingWithNoMoreData];
                
            }else{
                
                [self.myScrollView.mj_footer endRefreshing];
                
            }
             
            [self.myCollectionView reloadData];

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
            [self.myScrollView.mj_footer endRefreshing];

        }
    
        
        //计算高度
        if (self.type == twoCellsLayout) {
            
//            self.myCollectionViewHeight.constant = ((self.dataSourceArr.count - 1)/2 + 1) * (self.cellHeight + 10);
            
            self.myCollectionViewHeight.constant = ceilf(self.dataSourceArr.count/2)*(self.cellHeight + 10);
            
        }else{
            
            self.myCollectionViewHeight.constant = self.dataSourceArr.count  * (self.cellHeight + 10);
            
            
        }
        
    
        
//        self.myCollectionView.contentSize = CGSizeMake(KScreenW, self.myCollectionViewHeight.constant);
        
  
        
        //一定要加这行代码布局，要不然myCollectionView的底部会多出空白区域
        [self.myScrollView layoutIfNeeded];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myScrollView.mj_footer endRefreshing];
        
//        [hud hideAnimated:YES];

        
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



/*
//获取商品规格
-(void)getGoodsSpecification:(NSString *)goodsId button:(UIButton *)button goodsName:(NSString *)name indexPath:(NSIndexPath *)indexPath{

    
    
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
            
            if (model.goodsProducts.count == 1) {
                
                
                XMFHomeGoodsPropertyProductsModel *productModel= [model.goodsProducts firstObject];
                
                if ([productModel.stock integerValue] > 0) {
                    
                    [self getCartAdd:productModel goodsNum:@"1" button:button indexPath:indexPath];

                    
                }else{
                    
                    [MBProgressHUD showError:XMFLI(@"商品库存不足") toView:self.view];
                }
                
                
            }else{
                
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                typeView.propertyModel = model;
                
                typeView.delegate = self;
                
                typeView.selectGoodsTypeBlock = ^(XMFHomeGoodsPropertyProductsModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                    
                    [self getCartAdd:productModel goodsNum:selectedGoodCount button:button indexPath:indexPath];

                    
                };
                
                [typeView show];
                
            }

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
}*/


//添加或者减少购物车
-(void)getCartAdd:(NSString *)productId goodsNum:(NSString *)numStr button:(UIButton *)button indexPath:(NSIndexPath *)indexPath{


    //购物车增加就传入增加的数量，减就传-1
    
    NSDictionary *dic = @{
        
        @"num":numStr,
        @"productId":productId,
        @"returnCartInfo":@(YES)
    };
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"购物车加数量：%@",responseObject);
        
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            button.selected = YES;
            
            
            //一定要处理本地数据防止页面滑动出现复用问题
            XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
            
            model.cartNum = [NSString stringWithFormat:@"%zd",[model.cartNum integerValue] + [numStr integerValue]];
            

        
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
//            [self getCartNum];
            
            //发送通知告诉购物车刷新
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
        [hud hideAnimated:YES];

        

    }];
    

}


//获取商品分类
-(void)getGoodsClassify{
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_classify_enable_list parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"商品分类数据：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObject[@"data"];
            
            [self.goodsClassifyArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFHomeGoodsClassifyModel *model = [XMFHomeGoodsClassifyModel yy_modelWithDictionary:dic];
                
                [self.goodsClassifyArr addObject:model];
                
            }
            
            if (self.goodsClassifyArr.count > 0) {
                
                //通过行数计算分类列表的高度
                self.classifyCollectionViewHeight.constant =          ((self.goodsClassifyArr.count - 1)/self.classifyFlowLayout.columnCount + 1) * 0.27 * self.classifyCollectionView.width;
                
            }else{
                
                //防止后台没有数据返回
                self.classifyCollectionViewHeight.constant = 0.f;
            }
            

            
            [self.classifyCollectionView reloadData];
            
            
            
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


//2.1版本：获取规格相关信息
-(void)getGoodsSpecInfo:(NSString *)goodsId button:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail_specInfo parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品规格：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFHomeGoodsCellModel *selectedModel = self.dataSourceArr[indexPath.item];
            
            if ([responseObject[@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"] isEqual:[NSNull null]]) {
               //先对数据进行一次判空，避免出现商品不是上架状态的异常状态
                
//                XMFHomeGoodsCellModel *seletedModel = self.dataSourceArr[indexPath.item];
                
                
                [self getCartAdd:selectedModel.productId goodsNum:@"1" button:button indexPath:indexPath];
                
                
                
            }else{
                
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
                
                
//                typeView.detailModel = self.detailModel;
                
                
                //每次都需要重新创建防止数据重用
                self.selectGoodsTypeView = typeView;
                
                
                [self getGoodsDetail:selectedModel.goodsId];
                
                
                typeView.selectGoodsSpecInfoBlock = ^(NSString * _Nonnull goodsId, NSString * _Nonnull selectedGoodCount) {
                    
                    
                    [self getCartAdd:self.detailModel.productId goodsNum:selectedGoodCount button:button indexPath:indexPath];
                    
                    
                };
                

                
                
                [typeView show];
                
                
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

//获取启动页
-(void)getStartPage{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_startPage_getStartPage parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"启动页面：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            
            //显示引导页
            self.pageView.URLStr = [NSString stringWithFormat:@"%@",responseObject[@"data"]];

            
        }else{
            
            
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}


#pragma mark - ——————— 懒加载 ————————
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

-(NSMutableArray<XMFHomeGoodsClassifyModel *> *)goodsClassifyArr{
    
    if (_goodsClassifyArr == nil) {
        _goodsClassifyArr = [[NSMutableArray alloc] init];
    }
    return _goodsClassifyArr;
}

-(CHTCollectionViewWaterfallLayout *)classifyFlowLayout{
    
    if (_classifyFlowLayout == nil) {
        _classifyFlowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
        _classifyFlowLayout.columnCount = 4;
        _classifyFlowLayout.minimumColumnSpacing = 0;
        _classifyFlowLayout.minimumInteritemSpacing = 0;
        
    }
    return _classifyFlowLayout;
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


-(NSMutableArray<XMFHomeGoodsAdModel *> *)goodsAdArr{
    
    if (_goodsAdArr == nil) {
        _goodsAdArr = [[NSMutableArray alloc] init];
    }
    return _goodsAdArr;
    
}


-(XMFLoginRemindView *)loginRemindView{
    
    kWeakSelf(self)
    
    if (_loginRemindView == nil) {
        _loginRemindView = [XMFLoginRemindView XMFLoadFromXIB];
        _loginRemindView.loginRemindViewTapBlock = ^{
                      
            [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:weakself];
        };
    }
    return _loginRemindView;
}


-(XMFGuidePageView *)pageView{
    
    if (_pageView == nil) {
        _pageView = [XMFGuidePageView xibLoadViewWithFrame:kAppWindow.bounds];
    }
    return _pageView;
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
