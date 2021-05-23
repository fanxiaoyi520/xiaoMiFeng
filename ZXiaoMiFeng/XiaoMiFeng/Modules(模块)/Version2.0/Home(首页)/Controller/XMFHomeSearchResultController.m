//
//  XMFHomeSearchResultController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeSearchResultController.h"
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFHomeAllGoodsCell.h"//首页推荐cell
#import "XMFHomePartGoodsCell.h"//子分类cell
#import "XMFGoodsDetailViewController.h"//商品详情
#import "XMFHomeGoodsCellModel.h"//商品cell的model
#import "XMFSelectGoodsTypeView.h"//商品属性弹框
#import "XMFHomeGoodsFilterView.h"//筛选
#import "XMFHomeGoodsClassifyModel.h"//商品分类model
#import "XMFHomeGoodsSortView.h"//商品筛选view
#import "XMFHomeGoodsPropertyModel.h"//商品属性的model
#import "XMFGoodsSpecInfoModel.h"//商品规格model
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model
#import "XMFSearchKeywordsCell.h"//搜索关键词的cell


//布局的结构体
typedef enum : NSUInteger {
    twoCellsLayout,
    oneCellLayout,
} layoutType;

@interface XMFHomeSearchResultController ()<UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout,UITextFieldDelegate,XMFHomeGoodsFilterViewDelegate,XMFHomeAllGoodsCellDelegate,XMFHomePartGoodsCellDelegate,XMFHomeGoodsSortViewDelegate,XMFSelectGoodsTypeViewDelegate,UITableViewDelegate,UITableViewDataSource>


/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

/** 搜索框 */
@property (weak, nonatomic) IBOutlet UITextField *searchTfd;

/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLB;


/** 筛选按钮背景view */
@property (weak, nonatomic) IBOutlet UIView *filterBtnBgView;


/** 综合排序 */

@property (weak, nonatomic) IBOutlet UIButton *generalBtn;

/** 销量 */

@property (weak, nonatomic) IBOutlet UIButton *salesBtn;

/** 样式排列 */

@property (weak, nonatomic) IBOutlet UIButton *arrangeBtn;

/** 筛选 */

@property (weak, nonatomic) IBOutlet UIButton *filtrateBtn;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


/** 布局 */
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *flowLayout;


/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsCellModel *> *dataSourceArr;

/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

/** 布局类型 */
@property (nonatomic, assign) layoutType type;

/** 关键词 */
@property (nonatomic, copy) NSString *keyword;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *historyArray;

/** 筛选view */
@property (nonatomic, strong) XMFHomeGoodsFilterView *filterView;

/** 搜索来源 */
@property (nonatomic, assign) searchFromType fromType;

/** 搜索字典 */
@property (nonatomic, strong) NSMutableDictionary *searchDic;

/** 商品分类model */
@property (nonatomic, strong) XMFHomeGoodsClassifyModel *classifyModel;


/** 筛选排序view */
@property (nonatomic, strong) XMFHomeGoodsSortView *sortView;

/** 搜索默认字典 */
@property (nonatomic, strong) NSMutableDictionary *searchDefaultDic;


/** 商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;

/** 商品规格弹窗 */
@property (nonatomic, strong) XMFSelectGoodsTypeView *selectGoodsTypeView;


/** 搜索关键词列表 */
@property (nonatomic, strong) UITableView *myTableView;


/** 关键字数据数组 */
@property (nonatomic, strong) NSMutableArray *containKeywordsArr;


/** 搜索关键词 */
@property (nonatomic, copy) NSString *keywordsStr;




@end

@implementation XMFHomeSearchResultController

