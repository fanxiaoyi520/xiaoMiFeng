//
//  XMFHomeSearchController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/3.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeSearchController.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "XMFHomeSearchCell.h"//搜索的cell
#import "XMFHomeSearchHeaderView.h"//组头view
#import "XMFHomeSearchResultController.h"//搜索结果页
#import "XMFSearchKeywordsCell.h"//搜索关键词的cell


@interface XMFHomeSearchController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,XMFHomeSearchCellDelegate,UITableViewDelegate,UITableViewDataSource>

/** 列表 */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

/** 搜索按钮 */
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

/** 搜索框 */
@property (weak, nonatomic) IBOutlet UITextField *searchTfd;


/** 取消按钮 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

/** 搜索历史 */
@property (nonatomic, strong) NSMutableArray *historyArray;

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelectedMoreBtn;


/** 搜索关键词列表 */
@property (nonatomic, strong) UITableView *myTableView;


/** 关键字数据数组 */
@property (nonatomic, strong) NSMutableArray *containKeywordsArr;

/** 搜索关键词 */
@property (nonatomic, copy) NSString *keywordsStr;


@end

@implementation XMFHomeSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}


-(void)setupUI{
    
    //防止设置了myScrollView顶到状态栏但是没到的问题
    if (@available(iOS 11.0, *)) {
                
        self.myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    /*
    UICollectionViewLeftAlignedLayout *layout = [[UICollectionViewLeftAlignedLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 18;
    
    //这里如果这样子设置的话会导致当第一组没有组头时候顶部有一段空白
//    layout.sectionInset = UIEdgeInsetsMake(15, 15, 10, 15);
    
    layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    self.myCollectionView.collectionViewLayout = layout;
      */
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
    
    // line 跟滚动方向相同的间距
    flowLayout.minimumLineSpacing = 10;
    
    // item 跟滚动方向垂直的间距
    flowLayout.minimumInteritemSpacing = 10;
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.myCollectionView.collectionViewLayout = flowLayout;
    
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    //        self.myCollectionView.allowsMultipleSelection = YES;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeSearchCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomeSearchCell class])];
    
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomeSearchHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFHomeSearchHeaderView class])];
    
    self.searchTfd.delegate = self;
    
    [self.searchTfd becomeFirstResponder];
    
    //搜索框绑定方法
    [self.searchTfd addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    

        
    //获取历史数据
    self.historyArray = [GlobalManager getSearchHistoryArrayFromLocal];
    
    [self getGoodsHotWords];
    
        
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    
//    [self.searchBtn cornerWithRadius:5.f];
    
    [self.searchTfd cornerWithRadius:5.f];
    
    [self.searchTfd setTextOffsetWithLeftViewRect:CGRectMake(0, 0, 10, self.searchTfd.height) WithMode:UITextFieldViewModeAlways];
    
}

//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
            
        case 0:{//搜索
            
            
        }
            break;
            
        case 1:{//取消
            
            [self popAction];
            
        }
            break;
            
        default:
            break;
    }
    
}


#pragma mark - ——————— UICollectionView的代理方法 ————————
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
    
}



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if (section == 0) {
        
        if (self.historyArray.count > 8 && !self.isSelectedMoreBtn) {
            
             return 8;
            
        }else{
            
            return self.historyArray.count;

        }
        
        
    }else{
        
        return self.dataSourceArr.count;

    }

   
}



