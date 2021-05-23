//
//  XMFOrdersLogisticsController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFOrdersLogisticsController.h"
#import "XMFOrdersLogisticsFirstCell.h"
#import "XMFOrdersLogisticsCell.h"
#import "XMFOrdersLogisticsModel.h"
#import "XMFMyOrdersListModel.h"//我的订单总model


@interface XMFOrdersLogisticsController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *goodsPicBgView;


/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** 商品数量 */
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLB;

/** 物流公司 */
@property (weak, nonatomic) IBOutlet UILabel *logisticLB;

/** 快递单号 */
@property (weak, nonatomic) IBOutlet UILabel *expressNoLB;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 物流数据model */
@property (nonatomic, strong) XMFOrdersLogisticsModel *logisticsModel;


/** 订单model */
@property (nonatomic, strong) XMFMyOrdersListModel *listModel;

@end

@implementation XMFOrdersLogisticsController


-(instancetype)initWithOrderListModel:(XMFMyOrdersListModel *)listModel{
    
    
    if (self = [super init]) {
                
        self.listModel = listModel;
    }
    
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"查看物流");

   
    self.myTableView.delegate = self;

    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrdersLogisticsFirstCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFOrdersLogisticsFirstCell class])];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrdersLogisticsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFOrdersLogisticsCell class])];
    
    
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
//    self.myTableView.ly_emptyView = emptyView;
    
    
    [self getNewData];
    
    
    [self setDataForView:self.listModel];
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    
    [self.goodsPicBgView cornerWithRadius:5.f];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (self.listModel.shipSn.length > 0) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = self.listModel.shipSn;
        
        
        [MBProgressHUD showSuccess:XMFLI(@"复制成功") toView:self.view];
    }
    

    
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
        
        XMFOrdersLogisticsFirstCell *firstCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFOrdersLogisticsFirstCell class])];
        
         firstCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setModelOfFirstCell:firstCell atIndexPath:indexPath];
        
        return firstCell;
        
        
    }else{
        
        XMFOrdersLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFOrdersLogisticsCell class])];
        
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setModelOfCell:cell atIndexPath:indexPath];
        
        return cell;
        
        
    }
    

    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    kWeakSelf(self)
    
    if (indexPath.row == 0) {
        
        return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFOrdersLogisticsFirstCell class]) configuration:^(XMFOrdersLogisticsFirstCell *cell) {
            
            
            [weakself setModelOfFirstCell:cell atIndexPath:indexPath];
              
        }];
        
        
    }else{
        
        return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFOrdersLogisticsCell class]) configuration:^(XMFOrdersLogisticsCell *cell) {
            
            [weakself setModelOfCell:cell atIndexPath:indexPath];
            
        }];
        
    }
    
    
}


-(void)setModelOfFirstCell:(XMFOrdersLogisticsFirstCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    //收货地址赋值
    self.logisticsModel.address = self.listModel.address;
    
    cell.logisticsModel = self.logisticsModel;
    
    
}

-(void)setModelOfCell:(XMFOrdersLogisticsCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    //因为在cellforrow方法里面做了判断，所以这里直接使用indexPath.row不用判断了
    
    cell.tracksModel = self.logisticsModel.tracks[indexPath.row];
    
}



#pragma mark - ——————— 网络请求 ————————

-(void)getNewData{
    
    NSDictionary *dic = @{
        
        @"orderId":self.listModel.keyId
        
    };
    
//    [self.view ly_showEmptyView];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_queryTrack parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"物流轨迹：%@",responseObject);
        
        [hud hideAnimated:YES];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            self.logisticsModel = [XMFOrdersLogisticsModel yy_modelWithDictionary:responseObjectModel.data];
            
            [self.myTableView reloadData];

            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        [self.myTableView.mj_header endRefreshing];
        
        /*
        //当有物流信息的时候才隐藏掉
        if (self.logisticsModel.tracks.count > 0) {
            
            [self.view ly_hideEmptyView];
        }
         */
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myTableView.mj_header endRefreshing];
        
        [self.view ly_hideEmptyView];
        
        [hud hideAnimated:YES];
        
    }];
    
    
}


-(void)setDataForView:(XMFMyOrdersListModel *)listModel{
    
    [self.goodsPicImgView sd_setImageWithURL:[NSURL URLWithString:listModel.goodsList[0].picUrl] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsCountLB.text = [NSString stringWithFormat:@"共%zd件商品",listModel.goodsList.count];
    
    self.logisticLB.text = listModel.shipChannel;
    
    self.expressNoLB.text = [NSString stringWithFormat:@"快递单号：%@",listModel.shipSn];
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
