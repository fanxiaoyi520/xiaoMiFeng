//
//  XMFThemeController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFThemeController.h"
#import "XMFThemeCell.h"//主题cell
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFThemeDetailController.h"//专题详情
#import "XMFThemeModel.h"//主题model
#import "XMFHomeSearchController.h"//搜索


@interface XMFThemeController ()<UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>


@property (weak, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet UIButton *meBtn;


@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

//布局
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *flowLayout;


/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFThemeModel *> *dataSourceArr;

@end

@implementation XMFThemeController

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
    
    
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //    self.flowLayout.headerHeight = 15;
    //    self.flowLayout.footerHeight = 10;
    self.flowLayout.minimumColumnSpacing = 10;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.columnCount = 1;
     
    
    
    /*
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // line 跟滚动方向相同的间距
    flowLayout.minimumLineSpacing = 10;
    
    // item 跟滚动方向垂直的间距
    flowLayout.minimumInteritemSpacing = 10;
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
     */
     
    self.myCollectionView.collectionViewLayout = self.flowLayout;
    
//    self.myCollectionView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    self.view.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFThemeCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFThemeCell class])];
    
    kWeakSelf(self)
    
    self.myCollectionView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [weakself getTopicList];
    }];
    
    
    /*
    self.myCollectionView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        [self.myCollectionView reloadData];
        
        [self.myCollectionView.mj_footer endRefreshing];
        
    }];*/
    
    
    [self getTopicList];
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    [self.topView cornerWithRadius:15 direction:CornerDirectionTypeBottom];
    
    [self.searchBtn cornerWithRadius:self.searchBtn.height/2.0];
    
    
}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    switch (sender.tag) {
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



#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFThemeCell *themeCell = (XMFThemeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFThemeCell class]) forIndexPath:indexPath];
    
    
    themeCell.model = self.dataSourceArr[indexPath.item];
    
    
    return themeCell;
            
    
}


/*
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KScreenW - 20, 148.0/355 * (KScreenW - 20));
    
    
//    return CGSizeMake(KScreenW - 20, 300);

}*/


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
    XMFThemeModel *model = self.dataSourceArr[indexPath.item];
    
    XMFThemeDetailController  *VCtrl = [[XMFThemeDetailController alloc]initWithTopicId:model.topicId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}



#pragma mark - ——————— CHTCollectionViewDelegateWaterfallLayout ————————

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(KScreenW - 20, 148.0/355 * (KScreenW - 20));
    
    
//    return CGSizeMake(KScreenW - 20, 300);

    
}


#pragma mark - ——————— 网络请求 ————————

-(void)getTopicList{
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_topic_list parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"获取专题列表：%@",responseObject)
        
        [self.view hideErrorPageView];
        [self.view hideServerErrorPageView];
        
        [hud hideAnimated:YES];
        

        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            NSArray *dataArr = responseObject[@"data"];
            
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFThemeModel *model = [XMFThemeModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
                
            }
            
            
            [self.myCollectionView reloadData];
            
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getTopicList];
            }];
            
        }else{
           
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        [self.myCollectionView.mj_header endRefreshing];
        

    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        [self.myCollectionView.mj_header endRefreshing];
        
        [self.view hideErrorPageView];

        [self.view showErrorPageView];

        
        [self.view configReloadAction:^{
            
            [self getTopicList];
            
            
        }];

    }];
    
    
}





#pragma mark - ——————— 懒加载 ————————

-(CHTCollectionViewWaterfallLayout *)flowLayout{
    
    if (_flowLayout == nil) {
        
        _flowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    }
    return _flowLayout;
    
}


-(NSMutableArray<XMFThemeModel *> *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
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
