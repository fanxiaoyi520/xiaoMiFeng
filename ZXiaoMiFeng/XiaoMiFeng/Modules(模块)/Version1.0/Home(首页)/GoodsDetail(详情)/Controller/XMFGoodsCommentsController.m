//
//  XMFGoodsCommentsController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsCommentsController.h"
#import "XMFGoodsCommentsCell.h"
#import "XMFGoodsCommentsModel.h"
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDatailInfoModel.h"//商品信息model
#import "XMFGoodsRecommendView.h"//为你推荐
#import "XMFGoodsRecommendModel.h"//为你推荐
#import "XMFNoDataTableViewCell.h"//无数据的cell




@interface XMFGoodsCommentsController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,XMFGoodsRecommendViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (nonatomic, assign) BOOL canScroll;

//数据数组
@property (nonatomic, strong) NSMutableArray *dataSourceArr;

//当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) XMFGoodsDatailModel *detailModel;

//为你推荐
@property (nonatomic, strong) XMFGoodsRecommendView *recommendView;

//为你推荐的数据数组
@property (nonatomic, strong) NSMutableArray<XMFGoodsRecommendModel *> *recommendDataArr;



@end

@implementation XMFGoodsCommentsController

-(instancetype)initWith:(XMFGoodsDatailModel *)detailModel recommendData:(nonnull NSMutableArray<XMFGoodsRecommendModel *> *)dataArr{
    
    if (self = [super init]) {
        
        self.detailModel = detailModel;
        
        self.recommendDataArr = dataArr;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsCommentsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFGoodsCommentsCell class])];
    
    /*
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"暂无评价")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    //设置无数据样式
    self.myTableView.ly_emptyView = emptyView;
    
    */
    
    kWeakSelf(self)
    
    self.myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
 
        [weakself getNewData];

        
    }];
    
    self.myTableView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakself getMoreData];
        
    }];
    
    //判断有值就展示猜你喜欢
    if (self.recommendDataArr.count > 0) {
        
        self.myTableView.tableFooterView = self.recommendView;
        
        self.recommendView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要
        
        self.recommendView.dataSourceArr = [self.recommendDataArr mutableCopy];
    }
    

    
    if (self.detailModel != nil) {
        
        [self getNewData];
    }

    
    // add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeGoTopNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];//其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
}

//移除通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification

-(void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kHomeGoTopNotification]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            self.canScroll = YES;
            self.myTableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kHomeLeaveTopNotification]){
        self.myTableView.contentOffset = CGPointZero;
        self.canScroll = NO;
        self.myTableView.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeLeaveTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataSourceArr.count > 0 ? self.dataSourceArr.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (self.dataSourceArr.count == 0) {
        
        
        static NSString *nodataIdentifier = @"nodataCell";
        
        XMFNoDataTableViewCell *nodataCell = [tableView dequeueReusableCellWithIdentifier:nodataIdentifier];
        
        if (!nodataCell) {
            
            nodataCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFNoDataTableViewCell class]) owner:nil options:nil] firstObject];
            
            nodataCell.nodataImgView.image = [UIImage imageNamed:@"icon_details_zwpj"];
            
            nodataCell.nodataTipsLB.text = XMFLI(@"暂无评价");
            
            nodataCell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
        
        
        return nodataCell;
        
        
    }else{
       
        XMFGoodsCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFGoodsCommentsCell class]) forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setModelOfCell:cell atIndexPath:indexPath];
        
        
        return cell;
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(self)

    if (self.dataSourceArr.count == 0) {
        
        return self.view.height - self.recommendView.height;

        
    }else{
        
        return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFGoodsCommentsCell class]) configuration:^(XMFGoodsCommentsCell *cell) {
             
             [weakself setModelOfCell:cell atIndexPath:indexPath];
             
         }];
    }
    
    
}



-(void)setModelOfCell:(XMFGoodsCommentsCell *)Cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row < self.dataSourceArr.count) {
        
       
        Cell.commentsModel = self.dataSourceArr[indexPath.row];
        
    }

}

#pragma mark - ——————— 网络请求 ————————
-(void)getNewData{
    
    [self.myTableView.mj_footer endRefreshing];
       
    self.currentPage = 1;
    
    
    NSDictionary *dict = @{
        
        @"limit":@(5),
        
        @"page":@(self.currentPage),
        
        @"id":self.detailModel.info.goodsId
        
        
    };
    
    
//    [self.myTableView ly_startLoading];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_goods_commentList parameters:dict success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"评论列表:%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSArray *commentsListArr = responseObjectModel.data[@"data"];
           
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dict in commentsListArr) {
                
                XMFGoodsCommentsModel *model = [XMFGoodsCommentsModel yy_modelWithDictionary:dict];
                
                [self.dataSourceArr addObject:model];
                
            }
 

        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        [self.myTableView.mj_header endRefreshing];
        
        [self.myTableView reloadData];
        
//        [self.myTableView ly_endLoading];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myTableView.mj_header endRefreshing];
        
//        [self.myTableView ly_endLoading];
        
    }];
    
    
}


-(void)getMoreData{
    
    self.currentPage += 1;
    
    NSDictionary *dict = @{
        
        @"limit":@(5),
        
        @"page":@(self.currentPage),
        
        @"id":self.detailModel.info.goodsId
        
        
    };
       
              
       [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_goods_commentList parameters:dict success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
           
           DLog(@"评论列表:%@",[responseObject description]);
           
           if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
               
               
               NSArray *commentsListArr = responseObjectModel.data[@"data"];
               
               
               for (NSDictionary *dict in commentsListArr) {
                   
                   XMFGoodsCommentsModel *model = [XMFGoodsCommentsModel yy_modelWithDictionary:dict];
                   
                   [self.dataSourceArr addObject:model];
                   
               }

               //判断数据是否已经请求完了
               if (commentsListArr.count < 5) {
                   
                   [self.myTableView.mj_footer endRefreshingWithNoMoreData];
                   
               }else{
                   
                   [self.myTableView.mj_footer endRefreshing];
                   
               }
               
               
           }else{
               
               [self.myTableView.mj_footer endRefreshing];
               
               [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
           }
           
           [self.myTableView reloadData];
           
           
       } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
           
           [self.myTableView.mj_footer endRefreshing];
           
           
       }];
    
    
}

#pragma mark - ——————— XMFGoodsRecommendView的代理方法 ————————

//猜你喜欢商品点击
-(void)goodsRecommendCellOnXMFGoodsRecommendViewDidSelected:(XMFGoodsRecommendView *)recommendView recommendModel:(XMFGoodsRecommendModel *)recommendModel{
    
    
    if (_goodsDidTapBlock) {
        
        _goodsDidTapBlock(recommendModel);
    }
    
    
}

#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
    
}

-(XMFGoodsRecommendView *)recommendView{
    
    if (_recommendView == nil) {
        _recommendView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsRecommendView class]) owner:nil options:nil] firstObject];;
        _recommendView.delegate = self;

    }
    return _recommendView;
    
    
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
