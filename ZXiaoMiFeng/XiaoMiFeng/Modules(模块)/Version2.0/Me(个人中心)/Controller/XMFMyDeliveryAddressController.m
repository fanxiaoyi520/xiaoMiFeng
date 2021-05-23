//
//  XMFMyDeliveryAddressController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/9.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyDeliveryAddressController.h"
#import "XMFMyDeliveryAddressCell.h"//地址cell
#import "XMFMyDeliveryAddressModel.h"//地址的model
#import "XMFAddAddressController.h"//填写地址


@interface XMFMyDeliveryAddressController ()<UITableViewDelegate,UITableViewDataSource,XMFMyDeliveryAddressCellDelegate,XMFCommonCustomPopViewDelegate>


/** 提示语 */
@property (weak, nonatomic) IBOutlet UILabel *tipsLB;


/** 提示语的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsLBHeight;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 添加 */
@property (weak, nonatomic) IBOutlet UIButton *createBtn;


/** 添加按钮的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *createBtnHeight;


/** 数据数组 */
@property (nonatomic, strong) NSMutableArray *dataSourceArr;


/** 自定义补充照片弹框 */
@property (nonatomic, strong) XMFCommonCustomPopView *customPopView;

/** 编辑的地址数据 */
@property (nonatomic, strong) XMFMyDeliveryAddressModel *editAddressModel;

/** 来源类型 */
@property (nonatomic, assign) myDeliveryAddressJumpFromType type;


@end

@implementation XMFMyDeliveryAddressController


-(instancetype)initWithJumpFromType:(myDeliveryAddressJumpFromType)fromType{
    
    if (self = [super init]) {
        
        self.type = fromType;
        
    }
    
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
}


-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    [self.createBtn cornerWithRadius:5.f];
    
}


-(void)setupUI{
    
    
    kWeakSelf(self)
    
    //防止设置了myScrollView顶到状态栏但是没到的问题
    if (@available(iOS 11.0, *)) {
        
        self.myTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.naviTitle = XMFLI(@"地址管理");
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
//    self.myTableView.showsVerticalScrollIndicator = NO;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_address_empty"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"还没有添加收货地址")
                                                          btnTitleStr:XMFLI(@"添加收货地址")
                                                        btnClickBlock:^{
        [weakself createBtnDidClick:weakself.createBtn];
                                                        }];
    
    emptyView.autoShowEmptyView = NO;
    
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
     
     emptyView.detailLabTextColor = UIColorFromRGB(0x999999);
     
     emptyView.detailLabFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:16.f];
     
     emptyView.detailLabMargin = 10.f;
     
     emptyView.actionBtnCornerRadius = 5.f;
     
     emptyView.actionBtnBackGroundColor = UIColorFromRGB(0xF7CF21);
     
     emptyView.actionBtnFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:18.f];
     
     emptyView.actionBtnTitleColor = UIColorFromRGB(0x333333);
     
     emptyView.actionBtnWidth = 150.f;
     
     emptyView.actionBtnHeight = 44.f;
     
     emptyView.actionBtnMargin = 30.f;
    
    
    //设置无数据样式
    self.myTableView.ly_emptyView = emptyView;
    
    
    //只有当没有数据的时候才请求
    if (![AddressManager isContainsAddressInfo]) {
        
        [self getRegionTree];
        
    }else{
        
        [self getAddressList];
        
    }
    
}

#pragma mark - ——————— 网络请求 ————————

/*
-(void)getAddressList{
    
    [self.myTableView ly_startLoading];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_address_list parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"地址列表：%@",[responseObject description]);
        
        [hud hideAnimated:YES];

        [self.view hideErrorPageView];
        
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *addressArr = responseObject[@"data"];
            
            [self.dataSourceArr removeAllObjects];
            
            
            for (NSDictionary *dic in addressArr) {
                
                XMFMyDeliveryAddressModel *model = [XMFMyDeliveryAddressModel yy_modelWithDictionary:dic];
                
                if (!model.verified) {
                    
                    self.tipsLB.hidden = NO;
                    
                    self.tipsLBHeight.constant = 34.f;
                    
                    
                }else{
                    
                    self.tipsLB.hidden = YES;
                    
                    self.tipsLBHeight.constant = 0.f;
                }
                
                
                [self.dataSourceArr addObject:model];
                
            }
            
            [self.myTableView reloadData];
            
            
            //当地址列表没有地址的时候告知订单列表清除数据
            if (self.dataSourceArr.count == 0) {
                
                KPostNotification(KPost_MyDeliveryAddressVc_Notice_ConfirmOrderVc_IsRefresh, nil, nil)
                
            }
            
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getAddressList];
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        [self.myTableView ly_endLoading];
        
        
        if (self.dataSourceArr.count > 0) {
            
            self.createBtn.hidden = NO;
            
            self.createBtnHeight.constant = 44.f;
            
        }else{
            
            self.createBtn.hidden = YES;
            
            self.createBtnHeight.constant = 0.f;
        }

        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
        [self.myTableView ly_endLoading];

        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getAddressList];


        }];
        
    }];
    
    
}*/


