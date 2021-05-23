//
//  XMFGoodsParameterController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsParameterController.h"
#import "XMFGoodsParameterCell.h"//商品参数cell
#import "XMFGoodsDatailModel.h"//商品详情model
#import "XMFGoodsDetailAttributeModel.h"//商品参数model
#import "XMFGoodsRecommendView.h"//为你推荐
#import "XMFGoodsRecommendModel.h"//为你推荐
#import "XMFNoDataTableViewCell.h"//无数据的cell


@interface XMFGoodsParameterController ()<UITableViewDelegate,UITableViewDataSource,XMFGoodsRecommendViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) XMFGoodsDatailModel *detailModel;

@property (nonatomic, assign) BOOL canScroll;

//为你推荐
@property (nonatomic, strong) XMFGoodsRecommendView *recommendView;

//为你推荐的数据数组
@property (nonatomic, strong) NSMutableArray<XMFGoodsRecommendModel *> *recommendDataArr;


@end

@implementation XMFGoodsParameterController


-(instancetype)initWith:(XMFGoodsDatailModel *)detailModel recommendData:(nonnull NSMutableArray<XMFGoodsRecommendModel *> *)dataArr{
    
    self = [super init];
    
    if (self) {
        
        self.detailModel = detailModel;
        
        self.recommendDataArr = dataArr;
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /*
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"暂无相关数据")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
                                                           
                                                        }];
    
    emptyView.autoShowEmptyView = NO;
    
    //设置无数据样式
    self.myTableView.ly_emptyView = emptyView;
    
    //当没有数据的时候
    if (self.detailModel.attribute.count == 0) {
        
        [self.myTableView ly_showEmptyView];
        
    }else{
        
        [self.myTableView ly_hideEmptyView];
        
    }*/
    
    //判断有值就展示猜你喜欢
    if (self.recommendDataArr.count > 0) {
        
        self.myTableView.tableFooterView = self.recommendView;
        
         self.recommendView.autoresizingMask = UIViewAutoresizingNone;// 此行代码很重要

        self.recommendView.dataSourceArr = [self.recommendDataArr mutableCopy];
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


#pragma mark - ——————— tableview的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.detailModel.attribute.count > 0 ? self.detailModel.attribute.count : 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.detailModel.attribute.count == 0) {
        
        
        static NSString *nodataIdentifier = @"nodataCell";
        
        XMFNoDataTableViewCell *nodataCell = [tableView dequeueReusableCellWithIdentifier:nodataIdentifier];
        
        if (!nodataCell) {
            
            nodataCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFNoDataTableViewCell class]) owner:nil options:nil] firstObject];
            
            nodataCell.nodataImgView.image = [UIImage imageNamed:@"icon_common_pic"];
            
            nodataCell.nodataTipsLB.text = XMFLI(@"暂无相关数据");
            
            nodataCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        return nodataCell;
        
        
    }else{
        
        
        static NSString *identifier = @"cell";
        
        XMFGoodsParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell) {
            
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsParameterCell class]) owner:nil options:nil] firstObject];
        }
        
        cell.attributeModel = self.detailModel.attribute[indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
    }
    
  
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.detailModel.attribute.count == 0) {
        
        return self.view.height - self.recommendView.height;
        
    }else{
        
        return 40;

    }
    
}

#pragma mark - ——————— XMFGoodsRecommendView的代理方法 ————————

//猜你喜欢商品点击
-(void)goodsRecommendCellOnXMFGoodsRecommendViewDidSelected:(XMFGoodsRecommendView *)recommendView recommendModel:(XMFGoodsRecommendModel *)recommendModel{
    
    
    if (_goodsDidTapBlock) {
        
        _goodsDidTapBlock(recommendModel);
    }
    
    
}


#pragma mark - ——————— 懒加载 ————————

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
