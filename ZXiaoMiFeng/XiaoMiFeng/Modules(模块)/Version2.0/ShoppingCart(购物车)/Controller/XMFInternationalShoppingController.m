//
//  XMFInternationalShoppingController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/20.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFInternationalShoppingController.h"
#import "XMFGoodsInvalidCell.h"//失效商品cell
#import "XMFShoppingCartCell.h"//商品cell
#import "XMFShoppingCartHeaderView.h"//组头view
#import "XMFMyCollectionHeaderView.h"//头部view
#import "XMFShoppingCartCellModel.h"//购物车的总model
#import "XMFConfirmOrderController.h"//订单确认
#import "XMFShoppingSplitOrdersView.h"//体积多大弹窗view
#import "XMFShoppingSplitOrdersModel.h"//体积多大弹窗view的model
#import "XMFCommonPicPopView.h"//图片文本提示框
#import "XMFGoodsDetailViewController.h"//商品详情
#import "XMFShoppingHeaderView.h"//tableview的头部view




/** 蜜蜂国际-bc*/
@interface XMFInternationalShoppingController ()<UITableViewDelegate,UITableViewDataSource,XMFShoppingCartCellDelegate,XMFShoppingCartHeaderViewDelegate,XMFShoppingSplitOrdersViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


/** 底部View */
@property (weak, nonatomic) IBOutlet UIView *bottomView;

/** 底部View的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

/** 合计 */
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLB;

/** 结算 */
@property (weak, nonatomic) IBOutlet UIButton *caculateBtn;

/** 购物车总model */
@property (nonatomic, strong) XMFShoppingCartCellModel *internationalCartModel;


/** 选中的商品数组 */
@property (nonatomic, strong) NSMutableArray<XMFShoppingCartCellGoodsModel *> *selectedGoodsArr;

/** 体积过大拆分订单的model数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFShoppingSplitOrdersModel *> *SplitOrdersDataArr;

/** 体积拆分的view */
@property (nonatomic, strong) XMFShoppingSplitOrdersView *splitOrdersView;

/** 拆单后的商品数组 */
@property (nonatomic, strong) NSMutableArray *bcListArr;


@end

@implementation XMFInternationalShoppingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setupUI];

    
}


-(void)setupUI{

    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFShoppingCartCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFShoppingCartCell class])];
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsInvalidCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFGoodsInvalidCell class])];
    
    kWeakSelf(self)
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_shopcart_placeholder"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"购物车是空的~")
                                                          btnTitleStr:XMFLI(@"逛一逛")
                                                        btnClickBlock:^{
        
        
        XMFBaseUseingTabarController *tabBarVc =    (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
        
        //防止tabbar位置变动，遍历子控制器并选中
        for (XMFBaseNavigationController *navVc in tabBarVc.viewControllers) {
            
            UIViewController *firstVc = navVc.viewControllers[0];
            
            //当为标准版或者VIP尊享版首页时
            if ([firstVc  isKindOfClass:[XMFHomeController class]] || [firstVc  isKindOfClass:[XMFHomeSimpleController class]]){
                
                NSInteger  index =  [tabBarVc.viewControllers indexOfObject:navVc];
                
                tabBarVc.selectedIndex = index;
                
            }
            
            
        }
        
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    
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
    
    
    self.myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself getCartInfo];
                
    }];
    
    
    //接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshShoppingCart) name:KPost_HomeVc_Notice_ShoppingcartVc_Refresh object:nil];
    
    //接收登录状态发生改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:KPost_LoginSDK_Notice_LoginStatusChange object:nil];
    
    
    [self getCartInfo];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - ——————— 通知的方法 ————————
-(void)refreshShoppingCart{
    
    
    [self getCartInfo];
    
    
}


#pragma mark ————— 登录状态处理 —————
- (void)loginStateChange:(NSNotification *)notification{
    
    
    
    BOOL loginSuccess = [notification.object boolValue];

    
    if (loginSuccess) {
        
        
        [self getCartInfo];
        
        
    }else{
        
//        self.noneBackNaviTitle = XMFLI(@"购物车");
       
        self.internationalCartModel = nil;
        
        [self.myTableView ly_startLoading];
        
        [self.myTableView reloadData];
        
        [self.myTableView ly_endLoading];
        
        self.bottomView.hidden = YES;
        
        self.bottomViewHeight.constant = 0.f;
            
        
    }
    
    
}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    NSMutableArray<NSString *> *selectedArr = [[NSMutableArray alloc]init];
    
    for (XMFShoppingCartCellGoodsModel *goodsModel in self.selectedGoodsArr) {
        
        
        if ([goodsModel.checked boolValue]) {
            
            [selectedArr addObject:goodsModel.keyId];
        }
        
        
    }
    
    
    //先请求订单确认页面
