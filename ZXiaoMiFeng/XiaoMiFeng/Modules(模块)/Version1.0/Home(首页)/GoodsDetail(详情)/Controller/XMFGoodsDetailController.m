//
//  XMFGoodsDetailController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailController.h"
#import "XMFGoodsDetailHeaderView.h"//顶部view
#import "XMFGoodsDetailFooterView.h"//底部view
#import "WMPageController.h"//悬停
#import "ArtScrollView.h"//配合悬停ScrollView
#import "XMFGoodsParameterController.h"//商品参数
#import "XMFGoodsCommentsController.h"//用户评价
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDatailInfoModel.h"//商品信息的model
#import "XMFGoodsHTMLDetailController.h"//图文详情

#import "XMFChooseGoodsTypeView.h"//商品规格选择弹框
#import "XMFGoodsDatailProductListModel.h"//商品规格总数model
#import "XMFGoodsGuideView.h"//购买说明弹框
#import "XMFGoodsShareQRView.h"//商品分享弹框
#import "XMFGoodsDetailNaviView.h"//顶部导航栏view
#import "XMFGoodsRecommendModel.h"//为你推荐
#import "XMFOrderConfirmController.h"//订单确认



@interface XMFGoodsDetailController ()<UIScrollViewDelegate,WMPageControllerDelegate,WMPageControllerDataSource,XMFGoodsDetailFooterViewDelegate,XMFGoodsDetailHeaderViewDelegate,XMFGoodsDetailNaviViewDelegate>

@property (nonatomic, strong) WMPageController *pageController;

@property (nonatomic, strong) ArtScrollView *containerScrollView;

@property (nonatomic, strong) UIView *contentView;

//顶部view
@property (nonatomic, strong) XMFGoodsDetailHeaderView *headerView;

//底部view
@property (nonatomic, strong) XMFGoodsDetailFooterView *footerView;



//标题数组
@property (nonatomic, strong) NSArray *titlesArr;

@property (nonatomic, assign) BOOL canScroll;

//商品详情
@property (nonatomic, strong) XMFGoodsDatailModel *detailModel;

//顶部导航栏view
@property (nonatomic, strong) XMFGoodsDetailNaviView *naviView;

//为你推荐的数据数组
@property (nonatomic, strong) NSMutableArray<XMFGoodsRecommendModel *> *recommendDataArr;

//规格、加入购物车、立即购买共用弹框
@property (nonatomic, strong) XMFChooseGoodsTypeView *commonTypeView;

//占位图
@property (nonatomic, strong) LYEmptyView *emptyView;

@end

@implementation XMFGoodsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.naviTitle = @"商品详情";
    
    [self setupView];
    
    [self setupViewScroll];
    
    [self getGoodsDetail:self.goodsIdStr];
    
}

//移除通知
-(void)dealloc{

   [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)setupView{
    
    
    kWeakSelf(self)
    
    //初始化一个无数据的emptyView 點擊重試
    self.emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
        
        [weakself getGoodsDetail:weakself.goodsIdStr];
    }];
    
//    emptyView.autoShowEmptyView = YES;
    
    
    self.emptyView.emptyViewIsCompleteCoverSuperView = YES;
    
    
    self.view.ly_emptyView = self.emptyView;
    
    
    
    
    
    //0、添加顶部导航栏view
    [self.view  addSubview:self.naviView];
    
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset(0);
        
        make.leading.trailing.equalTo(self.view).offset(0);
        
        make.height.mas_equalTo(kTopHeight);
        
        
    }];

    
    //1、添加滚动view
    [self.view addSubview:self.containerScrollView];
    
    [self.containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(kTopHeight);
        
        make.leading.trailing.equalTo(self.view).offset(0);
        
        //距离底部安全距离再往上44
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-44);
        
    }];
    
    
    
    //2、添加头部view
    [self.containerScrollView addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.containerScrollView);
        make.width.equalTo(self.containerScrollView);
        //        make.height.mas_equalTo(KHeaderViewHeight);
    }];
    
    
    
    //3、添加内容view
    [self.containerScrollView addSubview:self.contentView];
 
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headerView.mas_bottom);
        make.leading.trailing.bottom.equalTo(self.containerScrollView);
        make.width.equalTo(self.containerScrollView);
