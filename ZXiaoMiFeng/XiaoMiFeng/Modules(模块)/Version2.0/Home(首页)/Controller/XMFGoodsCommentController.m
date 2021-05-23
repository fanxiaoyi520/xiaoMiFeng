//
//  XMFGoodsCommentController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/25.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsCommentController.h"
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFGoodsDetailCommentCell.h"//评价的cell
#import "XMFGoodsCommentDetailController.h"//评论详情
#import "XMFGoodsCommentModel.h"//评论的model


@interface XMFGoodsCommentController ()<UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

//布局
@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *flowLayout;


/** 当前页码 */
@property (nonatomic, assign) NSInteger currentPage;

/** 商品id */
@property (nonatomic, copy) NSString *goodsId;


/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFGoodsCommentModel *> *dataSourceArr;

@end

@implementation XMFGoodsCommentController


-(instancetype)initWithGoodsId:(NSString *)goodsId{
    
    self = [super init];
    
    if (self) {
        
        self.goodsId = goodsId;
    }
    
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}


-(void)setupUI{
    
    self.naviTitle = XMFLI(@"全部评价");
    
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
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsDetailCommentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFGoodsDetailCommentCell class])];
    
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_xiangqing_kongzhuangtai"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"暂无评价")
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


#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFGoodsDetailCommentCell *commentCell = (XMFGoodsDetailCommentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFGoodsDetailCommentCell class]) forIndexPath:indexPath];
    
    
    commentCell.commentListModel = self.dataSourceArr[indexPath.item];
    
    
    return commentCell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
//    [collectionView reloadData];
    
    
    

    XMFGoodsCommentDetailController  *VCtrl = [[XMFGoodsCommentDetailController alloc]initWithCommentModel:self.dataSourceArr[indexPath.item]];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}

#pragma mark - ——————— CHTCollectionViewDelegateWaterfallLayout ————————

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((KScreenW - 30)/2.0, 275);

    
}


#pragma mark - ——————— 网络请求 ————————

//获取评论列表数据
-(void)getNewData{
    
    [self.myCollectionView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    NSDictionary *dic = @{
        
        @"goodsId":self.goodsId,
        
        @"pageNo":@(self.currentPage),
        
        @"pageSize":@(10)
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self.myCollectionView ly_startLoading];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goods_comment_page parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"评论列表：%@",[responseObject description]);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self.dataSourceArr removeAllObjects];
            
            
            NSArray *dataArr = responseObjectModel.data[@"dataList"];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFGoodsCommentModel *model = [XMFGoodsCommentModel yy_modelWithDictionary:dic];
                
                model.goodsId = self.goodsId;
                
                [self.dataSourceArr addObject:model];
            }
        
            
            [self.myCollectionView reloadData];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        [self.myCollectionView.mj_header endRefreshing];
        
        [self.myCollectionView ly_endLoading];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
        [self.myCollectionView.mj_header endRefreshing];
        
        [self.myCollectionView ly_endLoading];

        
    }];
    

    
}



-(void)getMoreData{
    
       
    self.currentPage += 1;

    NSDictionary *dic = @{
        
        @"goodsId":self.goodsId,
        
        @"pageNo":@(self.currentPage),
        
        @"pageSize":@(10)
        
    };
    
    
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goods_comment_page parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"评论列表：%@",[responseObject description]);
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
                    
            NSArray *dataArr = responseObjectModel.data[@"dataList"];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFGoodsCommentModel *model = [XMFGoodsCommentModel yy_modelWithDictionary:dic];
                
                model.goodsId = self.goodsId;
                
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
            
            [self.myCollectionView.mj_footer endRefreshing];

        }
        
        
        [self.myCollectionView reloadData];

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
        [self.myCollectionView.mj_header endRefreshing];

        
    }];
    

    
}

#pragma mark - ——————— 懒加载 ————————
-(CHTCollectionViewWaterfallLayout *)flowLayout{
    
    if (_flowLayout == nil) {
        
        _flowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    }
    return _flowLayout;
    
}


-(NSMutableArray<XMFGoodsCommentModel *> *)dataSourceArr{
    
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
