//
//  XMFFootprintViewController.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/13.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFFootprintViewController.h"
#import "XMFGoodsRecommendCell.h"//ä¸ºä½ æ¨è
#import "XMFGoodsRecommendModel.h"//ä¸ºä½ æ¨è
#import "XMFFootprintBottomView.h"//åºé¨view
#import "XMFGoodsDetailController.h"//ååè¯¦æ


@interface XMFFootprintViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMFFootprintBottomViewDelegate,XMFGoodsRecommendCellDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

//æ°æ®æ°ç»
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

//å½åé¡µç 
@property (nonatomic, assign) NSInteger currentPage;

//åºé¨view
@property (nonatomic, strong) XMFFootprintBottomView *bottomView;

//æ¯å¦æ¯å¨é
@property (nonatomic, assign) BOOL isAllSelect;

//æ¯å¦æ¯ç¼è¾
@property (nonatomic, assign) BOOL isEdit;

//éä¸­çæ°é
@property (nonatomic, assign) int selectNum;


@end

@implementation XMFFootprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"æçè¶³è¿¹");
    
    self.topSpace.constant = kNavBarHeight;
    
    //åå§åæ°æ®
    self.isAllSelect = NO;
    
    self.selectNum = 0;
    
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
    
    //    _myCollectionView.pagingEnabled = YES;
    
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
    
    
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(self.topBgView.width-70-20, kStatusBarHeight, 70, kTopHeight-kStatusBarHeight);
    
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [rightBtn setImage:[UIImage imageNamed:@"icon_footprints_delete"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"icon_footprints_wancheng"] forState:UIControlStateSelected];
    
    rightBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [rightBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.topBgView addSubview:rightBtn];
    
    self.rightBtn = rightBtn;
    
    
    //å¸å±åºé¨view
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.bottom.equalTo(self.view).offset(44 + kSAFE_AREA_BOTTOM);
        
        make.height.mas_equalTo(44);
        
        
    }];
    
}

//å³è¾¹æé®ç»å®çæ¹æ³
-(void)rightBtnDidClick:(UIButton *)button{
    
    
    
    button.selected = !button.selected;
    
    
    CGFloat bottomSpace = button.selected ? -kSAFE_AREA_BOTTOM:(44 + kSAFE_AREA_BOTTOM);
    
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                
        make.bottom.equalTo(self.view).offset(bottomSpace);
        
    }];

    //Masonryå¨ç»æ´æ°çº¦æ
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
    
    
    self.isEdit = button.selected;
    
    [self.myCollectionView reloadData];
    
    
}

#pragma mark - âââââââ collectionViewçä»£çæ¹æ³åæ°æ®æº ââââââââ

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.dataSourceArr.count;
        
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    XMFGoodsRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFGoodsRecommendCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    
    XMFGoodsRecommendModel *footprintModel = self.dataSourceArr[indexPath.item];
    
    footprintModel.isShow = self.isEdit;
    
    cell.footprintModel = footprintModel;
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat width = KScreenWidth - 30;
    
    return CGSizeMake(width / 2.0, KScaleWidth(260));
     
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    XMFGoodsRecommendModel *footprintModel = self.dataSourceArr[indexPath.item];
    
    XMFGoodsDetailController  *VCtrl = [[XMFGoodsDetailController alloc]init];
    
    VCtrl.goodsIdStr = footprintModel.goodsId;
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}


