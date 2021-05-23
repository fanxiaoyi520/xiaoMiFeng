//
//  XMFMyCollectionViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyCollectionViewController.h"
#import "XMFMyCollectionCell.h"//收藏的cell
#import "XMFMyCollectionHeaderView.h"//头部view
#import "XMFMyCollectionModel.h"//收藏列表的总model
#import "XMFGoodsInvalidCell.h"//失效商品cell
#import "XMFSelectGoodsTypeView.h"//商品属性弹框
#import "XMFHomeGoodsPropertyModel.h"//商品属性的model
#import "XMFHomeGoodsCellModel.h"//首页商品model
#import "XMFGoodsSpecInfoModel.h"//商品规格model
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model
#import "XMFGoodsDetailViewController.h"//商品详情


@interface XMFMyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,XMFMyCollectionCellDelegate,XMFSelectGoodsTypeViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 全选按钮 */
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;

/** 确定 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


/** 底部view */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/** 底部view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

/** 右边按钮是否选中 */
@property (nonatomic, assign) BOOL isRightBtnSelected;

/** 收藏列表的总model */
@property (nonatomic, strong) XMFMyCollectionModel *collectionModel;

/** 商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;

/** 商品规格弹窗 */
@property (nonatomic, strong) XMFSelectGoodsTypeView *selectGoodsTypeView;


@end

@implementation XMFMyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    
    self.naviTitle = XMFLI(@"我的收藏");
    
//    self.topSpace.constant = kNavBarHeight;
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFMyCollectionCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFMyCollectionCell class])];
    
     [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsInvalidCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFGoodsInvalidCell class])];
    
    
    //防止刷新抖动
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;
    
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_shoucang_kongzhuangtai"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"还没有收藏商品")
                                                          btnTitleStr:XMFLI(@"去首页逛一逛")
                                                        btnClickBlock:^{
        
        [self.navigationController popToRootViewControllerAnimated:NO];

        
        
        XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
        
        //防止tabbar位置变动，遍历子控制器并选中
        for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
            
            UIViewController *firstVc = navVc.viewControllers[0];
            
            //当为标准版或者VIP尊享版首页时
            if ([firstVc  isKindOfClass:[XMFHomeController class]] || [firstVc  isKindOfClass:[XMFHomeSimpleController class]]) {
                
                NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                
                tabBarVc.selectedIndex = index;
                
            }
            
            
        }
        
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    emptyView.detailLabTextColor = UIColorFromRGB(0x999999);
    
    emptyView.detailLabFont = [UIFont systemFontOfSize:15.f];
    
    emptyView.detailLabMargin = 20.f;
    
    emptyView.actionBtnCornerRadius = 5.f;
    
    emptyView.actionBtnBackGroundColor = UIColorFromRGB(0xF7CF21);
    
    emptyView.actionBtnFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:17.f];
    
    emptyView.actionBtnTitleColor = UIColorFromRGB(0x333333);
    
    emptyView.actionBtnWidth = 160.f;
    
    emptyView.actionBtnHeight = 40.f;
    
    emptyView.actionBtnMargin = 50.f;
    
    //设置无数据样式
    self.myTableView.ly_emptyView = emptyView;
    
    
    kWeakSelf(self)
    
    self.myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself getMyCollecGoods];
        
    }];
    
    
//    [self addRightItemWithTitle:XMFLI(@"管理") action:@selector(rightBtnDidClick:)];
    
    
    [self addRightItemWithTitle:XMFLI(@"管理") selectedTitle:XMFLI(@"完成") action:@selector(rightBtnDidClick:) titleColor:UIColorFromRGB(0x666666)];
    
    
    self.bottomView.hidden = YES;
    
    self.bottomViewHeight.constant = 0.f;
    
    
    [self getMyCollecGoods];
    
}




#pragma mark - ——————— 页面上的按钮被点击 ————————

- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//全选
            
            sender.selected = !sender.selected;
            
            for (XMFHomeGoodsCellModel *model in self.collectionModel.enabledList) {
                
                model.isSelected = sender.selected;
                
                
            }
            
            NSIndexSet *reloadSet = [NSIndexSet indexSetWithIndex:0];
            
            [self.myTableView reloadSections:reloadSet withRowAnimation:UITableViewRowAnimationNone];
            
            
        }
            break;
            
        case 1:{//删除
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = @"确认删除商品吗?";
            
            popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                if (button.tag == 0) {//确定
                    
                    [self postCollectionsDelete:NO];
                }
                
            };
            
            [popView show];
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark - ——————— 右侧管理按钮被点击 ————————
-(void)rightBtnDidClick:(UIButton *)button{

    button.selected = !button.selected;
    
    self.isRightBtnSelected = button.selected;
    
    [self.myTableView reloadData];
    
    
    if (button.selected) {
        
        self.bottomView.hidden = NO;
        
        self.bottomViewHeight.constant = 56.f;
        
        
    }else{
        
        self.bottomView.hidden = YES;
        
        self.bottomViewHeight.constant = 0.f;
    }
    
}



#pragma mark - ——————— tableview的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return self.collectionModel.enabledList.count;
        
    }else{
        
        return self.collectionModel.invalidList.count;
    }
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        XMFMyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFMyCollectionCell class])];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.isSelected = self.isRightBtnSelected;
        
//        cell.sonModel = self.collectionModel.enabledList[indexPath.row];
        
        cell.goodsModel = self.collectionModel.enabledList[indexPath.row];
        
        cell.delegate = self;
        
        return cell;
        
    }else{
        
        
        XMFGoodsInvalidCell *invalidCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFGoodsInvalidCell class])];
        
        invalidCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        invalidCell.cellRow = indexPath.row;
        
        invalidCell.invalidCount = self.collectionModel.invalidList.count;
        
        invalidCell.collectionInvalidModel = self.collectionModel.invalidList[indexPath.row];
        
        
            
        return invalidCell;
        
    }
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 152;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFHomeGoodsCellModel *model;
    
    if (indexPath.section == 0) {
        
        model = self.collectionModel.enabledList[indexPath.row];
        
    }else{
        
        model = self.collectionModel.invalidList[indexPath.row];

    }
    
    
    XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:model.goodsId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    kWeakSelf(self)
    
    if (section== 1 && (self.collectionModel.invalidList.count > 0)) {
        
        XMFMyCollectionHeaderView *headerView = [XMFMyCollectionHeaderView XMFLoadFromXIB];
        
        headerView.frame = CGRectMake(0, 0, KScreenW, 50.f);
        
        
        headerView.emptyInvalidCollectionBlock = ^(XMFMyCollectionHeaderView * _Nonnull headerView) {
          
            [weakself gotoCleanInvalidGoods];
            
            
        };
        
        return headerView;
        
    }else{
        
    
        
        return nil;
    }
    
    
    
}

//清空失效商品弹框
-(void)gotoCleanInvalidGoods{
    
    XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
    
    popView.tipsLB.text = @"确认清空失效商品吗?";
    
    popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
        
        if (button.tag == 0) {//确定
            
//            [self getCollectionClean];
            
            [self postCollectionsDelete:YES];
        }
        
    };
    
    [popView show];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 1 && (self.collectionModel.invalidList.count > 0)) {

        return 62;
        
    }else{
        
        return 0.01;
        
    }
}

//UITableview处理section的不悬浮一起滚动，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 70;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
    
}