-(instancetype)initWithKeyword:(NSString *)keyword classifyModel:(XMFHomeGoodsClassifyModel *)classifyModel searchFromType:(searchFromType)fromType{
    
    self = [super init];
    
    if (self) {
        
        self.keyword = keyword;
        
        self.fromType = fromType;
        
        self.classifyModel = classifyModel;
        
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
    
    self.myCollectionView.collectionViewLayout = self.flowLayout;
    
    self.myCollectionView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeAllGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeAllGoodsCell class])];
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomePartGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomePartGoodsCell class])];
    
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_search_kongzhuangtai"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"未找到相关商品")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    //设置无数据样式
    self.myCollectionView.ly_emptyView = emptyView;
    
        
    
    kWeakSelf(self)
    
    self.myCollectionView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself getNewData];
        
    }];
    
    self.myCollectionView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself getMoreData];
        
    }];
    

    
    
    if (self.keyword.length > 0) {
        
        self.searchTfd.text = self.keyword;
    }
    
    
    //获取历史数据
    self.historyArray = [GlobalManager getSearchHistoryArrayFromLocal];
    
    self.searchTfd.delegate = self;
    
    //搜索框绑定方法
    [self.searchTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    //根据不同来源
    if (self.fromType == fromThemeItem) {
        //来自商品分类 
        
       self.titleLB.text = self.classifyModel.name;
        

        self.titleLB.hidden = NO;
        
        self.searchTfd.hidden = YES;
        
        //分类那里就是分类id
        [self.searchDefaultDic setValue:self.classifyModel.classifyId forKey:@"classify"];
        
        
    }else{
        //来自搜索页面
        
        self.titleLB.hidden = YES;
        
        self.searchTfd.hidden = NO;
        
        //搜索商品关键字
        [self.searchDefaultDic setValue:self.keyword forKey:@"goodsName"];
    }

    //提前设置每页条数
    [self.searchDefaultDic setValue:@(10) forKey:@"pageSize"];
    
    //默认综合排序
    [self.searchDefaultDic setValue:@(1) forKey:@"orderType"];
    
    
    [self.searchDic addEntriesFromDictionary:self.searchDefaultDic];
    
    
    //请求数据
    [self getNewData];
    
    //综合按钮默认亮色
    [self.generalBtn setTitleColor:UIColorFromRGB(0xF7CF20) forState:UIControlStateNormal];
    
    [self.generalBtn setTitleColor:UIColorFromRGB(0xF7CF20) forState:UIControlStateSelected];

    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];

    self.searchTfd.leftView = view;
    
    self.searchTfd.leftViewMode = UITextFieldViewModeAlways;
    
    [self.searchTfd cornerWithRadius:self.searchTfd.height/2];
    
    CGFloat imgTextSpace = 5.f;
    
    [self.generalBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imgTextSpace];
    
    [self.salesBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imgTextSpace];
    
    [self.filtrateBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imgTextSpace];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.sortView removeFromSuperview];
    
}

-(void)dealloc{
    
//    [self.sortView removeFromSuperview];
    
}

-(void)popAction{
    
    [super popAction];

    
    [self.sortView removeFromSuperview];

    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//返回
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
            break;
            
        case 1:{//综合
            
            sender.selected = !sender.selected;
            
            if (sender.selected) {
                
                [self.sortView showWithFrame:CGRectMake(0, self.filterBtnBgView.bottom, KScreenW, KScreenH - self.filterBtnBgView.bottom)];

            }else{
                
                [self.sortView hide];
            }
                        
            
            
        }
            break;
            
        case 2:{//销量
            
            sender.selected = !sender.selected;
            
            //把综合按钮恢复成灰色
            self.generalBtn.selected = NO;
                        
            [self.generalBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateSelected];
            
            [self.generalBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            
            [self.generalBtn setTitle:XMFLI(@"综合") forState:UIControlStateNormal];
            
            [self.generalBtn setTitle:XMFLI(@"综合") forState:UIControlStateSelected];
            

            [self.sortView hide];
            
            [self.sortView.myTableView reloadData];
            
            /*
            self.sortView = [XMFHomeGoodsSortView XMFLoadFromXIB];
            
            self.sortView.delegate = self;
            
            
            self.sortView.GoodsSortViewIsShowBlock = ^(BOOL isShow) {
                
                weakself.generalBtn.selected = isShow;
            };*/
            
            
            if (sender.selected) {
                
                [self.searchDic setValue:@(0) forKey:@"orderType"];
                
                
            }else{
                
                [self.searchDic removeObjectForKey:@"orderType"];
            }
            
            [self getNewData];
            
        }
            break;
        case 3:{//排列
                    
            sender.selected = !sender.selected;
            
            if (sender.selected) {
                
                self.type = oneCellLayout;
                
                self.flowLayout.columnCount = 1;
                
            }else{
                
                self.type = twoCellsLayout;
                
                self.flowLayout.columnCount = 2;
            }
            
            
            [self.myCollectionView reloadData];
            
        }
            break;
        case 4:{//筛选
            
            [self.filterView show];
            
            
        }
            break;
            
        default:
            break;
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


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
//    [collectionView reloadData];
    
    XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
    
    XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:model.goodsId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}

#pragma mark - ——————— CHTCollectionViewDelegateWaterfallLayout ————————

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.type == twoCellsLayout) {
        
        return CGSizeMake((KScreenW - 30)/2.0, 1.44 *(KScreenW/2.0));
        
    }else{
        
       return CGSizeMake(KScreenW - 20, 137);
        
    }

    
}