//            [self getConfirmOrderInfo:selectedArr];
    
    
    [self getCartCheckStock:selectedArr];
    
}



#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (self.internationalCartModel.invalidBcGoods.count > 0) {//当有失效商品的时候
        
        return self.internationalCartModel.bcGoodsInfos.count + 1;
        
    }else{
        
        return self.internationalCartModel.bcGoodsInfos.count;
    }
    

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.internationalCartModel.invalidBcGoods.count > 0) {//当有失效商品的时候
        
        if (section == self.internationalCartModel.bcGoodsInfos.count) {
            
            //失效商品
            return self.internationalCartModel.invalidBcGoods.count;
            
        }else{
            
            XMFShoppingCartCellGoodsInfoModel *goodsInfoModel = self.internationalCartModel.bcGoodsInfos[section];
            
            if (goodsInfoModel.isfolded) {
               
                //是否折叠
                return 0;
                
            }else{
                
                return goodsInfoModel.cartGoodsRespVos.count;

            }
            
        }
        
    }else{//当无失效商品时
        
        
        XMFShoppingCartCellGoodsInfoModel *goodsInfoModel = self.internationalCartModel.bcGoodsInfos[section];
        
        if (goodsInfoModel.isfolded) {
           
            //是否折叠
            return 0;
            
        }else{
            
            return goodsInfoModel.cartGoodsRespVos.count;

        }
        
    }
    
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == self.internationalCartModel.bcGoodsInfos.count&& (self.internationalCartModel.invalidBcGoods.count > 0)) {
        //当组数和商品组数一样并且有失效商品的时候
       
        //失效商品
        XMFGoodsInvalidCell *invalidCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFGoodsInvalidCell class])];
        
        invalidCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        invalidCell.cartInvalidModel = self.internationalCartModel.invalidBcGoods[indexPath.row];
        

        return invalidCell;
        
        
        
    }else{
        
        XMFShoppingCartCell *cartCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFShoppingCartCell class])];
        
        cartCell.delegate = self;
        
        cartCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
        cartCell.selectedIndexPath = indexPath;
        
        
        [self setModelOfCell:cartCell atIndexPath:indexPath];
        
        
        return cartCell;

        
    }

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
    if (indexPath.section == self.internationalCartModel.bcGoodsInfos.count) {
        
        return KScaleWidth(138 + 28);
        
    }else{
        
        return KScaleWidth(141);
    }*/
    
    
    
    kWeakSelf(self)
    
    if (indexPath.section == self.internationalCartModel.bcGoodsInfos.count && (self.internationalCartModel.invalidBcGoods.count > 0)) {  //当组数和商品组数一样并且有失效商品的时候
        
        return KScaleWidth(141);

        
    }else{
        
        
        return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFShoppingCartCell class]) configuration:^(XMFShoppingCartCell *cell) {
            
            [weakself setModelOfCell:cell atIndexPath:indexPath];
            
        }];
    }
    

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    kWeakSelf(self)
    
    if (section == self.internationalCartModel.bcGoodsInfos.count && (self.internationalCartModel.invalidBcGoods.count > 0)) {//当组数和商品组数一样并且有失效商品的时候
      
        //失效商品
        XMFMyCollectionHeaderView *invalidHeaderView = [XMFMyCollectionHeaderView XMFLoadFromXIB];
        
        invalidHeaderView.frame = CGRectMake(0, 0, KScreenW, 50.f);
        
        invalidHeaderView.emptyInvalidCollectionBlock = ^(XMFMyCollectionHeaderView * _Nonnull headerView) {
            
            
            //清空购物车失效商品
            NSMutableArray *cartIdArr = [[NSMutableArray alloc]init];
            
            for (XMFShoppingCartCellGoodsModel *model in weakself.internationalCartModel.invalidBcGoods) {
                
                [cartIdArr addObject:model.keyId];
                
                
            }
            
            
            [weakself getCartClean:cartIdArr];
            
            
            
        };
        
        return invalidHeaderView;
        
    }else{
        
        XMFShoppingCartHeaderView *headerView = [XMFShoppingCartHeaderView XMFLoadFromXIB];
        
        headerView.delegate = self;
        
        headerView.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        
        headerView.goodsInfoModel = self.internationalCartModel.bcGoodsInfos[section];
        
        return headerView;
    }
    

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == self.internationalCartModel.bcGoodsInfos.count && (self.internationalCartModel.invalidBcGoods.count > 0)) {//当组数和商品组数一样并且有失效商品的时候
        
        
        return 52;
        
        
    }else{
        
        return 62;
    }
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
     return YES;
    
}