//        make.height.mas_equalTo(contentViewHeight);
        
    }];
    
    
    CGFloat contentViewHeight;
      
      contentViewHeight = KScreenHeight - kTopHeight -  44 - kSAFE_AREA_BOTTOM;
    
    //4、内容view添加页面view
    [self.contentView addSubview:self.pageController.view];
    
    
    //    self.pageController.viewFrame = CGRectMake(0, 0, KScreenWidth, contentViewHeight);
    
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView);
        
        make.leading.trailing.equalTo(self.contentView);
        
        make.width.equalTo(self.contentView);
        
        make.height.mas_equalTo(contentViewHeight);
        
        make.bottom.equalTo(self.contentView);
        
    }];
    
    
    /*
    //5、添加为你推荐view
    
    [self.contentView addSubview:self.recommendView];
    
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.pageController.view.mas_bottom);
        
        make.leading.trailing.equalTo(self.contentView);
        
        make.width.equalTo(self.contentView);
        
        make.height.mas_equalTo(200);
        
        make.bottom.equalTo(self.contentView);
        
    }];*/
    
    
    //6、添加底部view
    [self.view addSubview:self.footerView];
    
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(44);
        
        //距离底部安全距离再往上44
        make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        
        
    }];
    
    
    
}

//设置页面滚动相关
-(void)setupViewScroll{
    
    
    _canScroll = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
    
}

#pragma mark - notification

-(void)acceptMsg : (NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        _canScroll = YES;
    }
}


#pragma mark - ——————— WMPageController的代理方法和数据源 ————————

