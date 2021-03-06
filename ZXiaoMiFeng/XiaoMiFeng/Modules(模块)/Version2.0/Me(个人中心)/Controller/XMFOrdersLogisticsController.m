//
//  XMFOrdersLogisticsController.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFOrdersLogisticsController.h"
#import "XMFOrdersLogisticsFirstCell.h"
#import "XMFOrdersLogisticsCell.h"
#import "XMFOrdersLogisticsModel.h"
#import "XMFMyOrdersListModel.h"//æçè®¢åæ»model


@interface XMFOrdersLogisticsController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *goodsPicBgView;


/** ååå¾ç */
@property (weak, nonatomic) IBOutlet UIImageView *goodsPicImgView;

/** ååæ°é */
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLB;

/** ç©æµå¬å¸ */
@property (weak, nonatomic) IBOutlet UILabel *logisticLB;

/** å¿«éåå· */
@property (weak, nonatomic) IBOutlet UILabel *expressNoLB;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** ç©æµæ°æ®model */
@property (nonatomic, strong) XMFOrdersLogisticsModel *logisticsModel;


/** è®¢åmodel */
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
    
    self.naviTitle = XMFLI(@"æ¥çç©æµ");

   
    self.myTableView.delegate = self;

    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrdersLogisticsFirstCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFOrdersLogisticsFirstCell class])];
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFOrdersLogisticsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFOrdersLogisticsCell class])];
    
    
    //åå§åä¸ä¸ªæ æ°æ®çemptyView é»æéè©¦
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"å è½½ä¸­...")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    
    //è®¾ç½®æ æ°æ®æ ·å¼
//    self.myTableView.ly_emptyView = emptyView;
    
    
    [self getNewData];
    
    
    [self setDataForView:self.listModel];
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    
    [self.goodsPicBgView cornerWithRadius:5.f];
    
}


//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    if (self.listModel.shipSn.length > 0) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        pasteboard.string = self.listModel.shipSn;
        
        
        [MBProgressHUD showSuccess:XMFLI(@"å¤å¶æå") toView:self.view];
    }
    

    
}

#pragma mark - âââââââ tableViewçæ°æ®æºåä»£çæ¹æ³ ââââââââ

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
    
    //æ¶è´§å°åèµå¼
    self.logisticsModel.address = self.listModel.address;
    
    cell.logisticsModel = self.logisticsModel;
    
    
}

-(void)setModelOfCell:(XMFOrdersLogisticsCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    //å ä¸ºå¨cellforrowæ¹æ³éé¢åäºå¤æ­ï¼æä»¥è¿éç´æ¥ä½¿ç¨indexPath.rowä¸ç¨å¤æ­äº
    
    cell.tracksModel = self.logisticsModel.tracks[indexPath.row];
    
}



#pragma mark - âââââââ ç½ç»è¯·æ± ââââââââ

-(void)getNewData{
    
    NSDictionary *dic = @{
        
        @"orderId":self.listModel.keyId
        
    };
    
//    [self.view ly_showEmptyView];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_queryTrack parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"ç©æµè½¨è¿¹ï¼%@",responseObject);
        
        [hud hideAnimated:YES];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            self.logisticsModel = [XMFOrdersLogisticsModel yy_modelWithDictionary:responseObjectModel.data];
            
            [self.myTableView reloadData];

            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        [self.myTableView.mj_header endRefreshing];
        
        /*
        //å½æç©æµä¿¡æ¯çæ¶åæéèæ
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
    
    self.goodsCountLB.text = [NSString stringWithFormat:@"å±%zdä»¶åå",listModel.goodsList.count];
    
    self.logisticLB.text = listModel.shipChannel;
    
    self.expressNoLB.text = [NSString stringWithFormat:@"å¿«éåå·ï¼%@",listModel.shipSn];
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
