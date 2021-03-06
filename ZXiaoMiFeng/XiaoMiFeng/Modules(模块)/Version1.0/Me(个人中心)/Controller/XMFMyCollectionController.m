//
//  XMFMyCollectionController.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/13.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFMyCollectionController.h"
#import "XMFGoodsRecommendCell.h"//ä¸ºä½ æ¨è
#import "XMFGoodsRecommendModel.h"//ä¸ºä½ æ¨è
#import "XMFGoodsDetailController.h"//ååè¯¦æ


@interface XMFMyCollectionController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

//æ°æ®æ°ç»
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

//å½åé¡µç 
@property (nonatomic, assign) NSInteger currentPage;




@end

@implementation XMFMyCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"æçæ¶è");
    
    self.topSpace.constant = kNavBarHeight;
    
    // æ°´å¹³æ¹åçé´è·
    _flowLayout.minimumLineSpacing = 0;
    
    // åç´æ¹åçé´è·
    _flowLayout.minimumInteritemSpacing = 10;
    
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    if (@available (iOS 11.0,*)) {
        
        _myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    _myCollectionView.delegate = self;
    
    _myCollectionView.dataSource = self;
    
    
    [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsRecommendCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFGoodsRecommendCell class])];
    
    
    //åå§åä¸ä¸ªæ æ°æ®çemptyView é»æéè©¦
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"ææ ç¸å³æ°æ®")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
                                                           
                                                        }];
    
    emptyView.autoShowEmptyView = NO;
    
    //è®¾ç½®æ æ°æ®æ ·å¼
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


#pragma mark - âââââââ collectionViewçä»£çæ¹æ³åæ°æ®æº ââââââââ

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
            //è¿å¥è¯¦æçæ¶åæ¯æ¶èç¶æï¼ç¶ååæ¶ï¼åæ¶èçæä½
            
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


#pragma mark - âââââââ ç½ç»è¯·æ± ââââââââ
//ä¸ºä½ æ¨è - æçè¶³è¿¹åè¡¨
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
        
        DLog(@"æçæ¶è%@",[responseObject description]);
        
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
          
          DLog(@"æçæ¶è%@",[responseObject description]);
          
          if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
              
              NSArray *dataArr = responseObjectModel.data[@"collectList"];
              
              
              for (NSDictionary *dic in dataArr) {
                  
                  XMFGoodsRecommendModel *model = [XMFGoodsRecommendModel yy_modelWithDictionary:dic];
                  
                  [self.dataSourceArr addObject:model];
              }
              
              
              //å¤æ­æ°æ®æ¯å¦å·²ç»è¯·æ±å®äº
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



#pragma mark - âââââââ æå è½½ ââââââââ
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