/**
菜单项 个数
*/
-(NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController{
    
    return self.titlesArr.count;
    
}

/**
菜单项 标题
*/
-(NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index{
    
    return self.titlesArr[index];
    
}

/**
菜单项 内容控制器
*/
-(__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index{
    
    kWeakSelf(self)
    
    switch (index) {
        case 0:{//图文详情
            
            XMFGoodsHTMLDetailController  *VCtrl = [[XMFGoodsHTMLDetailController alloc]initWith:self.detailModel recommendData:[self.recommendDataArr mutableCopy]];
            
            //猜你喜欢
            VCtrl.goodsDidTapBlock = ^(XMFGoodsRecommendModel * _Nonnull model) {
                
                [weakself getGoodsDetail:model.goodsId];
                
                //回到顶部
                weakself.canScroll = YES;
                
                [weakself.containerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                
            };
            
            
            return VCtrl;
            
            
        }
            break;
            
        case 1:{//商品参数
            
            XMFGoodsParameterController *VCtrl = [[XMFGoodsParameterController alloc]initWith:self.detailModel recommendData:self.recommendDataArr];
            
            //猜你喜欢
            VCtrl.goodsDidTapBlock = ^(XMFGoodsRecommendModel * _Nonnull model) {
                
                [weakself getGoodsDetail:model.goodsId];
                
                //回到顶部
                weakself.canScroll = YES;
                
                [weakself.containerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                
            };
            
            return VCtrl;
            
            
        }
            break;
            
        default:{
            
            XMFGoodsCommentsController *VCtrl = [[XMFGoodsCommentsController alloc]initWith:self.detailModel recommendData:self.recommendDataArr];
            
            //猜你喜欢
            VCtrl.goodsDidTapBlock = ^(XMFGoodsRecommendModel * _Nonnull model) {
                
                [weakself getGoodsDetail:model.goodsId];
                
                //回到顶部
                weakself.canScroll = YES;
                
                [weakself.containerScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
                
            };
            
            return VCtrl;
        }
            break;
    }
    
    
    
}


/**
菜单视图 frame
*/
-(CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView{
    
    
    return CGRectMake(0, 0, KScreenWidth, 44.f);
    
}




/**
 viewController即将显示时调用
 
 @param pageController pageController
 @param viewController 即将显示的viewController
 @param info 包含index、title
 */
- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    
    DLog(@"%@",NSStringFromClass([viewController class]));
    
    DLog(@"info:%@",info);
    
    
    NSInteger index = [info[@"index"] integerValue];
    
    if (index == 0) {
        
        
    }else if(index == 2){
        
        
        
    }
    
    
    
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat  maxOffsetY = self.headerView.height;
    
    CGFloat offsetY = scrollView.contentOffset.y;
//    self.navigationController.navigationBar.alpha = offsetY/maxOffsetY;
    if (offsetY>=maxOffsetY) {
        scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        //NSLog(@"滑动到顶端");
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeGoTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
        _canScroll = NO;
    } else {
        //NSLog(@"离开顶端");
        if (!_canScroll) {
            scrollView.contentOffset = CGPointMake(0, maxOffsetY);
        }
    }
}

#pragma mark - ——————— XMFGoodsDetailNaviView的代理方法 ————————
-(void)buttonsOnXMFGoodsDetailNaviViewDidClick:(XMFGoodsDetailNaviView *)naviView button:(UIButton *)button{
    
    switch (button.tag) {
        case 0:{//返回
            
            [self popAction];
            
        }
            break;
        case 1:{//详情
            
            self.pageController.selectIndex =  0;
            
             [self.containerScrollView setContentOffset:CGPointMake(0,self.contentView.y) animated:YES];
            
            
            
        }
            break;
        case 2:{//评价
            
            self.pageController.selectIndex =  2;
            
             [self.containerScrollView setContentOffset:CGPointMake(0,self.contentView.y) animated:YES];
        }
            break;
        case 3:{//首页
            
            XMFBaseUseingTabarController *rootVc = (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
            
            rootVc.selectedIndex = 0;
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


#pragma mark - ——————— XMFGoodsDetailHeaderView的代理方法 ————————

//点击手势
-(void)viewsOnXMFGoodsDetailHeaderViewDidTap:(XMFGoodsDetailHeaderView *)headerView view:(UIView *)view{
    
    kWeakSelf(self)
    
    switch (view.tag) {
        case 0:{//规格选择
            
            
//            XMFChooseGoodsTypeView *typeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFChooseGoodsTypeView class]) owner:nil options:nil] firstObject];
            
            
            self.commonTypeView.chooseType = goodsDetailChooseType;
            
            //加入规格
            self.detailModel.specificationsStr = self.headerView.goodsTypeLB.text;
            
            //加入类型
            self.detailModel.goodsChooseType = goodsDetailAddCart;
            
            
            self.commonTypeView.model = self.detailModel;
            
            //确定按钮
            self.commonTypeView.ChooseGoodsTypeBlock = ^(XMFGoodsDatailProductListModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                
                //判断登录状态
                if (UserInfoModel.token.length == 0) {
                    
                    [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:weakself];
                    
                }else{
                    
                    
                    weakself.headerView.productListModel = productModel;
                    
                    [weakself addCartProductModel:productModel goodsCount:selectedGoodCount];
                }
 
                
            };
            
            
            [self.commonTypeView show];
            
           
            
        }
            break;
            
        case 1:{//购买说明
            
            XMFGoodsGuideView *guideView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsGuideView class]) owner:nil options:nil] firstObject];
            
            guideView.detailModel = self.detailModel;
            
            [guideView show];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}


//按钮点击
-(void)buttonsOnXMFGoodsDetailHeaderViewDidClick:(XMFGoodsDetailHeaderView *)headerView button:(UIButton *)button{
    
    
    XMFGoodsShareQRView *shareQRView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsShareQRView class]) owner:nil options:nil] firstObject];
    
    shareQRView.detailModel = self.detailModel;
    
    [shareQRView show];
    
}


//图片点击
-(void)imageViewOnXMFGoodsDetailHeaderView:(XMFGoodsDetailHeaderView *)headerView didSelectItemAtIndex:(NSInteger)index{
    
    
    NSMutableArray *photos = [NSMutableArray new];
  
    [self.detailModel.galleryURLArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
 
        GKPhoto *photo = [GKPhoto new];
      
        photo.url = [NSURL URLWithString:obj];
        
        [photos addObject:photo];
        
        
    }];
    
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    
    browser.showStyle = GKPhotoBrowserShowStyleNone;
   
    browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
    
    [browser showFromVC:self];
    
    
    
    
}

#pragma mark - ——————— XMFGoodsDetailFooterView的代理方法 ————————
-(void)buttonsOnXMFGoodsDetailFooterViewDidClick:(XMFGoodsDetailFooterView *)footerView button:(UIButton *)button{
    
    kWeakSelf(self)
    
    switch (button.tag) {
        case 0:{//客服
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = @"https://im.7x24cc.com/phone_webChat.html?accountId=N000000013029&chatId=6aded8fa-f405-4371-8aba-c982f8fb7f8d";
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        
        }
            break;
        case 1:{//收藏
            
            [self getGoodsCollectAddOrDelete:button];
            
        }
            break;
        case 2:{//加入购物车
            
            
            
//            XMFChooseGoodsTypeView *typeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFChooseGoodsTypeView class]) owner:nil options:nil] firstObject];
                            
            self.commonTypeView.chooseType = goodsDetailAddCart;
            
            //加入规格
            self.detailModel.specificationsStr = self.headerView.goodsTypeLB.text;
            
            //加入类型
            self.detailModel.goodsChooseType = goodsDetailAddCart;
            
            self.commonTypeView.model = self.detailModel;
            
            //选择的商品
            self.commonTypeView.ChooseGoodsTypeBlock = ^(XMFGoodsDatailProductListModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {

                
                //判断登录状态
                if (UserInfoModel.token.length == 0) {
                    
                    [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:weakself];
                    
                }else{
                    
                    weakself.headerView.productListModel = productModel;
                    
                    [weakself addCartProductModel:productModel goodsCount:selectedGoodCount];
                }
                
                
            };
            
            
            
            [self.commonTypeView show];
            
            
            
            /*
            if (self.detailModel.productList.count > 1) {//当有多个规格的时候
                

                
                
            }else{
                
                
                [self addCartProductModel:self.detailModel.productList[0] goodsCount:@"1"];
                
                
            }*/
            
            
            
            
        }
            break;
        case 3:{//立即购买
            
            XMFChooseGoodsTypeView *typeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFChooseGoodsTypeView class]) owner:nil options:nil] firstObject];
            
            
            typeView.chooseType = goodsDetailSoonPay;
            
            //加入规格
            self.detailModel.specificationsStr = self.headerView.goodsTypeLB.text;
            
            //加入类型
            self.detailModel.goodsChooseType = goodsDetailSoonPay;
            
            typeView.model = self.detailModel;
            
            //确定按钮
            typeView.ChooseGoodsTypeBlock = ^(XMFGoodsDatailProductListModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                
                //判断登录状态
                if (UserInfoModel.token.length == 0) {
                    
                    [[XMFGlobalManager getGlobalManager] presentLoginControllerWith:weakself];
                    
                }else{
                    
                     weakself.headerView.productListModel = productModel;
                    
                    [weakself postFastaddGoods:productModel goodsAmount:selectedGoodCount];
                }
 
                
            };
            
            
            [typeView show];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}




#pragma mark - ——————— 网络请求 ————————
//获取商品详情
-(void)getGoodsDetail:(NSString *)goodsIdStr{
    
    NSDictionary *dic = @{
        
        @"id":goodsIdStr
        
    };
    
    [self.view ly_showEmptyView];
    
    //失败的占位view设置
    self.emptyView.detailStr = XMFLI(@"");
   
    self.emptyView.btnTitleStr = XMFLI(@"");
    
    self.emptyView.tapEmptyViewBlock = ^{
        
        
    };
    
    
    [MBProgressHUD showOnlyLoadToView:self.view];

    kWeakSelf(self)
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_goods_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"商品详情：%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            [self.view ly_hideEmptyView];
            
            
            self.detailModel = [XMFGoodsDatailModel yy_modelWithDictionary:responseObjectModel.data];
            
            //对图片链接进行处理
            for (NSString *imageStr in self.detailModel.info.gallery) {
                
                //字符串转字典
                NSData *jsonData = [imageStr dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                        
                NSString *imageURL = [NSString stringWithFormat:@"%@",dic[@"image"]];
                
                [self.detailModel.galleryURLArr addObject:imageURL];
                
                
            }
            
            
            
            
            self.headerView.detailModel = self.detailModel;
            
            self.footerView.detailModel = self.detailModel;
            
            //先判断登录状态
             if (UserInfoModel.token.length == 0) {

                  [self.pageController reloadData];
                   
               }else{
                   
                   
                    [self getMyFootprint];
               }
            
           
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
            //失败的占位view设置
            self.emptyView.detailStr = XMFLI(@"暂无相关数据");
            self.emptyView.btnTitleStr = XMFLI(@"点击重试");
            
            self.emptyView.tapEmptyViewBlock = ^{
                
                [weakself getGoodsDetail:weakself.goodsIdStr];
                
            };
            
            
            
        }
        
        
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
//        [self.view ly_hideEmptyView];
        
        //失败的占位view设置
        self.emptyView.detailStr = XMFLI(@"暂无相关数据");
        self.emptyView.btnTitleStr = XMFLI(@"点击重试");
        
        self.emptyView.tapEmptyViewBlock = ^{
            
            [weakself getGoodsDetail:weakself.goodsIdStr];
            
        };
        
    }];
    
}