#pragma mark - ——————— XMFMyCollectionCell的代理方法 ————————
-(void)buttonsOnXMFMyCollectionCellDidClick:(XMFMyCollectionCell *)cell button:(UIButton *)button{
    
    NSIndexPath *indexPath = [self.myTableView indexPathForCell:cell];
    
    switch (button.tag) {
        case 0:{//选中与否
            
            button.selected = !button.selected;
            
//            XMFMyCollectionSonModel *sonModel = self.collectionModel.enabledList[indexPath.row];
            
            XMFHomeGoodsCellModel *goodsModel = self.collectionModel.enabledList[indexPath.row];
            
            goodsModel.isSelected = button.selected;
            
            [self.myTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            
            NSMutableArray *selectedArr = [[NSMutableArray alloc]init];
            
            for (XMFHomeGoodsCellModel *model in self.collectionModel.enabledList) {
                
                if (model.isSelected) {
                    
                    [selectedArr addObject:model];
                }
                
            }
            
            
            //当选中的和没选中的数量一样的时候全选选中
            if (selectedArr.count == self.collectionModel.enabledList.count) {
                
                self.allSelectBtn.selected = YES;
                
            }else{
                
                self.allSelectBtn.selected = NO;

            }
            
            
            
        }
            break;
            
        case 1:{//加入购物车
            
            
//            [self getGoodsSpecification:cell.goodsModel.goodsId button:button goodsName:cell.goodsModel.goodsName];
            
            
            NSIndexPath *selectedIndexPath = [self.myTableView indexPathForCell:cell];

            
        //    [self getGoodsSpecification:cell.recommendModel.goodsId button:button goodsName:cell.recommendModel.goodsName indexPath:selectedIndexPath];
            
            //先判断是否是组合商品
            if (cell.goodsModel.isGroupGoods) {
                
                
                [self getGoodsSpecInfo:cell.goodsModel.goodsId button:button indexPath:selectedIndexPath];
                
                
            }else{
                
                
                [self getCartAdd:cell.goodsModel.productId goodsNum:@"1" button:button indexPath:selectedIndexPath];
                
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}


#pragma mark - ——————— XMFSelectGoodsTypeView的代理方法 ————————
-(void)selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView goodsId:(NSString *)goodsId{
    
    [self getGoodsDetail:goodsId];
    
}


#pragma mark - ——————— 网络请求 ————————
-(void)getMyCollecGoods{
    
    
    //收藏类型 0=商品，1=专题
    NSDictionary *dic = @{
        
        @"type":@"0"
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self.myTableView ly_startLoading];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_collect_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"我的收藏列表：%@",responseObject);
        
        [hud hideAnimated:YES];

        [self.view hideErrorPageView];
        
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            self.collectionModel = [XMFMyCollectionModel yy_modelWithDictionary:responseObjectModel.data];
            
            //当没有商品的时候复原
            if (self.collectionModel.enabledList.count == 0) {
                
                self.bottomView.hidden = YES;
                
                self.bottomViewHeight.constant = 0.f;
                
                self.allSelectBtn.selected = NO;
                
                self.rightBtn.hidden = YES;
                
            }else{
                
                self.rightBtn.hidden = NO;
            }

            
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getMyCollecGoods];
                
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        [self.myTableView.mj_header endRefreshing];
        
        [self.myTableView reloadData];
        
        [self.myTableView ly_endLoading];
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        [self.myTableView.mj_header endRefreshing];

        [self.myTableView ly_endLoading];

        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getMyCollecGoods];


        }];

    }];
    
    
    
}


//删除收藏和清空收藏
-(void)postCollectionsDelete:(BOOL)isClean{
    
    NSMutableArray *collectIdsArr = [[NSMutableArray alloc]init];
    
    if (isClean) {
        //清空收藏
        
        for (XMFHomeGoodsCellModel *model in self.collectionModel.invalidList) {
            
            
            [collectIdsArr addObject:model.goodsId];
            
            
        }
        
        
    }else{
        
        //删除收藏
        for (XMFHomeGoodsCellModel *model in self.collectionModel.enabledList) {
            
            if (model.isSelected) {
                
                [collectIdsArr addObject:model.goodsId];
            }
            
        }
        
    }

    
    NSDictionary *dic = @{
        
        
        @"collectIds":collectIdsArr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_collect_batchDelete parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"收藏商品删除：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self getMyCollecGoods];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
}


/*
//清空失效商品
-(void)getCollectionClean{
    
    NSDictionary *dic = @{
        
        @"type":@"0"
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_collect_clean parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"清空失效商品：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self getMyCollecGoods];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
}
 */


/*
//获取商品规格
-(void)getGoodsSpecification:(NSString *)goodsId button:(UIButton *)button goodsName:(NSString *)name{
    
    
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
                
                
                [self getCartAdd:[model.goodsProducts firstObject] goodsNum:@"1" button:button];
                
                
            }else{
                
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                typeView.propertyModel = model;
                
                
                typeView.selectGoodsTypeBlock = ^(XMFHomeGoodsPropertyProductsModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                    
                    [self getCartAdd:productModel goodsNum:selectedGoodCount button:button];
                    
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
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物车加数量：%@",responseObject);
        
        [hud hideAnimated:YES];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            button.selected = YES;
        
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
        
            //发送通知告诉购物车刷新
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            //通知首页列表进行刷新
              KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

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
            
            XMFHomeGoodsCellModel *selectedModel = self.collectionModel.enabledList[indexPath.row];
            
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
                
                
                //每次都需要重新创建防止数据重用
                self.selectGoodsTypeView = typeView;
                
//                typeView.detailModel = self.detailModel;
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