/**
 设置更新按钮数组
 @param tableView 表格
 @param indexPath 位置
 @return 更新按钮数组
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == self.internationalCartModel.bcGoodsInfos.count && (self.internationalCartModel.invalidBcGoods.count > 0)){//当组数和商品组数一样并且有失效商品的时候
        
        //失效商品
        
        return @[];
        
    }else{
        
        
        // 添加一个'删除'按钮,默认红色背景
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            DLog(@"删除");
            
            //删除商品
            NSMutableArray *cartIdArr = [[NSMutableArray alloc]init];
            
            XMFShoppingCartCellGoodsInfoModel *goodsInfoModel = self.internationalCartModel.bcGoodsInfos[indexPath.section];
            
            XMFShoppingCartCellGoodsModel *goodsModel = goodsInfoModel.cartGoodsRespVos[indexPath.row];
            
            [cartIdArr addObject:goodsModel.keyId];

            
            
            XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = @"确认删除商品吗?";
            
            popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                
                if (button.tag == 0) {//确定
                    
                    [self getCartClean:cartIdArr];
                    
                }
                
            };
            
            [popView show];
            
            
        }];
        
        deleteRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        
        // 添加一个'移入收藏'按钮
        UITableViewRowAction *updateRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"移入\n收藏" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            DLog(@"移入收藏");
            
            XMFShoppingCartCellGoodsInfoModel *goodsInfoModel = self.internationalCartModel.bcGoodsInfos[indexPath.section];
            
            XMFShoppingCartCellGoodsModel *goodsModel = goodsInfoModel.cartGoodsRespVos[indexPath.row];
            
        
            [self postDeleteCartAndAddCollect:goodsModel.keyId];

            
            
            
        }];
        updateRowAction.backgroundColor = UIColorFromRGB(0xF7CF20);
        

        return @[deleteRowAction, updateRowAction];
        
        
    }
    


}


 

//设置数据
-(void)setModelOfCell:(XMFShoppingCartCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    XMFShoppingCartCellGoodsInfoModel *goodsInfoModel = self.internationalCartModel.bcGoodsInfos[indexPath.section];
    
    
    cell.validModel = goodsInfoModel.cartGoodsRespVos[indexPath.row];
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XMFShoppingCartCellGoodsModel *goodsModel;
    
    if (indexPath.section == self.internationalCartModel.bcGoodsInfos.count && (self.internationalCartModel.invalidBcGoods.count > 0)){//当组数和商品组数一样并且有失效商品的时候
        
        
        goodsModel = self.internationalCartModel.invalidBcGoods[indexPath.row];
        
    }else{
        
        XMFShoppingCartCellGoodsInfoModel *goodsInfoModel = self.internationalCartModel.bcGoodsInfos[indexPath.section];
        
       goodsModel = goodsInfoModel.cartGoodsRespVos[indexPath.row];
        
        
    }
    
    XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:goodsModel.goodsId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
}

#pragma mark - ——————— XMFShoppingCartCell的代理方法 ————————
-(void)buttonsOnXMFShoppingCartCellDidClick:(XMFShoppingCartCell *)cell button:(UIButton *)button{
    
    
    switch (button.tag) {
        case 0:{//选择
            
            [self getCartCheck:cell headerView:nil  cartIds:@[cell.validModel.keyId] checked:![cell.validModel.checked boolValue]];
            
        }
            break;
            
        case 1:{//减
            
            [self getCartAdd:cell isAdd:NO];
            
        }
            break;
            
        case 2:{//加
            
            [self getCartAdd:cell isAdd:YES];
        }
            break;
            
        default:
            break;
    }
    
    
}


//手动输入商品数量
-(void)textFieldOnXMFShoppingCartCellEndInput:(XMFShoppingCartCell *)cell textField:(UITextField *)textField{
    
    
    [self postSetCartNum:cell goodCount:textField.text];
    

    
}


#pragma mark - ——————— XMFShoppingCartHeaderView ————————

//商品仓库全选
-(void)buttonsOnXMFShoppingCartHeaderViewDidClick:(XMFShoppingCartHeaderView *)headerView button:(UIButton *)button{
    
    
    switch (button.tag) {
        case 0:{//选择按钮
            
                        
            NSMutableArray *cartIdArr = [[NSMutableArray alloc]init];
            
            
            XMFShoppingCartCellGoodsInfoModel *goodsInfoModel = self.internationalCartModel.bcGoodsInfos[headerView.selectedIndexPath.section];
            
            for (XMFShoppingCartCellGoodsModel
                 *model in goodsInfoModel.cartGoodsRespVos) {
                
                [cartIdArr addObject:model.keyId];
                
            }
            
            [self getCartCheck:nil headerView:headerView  cartIds:cartIdArr checked:!button.selected];
        
            
        }
            break;
            
        case 1:{//展开收起按钮
            
            XMFShoppingCartCellGoodsInfoModel *goodsInfoModel = self.internationalCartModel.bcGoodsInfos[headerView.selectedIndexPath.section];
            
            goodsInfoModel.isfolded =   !goodsInfoModel.isfolded;
            
            [self.myTableView reloadData];
            
        }
            break;
            
        default:
            break;
    }

}


#pragma mark - ——————— XMFShoppingSplitOrdersView的代理方法 ————————
-(void)buttonsOnXMFShoppingSplitOrdersViewDidClick:(XMFShoppingSplitOrdersView *)splitOrdersView button:(UIButton *)button{
    
    
    XMFShoppingSplitOrdersModel *selectedModel = self.SplitOrdersDataArr[splitOrdersView.selectedIndexPathRow];
    
    NSMutableArray *selectedGoodsArr = [[NSMutableArray alloc]init];
    
    [self.bcListArr removeAllObjects];
    

    for (XMFShoppingSplitOrdersGoodsModel *goodsModel in selectedModel.ordersGoods) {
        
        [selectedGoodsArr addObject:goodsModel.cartId];
        
        NSMutableDictionary *bcListDic = [[NSMutableDictionary alloc]init];
        
        //为跳转订单确认做数据准备
        [bcListDic setValue:goodsModel.cartId forKey:@"cartId"];
        
        [bcListDic setValue:goodsModel.number forKey:@"num"];
        
        [self.bcListArr addObject:bcListDic];

    }
    
    DLog(@"选择的商品：%@",selectedGoodsArr);
    
    //调起订单确认接口
    [self getConfirmOrderInfo:selectedGoodsArr];
    
}
 

#pragma mark - ——————— 网络请求 ————————

//获取购物车的列表数据
-(void)getCartInfo{
    
    [self.myTableView ly_startLoading];
    
    
    [self.view showLoadingPageView];
        
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_cart_info parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"国际购物车：%@",[responseObject description]);
        
        
        [self.view hideErrorPageView];
        
        [self.view hideLoadingPageView];
        
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            XMFShoppingCartCellModel *model = [XMFShoppingCartCellModel yy_modelWithDictionary:responseObjectModel.data];
            
            self.internationalCartModel = model;
            
        
            //给页面赋值
            [self setDataForView];
            
    
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getCartInfo];
                                
            }];
            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
            self.bottomView.hidden = YES;
            
            self.bottomViewHeight.constant = 0.f;
            
            [self.view layoutIfNeeded];

            
        }
        
        
        [self.myTableView.mj_header endRefreshing];
        
    

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
        [self.view hideLoadingPageView];

        [self.view hideErrorPageView];
        
        [self.myTableView.mj_header endRefreshing];

        [self.myTableView ly_endLoading];
        
        [self.view showErrorPageView];
        
//        self.noneBackNaviTitle = XMFLI(@"购物车");

        //给父控制器返回数据
        if (self->_internationalShoppingBlock) {
            self->_internationalShoppingBlock(nil);
        }
        
        [self.view configReloadAction:^{
            
            [self getCartInfo];
            
            
        }];

    }];
    
    
}


//购物车商品选择与否
-(void)getCartCheck:(XMFShoppingCartCell * _Nullable)cell headerView:(XMFShoppingCartHeaderView * _Nullable)headerView cartIds:(NSArray *)cartIdsArr checked:(BOOL)isChecked{
    
    NSDictionary *dic = @{
        
        @"cartIds":cartIdsArr,
        @"checked":@(isChecked),
        @"returnCartInfo":@(YES)
  
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_check parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"选中商品与否：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFShoppingCartCellModel *model = [XMFShoppingCartCellModel yy_modelWithDictionary:responseObjectModel.data];
            
            self.internationalCartModel = model;
            
            //给页面赋值
            [self setDataForView];
 
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];

    
}


//给界面控件赋值
-(void)setDataForView{
    
    //给父控制器返回数据
    if (_internationalShoppingBlock) {
        _internationalShoppingBlock(self.internationalCartModel);
    }
    
    
    //头部view
    if (self.internationalCartModel.bcGoodsInfos.count > 0) {
        
        XMFShoppingHeaderView *headerView = [XMFShoppingHeaderView XMFLoadFromXIB];
        
        headerView.frame = CGRectMake(0, 0, KScreenW, 44);
        
        headerView.internationalModel = self.internationalCartModel;
        
        self.myTableView.tableHeaderView = headerView;
        
        
    }else{
        
        self.myTableView.tableHeaderView = [[UIView alloc]init];
    }
    
    
    [self.myTableView ly_startLoading];
    
    [self.myTableView reloadData];
    
    //显示占位与否
    if (self.internationalCartModel.bcGoodsInfos.count == 0 && self.internationalCartModel.invalidBcGoods.count == 0) {

        
        [self.myTableView ly_endLoading];

        
    }
    
    /**
     
     以下部分为给底部view赋值
     
     
     */
    

    if (self.internationalCartModel.bcGoodsInfos.count == 0) { //显示底部view与否
                        
        self.bottomView.hidden = YES;
        
        self.bottomViewHeight.constant = 0.f;
        
        
    }else{
        
                        
        self.bottomView.hidden = NO;
                        
        self.totalMoneyLB.hidden = NO;
        
        self.bottomViewHeight.constant = 56.f;
        
        [self.bottomView layoutIfNeeded];

    }
    
    
    
    [self.selectedGoodsArr removeAllObjects];
    
    
    //蜜蜂国际-bc不支持不同仓一起结算
    for (XMFShoppingCartCellGoodsInfoModel *goodsInfoModel in self.internationalCartModel.bcGoodsInfos) {
        
        
        for (XMFShoppingCartCellGoodsModel *goodsModel in goodsInfoModel.cartGoodsRespVos) {
            
            
            if ([goodsModel.checked boolValue]) {
                
                [self.selectedGoodsArr addObject:goodsModel];
                
            }
            
        }
        
    }
    

    
    NSMutableAttributedString *totalMoneyStr = [[XMFGlobalManager getGlobalManager] changToAttributedStringUpperStr:@"HK$ " upperColor:UIColorFromRGB(0xFB4D44) upperFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18.f] lowerStr:[NSString removeSuffix:self.internationalCartModel.bcAmount] lowerColor:UIColorFromRGB(0xFB4D44) lowerFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18.f]];
    
    
    NSMutableAttributedString *allTotalMoneyStr = [[NSMutableAttributedString alloc]initWithString:@"合计："];
    
    [allTotalMoneyStr appendAttributedString:totalMoneyStr];
    
    
    self.totalMoneyLB.attributedText = allTotalMoneyStr;
    
    
    //结算按钮
    if (self.selectedGoodsArr.count > 0) {
        
        [self.caculateBtn setTitle:[NSString stringWithFormat:@"结算(%zd)",self.selectedGoodsArr.count] forState:UIControlStateNormal];
        
        self.caculateBtn.enabled = YES;
        
        self.caculateBtn.alpha = 1.0;
        
        
    }else{
        
        [self.caculateBtn setTitle:@"结算" forState:UIControlStateNormal];
        
        self.caculateBtn.enabled = NO;
        
        self.caculateBtn.alpha = 0.6;
        
        
    }
    

}