-(__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XMFHomeSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomeSearchCell class]) forIndexPath:indexPath];
   
    cell.indexPath = indexPath;
    
    
    if (indexPath.section == 0) {
        
      cell.keywordStr = [NSString stringWithFormat:@"%@",self.historyArray[indexPath.item]];
        
    }else{
        
        
        cell.keywordStr = [NSString stringWithFormat:@"%@",self.dataSourceArr[indexPath.item]];
    }
    
    
    cell.delegate = self;
    
    cell.isSelectedBtn = self.isSelectedMoreBtn;
    

    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((KScreenW - 30 - 30)/4.0 , 30);
    
    
    
    
    
    /*
    if (indexPath.section == 0) {
        
        NSString *keywordStr = [NSString stringWithFormat:@"%@",self.historyArray[indexPath.item]];
        
        //排列不能超过一行
        CGFloat itemWidth = [NSString SG_widthWithString:keywordStr font:[UIFont systemFontOfSize:13.f]] + 30;
        
        if (itemWidth >= (KScreenW - 30)) {
            
            itemWidth = KScreenW - 30;
        }
        
        //cell的高度
        CGFloat itemHeight = self.historyArray.count > 0 ? 30 : 0;
        
        return CGSizeMake(itemWidth , itemHeight);
        
        
    }else{
        
        NSString *keywordStr = [NSString stringWithFormat:@"%@",self.dataSourceArr[indexPath.item]];

        return CGSizeMake([NSString SG_widthWithString:keywordStr font:[UIFont systemFontOfSize:13.f]] + 30, 30);
        
    }*/
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    XMFHomeSearchCell *cell = (XMFHomeSearchCell *)[collectionView cellForItemAtIndexPath:indexPath];

    XMFHomeSearchResultController  *VCtrl = [[XMFHomeSearchResultController alloc]initWithKeyword:cell.keywordStr classifyModel:nil searchFromType:fromSearchVc];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
   //如果点击了当前已经选中的cell  忽略她~
    [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   
    kWeakSelf(self)
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){

        
        XMFHomeSearchHeaderView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFHomeSearchHeaderView class]) forIndexPath:indexPath];

        
        if (indexPath.section == 0) {
            
            headView.rightBtn.hidden = NO;
            
            [headView.leftBtn setImage:[UIImage imageNamed:@"icon_search_zuijin"] forState:UIControlStateNormal];
            
            [headView.leftBtn setTitle:XMFLI(@" 最近搜索") forState:UIControlStateNormal];
            
            headView.buttonsClickBlock = ^(UIButton * _Nonnull button) {
                
                
                XMFCommonPopView *popView = [XMFCommonPopView XMFLoadFromXIB];
                
                popView.tipsLB.text = XMFLI(@"确认清空搜索历史？");
                
                popView.commonPopViewBtnsClickBlock = ^(UIButton * _Nonnull button) {
                    
                    if (button.tag == 0) {//确认
                        
                        [GlobalManager removeUserDefaultsObjectForKey:HistoryStringArray];
                        
                        [weakself.historyArray removeAllObjects];
                        
                        [weakself.myCollectionView reloadData];
                        
                    }
                    
                };
                
                [popView show];

           
            };
            
            
//            headView.hidden = !self.historyArray.count;
            
        }else{
            
            headView.rightBtn.hidden = YES;
            
            [headView.leftBtn setImage:[UIImage imageNamed:@"icon_search_remen"] forState:UIControlStateNormal];
            
            [headView.leftBtn setTitle:XMFLI(@" 热门搜索") forState:UIControlStateNormal];
            
        }
        
        return headView;

    
    }else {
        
         return nil;
    }
    
    
   
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {//最近搜索
        
        CGFloat headerViewHeight;
        
        self.historyArray.count > 0 ? (headerViewHeight = 46 + 10) : (headerViewHeight = 0);
        
        return CGSizeMake(KScreenWidth, headerViewHeight);
        
    }else if(section == 1){//热门搜索
        
        CGFloat headerViewHeight;
        
        self.dataSourceArr.count > 0 ? (headerViewHeight = 46 + 10) : (headerViewHeight = 0);
        
        return CGSizeMake(KScreenWidth, headerViewHeight);
    
    }else{
        
        return CGSizeMake(KScreenWidth, 0);;
    }
    
}


#pragma mark - ——————— XMFHomeSearchCell的代理方法 ————————

-(void)buttonsOnXMFHomeSearchCellDidClick:(XMFHomeSearchCell *)cell button:(UIButton *)button{
    
    
    button.selected = !button.selected;
    
    self.isSelectedMoreBtn = button.selected;
    
    [self.myCollectionView reloadData];
    
    
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
    
    XMFHomeSearchResultController  *VCtrl = [[XMFHomeSearchResultController alloc]initWithKeyword:searchStr classifyModel:nil searchFromType:fromSearchVc];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
}





#pragma mark - ——————— UITextFieldDelegate ————————
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    

    if ([textField.text nullToString]) {
        
        //保证不会在键盘下面
        [MBProgressHUD showOnlyTextToView:[kApplication.windows lastObject] title:XMFLI(@"请输入搜索关键字")];
        
        return NO;
        
    }
    
    [textField resignFirstResponder];

        
    [self addHistoryString:textField.text];
    
    XMFHomeSearchResultController  *VCtrl = [[XMFHomeSearchResultController alloc]initWithKeyword:textField.text classifyModel:nil searchFromType:fromSearchVc];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
    return YES;
    
}


//添加历史数据
- (void)addHistoryString:(NSString *)historyString{
    
    if ([self.historyArray containsObject:historyString]) {
        [self.historyArray removeObject:historyString];
    }
    [self.historyArray insertObject:historyString atIndex:0];
    
    [GlobalManager saveSearchHistoryArrayToLocal:self.historyArray];
   
    [self.myCollectionView reloadData];
    
}


//当输入框内容发生改变时候
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



#pragma mark - ——————— 网络请求 ————————

//获取热门搜索关键字
-(void)getGoodsHotWords{
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self.myCollectionView ly_startLoading];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goods_hotSearch parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"热门搜索关键字：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            self.dataSourceArr = responseObject[@"data"];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        [self.myCollectionView reloadData];
        
        [self.myCollectionView ly_endLoading];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myCollectionView ly_endLoading];

        [hud hideAnimated:YES];

        
    }];
    
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
-(NSMutableArray *)dataSourceArr{
    
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
    
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