//收藏或者取消收藏商品
-(void)getGoodsCollectAddOrDelete:(UIButton *)button{
    
    //类型 0商品 或 1专题
    
    NSDictionary *dic = @{
        
        @"type":@"0",
        
        @"valueId":self.goodsIdStr
        
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_collect_addordelete parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"收藏或取消收藏：%@",[responseObject description]);
               
      if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
         
          button.selected = !button.selected;
          
          //收藏的block
          if (self->_goodsCollectAddOrDeleteBlock) {
              
              self->_goodsCollectAddOrDeleteBlock(self.goodsIdStr,button.selected);
          }
          
          
      }else{
          
           [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
          
      }
 
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}

//加入购物车
-(void)addCartProductModel:(XMFGoodsDatailProductListModel *)selectedProductModel goodsCount:(NSString *)goodsCountStr{
    
    
    
    NSDictionary *dic = @{
        
        @"goodsId":selectedProductModel.goodsId,
        
        @"number":goodsCountStr,
        
        @"productId":selectedProductModel.productId
        
        
    };
    
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"添加购物车：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
            [MBProgressHUD showSuccess:XMFLI(@"加入购物车成功") toView:self.view];
            
            //发送通知告诉购物车刷新
          
            KPostNotification(KPost_HomeSonVc_Notice_ShoppingcartVc_Refresh, nil, nil)
    
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
}

