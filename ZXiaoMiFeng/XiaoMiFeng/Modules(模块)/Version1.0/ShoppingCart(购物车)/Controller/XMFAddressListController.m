//
//  XMFAddressListController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/6.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAddressListController.h"
#import "XMFAddressListCell.h"//地址cell
#import "XMFAddressListModel.h"
#import "XMFAddAddressController.h"//填写地址


@interface XMFAddressListController ()<UITableViewDelegate,UITableViewDataSource,XMFAddressListCellDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (weak, nonatomic) IBOutlet UIButton *createBtn;


@property (nonatomic, strong) NSMutableArray *dataSourceArr;

//跳转页面来源
@property (nonatomic, assign) jumpToAddressListType jumpType;

@end

@implementation XMFAddressListController


-(instancetype)initWithJumpType:(jumpToAddressListType)jumpType{
    
    if (self = [super init]) {
        
        self.jumpType = jumpType;
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
    
    self.naviTitle = @"地址管理";
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_address_empty"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"还没有添加收货地址")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
                                                           
                                                        }];
    
    emptyView.autoShowEmptyView = NO;
    
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
-(void)getAddressList{
    
    [self.myTableView ly_startLoading];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_address_list parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"地址列表：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
            NSArray *addressArr = responseObject[@"data"];
            
            [self.dataSourceArr removeAllObjects];
            
            for (NSDictionary *dic in addressArr) {
                
                XMFAddressListModel *model = [XMFAddressListModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
                
            }
            
            [self.myTableView reloadData];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.kerrmsg toView:self.view];
            
        }
        
        [self.myTableView ly_endLoading];
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [self.myTableView ly_endLoading];
        
    }];
    
    
}

//获取行政区域
-(void)getRegionTree{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_region_tree parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"行政区域：%@",[responseObject description]);
        
        if (responseObjectModel.kerrno == XMFHttpReturnCodeSuccess) {
            
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
    
    XMFAddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFAddressListCell class]) owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        cell.delegate = self;
       
    }
    
    
    cell.model = self.dataSourceArr[indexPath.row];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.jumpType == jumpFromOrderConfirmVcToAddressList) {
        
        XMFAddressListModel *model = self.dataSourceArr[indexPath.row];
          
          if (_selectedAddressBlock) {
              _selectedAddressBlock(model);
          }
          
          [self popAction];
    }
    

}


#pragma mark - ——————— XMFAddressListCell的代理方法 ————————
-(void)buttonsOnXMFAddressListCellDidClick:(XMFAddressListCell *)cell button:(UIButton *)button{
    
    
    XMFAddAddressController  *VCtrl = [[XMFAddAddressController alloc]initWithType:editAddress addressId:cell.model.addressId];
    
    kWeakSelf(self)
    
    VCtrl.addAddressBlock = ^{
        
        [weakself getAddressList];
        
        if (self->_addressHasChangedBlock) {
            self->_addressHasChangedBlock();
        }
        
    };
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}


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


@end