#pragma mark - ——————— UITableView的代理方法和数据源 ————————
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.containKeywordsArr.count;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XMFSearchKeywordsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFSearchKeywordsCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.suggestSearchwordsStr = [NSString stringWithFormat:@"%@^%@",self.containKeywordsArr[indexPath.row],self.keywordsStr];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.myTableView removeFromSuperview];
    
    
    [self.searchTfd resignFirstResponder];
    
    NSString *searchStr = self.containKeywordsArr[indexPath.row];
    
    [self addHistoryString:searchStr];
    
    //给搜索框赋值
    self.searchTfd.text = searchStr;
    
    
    //搜索
    [self.searchDefaultDic setValue:searchStr forKey:@"goodsName"];
    
    [self.searchDic setValue:searchStr forKey:@"goodsName"];
    
    [self getNewData];
    
    
}



#pragma mark - ——————— UITextFieldDelegate ————————
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField.text nullToString]) {
        
        //保证不会在键盘下面
        [MBProgressHUD showOnlyTextToView:[kApplication.windows lastObject] title:XMFLI(@"请输入搜索关键字")];
        
        return NO;
        
    }
    
    
    
    [textField resignFirstResponder];
    
    [self.myTableView removeFromSuperview];
    
    [self addHistoryString:textField.text];
    
    //搜索
    
    [self.searchDefaultDic setValue:textField.text forKey:@"goodsName"];
    
    [self.searchDic setValue:textField.text forKey:@"goodsName"];
    
    [self getNewData];
    
    return YES;
    
}

//添加历史数据
- (void)addHistoryString:(NSString *)historyString{
    
    if ([self.historyArray containsObject:historyString]) {
        [self.historyArray removeObject:historyString];
    }
    [self.historyArray insertObject:historyString atIndex:0];
    
    [GlobalManager saveSearchHistoryArrayToLocal:self.historyArray];
       
}


- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    
    //替换空格
    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    if(![string isEqualToString:blank]) {
        
        return NO;
        
    }
    
    return YES;
}


#pragma mark 文本框字符变化时

- (void)textFieldDidChange:(UITextField *)textField{
    
    NSString *string = textField.text;
    
    //替换空格
    NSString *blank = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""];
    
    UITextRange *selectedRange = [textField markedTextRange];
    
    //获取高亮部分

    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];

    // 没有高亮选择的字，说明不是拼音输入

    if (!position) {

        //大写
//        NSString *upperCaseString = [textField.text uppercaseString];
//
//        textField.text = upperCaseString;
        
        DLog(@"sender.text:%@",textField.text);
        
        
        if(blank.length > 0){
            
            [self getSuggestSearchwords:blank];


        }else{
            
            [self.myTableView removeFromSuperview];

            
        }

    } else {// 有高亮选择的字符串，不做处理
        
        DLog(@"sender.text1:%@",textField.text);


    }
    

    
}

#pragma mark - ——————— XMFHomeGoodsFilterView的代理方法 ————————
-(void)buttonsOnXMFHomeGoodsFilterViewDidClick:(XMFHomeGoodsFilterView *)filterView button:(UIButton *)button selectedDic:(NSMutableDictionary *)selectedTagDic{
    
    
    [self.searchDic removeAllObjects];
    
    
    [self.searchDic addEntriesFromDictionary:self.searchDefaultDic];

    
    [self.searchDic addEntriesFromDictionary:selectedTagDic];
    
    
    [self getNewData];
    
    
}


#pragma mark - ——————— XMFHomeAllGoodsCell的代理方法 ————————
-(void)buttonsOnXMFHomeAllGoodsCellDidClick:(XMFHomeAllGoodsCell *)cell button:(UIButton *)button{
    
    
//     [self getGoodsSpecification:cell.recommendModel.goodsId button:button goodsName:cell.recommendModel.goodsName];
    
    NSIndexPath *selectedIndexPath = [self.myCollectionView indexPathForCell:cell];

    
    //先判断是否是组合商品
    if (cell.recommendModel.isGroupGoods) {
        
        
        [self getGoodsSpecInfo:cell.recommendModel.goodsId button:button indexPath:selectedIndexPath];
        
        
    }else{
        
        
        [self getCartAdd:cell.recommendModel.productId goodsNum:@"1" button:button indexPath:selectedIndexPath];
        
    }
    
}

#pragma mark - ——————— XMFHomePartGoodsCell的代理方法 ————————
-(void)buttonsOnXMFHomePartGoodsCellDidClick:(XMFHomePartGoodsCell *)cell button:(UIButton *)button{
    
//     [self getGoodsSpecification:cell.model.goodsId button:button goodsName:cell.model.goodsName];
    
    NSIndexPath *selectedIndexPath = [self.myCollectionView indexPathForCell:cell];

    
    //先判断是否是组合商品
    if (cell.model.isGroupGoods) {
        
        
        [self getGoodsSpecInfo:cell.model.goodsId button:button indexPath:selectedIndexPath];
        
        
    }else{
        
        
        [self getCartAdd:cell.model.productId goodsNum:@"1" button:button indexPath:selectedIndexPath];
        
    }
    
}


#pragma mark - ——————— XMFHomeGoodsSortView ————————