-(void)getAddressList{
    
    [self.myTableView ly_startLoading];
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_addresses parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"地址列表：%@",[responseObject description]);
        
        [hud hideAnimated:YES];

        [self.view hideErrorPageView];
        
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSArray *addressArr = responseObject[@"data"];
            
            [self.dataSourceArr removeAllObjects];
            
            
            for (NSDictionary *dic in addressArr) {
                
                XMFMyDeliveryAddressModel *model = [XMFMyDeliveryAddressModel yy_modelWithDictionary:dic];
                
                if (!model.verified) {
                    
                    self.tipsLB.hidden = NO;
                    
                    self.tipsLBHeight.constant = 34.f;
                    
                    
                }else{
                    
                    self.tipsLB.hidden = YES;
                    
                    self.tipsLBHeight.constant = 0.f;
                }
                
                
                [self.dataSourceArr addObject:model];
                
            }
            
            [self.myTableView reloadData];
            
            
            //当地址列表没有地址的时候告知订单列表清除数据
            if (self.dataSourceArr.count == 0) {
                
                KPostNotification(KPost_MyDeliveryAddressVc_Notice_ConfirmOrderVc_IsRefresh, nil, nil)
                
            }
            
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getAddressList];
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        [self.myTableView ly_endLoading];
        
        
        if (self.dataSourceArr.count > 0) {
            
            self.createBtn.hidden = NO;
            
            self.createBtnHeight.constant = 44.f;
            
        }else{
            
            self.createBtn.hidden = YES;
            
            self.createBtnHeight.constant = 0.f;
        }

        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
        [self.myTableView ly_endLoading];

        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getAddressList];


        }];
        
    }];
    
    
}

//获取行政区域
-(void)getRegionTree{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_region_tree parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"行政区域：%@",[responseObject description]);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
            
            [AddressManager updateAddressInfo:dic];
            
            
            //获取到了行政区域再去获取地址列表
            [self getAddressList];
            
 
        }else{
            
            
            
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];

    
}

#pragma mark - ——————— tableview的数据源和代理方法 ————————

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.dataSourceArr.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFMyDeliveryAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFMyDeliveryAddressCell class]) owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        cell.delegate = self;
       
    }
    
    
    cell.addressModel = self.dataSourceArr[indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 70;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.type != fromMeVc) {
        //只有当来源不是个人中心的时候执行下面的方法
        
        XMFMyDeliveryAddressModel *model = self.dataSourceArr[indexPath.row];
        
        
        if (!model.verified) {
            //未认证
            
            self.editAddressModel = model;
            
            
            [self.customPopView show];
            
            
        }else if(model.unusable){
            //地址不可用
            
            [MBProgressHUD showOnlyTextToView:self.view title:XMFLI(@"该地区暂时无货")];
            
            
        }else{
            
            if (_selectedAddressBlock) {
                _selectedAddressBlock(model);
            }
            
            [self popAction];
        }
        
        
        
    }
    

}

#pragma mark - ——————— XMFMyDeliveryAddressCell的代理方法 ————————
-(void)buttonsOnXMFMyDeliveryAddressCellDidClick:(XMFMyDeliveryAddressCell *)cell button:(UIButton *)button{
    
    XMFAddAddressController  *VCtrl = [[XMFAddAddressController alloc]initWithType:editAddress addressId:cell.addressModel.addressId];
      
      kWeakSelf(self)
      
      VCtrl.addAddressBlock = ^{
          
          [weakself getAddressList];
          
          if (self->_addressHasChangedBlock) {
              self->_addressHasChangedBlock();
          }

          
      };
      
      [self.navigationController pushViewController:VCtrl animated:YES];
    
}


#pragma mark - ——————— XMFCommonCustomPopView的代理方法 ————————

-(void)buttonsOnXMFCommonCustomPopViewDidClick:(XMFCommonCustomPopView *)popView button:(UIButton *)button{
    
    
    kWeakSelf(self)
    
    switch (button.tag) {
        case 0:{//右边：补充身份信息
            
            
            XMFAddAddressController  *VCtrl = [[XMFAddAddressController alloc]initWithType:editAddress addressId:self.editAddressModel.addressId];
              
              
              VCtrl.addAddressBlock = ^{
                  
                  [weakself getAddressList];
                
                  
              };
              
              [self.navigationController pushViewController:VCtrl animated:YES];

            
        }
            
            break;
            
        case 1:{//左边：更改收货地址
            
           //啥都不做，弹框消失
            
        }
            
            break;
            
        default:
            break;
    }
    
    
    
}


#pragma mark - ——————— 页面上的按钮被点击 ————————

//新建按钮
- (IBAction)createBtnDidClick:(UIButton *)sender {
    
    XMFAddAddressController  *VCtrl = [[XMFAddAddressController alloc]initWithType:addAddress addressId:nil];
    
    kWeakSelf(self)
    
    VCtrl.addAddressBlock = ^{
        
        [weakself getAddressList];
        
    };
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}


#pragma mark - ——————— 懒加载 ————————

-(NSMutableArray *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
    
}

-(XMFCommonCustomPopView *)customPopView{
    
    if (_customPopView == nil) {
        _customPopView = [XMFCommonCustomPopView XMFLoadFromXIB];
        
        _customPopView.tipsLB.text = XMFLI(@"海关政策抽检，购买跨境进口商品需要\n上传身份证照片，仅用于海关清关。");
        
        [_customPopView.sureBtn setTitle:XMFLI(@"补充身份信息") forState:UIControlStateNormal];
        
        [_customPopView.cancelBtn setTitle:XMFLI(@"更改收货地址") forState:UIControlStateNormal];
        
        _customPopView.delegate = self;
        
    }
    return _customPopView;
    
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