//删除购物车
-(void)getCartClean:(NSArray *)cartIdsArr{
    
      NSDictionary *dic = @{
          
          @"cartIds":cartIdsArr,
          @"returnCartInfo":@(YES)
    
      };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_clean parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"删除购物车商品：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFShoppingCartCellModel *model = [XMFShoppingCartCellModel yy_modelWithDictionary:responseObjectModel.data];
            
            self.internationalCartModel = model;

            //给页面赋值
            [self setDataForView];
  
            
            //通知首页列表进行刷新
              KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
             //通知个人中心刷新页面
            KPostNotification(KPost_Anyone_Notice_MeVc_Refesh, nil, nil)
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    
    
}


//删除购物车加入收藏
-(void)postDeleteCartAndAddCollect:(NSString *)cartId{
    
    NSDictionary *dic = @{
        
        @"cartId":cartId,
        @"returnCartInfo":@(YES)
  
    };
  
  MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
  
  [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_deleteCartAndAddCollect parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
      
      DLog(@"移入收藏：%@",responseObject);
      
      [hud hideAnimated:YES];
      
      
      if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
          
          XMFShoppingCartCellModel *model = [XMFShoppingCartCellModel yy_modelWithDictionary:responseObjectModel.data];
          
          self.internationalCartModel = model;
          
        
          //给页面赋值

          [self setDataForView];
          
       
          //通知首页列表进行刷新
            KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
           //通知个人中心刷新页面
          KPostNotification(KPost_Anyone_Notice_MeVc_Refesh, nil, nil)
          
      }else{
          
          [MBProgressHUD showError:responseObjectModel.message toView:self.view];
          
      }
      
      
  } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
      
      [hud hideAnimated:YES];

  }];
  
  
}