-(void)cellOnXMFHomeGoodsSortViewDidSelected:(XMFHomeGoodsSortView *)sortView selectedDic:(NSMutableDictionary *)selectedTagDic seletedTitle:(NSString *)titleStr{
    
    //把综合按钮置为亮色
    self.generalBtn.selected = NO;

    [self.generalBtn setTitleColor:UIColorFromRGB(0xF7CF20) forState:UIControlStateSelected];
    
    [self.generalBtn setTitleColor:UIColorFromRGB(0xF7CF20) forState:UIControlStateNormal];
    
    [self.generalBtn setTitle:titleStr forState:UIControlStateNormal];
    
    [self.generalBtn setTitle:titleStr forState:UIControlStateSelected];
        
    self.salesBtn.selected = NO;
    
    
    [self.searchDic addEntriesFromDictionary:selectedTagDic];
    
    [self getNewData];
    
    
    
}

#pragma mark - ——————— XMFSelectGoodsTypeView的代理方法 ————————

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
    
        
    
    [self.searchDic setValue:@(self.currentPage) forKey:@"pageNo"];
    
    
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
    
    
    [self.searchDic setValue:@(self.currentPage) forKey:@"pageNo"];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_goods_search parameters:self.searchDic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"首页商品：%@",[responseObject description]);
        
        
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
             
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        [self.myCollectionView reloadData];


        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myCollectionView.mj_footer endRefreshing];
        
    }];
    
    
}

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
                
                typeView.delegate = self;
                
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
            
            //一定要处理本地数据防止页面滑动出现复用问题
            XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
            
            model.cartNum = [NSString stringWithFormat:@"%zd",[model.cartNum integerValue] + [numStr integerValue]];
        
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

//获取搜索推荐关键词
-(void)getSuggestSearchwords:(NSString*)keywordsStr{
    
    
    NSDictionary *dic = @{
        
        @"words":keywordsStr
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goods_search_suggest parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取推荐搜索关键词：%@",responseObject);
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self.containKeywordsArr removeAllObjects];
            
            self.containKeywordsArr = responseObject[@"data"];
            
            self.keywordsStr = keywordsStr;

            
            [self.myTableView ly_startLoading];
            
            [self.myTableView reloadData];
            
            [self.myTableView ly_endLoading];
            
            [self.view addSubview:self.myTableView];
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
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

-(XMFHomeGoodsFilterView *)filterView{
    
    if (_filterView == nil) {
        _filterView = [XMFHomeGoodsFilterView XMFLoadFromXIB];
        _filterView.frame = CGRectMake(KScreenW, 0, KScreenW, KScreenH);
        _filterView.delegate = self;
    }
    return _filterView;
    
    
}

-(NSMutableDictionary *)searchDic{
    
    if (_searchDic == nil) {
        _searchDic = [[NSMutableDictionary alloc] init];
    }
    return _searchDic;
    
    
}


-(XMFHomeGoodsSortView *)sortView{
    
    kWeakSelf(self)
    
    if (_sortView == nil) {
        _sortView = [XMFHomeGoodsSortView XMFLoadFromXIB];
        _sortView.delegate = self;
        _sortView.frame = CGRectMake(0,KScreenH, KScreenW, KScreenH - self.filterBtnBgView.bottom);
        _sortView.GoodsSortViewIsShowBlock = ^(BOOL isShow) {
            
            weakself.generalBtn.selected = isShow;
            
        };
    }
    return _sortView;
}


-(NSMutableDictionary *)searchDefaultDic{
    
    if (_searchDefaultDic == nil) {
        _searchDefaultDic = [[NSMutableDictionary alloc] init];
    }
    return _searchDefaultDic;
    
}

-(UITableView *)myTableView{
    
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopHeight, KScreenW, KScreenH - kTopHeight)];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTableView.estimatedSectionHeaderHeight = 0;
        _myTableView.estimatedSectionFooterHeight = 0;
        _myTableView.showsVerticalScrollIndicator = NO;
        
        //初始化一个无数据的emptyView
        LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                                 titleStr:@""
                                                                detailStr:XMFLI(@"暂无相关数据")
                                                              btnTitleStr:@""
                                                            btnClickBlock:^{
            
        }];
        
        emptyView.autoShowEmptyView = NO;
        
        emptyView.contentViewY = kTopHeight + 64;
        
        //设置无数据样式
        _myTableView.ly_emptyView = emptyView;
        
        _myTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        //注册cell
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFSearchKeywordsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFSearchKeywordsCell class])];
                
        
    }
    return _myTableView;
    
    
}



-(NSMutableArray *)containKeywordsArr{
    
    if (_containKeywordsArr == nil) {
        _containKeywordsArr = [[NSMutableArray alloc] init];
    }
    return _containKeywordsArr;
    
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
