//
//  XMFFootprintViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/13.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFFootprintViewController.h"
#import "XMFGoodsRecommendCell.h"//为你推荐
#import "XMFGoodsRecommendModel.h"//为你推荐
#import "XMFFootprintBottomView.h"//底部view
#import "XMFGoodsDetailController.h"//商品详情


@interface XMFFootprintViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,XMFFootprintBottomViewDelegate,XMFGoodsRecommendCellDelegate>


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

//数据数组
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

//当前页码
@property (nonatomic, assign) NSInteger currentPage;

//底部view
@property (nonatomic, strong) XMFFootprintBottomView *bottomView;

//是否是全选
@property (nonatomic, assign) BOOL isAllSelect;

//是否是编辑
@property (nonatomic, assign) BOOL isEdit;

//选中的数量
@property (nonatomic, assign) int selectNum;


@end

@implementation XMFFootprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"我的足迹");
    
    self.topSpace.constant = kNavBarHeight;
    
    //初始化数据
    self.isAllSelect = NO;
    
    self.selectNum = 0;
    
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
    
    //    _myCollectionView.pagingEnabled = YES;
    
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
    
    
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    rightBtn.frame = CGRectMake(self.topBgView.width-70-20, kStatusBarHeight, 70, kTopHeight-kStatusBarHeight);
    
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [rightBtn setImage:[UIImage imageNamed:@"icon_footprints_delete"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"icon_footprints_wancheng"] forState:UIControlStateSelected];
    
    rightBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [rightBtn addTarget:self action:@selector(rightBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.topBgView addSubview:rightBtn];
    
    self.rightBtn = rightBtn;
    
    
    //布局底部view
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.bottom.equalTo(self.view).offset(44 + kSAFE_AREA_BOTTOM);
        
        make.height.mas_equalTo(44);
        
        
    }];
    
}

//右边按钮绑定的方法
-(void)rightBtnDidClick:(UIButton *)button{
    
    
    
    button.selected = !button.selected;
    
    
    CGFloat bottomSpace = button.selected ? -kSAFE_AREA_BOTTOM:(44 + kSAFE_AREA_BOTTOM);
    
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                
        make.bottom.equalTo(self.view).offset(bottomSpace);
        
    }];

    //Masonry动画更新约束
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
    
    
    self.isEdit = button.selected;
    
    [self.myCollectionView reloadData];
    
    
}

#pragma mark - ——————— collectionView的代理方法和数据源 ————————

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


#pragma mark - ——————— 网络请求 ————————
//为你推荐 - 我的足迹列表
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
        
        DLog(@"我的足迹%@",[responseObject description]);
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSArray *dataArr = responseObjectModel.data[@"footprintList"];
            
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFGoodsRecommendModel *model = [XMFGoodsRecommendModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
            }
            
            //如果没有数据，删除按钮不能点击
            if (self.dataSourceArr.count == 0) {
                
                self.rightBtn.enabled = NO;
            }
            
            //取消全选选中状态
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
          
          DLog(@"我的足迹%@",[responseObject description]);
          
          if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
              
              NSArray *dataArr = responseObjectModel.data[@"footprintList"];
              
              
              for (NSDictionary *dic in dataArr) {
                  
                  XMFGoodsRecommendModel *model = [XMFGoodsRecommendModel yy_modelWithDictionary:dic];
                  
                  [self.dataSourceArr addObject:model];
                  
                  //取消全选选中状态
                  self.bottomView.allSelectedBtn.selected = NO;
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


//删除我的足迹
-(void)postDeletFooteprint{
    
    NSMutableArray *selectedArr = [[NSMutableArray alloc]init];
    
    NSNumber *commendIdNum;
    
    for (int i = 0; i < self.dataSourceArr.count; i++) {
        XMFGoodsRecommendModel *itemModel = self.dataSourceArr[i];
        
        if (itemModel.isSelected) {
            
            
             commendIdNum = [NSNumber numberWithInteger:[itemModel.commendId integerValue]];
            
            [selectedArr addObject:itemModel.commendId];
            
//            [self.dataSourceArr removeObject:itemModel];
            // 当有元素被删除的时候i的值回退1 从而抵消因删除元素而导致的元素下标位移的变化
//            i--;
        }
    }
    
    /*
    NSDictionary *dic = @{
        
        @"footprintId":selectedArr
        
    };*/
    
    /**
     
     备注：注意这里不需要传字典类似于JSON格式的参数，直接传入数组作为参数即可
     
     */
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_footprint_delete parameters:selectedArr success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"删除足迹：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            
            if (self.isAllSelect) {
            
                
                [self.dataSourceArr removeAllObjects];
                
                [self rightBtnDidClick:self.rightBtn];
                
                
                [self.myCollectionView ly_showEmptyView];
                
                //如果没有数据，删除按钮不能点击
                self.rightBtn.enabled = NO;
                
            } else {
                
                for (int i = 0; i < self.dataSourceArr.count; i++) {
                    XMFGoodsRecommendModel *itemModel = self.dataSourceArr[i];
                  
                    if (itemModel.isSelected ) {
                        [self.dataSourceArr removeObject:itemModel];
                        // 当有元素被删除的时候i的值回退1 从而抵消因删除元素而导致的元素下标位移的变化
                        i--;
                    }
                }
            }
            
            self.isAllSelect = NO;
            
            self.selectNum = self.isAllSelect ? (unsigned)self.dataSourceArr.count : 0;
           
//            [self.bottomView.allSelectedBtn setTitle:self.isAllSelect ? @"  取消全选" : @"  全选" forState:UIControlStateNormal];
            
            
            [self.myCollectionView reloadData];
            
        
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
    
}

#pragma mark - ——————— XMFGoodsRecommendCell的代理方法 ————————
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
        
        [self.bottomView.allSelectedBtn setTitle:@"  全选" forState:UIControlStateNormal];
        
        self.bottomView.allSelectedBtn.selected = self.isAllSelect;
        
    } else {
        
        self.isAllSelect = NO;
        
        [self.bottomView.allSelectedBtn setTitle:@"  全选" forState:UIControlStateNormal];
        
        self.bottomView.allSelectedBtn.selected = self.isAllSelect;
    }
    
    
    [self.myCollectionView reloadItemsAtIndexPaths:@[indexPath]];

    
}

#pragma mark - ——————— XMFFootprintBottomView的代理方法 ————————
-(void)buttonsOnXMFFootprintBottomViewDidClick:(XMFFootprintBottomView *)bottomView button:(UIButton *)button{
    
    switch (button.tag) {
        case 0:{//全选
            
            for (int i = 0; i < self.dataSourceArr.count; i++) {
                
                XMFGoodsRecommendModel *itemModel = self.dataSourceArr[i];
                
                itemModel.isSelected = !self.isAllSelect;
            }
            
            self.isAllSelect = !self.isAllSelect;
            
            self.selectNum = self.isAllSelect ? (unsigned)self.dataSourceArr.count : 0;
           
//            [self.bottomView.allSelectedBtn setTitle:self.isAllSelect ? @"  取消全选" : @"  全选" forState:UIControlStateNormal];
            
            self.bottomView.allSelectedBtn.selected = self.isAllSelect;
            
            
            [self.myCollectionView reloadData];

            
        }
            break;
        case 1:{//删除
            
            if (self.selectNum < 1) {
                
                [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"请选中需要删除的足迹")];
                
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



#pragma mark - ——————— 懒加载 ————————
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