//添加或者减少购物车
-(void)getCartAdd:(XMFShoppingCartCell *)cell isAdd:(BOOL)isAdd{
    
    
    NSString *goodsNumber;
    
    //购物车增加就传入增加的数量，减就传-1
    NSString *addGoodsNumber;
    
    if (isAdd) {
        
        goodsNumber = [NSString stringWithFormat:@"%zd",[cell.validModel.number integerValue] + 1];
        
        addGoodsNumber = @"1";
        
        if ([goodsNumber integerValue] > 999){
            
            [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"亲,实在不能再多了")];
            
            return;
        }
        
        
        
    }else{
        
        goodsNumber = [NSString stringWithFormat:@"%zd",[cell.validModel.number integerValue] - 1];
        
         addGoodsNumber = @"-1";
        
        if ([goodsNumber integerValue] <= 0){
            
            [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"亲,实在不能再少了")];
            
            return;
        }
        
    }
    
    
    NSDictionary *dic = @{
        
        @"num":addGoodsNumber,
        @"productId":cell.validModel.productId,
        @"returnCartInfo":@(YES)
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物车加减数量：%@",responseObject);
        
        [hud hideAnimated:YES];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFShoppingCartCellModel *model = [XMFShoppingCartCellModel yy_modelWithDictionary:responseObjectModel.data];
            
            self.internationalCartModel = model;
            
            [self setDataForView];
            
                        
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    
    
    
}


