//
//  XMFLogisticsController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/19.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFLogisticsController.h"
#import "XMFLogisticsModel.h"
#import "XMFLogisticsFirstCell.h"
#import "XMFLogisticsCell.h"




@interface XMFLogisticsController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) UITableView *myTableView;


//数据model
@property (nonatomic, strong) XMFLogisticsModel *logisticsModel;

//订单ID
@property (nonatomic, copy) NSString *orderId;


@end

@implementation XMFLogisticsController


-(instancetype)initWithOrderId:(NSString *)orderId{
    
    
    if (self = [super init]) {
        
        self.orderId = orderId;
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"物流详情");
    
    self.view.backgroundColor = KWhiteColor;
    
    [self.view addSubview:self.myTableView];
    
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(kTopHeight);
        
        make.left.right.bottom.equalTo(self.view);
        
    }];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFLogisticsFirstCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFLogisticsFirstCell class])];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFLogisticsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFLogisticsCell class])];
    
    [self getNewData];
    
}

#pragma mark - ——————— tableView的数据源和代理方法 ————————

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.logisticsModel.tracks.count == 0) {
        
        return 1;
        
    }else{
        
        return self.logisticsModel.tracks.count;
    }
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        
        XMFLogisticsFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFLogisticsFirstCell class])];
        
         firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setModelOfFirstCell:firstCell atIndexPath:indexPath];
        
        return firstCell;
        
        
    }else{
        
        XMFLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFLogisticsCell class])];
        
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setModelOfCell:cell atIndexPath:indexPath];
        
        return cell;
        
        
    }
    

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(self)
    
    if (indexPath.row == 0) {
        
        return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFLogisticsFirstCell class]) configuration:^(XMFLogisticsFirstCell *cell) {
            
            
            [weakself setModelOfFirstCell:cell atIndexPath:indexPath];
              
        }];
        
        
    }else{
        
        return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFLogisticsCell class]) configuration:^(XMFLogisticsCell *cell) {
            
            [weakself setModelOfCell:cell atIndexPath:indexPath];
            
        }];
        
    }
    
    
}


-(void)setModelOfFirstCell:(XMFLogisticsFirstCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    cell.logisticsModel = self.logisticsModel;
    
    
}

-(void)setModelOfCell:(XMFLogisticsCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    //因为在cellforrow方法里面做了判断，所以这里直接使用indexPath.row不用判断了
    
    cell.tracksModel = self.logisticsModel.tracks[indexPath.row];
    
}


#pragma mark - ——————— 网络请求 ————————

-(void)getNewData{
    
    NSDictionary *dic = @{
        
        @"orderId":self.orderId
        
    };
    
    [self.myTableView ly_showEmptyView];
    
    [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_queryTrack parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"物流轨迹：%@",[responseObject description])
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            self.logisticsModel = [XMFLogisticsModel yy_modelWithDictionary:responseObjectModel.data];
            
            [self.myTableView reloadData];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
        }
        
        [self.myTableView.mj_header endRefreshing];
        
        [self.myTableView ly_hideEmptyView];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myTableView.mj_header endRefreshing];
        
        [self.myTableView ly_hideEmptyView];
        
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
}

#pragma mark - ——————— 懒加载 ————————
-(UITableView *)myTableView{
    
    if (_myTableView == nil) {
        
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _myTableView.delegate = self;
        
        _myTableView.dataSource = self;
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //初始化一个无数据的emptyView 點擊重試
        LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                                 titleStr:@""
                                                                detailStr:XMFLI(@"加载中...")
                                                              btnTitleStr:@""
                                                            btnClickBlock:^{
            
        }];
        
        emptyView.autoShowEmptyView = NO;
        
        emptyView.emptyViewIsCompleteCoverSuperView = YES;
        
        //设置无数据样式
        _myTableView.ly_emptyView = emptyView;
        
        kWeakSelf(self)
        
        _myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
            
            [weakself getNewData];
            
        }];
        
        
       
        
    }
    return _myTableView;
    
}



@end