//为你推荐 - 我的足迹列表
-(void)getMyFootprint{
    
    NSDictionary *dic = @{
        
        @"page":@"1",
        
        @"size":@(12)
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_footprint_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"我的足迹%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObjectModel.data[@"footprintList"];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFGoodsRecommendModel *model = [XMFGoodsRecommendModel yy_modelWithDictionary:dic];
                
                [self.recommendDataArr addObject:model];
            }
            
            [self.pageController reloadData];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
//            [self.pageController reloadData];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
    }];
    
    
}

//立即购买
-(void)postFastaddGoods:(XMFGoodsDatailProductListModel *)selectedProductModel goodsAmount:(NSString *)goodsAmountStr{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":selectedProductModel.goodsId,
        
        @"number":goodsAmountStr,
        
        @"productId":selectedProductModel.productId
        
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


#pragma mark - ——————— 懒加载 ————————

-(XMFGoodsDetailNaviView *)naviView{
    
    if (_naviView == nil) {
        _naviView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsDetailNaviView class]) owner:nil options:nil] firstObject];
        _naviView.delegate = self;
    }
    return _naviView;
    
}





-(XMFGoodsDetailHeaderView *)headerView{
    
    if (_headerView == nil) {
        
        _headerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsDetailHeaderView class]) owner:nil options:nil] firstObject];
        
        _headerView.delegate = self;
    }
    return _headerView;
    
}

-(XMFGoodsDetailFooterView *)footerView{
    
    if (_footerView == nil) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsDetailFooterView class]) owner:nil options:nil] firstObject];
        
        _footerView.delegate = self;
        
    }
    return _footerView;
    
}

- (ArtScrollView *)containerScrollView {
    if (!_containerScrollView) {
        _containerScrollView = [[ArtScrollView alloc] init];
        _containerScrollView.delegate = self;
        _containerScrollView.showsVerticalScrollIndicator = NO;
    }
    return _containerScrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (WMPageController *)pageController {
    if (!_pageController) {
       
        _pageController = [[WMPageController alloc]init];
        _pageController.delegate = self;
       
        _pageController.dataSource = self;
                
        _pageController.menuViewStyle      = WMMenuViewStyleLine;
                
        _pageController.menuItemWidth         = KScreenWidth/3.0;
        
        _pageController.progressWidth      = 20;
        _pageController.titleFontName = @"PingFang-SC-Medium";
        _pageController.titleSizeNormal    = 15;
        _pageController.titleSizeSelected  = 15;
        _pageController.titleColorNormal   = UIColorFromRGB(0x666666);
        _pageController.titleColorSelected = UIColorFromRGB(0x333333);
       
        _pageController.progressColor = UIColorFromRGB(0xF7CF20);
        
        //下面控制器是否可以滚动
        _pageController.scrollEnable = NO;
        
        /**
         预加载机制
         在停止滑动的时候预加载 n 页
         WMPageControllerPreloadPolicyNever     = 0, // 从不预加载
         WMPageControllerPreloadPolicyNeighbour = 1, // 预加载下一页.
         WMPageControllerPreloadPolicyNear      = 2  // 预加载相邻页.
         */
        
        _pageController.preloadPolicy = WMPageControllerPreloadPolicyNear;
        
    }
    return _pageController;
}


-(NSArray *)titlesArr{
    
    if (_titlesArr == nil) {
        _titlesArr = @[@"图文详情",@"商品参数",@"用户评价"];
    }
    return _titlesArr;
    
}

-(NSMutableArray<XMFGoodsRecommendModel *> *)recommendDataArr{
    
    if (_recommendDataArr == nil) {
        _recommendDataArr = [[NSMutableArray alloc] init];
    }
    return _recommendDataArr;
    
    
}


-(XMFChooseGoodsTypeView *)commonTypeView{
    
    if (_commonTypeView == nil) {
        _commonTypeView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFChooseGoodsTypeView class]) owner:nil options:nil] firstObject];;
    }
    return _commonTypeView;
    
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