//手动输入添加或者减少购物车
-(void)postSetCartNum:(XMFShoppingCartCell *)cell goodCount:(NSString *)goodCountStr{
    
    
    //如果输入的数量大于库存数的时候
    if ([goodCountStr integerValue] > [cell.validModel.stock integerValue]) {
        
        goodCountStr = cell.validModel.stock;
    }
    
    
    
    NSDictionary *dic = @{
           
        @"num":goodCountStr,
        @"productId":cell.validModel.productId,
        @"returnCartInfo":@(YES)
        
       };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_add_set parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"手动更改购物车商品：%@",responseObject);
        
        [hud hideAnimated:YES];

              
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFShoppingCartCellModel *model = [XMFShoppingCartCellModel yy_modelWithDictionary:responseObjectModel.data];
            
            self.internationalCartModel = model;
            
            [self setDataForView];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
       
    
}

//提交购物车校验库存
-(void)getCartCheckStock:(NSArray *)cartGoodsIdArr{
    
    
    NSDictionary *dic = @{
        
        @"cartIds":cartGoodsIdArr
        
    };
    
    
    DLog(@"token:%@",UserInfoModel.token);
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_checkStock parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"库存校验：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            NSArray *dataArr = responseObject[@"data"];
            
        
            if (dataArr.count > 0) {
                
                //刷新
                [self getCartInfo];
                            
                
                //当存在库存不足的商品时候弹窗
              
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"库存不足")];
                
            
                
            }else{
                
                
                //先请求订单确认页面
//                [self getConfirmOrderInfo:cartGoodsIdArr];
                
                //先查询是否需要拆分订单
                [self posCartSplitOrders:cartGoodsIdArr];
                
            }
        
            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
            
        } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
            
            [hud hideAnimated:YES];

            
        }];
    

}


