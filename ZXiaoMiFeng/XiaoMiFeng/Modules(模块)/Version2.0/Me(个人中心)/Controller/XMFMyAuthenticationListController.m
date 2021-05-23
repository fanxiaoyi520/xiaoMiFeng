//
//  XMFMyAuthenticationListController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/10/21.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyAuthenticationListController.h"
#import "XMFMyAuthenticationListCell.h"
#import "XMFAuthenticationController.h"//身份认证
#import "XMFMyAuthenticationListModel.h"//身份认证的model


@interface XMFMyAuthenticationListController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray<XMFMyAuthenticationListModel *> *dataSourceArr;

@end

@implementation XMFMyAuthenticationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
}


-(void)setupUI{
    
    self.naviTitle = XMFLI(@"实名认证");
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFMyAuthenticationListCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFMyAuthenticationListCell class])];
    
    //防止刷新抖动
    self.myTableView.estimatedRowHeight = 0;
    self.myTableView.estimatedSectionHeaderHeight = 0;
    self.myTableView.estimatedSectionFooterHeight = 0;
    
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_kongzhuangtai_renzheng"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"还没相关实名认证信息哦～")
                                                          btnTitleStr:XMFLI(@"新增实名认证")
                                                        btnClickBlock:^{
        
        //实名认证
        XMFAuthenticationController  *VCtrl = [[XMFAuthenticationController alloc]init];
        
        [self.navigationController pushViewController:VCtrl animated:YES];
        
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    emptyView.detailLabTextColor = UIColorFromRGB(0x696964 );
    
    emptyView.detailLabFont = [UIFont systemFontOfSize:16.f];
    
    emptyView.detailLabMargin = 16.f;
    
    emptyView.actionBtnCornerRadius = 20.f;
    
    emptyView.actionBtnBackGroundColor = UIColorFromRGB(0xF7CF20);
    
    emptyView.actionBtnFont = [UIFont systemFontOfSize:16.f];
    
    emptyView.actionBtnTitleColor = UIColorFromRGB(0xFFFFFF);
    
    emptyView.actionBtnWidth = 188.f;
    
    emptyView.actionBtnHeight = 40.f;
    
    emptyView.actionBtnMargin = 45.f;
    
    //设置无数据样式
    self.myTableView.ly_emptyView = emptyView;
    
    
    kWeakSelf(self)
    
    self.myTableView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself getAutherizedList];
        
    }];
    

    [self addRightItemWithTitle:XMFLI(@"添加认证") selectedTitle:XMFLI(@"添加认证") action:@selector(rightBtnDidClick:) titleColor:UIColorFromRGB(0xF7CF20)];
    
    
    [self getAutherizedList];
    
}


#pragma mark - ——————— 右侧管理按钮被点击 ————————
-(void)rightBtnDidClick:(UIButton *)button{

    
    XMFAuthenticationController  *VCtrl = [[XMFAuthenticationController alloc]init];
    
    [self.navigationController pushViewController:VCtrl animated:YES];

    
}


#pragma mark - ——————— tableview的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSourceArr.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    XMFMyAuthenticationListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFMyAuthenticationListCell class])];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    cell.model = self.dataSourceArr[indexPath.row];
        
    return cell;
    


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 61;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

#pragma mark - ——————— 网络请求 ————————
-(void)getAutherizedList{
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self.myTableView ly_startLoading];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_auth_ocr_autherized_list parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"认证身份列表：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self.dataSourceArr removeAllObjects];
            
            
            NSArray *dataArr = [NSArray arrayWithArray:responseObject[@"data"]];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFMyAuthenticationListModel *model = [XMFMyAuthenticationListModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
            }
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView reloadData];
        [self.myTableView ly_endLoading];
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView ly_endLoading];
    }];
    
    
    
}

#pragma mark - ——————— 懒加载 ————————
-(NSMutableArray<XMFMyAuthenticationListModel *> *)dataSourceArr{
    
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
