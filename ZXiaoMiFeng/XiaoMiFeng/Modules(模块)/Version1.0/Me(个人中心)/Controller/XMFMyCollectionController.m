//
//  XMFMyCollectionController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/13.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyCollectionController.h"
#import "XMFGoodsRecommendCell.h"//为你推荐
#import "XMFGoodsRecommendModel.h"//为你推荐
#import "XMFGoodsDetailController.h"//商品详情


@interface XMFMyCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

//数据数组
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

//当前页码
@property (nonatomic, assign) NSInteger currentPage;




@end

@implementation XMFMyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"我的收藏");
    
    self.topSpace.constant = kNavBarHeight;
    
    // 水平方向的间距
    _flowLayout.minimumLineSpacing = 0;
    
    // 垂直方向的间距
    _flowLayout.minimumInteritemSpacing = 10;
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    if (@available (iOS 11.0,*)) {
        
        _myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _myCollectionView.delegate = self;
    
    _myCollectionView.dataSource = self;
    
    
    [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsRecommendCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFGoodsRecommendCell class])];
    
    
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
    
    self.myCollectionView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{

        [weakself getNewData];
      
  
    }];
    
    self.myCollectionView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself getMoreData];
        
    }];
    
    
    [self getNewData];
    
  
    
}


#pragma mark - ——————— collectionView的代理方法和数据源 ————————

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.dataSourceArr.count;
        
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMFGoodsRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFGoodsRecommendCell class]) forIndexPath:indexPath];
    
    cell.collectionModel = self.dataSourceArr[indexPath.item];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = KScreenWidth - 30;
    
    return CGSizeMake(width / 2.0, KScaleWidth(260));
     
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFGoodsRecommendModel *collectionModel = self.dataSourceArr[indexPath.item];
    
    XMFGoodsDetailController  *VCtrl = [[XMFGoodsDetailController alloc]init];
    
    VCtrl.goodsIdStr = collectionModel.valueId;
    
    kWeakSelf(self)
    
    VCtrl.goodsCollectAddOrDeleteBlock = ^(NSString * _Nonnull goodsIdStr, BOOL isCollection) {
      
        if (isCollection) {
            //进入详情的时候是收藏状态，然后取消，又收藏的操作
            
            [weakself getNewData];
            
        }else{
            
            
            [weakself.dataSourceArr removeObjectAtIndex:indexPath.row];
            
            [weakself.myCollectionView ly_startLoading];
            
            [weakself.myCollectionView reloadData];
            
            [weakself.myCollectionView ly_endLoading];
        }
        
        
    };
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}


#pragma mark - ——————— 网络请求 ————————
//为你推荐 - 我的足迹列表
-(void)getNewData{
    
    [self.myCollectionView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    NSDictionary *dic = @{
        
        @"type":@"0",
        
        @"page":@(self.currentPage),
        
        @"size":@(10)
        
    };
    
    [self.myCollectionView ly_startLoading];

    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_collect_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"我的收藏%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObjectModel.data[@"collectList"];
            
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFGoodsRecommendModel *model = [XMFGoodsRecommendModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
            }
            
          
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        [self.myCollectionView.mj_header endRefreshing];

        
        [self.myCollectionView reloadData];
        
        [self.myCollectionView ly_endLoading];
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
         [self.myCollectionView.mj_header endRefreshing];
        
         [self.myCollectionView ly_endLoading];
    }];
    
    
}

-(void)getMoreData{
    
    self.currentPage += 1;
    
    NSDictionary *dic = @{
        
          @"type":@"0",
          
          @"page":@(self.currentPage),
          
          @"size":@(10)
          
      };
      
      
      [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_collect_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
          
          DLog(@"我的收藏%@",[responseObject description]);
          
          if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
              
              NSArray *dataArr = responseObjectModel.data[@"collectList"];
              
              
              for (NSDictionary *dic in dataArr) {
                  
                  XMFGoodsRecommendModel *model = [XMFGoodsRecommendModel yy_modelWithDictionary:dic];
                  
                  [self.dataSourceArr addObject:model];
              }
              
              
              //判断数据是否已经请求完了
              if (dataArr.count < 10) {
                  
                  [self.myCollectionView.mj_footer endRefreshingWithNoMoreData];
                  
              }else{
                  
                  [self.myCollectionView.mj_footer endRefreshing];
                  
              }
              
            
              
          }else{
              
              [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
          }
          
          [self.myCollectionView reloadData];
          
          
          
      } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
          
           [self.myCollectionView.mj_footer endRefreshing];
         
      }];
    
    
}



#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray *)dataSourceArr{
    
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