//获取确认订单页面的信息
-(void)getConfirmOrderInfo:(NSArray *)cartGoodsIdArr{
    
    
    NSDictionary *dic = @{
        
        @"cartIds":cartGoodsIdArr
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_commitApp parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取确认订单页面的信息:%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
//            XMFConfirmOrderController  *VCtrl = [[XMFConfirmOrderController alloc]initWithCartId:[cartGoodsIdArr copy] confirmOrderModel:nil confirmOrderType:fromShoppingCartVc];
            
            DLog(@"选择商品的ID数组：%@",cartGoodsIdArr);
            
            DLog(@"选择商品self.bcListArr数组：%@",self.bcListArr);
            
            XMFConfirmOrderController  *VCtrl = [[XMFConfirmOrderController alloc]initWithCartId:[cartGoodsIdArr copy] listArr:self.bcListArr confirmOrderModel:nil confirmOrderType:fromShoppingCartVc];
            
            //库存不足返回来的时候重新刷新
            VCtrl.goodsStockoutBlock = ^{
                
                [self getCartInfo];
                
            };
                       
            
            [self.navigationController pushViewController:VCtrl animated:YES];
           
            
        }else if (responseObjectModel.code == 408){
            //库存不足
            XMFCommonPicPopView *popView = [XMFCommonPicPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"手慢啦，商品库存不足…");
        
            
            [popView show];
            
        }else{
            
            //再次获取购物车数据，防止有些商品失效等等
            [MBProgressHUD showError:responseObjectModel.message toView:kAppWindow];
            
            [self.myTableView.mj_header beginRefreshing];
            
        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
}


//提交购物车校验库存
-(void)posCartSplitOrders:(NSArray *)cartGoodsIdArr{
    
    
    NSDictionary *dic = @{
        
        @"cartIds":cartGoodsIdArr
        
    };
    
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_splitOrders parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"拆分订单：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            NSArray *dataArr = responseObject[@"data"];
            
            
            [self.SplitOrdersDataArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFShoppingSplitOrdersModel *splitOrdersModel = [XMFShoppingSplitOrdersModel yy_modelWithDictionary:dic];
                
                [self.SplitOrdersDataArr addObject:splitOrdersModel];
                
            }
            
        
            if (self.SplitOrdersDataArr.count > 1) {
                //当拆分的数量大于1的时候需要拆分
                
                XMFShoppingSplitOrdersView *popView = [XMFShoppingSplitOrdersView XMFLoadFromXIB];
                
                popView.delegate = self;
                
                self.splitOrdersView = popView;
                
                popView.dataSourceArr = [self.SplitOrdersDataArr copy];
                
                [popView show];
                
                
            }else if(self.SplitOrdersDataArr.count == 1){
                //当拆分的数量等于1的时候直接跳转到订单确认
                
                
                //一定要清空上一次拆单后选择的商品数据，因为当数量为1的时候不经过选择拆单的商品，相当于要把上一次选择的数据清空
                [self.bcListArr removeAllObjects];
                
                //先请求订单确认页面
                [self getConfirmOrderInfo:cartGoodsIdArr];
                
                
            }
        
            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
            
        } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
            
            [hud hideAnimated:YES];

            
        }];
    

}



#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray<XMFShoppingCartCellGoodsModel *> *)selectedGoodsArr{
    
    if (_selectedGoodsArr == nil) {
        _selectedGoodsArr = [[NSMutableArray alloc] init];
    }
    return _selectedGoodsArr;
}

-(NSMutableArray<XMFShoppingSplitOrdersModel *> *)SplitOrdersDataArr{
    
    if (_SplitOrdersDataArr == nil) {
        _SplitOrdersDataArr = [[NSMutableArray alloc] init];
    }
    return _SplitOrdersDataArr;
}

-(NSMutableArray *)bcListArr{
    
    if (_bcListArr == nil) {
        _bcListArr = [[NSMutableArray alloc] init];
    }
    return _bcListArr;
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