#pragma mark - âââââââ ç½ç»è¯·æ± ââââââââ
//ä¸ºä½ æ¨è - æçè¶³è¿¹åè¡¨
-(void)getNewData{
    
    [self.myCollectionView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    NSDictionary *dic = @{
        
        @"page":@(self.currentPage),
        
        @"size":@(10)
        
    };
    
    [self.myCollectionView ly_startLoading];

    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_footprint_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"æçè¶³è¿¹%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObjectModel.data[@"footprintList"];
            
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFGoodsRecommendModel *model = [XMFGoodsRecommendModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
            }
            
            //å¦ææ²¡ææ°æ®ï¼å é¤æé®ä¸è½ç¹å»
            if (self.dataSourceArr.count == 0) {
                
                self.rightBtn.enabled = NO;
            }
            
            //åæ¶å¨ééä¸­ç¶æ
            self.bottomView.allSelectedBtn.selected = NO;
          
            
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
          
          @"page":@(self.currentPage),
          
          @"size":@(10)
          
      };
      
      
      [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_footprint_list parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
          
          DLog(@"æçè¶³è¿¹%@",[responseObject description]);
          
          if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
              
              NSArray *dataArr = responseObjectModel.data[@"footprintList"];
              
              
              for (NSDictionary *dic in dataArr) {
                  
                  XMFGoodsRecommendModel *model = [XMFGoodsRecommendModel yy_modelWithDictionary:dic];
                  
                  [self.dataSourceArr addObject:model];
                  
                  //åæ¶å¨ééä¸­ç¶æ
                  self.bottomView.allSelectedBtn.selected = NO;
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


//å é¤æçè¶³è¿¹
-(void)postDeletFooteprint{
    
    NSMutableArray *selectedArr = [[NSMutableArray alloc]init];
    
    NSNumber *commendIdNum;
    
    for (int i = 0; i < self.dataSourceArr.count; i++) {
        XMFGoodsRecommendModel *itemModel = self.dataSourceArr[i];
        
        if (itemModel.isSelected) {
            
            
             commendIdNum = [NSNumber numberWithInteger:[itemModel.commendId integerValue]];
            
            [selectedArr addObject:itemModel.commendId];
            
//            [self.dataSourceArr removeObject:itemModel];
            // å½æåç´ è¢«å é¤çæ¶åiçå¼åé1 ä»èæµæ¶å å é¤åç´ èå¯¼è´çåç´ ä¸æ ä½ç§»çåå
//            i--;
        }
    }
    
    /*
    NSDictionary *dic = @{
        
        @"footprintId":selectedArr
        
    };*/
    
    /**
     
     å¤æ³¨ï¼æ³¨æè¿éä¸éè¦ä¼ å­å¸ç±»ä¼¼äºJSONæ ¼å¼çåæ°ï¼ç´æ¥ä¼ å¥æ°ç»ä½ä¸ºåæ°å³å¯
     
     */
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_footprint_delete parameters:selectedArr success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"å é¤è¶³è¿¹ï¼%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
            if (self.isAllSelect) {
            
                
                [self.dataSourceArr removeAllObjects];
                
                [self rightBtnDidClick:self.rightBtn];
                
                
                [self.myCollectionView ly_showEmptyView];
                
                //å¦ææ²¡ææ°æ®ï¼å é¤æé®ä¸è½ç¹å»
                self.rightBtn.enabled = NO;
                
            } else {
                
                for (int i = 0; i < self.dataSourceArr.count; i++) {
                    XMFGoodsRecommendModel *itemModel = self.dataSourceArr[i];
                  
                    if (itemModel.isSelected ) {
                        [self.dataSourceArr removeObject:itemModel];
                        // å½æåç´ è¢«å é¤çæ¶åiçå¼åé1 ä»èæµæ¶å å é¤åç´ èå¯¼è´çåç´ ä¸æ ä½ç§»çåå
                        i--;
                    }
                }
            }
            
            self.isAllSelect = NO;
            
            self.selectNum = self.isAllSelect ? (unsigned)self.dataSourceArr.count : 0;
           
//            [self.bottomView.allSelectedBtn setTitle:self.isAllSelect ? @"  åæ¶å¨é" : @"  å¨é" forState:UIControlStateNormal];
            
            
            [self.myCollectionView reloadData];
            
        
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}

#pragma mark - âââââââ XMFGoodsRecommendCellçä»£çæ¹æ³ ââââââââ
-(void)buttonsOnXMFGoodsRecommendCellDidClick:(XMFGoodsRecommendCell *)cell button:(UIButton *)button{
    
    NSIndexPath *indexPath = [self.myCollectionView indexPathForCell:cell];
    
    XMFGoodsRecommendModel *itemModel = self.dataSourceArr[indexPath.item];
    
    itemModel.isSelected = !itemModel.isSelected;
    
    if (itemModel.isSelected) {
        
        self.selectNum = self.selectNum + 1;
        
    } else {
        
        self.selectNum = self.selectNum - 1;
    }
    
    if (self.selectNum == self.dataSourceArr.count) {
        
        self.isAllSelect = YES;
        
        [self.bottomView.allSelectedBtn setTitle:@"  å¨é" forState:UIControlStateNormal];
        
        self.bottomView.allSelectedBtn.selected = self.isAllSelect;
        
    } else {
        
        self.isAllSelect = NO;
        
        [self.bottomView.allSelectedBtn setTitle:@"  å¨é" forState:UIControlStateNormal];
        
        self.bottomView.allSelectedBtn.selected = self.isAllSelect;
    }
    
    
    [self.myCollectionView reloadItemsAtIndexPaths:@[indexPath]];

    
}

#pragma mark - âââââââ XMFFootprintBottomViewçä»£çæ¹æ³ ââââââââ
-(void)buttonsOnXMFFootprintBottomViewDidClick:(XMFFootprintBottomView *)bottomView button:(UIButton *)button{
    
    switch (button.tag) {
        case 0:{//å¨é
            
            for (int i = 0; i < self.dataSourceArr.count; i++) {
                
                XMFGoodsRecommendModel *itemModel = self.dataSourceArr[i];
                
                itemModel.isSelected = !self.isAllSelect;
            }
            
            self.isAllSelect = !self.isAllSelect;
            
            self.selectNum = self.isAllSelect ? (unsigned)self.dataSourceArr.count : 0;
           
//            [self.bottomView.allSelectedBtn setTitle:self.isAllSelect ? @"  åæ¶å¨é" : @"  å¨é" forState:UIControlStateNormal];
            
            self.bottomView.allSelectedBtn.selected = self.isAllSelect;
            
            
            [self.myCollectionView reloadData];

            
        }
            break;
        case 1:{//å é¤
            
            if (self.selectNum < 1) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"è¯·éä¸­éè¦å é¤çè¶³è¿¹")];
                
                return;
                
            }else{
                
                [self postDeletFooteprint];
                
            }
            
            
        }
            break;
            
        default:
            break;
    }
    
}



#pragma mark - âââââââ æå è½½ ââââââââ
-(NSMutableArray *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
    
    
}

-(XMFFootprintBottomView *)bottomView{
    
    if (_bottomView == nil) {
        _bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFFootprintBottomView class]) owner:nil options:nil] firstObject];
        _bottomView.delegate = self;
    }
    return _bottomView;
    
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
