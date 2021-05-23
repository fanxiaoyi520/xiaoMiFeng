//
//  ZDPay_OrderSureViewController.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/13.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPay_OrderSureViewController.h"
#import "ZDGPayManagerTool.h"
#import "PayModel.h"
#import "ZDPay_OrderSureHeaderView.h"
#import "ZDPay_OrderSureFooterView.h"
#import "ZDPay_OrderSureTableViewCell.h"
#import "ZDPayFuncTool.h"
#import "ZDPayNetRequestManager.h"
#import "ZDPay_MyWalletViewController.h"
#import "ZD_PayForgetPasswordViewController.h"
#import "ZDPay_AddBankCardViewController.h"
#import "ZDPay_SecurityVerificationSecondViewController.h"

#import "ZDPay_OrderSureRespModel.h"
#import "ZDPay_OrderSureBankListRespModel.h"
#import "ZDPay_OrderSurePayListRespModel.h"
#import "ZDPay_OrderSurePayListRespModel.h"
#import <WebKit/WebKit.h>
#import "AlipayTool.h"
#import "WXApi.h"
#import <WebKit/WebKit.h>

typedef void (^UseTheDiscountCodeBlock)(NSString *text);
typedef void (^WKWebViewBlock)( id _Nullable message,BOOL paySuccess);
@interface ZDWKWebViewController : ZDPayRootViewController<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property (nonatomic ,strong)NSString *payInfo;
@property (nonatomic ,strong)WKWebView *webView;
@property (nonatomic ,copy)WKWebViewBlock webViewBlock;
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *third_Model;
@end

@implementation ZDWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadHTMLString:self.payInfo baseURL:nil];
}

-(WKWebView *)webView
{
    if (!_webView) {
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.preferences = [[WKPreferences alloc] init];
        //wkWebConfig.preferences.minimumFontSize = 10;
        wkWebConfig.preferences.javaScriptEnabled = YES;
        wkWebConfig.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        wkWebConfig.userContentController = [[WKUserContentController alloc] init];
        wkWebConfig.processPool = [[WKProcessPool alloc] init];
        wkWebConfig.userContentController = [WKUserContentController new];
        //在创建wkWebView时，需要将被js调用的方法注册进去,oc与js端对应实现
        [wkWebConfig.userContentController addScriptMessageHandler:self name:@"jsToOc"];

        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight) configuration:wkWebConfig];
//        _webView.navigationDelegate = self;
//        _webView.scrollView.bounces = NO;
//        _webView.scrollView.alwaysBounceVertical = NO;
//        _webView.scrollView.scrollEnabled = NO;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark - delegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self getDataFromNetWorkingUnifiedQuery:message];
}

//查询信用卡支付后接口
- (void)getDataFromNetWorkingUnifiedQuery:(_Nullable id)info {
    @WeakObj(self)
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getUnifiedQuery];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),UNIFIEDQUERY] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            NSString *status = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"status"]];
            if ([status isEqualToString:@"22"]) {
//22就是交易正在处理中
//23 交易已批准
                if (self.webViewBlock) self.webViewBlock(responseObject,NO);
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self getDataFromNetWorkingCreditCards];
            }
        }
    }];
}

//信用卡支付
- (void)getDataFromNetWorkingCreditCards {
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getCreditCardsDictionary];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setDictionary:dic];
    [mutableDic setValue:_third_Model.cardId forKey:@"cardNum"];
    [mutableDic setValue:@"TRADE" forKey:@"purchaseType"];
    @WeakObj(self)
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:mutableDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),PAYMENT] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            NSString *status = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"status"]];
            if ([status isEqualToString:@"0"]) {
                 if (self.webViewBlock) self.webViewBlock(responseObject,YES);
                [self.navigationController popViewControllerAnimated:NO];
            } else {
                if (self.webViewBlock) self.webViewBlock(responseObject,NO);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (void)dealloc{
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"jsToOc"];
}

@end

@interface DiscountCodeView : UIView


@property (nonatomic ,strong)UIImageView *imageView;
@property (nonatomic ,strong)UIImageView *imageView1;
@property (nonatomic ,strong)UILabel *label;
@property (nonatomic ,strong)UIButton *button;
@property (nonatomic ,strong)UITextField *textField;
@property (nonatomic ,copy)UseTheDiscountCodeBlock useTheDiscountCodeBlock;

- (void)layoutAndLoadingData:(_Nullable id)model block:(void (^)(NSString *text))block;
@end

@implementation DiscountCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatView];
    }
    return self;
}

- (void)creatView {
    
    UIImageView *imageView = [UIImageView new];
    [self addSubview:imageView];
    _imageView = imageView;

    UIImageView *imageView1 = [UIImageView new];
    [self addSubview:imageView1];
    _imageView1 = imageView1;

    UILabel *label = [UILabel new];
    [self addSubview:label];
    _label = label;
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    [button setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].Use_Promo_Codes forState:UIControlStateNormal];
    button.titleLabel.font = ZD_Fout_Regular(14);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button = button;
    button.layer.cornerRadius = 3.5;
    button.layer.masksToBounds = YES;
    
    UITextField *textField = [[UITextField alloc] init];
    [self addSubview:textField];
    _textField = textField;
    [_textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    textField.font = ZD_Fout_Medium(14);
    textField.textColor = COLORWITHHEXSTRING(@"#999999", 1);
    
    for (int i=0; i<2; i++) {
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#DCDCDC", 1.0);
        [self addSubview:lineView];
        lineView.tag = 10+i;
    }
}

- (void)layoutAndLoadingData:(_Nullable id)model block:(void (^)(NSString *text))block {
    _useTheDiscountCodeBlock = block;
    
    _imageView.frame = CGRectMake(20, (49-20)/2, 20, 20);
    _imageView.image = [UIImage imageNamed:@"icon_yinlian"];
    
    _imageView1.frame = CGRectMake(_imageView.right+4, (49-20)/2, 20, 20);
    _imageView1.image = [UIImage imageNamed:@"icon_youjihua"];

    CGRect labelRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].Premium_Plan_Promo_Code withFont:[UIFont boldSystemFontOfSize:16]];
    _label.frame = CGRectMake(_imageView1.right+8, (49-16)/2, labelRect.size.width, 16);
    _label.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].Premium_Plan_Promo_Code;
    
    CGRect buttonRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].Use_Promo_Codes withFont:ZD_Fout_Regular(14)];

    _button.frame = CGRectMake(self.width-buttonRect.size.width-20, 49+(49-24)/2, buttonRect.size.width+10, 24);
    
    _textField.frame = CGRectMake(20, 49+(49-30)/2, self.width-_button.width-40, 30);
    _textField.placeholder = [[ZDPayInternationalizationModel sharedSingleten] getModelData].Please_enter_the_promo_code;
    
    for (int i=0; i<2; i++) {
        UIView *lineView = [self viewWithTag:10+i];
        lineView.frame = CGRectMake(0, i*(49+.5), self.width, .5);
    }
}

- (void)buttonAction:(UIButton *)sender {
    if (_useTheDiscountCodeBlock) {
        _useTheDiscountCodeBlock(_textField.text);
    }
}

- (void)textFieldAction:(UITextField *)textField {

}

@end


@interface ZDThirdHeaderView : UIButton
@property (nonatomic ,strong)UIImageView *headImageView;
@property (nonatomic ,strong)UIImageView *headImageView1;
@property (nonatomic ,strong)UILabel *nameLab;
@property (nonatomic ,strong)UILabel *tipsLab;

- (void)layoutData:(_Nullable id)model mySetion:(NSInteger)mySetion;
@end
@implementation ZDThirdHeaderView
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    UIImageView *headImageView = [UIImageView new];
    [self addSubview:headImageView];
    self.headImageView = headImageView;
    
    UIImageView *headImageView1 = [UIImageView new];
    [self addSubview:headImageView1];
    self.headImageView1 = headImageView1;
    
    UILabel *nameLab = [UILabel new];
    self.nameLab = nameLab;
    [self addSubview:nameLab];
    nameLab.textAlignment = NSTextAlignmentLeft;
    nameLab.font = [UIFont boldSystemFontOfSize:16];
    nameLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);

    
    UILabel *tipsLab = [UILabel new];
    self.tipsLab = tipsLab;
    [self addSubview:tipsLab];
    tipsLab.font = ZD_Fout_Medium(14);
    tipsLab.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
}

- (void)layoutData:(_Nullable id)model mySetion:(NSInteger)mySetion{
    
    self.headImageView.frame = CGRectMake(20, 15, 20, 20);
    self.headImageView.image = [UIImage imageNamed:@"icon_visa-line"];
    
    self.headImageView1.frame = CGRectMake(self.headImageView.right+4, 15, 20, 20);
    self.headImageView1.image = [UIImage imageNamed:@"icon_mastercard_line"];
    
    CGRect nameLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].credit_cards_accepted withFont:[UIFont boldSystemFontOfSize:16]];
    self.nameLab.frame = CGRectMake(self.headImageView1.right+4, 17, nameLabRect.size.width, 16);
    self.nameLab.text = model[mySetion];
    
    CGRect tipsLabRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].Add_new_credit_card_payments] withFont:ZD_Fout_Medium(14)];
    self.tipsLab.frame = CGRectMake(self.width-10-tipsLabRect.size.width, 18.5, tipsLabRect.size.width, 14);
    self.tipsLab.text = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].Add_new_credit_card_payments];
    
    if (mySetion != 2) {
        self.headImageView.hidden = YES;
        self.headImageView1.hidden = YES;
        self.userInteractionEnabled = NO;
        self.tipsLab.hidden = YES;
        self.nameLab.left = 20;
    }
    if (mySetion == 0) {
        self.headImageView.hidden = NO;
        self.headImageView.frame = CGRectMake(20, 15, 62, 20);
        self.headImageView.image = [UIImage imageNamed:@"icon_yinlianguoji"];
        
        self.nameLab.frame = CGRectMake(self.headImageView.right+4, 17, nameLabRect.size.width, 16);
    }
}
@end

@interface ZDPay_OrderSureViewController()<UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic ,strong)UITableView *payTableView;
@property (nonatomic ,strong)ZDPay_OrderSureHeaderView *headerView;
@property (nonatomic ,strong)ZDPay_OrderSureFooterView *footerView;
@property (nonatomic ,strong)ZDPay_OrderSureModel *pay_OrderSureModel;
@property (nonatomic ,strong)ZDPay_OrderSureRespModel *pay_OrderSureRespModel;
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *pay_OrderSurePayListRespModel;
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *third_Model;
@property (nonatomic ,strong)NSMutableArray *bankDataList;
@property (nonatomic ,strong)NSMutableArray *payDataList;
@property (nonatomic ,strong)NSMutableArray *bankPointDataList;
@property (nonatomic ,strong)NSMutableArray *payPointDataList;
@property (nonatomic ,strong)NSMutableArray *creditDataList;
@property (nonatomic ,strong)NSMutableArray *creditPointDataList;
@property (nonatomic ,strong)NSMutableArray *creditChannelCodeDataList;
@property (nonatomic ,assign)BOOL isSelProxy;
@property (nonatomic ,copy)NSString *password;
@property (nonatomic ,strong)NSIndexPath *oldIndexPath;
@property (nonatomic ,strong)ZDPay_OrderSureTableViewCell *oldCell;
@property (nonatomic ,assign)BOOL isImageSel;
@property (nonatomic ,assign)BOOL third_isImageSel;
@property (strong, nonatomic)CountDown *countDownForLab;
@property (assign, nonatomic)NSInteger recordSectionThird;
@property (assign, nonatomic)NSInteger recordSectionTwo;
@property (nonatomic ,strong)DiscountCodeView *backView;
@property (nonatomic ,assign)NSInteger sectionControl;
@end

@implementation ZDPay_OrderSureViewController
+ (instancetype)manager {
    return [[[self class] alloc] init];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:url forKey:@"url"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZDPay_callback" object:self userInfo:dic];
    return YES;
}

- (void)ZDPay_PaymentResultCallbackWithCompletionBlock:(void (^)(id _Nonnull responseObject))completionBlock {
    self.completionBlock = completionBlock;
}

//移除通知
- (void)dealloc {
    [self.countDownForLab destoryTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpPayPassword:(NSNotification *)noti {
    [self.payTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self getDataFromNetWorkingOrderSure:YES];
    [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSWORD_WAS_SUCCESSFULLY_CREATED target:nil];
}

- (void)bindBankCardSucceeded:(NSNotification *)noti {
    [self.payTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    [self getDataFromNetWorkingOrderSure:YES];
    [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].BIND_SUCCESSFULLY target:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isImageSel = 0;
    _third_isImageSel = 0;
    _recordSectionTwo = 0;
    _recordSectionThird = 0;
    self.view.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5",1.0);
    _countDownForLab = [[CountDown alloc] init];
    @WeakObj(self);
    self.topNavBar.backBlock = ^{
        @StrongObj(self)
        NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"9000" withData:@"" withMessage:@"支付取消"];
        self.completionBlock(mutableDic);
        [self.navigationController popViewControllerAnimated:NO];
        NSLog(@"%@",self.navigationController.viewControllers);
    };
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpPayPassword:) name:SETUPPAYMENTFEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindBankCardSucceeded:) name:BINDBANKCARDSUCCEEDED object:nil];

    self.isSelProxy = YES;
    
    [self getDataFromNetWorkingAppInternationalization];
}

#pragma mark - lazy loading
- (UITableView *)payTableView {
    if (!_payTableView) {
        _payTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _payTableView.showsVerticalScrollIndicator = NO;
        _payTableView.showsHorizontalScrollIndicator = NO;
        _payTableView.backgroundView = nil;
        _payTableView.backgroundColor = [UIColor clearColor];
        _payTableView.bounces = NO;
        _payTableView.scrollEnabled = YES;
        _payTableView.frame = CGRectMake(10 ,mcNavBarAndStatusBarHeight, ZDScreen_Width-20,ZDScreen_Height - mcNavBarAndStatusBarHeight);
        _payTableView.delegate = self;
        _payTableView.dataSource = self;
        [self.view addSubview:_payTableView];
        
        ZDPay_OrderSureHeaderView *headerView = [ZDPay_OrderSureHeaderView new];
        headerView.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
        headerView.frame = CGRectMake(0, 0, ZDScreen_Width, 133);
        _payTableView.tableHeaderView = headerView;
        self.headerView = headerView;
        
        ZDPay_OrderSureFooterView *footerView = [ZDPay_OrderSureFooterView new];
        footerView.backgroundColor = COLORWITHHEXSTRING(@"#F3F3F5", 1.0);
        _payTableView.tableFooterView = footerView;
        footerView.frame = CGRectMake(0, 0, ScreenWidth, 84);
        self.footerView = footerView;
    }
    return _payTableView;
}

- (NSMutableArray *)payDataList {
    if (!_payDataList) {
        _payDataList = [NSMutableArray array];
    }
    return _payDataList;
}

- (NSMutableArray *)bankDataList {
    if (!_bankDataList) {
        _bankDataList = [NSMutableArray array];
    }
    return _bankDataList;
}

- (NSMutableArray *)payPointDataList {
    if (!_payPointDataList) {
        _payPointDataList = [NSMutableArray array];
    }
    return _payPointDataList;
}

- (NSMutableArray *)creditPointDataList {
    if (!_creditPointDataList) {
        _creditPointDataList = [NSMutableArray array];
    }
    return _creditPointDataList;
}

- (NSMutableArray *)bankPointDataList {
    if (!_bankPointDataList) {
        _bankPointDataList = [NSMutableArray array];
    }
    return _bankPointDataList;
}

- (NSMutableArray *)creditDataList {
    if (!_creditDataList) {
        _creditDataList = [NSMutableArray array];
    }
    return _creditDataList;
}

- (NSMutableArray *)creditChannelCodeDataList {
    if (!_creditChannelCodeDataList) {
        _creditChannelCodeDataList = [NSMutableArray array];
    }
    return _creditChannelCodeDataList;
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        if (self.bankDataList) {
            return self.bankPointDataList.count+1;
        }
        return 2;
    } else if (section == 1) {
        if (self.payDataList) {
            if (self.payPointDataList.count>2) {
                return self.payPointDataList.count;
            }
            return self.payPointDataList.count + 1;
        }
        return 0;
    } else {
        if (self.creditDataList) {
            if (self.creditDataList.count==0) {
                return 0;
            }
            if (self.creditDataList.count==1) {
                return 1;
            }
            return self.creditPointDataList.count + 1;
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"ldcellid";
    ZDPay_OrderSureTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (!cell) {
        cell = [[ZDPay_OrderSureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);

        UIView *lineView = [UIView new];
        [cell.contentView addSubview:lineView];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#DCDCDC", 1.0);
        lineView.tag = 30;
        
        if (indexPath.section == 0) {
            if (indexPath.row == self.bankPointDataList.count && ![self.pay_OrderSureRespModel.bankList isKindOfClass:[NSString class]]) {
                UILabel *label = [UILabel new];
                [cell.contentView addSubview:label];
                label.tag = 200;
                label.font = ZD_Fout_Medium(14);
                label.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
            }
        } else if (indexPath.section == 1){
            if (self.payPointDataList.count < 3) {
                if (indexPath.row == self.payPointDataList.count) {
                    UILabel *label = [UILabel new];
                    [cell.contentView addSubview:label];
                    label.tag = 200;
                    label.font = ZD_Fout_Medium(14);
                    label.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
                }
            }
        } else {
            if (indexPath.row == self.creditPointDataList.count && ![self.creditDataList isKindOfClass:[NSString class]]) {
                UILabel *label = [UILabel new];
                [cell.contentView addSubview:label];
                label.tag = 200;
                label.font = ZD_Fout_Medium(14);
                label.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
            }

        }
    }

    UIView *lineView = (UIView *)[cell.contentView viewWithTag:30];
    
    if (indexPath.section == 0) {
        if (self.third_isImageSel == 1) {
            self.isImageSel = 0;
        }
        
        if (indexPath.row == self.bankPointDataList.count &&  ![self.pay_OrderSureRespModel.bankList isKindOfClass:[NSString class]]) {
            NSString *SWITCH_UNIONPAY_CARD = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].SWITCH_UNIONPAY_CARD];
            CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:SWITCH_UNIONPAY_CARD withFont:ZD_Fout_Medium(14)];
            UILabel *label = [cell.contentView viewWithTag:200];
            label.frame = CGRectMake(48, 19, rect.size.width, 14);
            label.text = SWITCH_UNIONPAY_CARD;
        } else {
            lineView.frame = CGRectMake(20, 49-.5, self.payTableView.width-20, .5);
            [cell layoutAndLoadData:self.bankPointDataList[indexPath.row] isImageSel:self.isImageSel];
            self.isImageSel = 0;
        }
    }
    
    if (indexPath.section == 1){
        if (self.third_isImageSel == 1) self.isImageSel = 0;
        if (self.payPointDataList.count < 2) {
            if (indexPath.row == self.payPointDataList.count) {
                CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:@"暂无更多支付方式" withFont:ZD_Fout_Medium(14)];
                UILabel *label = [cell.contentView viewWithTag:200];
                label.frame = CGRectMake(48, 19, rect.size.width, 14);
                label.text = @"暂无更多支付方式";
            }
            
            if (indexPath.row >= 0 && indexPath.row < self.payPointDataList.count) {
                lineView.frame = CGRectMake(20, 49-.5, self.payTableView.width-20, .5);
                [cell layoutAndLoadData:self.payPointDataList[indexPath.row] isImageSel:self.isImageSel];
            }
        } else if (self.payPointDataList.count > 1 && self.payPointDataList.count < 3) {
            if (indexPath.row == self.payPointDataList.count) {
                NSString *SWITCH_UNIONPAY_CARD = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].AND_MORE_PAYMENT_METHODS];
                CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:SWITCH_UNIONPAY_CARD withFont:ZD_Fout_Medium(14)];
                UILabel *label = [cell.contentView viewWithTag:200];
                label.frame = CGRectMake(48, 19, rect.size.width, 14);
                label.text = SWITCH_UNIONPAY_CARD;
            }
            
            if (indexPath.row >= 0 && indexPath.row < self.payPointDataList.count) {
                lineView.frame = CGRectMake(20, 49-.5, self.payTableView.width-20, .5);
                [cell layoutAndLoadData:self.payPointDataList[indexPath.row] isImageSel:self.isImageSel];
            }
        } else {
            lineView.frame = CGRectMake(20, 49-.5, self.payTableView.width-20, .5);
            [cell layoutAndLoadData:self.payPointDataList[indexPath.row] isImageSel:self.isImageSel];
            if (_recordSectionTwo == 1 && indexPath.row == self.payPointDataList.count-1) lineView.hidden = YES;
        }
    }

    if (indexPath.section == 2){
        if (self.third_isImageSel == 1) self.isImageSel = 1;
        if (indexPath.row == self.creditPointDataList.count &&  ![self.creditDataList isKindOfClass:[NSString class]]) {
            NSString *SWITCH_UNIONPAY_CARD = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].Expand_more_credit_card_payments];
            CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:SWITCH_UNIONPAY_CARD withFont:ZD_Fout_Medium(14)];
            UILabel *label = [cell.contentView viewWithTag:200];
            label.frame = CGRectMake(48, 19, rect.size.width, 14);
            label.text = SWITCH_UNIONPAY_CARD;
            self.isImageSel = 0;
        } else {
            lineView.frame = CGRectMake(20, 49-.5, self.payTableView.width-20, .5);
            [cell layoutAndLoadData:self.creditPointDataList[indexPath.row] isImageSel:self.isImageSel];
            self.isImageSel = 0;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && [self.pay_OrderSureRespModel.bankList isKindOfClass:[NSString class]]) {
        return 0;
    }
    return 49;
}

//cell每组第一和最后一个单元格切圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    CGFloat radius = 6.f;
    cell.backgroundColor = UIColor.clearColor;
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    CGRect bounds = CGRectInset(cell.bounds, 0, 0);
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    UIBezierPath *bezierPath = nil;
    if (rowNum == 1) {
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
    }else{
        if (indexPath.row == 0) {
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
        }else if (indexPath.row == rowNum - 1){
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(radius, radius)];
        }else{
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
        }
    }
     normalLayer.path = bezierPath.CGPath;
     selectLayer.path = bezierPath.CGPath;
        
     UIView *nomarBgView = [[UIView alloc] initWithFrame:bounds];
     normalLayer.fillColor = [[UIColor whiteColor] CGColor];
     [nomarBgView.layer insertSublayer:normalLayer atIndex:0];
     nomarBgView.backgroundColor = UIColor.clearColor;
     cell.backgroundView = nomarBgView;

    UIView *selectBgView = [[UIView alloc] initWithFrame:bounds];
     selectLayer.fillColor = [[UIColor whiteColor] CGColor];
     [selectBgView.layer insertSublayer:selectLayer atIndex:0];
     selectBgView.backgroundColor = UIColor.clearColor;
     cell.selectedBackgroundView = selectBgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    [self.headerView layoutAndLoadData:model countDownForLab:_countDownForLab];
    UIView *view = [UIView new];
//    if (section == 2) {
    NSArray *array = @[@"银行卡支付",[[ZDPayInternationalizationModel sharedSingleten] getModelData].APP_to_pay,[[ZDPayInternationalizationModel sharedSingleten] getModelData].credit_cards_accepted];
    ZDThirdHeaderView *bgView = [ZDThirdHeaderView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame = CGRectMake(0, 0, _payTableView.width, 51);
    [view addSubview:bgView];
    [bgView layoutData:array mySetion:section];
    [bgView addTarget:self action:@selector(addMoreCreditCardAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [ZDPayFuncTool setupRoundedCornersWithView:bgView cutCorners:UIRectCornerTopLeft | UIRectCornerTopRight borderColor:nil cutCornerRadii:CGSizeMake(6, 6) borderWidth:0 viewColor:nil];
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#DCDCDC", 1.0);
    lineView.frame = CGRectMake(0, bgView.bottom+.5, _payTableView.width, .5);
    [view addSubview:lineView];
   // }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        DiscountCodeView *backView = [[DiscountCodeView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 49*2)];
        self.backView = backView;
        [view addSubview:backView];
        if (_sectionControl == 0) {
            self.backView.hidden = YES;
        } else {
            self.backView.hidden = NO;
        }
        [backView layoutAndLoadingData:nil block:^(NSString *text) {
            if (![text isEqualToString:@""]) {
                [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].For_successful target:nil];
                self.headerView.discountCodeLab.hidden = NO;
                NSString *amountMoneyStr = [ZDPayFuncTool formatToTwoDecimal:[NSString stringWithFormat:@"%f",[[[ZDPay_OrderSureModel sharedSingleten] getModelData].txnAmt doubleValue] - 200*1]];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSString stringWithFormat:@"%f",[[[ZDPay_OrderSureModel sharedSingleten] getModelData].txnAmt doubleValue] - 200*1] forKey:@"txnAmt"];
                [userDefaults synchronize];

                self.headerView.moneyUnitLab.text = [NSString stringWithFormat:@"%@ %@",[[ZDPay_OrderSureModel sharedSingleten] getModelData].currencyCode,amountMoneyStr];
                [ZDPayFuncTool LabelAttributedString:self.headerView.moneyUnitLab FontNumber:ZD_Fout_Medium(ratioH(30)) AndRange:NSMakeRange(4, amountMoneyStr.length-2) AndColor:nil];
                
                [self.footerView.surePayBtn setTitle:[NSString stringWithFormat:@"%@ %@ %@",[[ZDPayInternationalizationModel sharedSingleten] getModelData].CONFIRM_AND_PAY,[[ZDPay_OrderSureModel sharedSingleten] getModelData].currencyCode,amountMoneyStr] forState:UIControlStateNormal];
            } else {
                [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].Please_enter_the_promo_code target:nil];
            }
        }];
        return view;
    }

    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    @WeakObj(self)
    [self.footerView layoutAndLoadData:model surePay:^(UIButton * _Nonnull sender) {
        @StrongObj(self)
        if (self.pay_OrderSurePayListRespModel.channelCode) {
            if ([model.isPopup isEqualToString:@"1"]) {
                ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:Reminder];
                [popView showPopupMakeViewWithData:@"" reminder:^(UIButton * _Nonnull sender) {
                    [popView closeThePopupView];
                    if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
                        [self getDataFromNetWorkingCreditCards];
                        return ;
                    }
                    
                    if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@""]) {
                        [self UNIONPAY];
                        return ;
                    }
        
                    if (([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"APPLEPAY"])) {
                        [self APPLEPAY];
                        return ;
                    }
        
                    //其他
                    [self getDataFromNetWorkingPutPay];
                }];
            } else {
                if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
                    [self getDataFromNetWorkingCreditCards];
                    return ;
                }

                if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@""]) {
                    [self UNIONPAY];
                    return ;
                }
    
                if (([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"APPLEPAY"])) {
                    [self APPLEPAY];
                    return ;
                }
    
                //其他
                [self getDataFromNetWorkingPutPay];
            }
        } else {
            [self showMessage:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PLEASE_SELECT_PAYMENT_METHOD target:nil];
        }
    } selProxy:^(UIButton * _Nonnull sender) {
        self.isSelProxy = !sender.selected;
    }];

    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 51;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 49;
    }
    
    if (section == 0) {
        if (_sectionControl == 0) {
            return 11;
        } else {
            return 49*2+11;
        }
    }
    return 12;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.third_isImageSel = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0 && self.bankPointDataList.count != 0) {

            //记录选择支付方式对应数据
            ZDPay_OrderSurePayListRespModel *model = self.bankPointDataList[indexPath.row];
            NSDictionary *dic = [model mj_keyValues];
            [[ZDPay_OrderSurePayListRespModel sharedSingleten] setModelProcessingDic:dic];

            //获取上一个cell，改变选择支付方式图标
            if (self.oldIndexPath) {
                self.oldCell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:self.oldIndexPath];
                self.oldCell.selectImageView.image = [UIImage imageNamed:@"btn_unch"];
            }

            ZDPay_OrderSureTableViewCell *cell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.selectImageView.image = [UIImage imageNamed:@"btn_choose"];
            self.oldIndexPath = indexPath;

            self.pay_OrderSurePayListRespModel = self.bankPointDataList[indexPath.row];

            NSIndexPath *insetPath1 = [NSIndexPath indexPathForRow:0 inSection:2];
            ZDPay_OrderSureTableViewCell *cell2 = (ZDPay_OrderSureTableViewCell *)[self.payTableView cellForRowAtIndexPath:insetPath1];
            cell2.selectImageView.image = [UIImage imageNamed:@"btn_unch"];

            _sectionControl = 1;
            self.isImageSel = 1;
            [self.payTableView beginUpdates];
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                [self.payTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [self.payTableView endUpdates];
        }

        if (indexPath.row == self.bankPointDataList.count) {
            @WeakObj(self)
            self.pay_OrderSurePayListRespModel = nil;
            ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:SelectPayMethod];
            [popView showPopupViewWithData:self.bankDataList SelectPayMethod:^(UITableView * _Nullable tableView, NSIndexPath * _Nullable indexPath, id  _Nullable model) {
                @StrongObj(self)
                if ([model isKindOfClass:[NSString class]]) {
                    ZDPay_OrderSureRespModel *respModel = [[ZDPay_OrderSureRespModel sharedSingleten] getModelData];
                    ZDPay_OrderSureBankListRespModel *bankModel = [[ZDPay_OrderSureRespModel sharedSingleten] getModelData].bankList;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:bankModel.isSetPwd forKey:@"shezhimima"];
                    [userDefaults synchronize];

                    if ([bankModel isKindOfClass:[ZDPay_OrderSureBankListRespModel class]]) {
                        if ([bankModel.isSetPwd isEqualToString:@"0"] && [respModel.isUser isEqualToString:@"0"]) {
                            ZDPay_SecurityVerificationSecondViewController *vc = [ZDPay_SecurityVerificationSecondViewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        } else {
                            ZDPay_AddBankCardViewController *vc = [ZDPay_AddBankCardViewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    } else {
                        if ([respModel.isUser isEqualToString:@"0"]) {
                             ZDPay_SecurityVerificationSecondViewController *vc = [ZDPay_SecurityVerificationSecondViewController new];
                             [self.navigationController pushViewController:vc animated:YES];
                         } else {
                             ZDPay_AddBankCardViewController *vc = [ZDPay_AddBankCardViewController new];
                             [self.navigationController pushViewController:vc animated:YES];
                         }
                    }
                } else {
                    self.isImageSel = 1;
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        self.pay_OrderSurePayListRespModel = (ZDPay_OrderSurePayListRespModel *)model;
                        [self.bankPointDataList removeAllObjects];
                        [self.bankPointDataList addObject:(ZDPay_OrderSurePayListRespModel *)model];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.sectionControl = 1;
                            [self.payTableView reloadData];
                        });
                    });

                }
            } SlideLeftToDelete:^(id  _Nullable info) {
                [self getDataFromNetWorkingUntying:info];
            } withPayListRespModel:self.pay_OrderSurePayListRespModel];
        }
    }
    
    if (indexPath.section == 1) {

        if (indexPath.row >= 0 && indexPath.row < self.payPointDataList.count) {

            //记录选择支付方式对应数据
            ZDPay_OrderSurePayListRespModel *model = self.payPointDataList[indexPath.row];
            NSDictionary *dic = [model mj_keyValues];
            [[ZDPay_OrderSurePayListRespModel sharedSingleten] setModelProcessingDic:dic];

            //获取上一个cell，改变选择支付方式图标
            if (self.oldIndexPath) {
                self.oldCell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:self.oldIndexPath];
                self.oldCell.selectImageView.image = [UIImage imageNamed:@"btn_unch"];
            }

            ZDPay_OrderSureTableViewCell *cell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.selectImageView.image = [UIImage imageNamed:@"btn_choose"];
            self.oldIndexPath = indexPath;

            NSIndexPath *insetPath = [NSIndexPath indexPathForRow:1 inSection:0];
            ZDPay_OrderSureTableViewCell *cell1 = (ZDPay_OrderSureTableViewCell *)[self.payTableView cellForRowAtIndexPath:insetPath];
            cell1.selectImageView.image = [UIImage imageNamed:@"btn_unch"];

            NSIndexPath *insetPath1 = [NSIndexPath indexPathForRow:0 inSection:2];
            ZDPay_OrderSureTableViewCell *cell2 = (ZDPay_OrderSureTableViewCell *)[self.payTableView cellForRowAtIndexPath:insetPath1];
            cell2.selectImageView.image = [UIImage imageNamed:@"btn_unch"];

            //获取选中支付方式，在确认支付时传递的参数
            self.pay_OrderSurePayListRespModel = self.payPointDataList[indexPath.row];
            
            _sectionControl = 0;
            [self.payTableView beginUpdates];
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                [self.payTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [self.payTableView endUpdates];
        }

        if (indexPath.row == self.payPointDataList.count) {
            _recordSectionTwo = 1;
            [self.payPointDataList removeAllObjects];
            [self.payPointDataList addObjectsFromArray:self.payDataList];
            [tableView reloadData];
        }
    }
    
    if (indexPath.section == 2) {

        if (indexPath.row >= 0 && indexPath.row < self.creditDataList.count) {

            //记录选择支付方式对应数据
            ZDPay_OrderSurePayListRespModel *model = self.creditDataList[indexPath.row];
            NSDictionary *dic = [model mj_keyValues];
            [[ZDPay_OrderSurePayListRespModel sharedSingleten] setModelProcessingDic:dic];
            _third_Model = model;
            //获取上一个cell，改变选择支付方式图标
            if (self.oldIndexPath) {
                self.oldCell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:self.oldIndexPath];
                self.oldCell.selectImageView.image = [UIImage imageNamed:@"btn_unch"];
            }

            ZDPay_OrderSureTableViewCell *cell = (ZDPay_OrderSureTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.selectImageView.image = [UIImage imageNamed:@"btn_choose"];
            self.oldIndexPath = indexPath;

            NSIndexPath *insetPath = [NSIndexPath indexPathForRow:1 inSection:0];
            ZDPay_OrderSureTableViewCell *cell1 = (ZDPay_OrderSureTableViewCell *)[self.payTableView cellForRowAtIndexPath:insetPath];
            cell1.selectImageView.image = [UIImage imageNamed:@"btn_unch"];

            //获取选中支付方式，在确认支付时传递的参数
            self.pay_OrderSurePayListRespModel = self.creditChannelCodeDataList[0];
            
            _sectionControl = 0;
            [self.payTableView beginUpdates];
                NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                [self.payTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            [self.payTableView endUpdates];
        }

        if (indexPath.row == self.creditPointDataList.count) {
//            _recordSectionThird = 1;
//            [self.creditDataList removeAllObjects];
//            [self.creditDataList addObjectsFromArray:self.payDataList];
//            [tableView reloadData];
            //self.pay_OrderSurePayListRespModel = self.creditChannelCodeDataList[0];
            @WeakObj(self)
            ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:SelectPayMethod];
            [popView showPopupViewWithData:self.creditDataList SelectPayMethod:^(UITableView * _Nullable tableView, NSIndexPath * _Nullable indexPath, id  _Nullable model) {
                @StrongObj(self)
                if ([model isKindOfClass:[NSString class]]) {
                    ZDPay_OrderSureRespModel *respModel = [[ZDPay_OrderSureRespModel sharedSingleten] getModelData];
                    ZDPay_OrderSureBankListRespModel *bankModel = [[ZDPay_OrderSureRespModel sharedSingleten] getModelData].bankList;
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:bankModel.isSetPwd forKey:@"shezhimima"];
                    [userDefaults synchronize];

                    if ([bankModel isKindOfClass:[ZDPay_OrderSureBankListRespModel class]]) {
                        if ([bankModel.isSetPwd isEqualToString:@"0"] && [respModel.isUser isEqualToString:@"0"]) {
                            ZDPay_SecurityVerificationSecondViewController *vc = [ZDPay_SecurityVerificationSecondViewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        } else {
                            ZDPay_AddBankCardViewController *vc = [ZDPay_AddBankCardViewController new];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    } else {
                        if ([respModel.isUser isEqualToString:@"0"]) {
                             ZDPay_SecurityVerificationSecondViewController *vc = [ZDPay_SecurityVerificationSecondViewController new];
                             [self.navigationController pushViewController:vc animated:YES];
                         } else {
                             ZDPay_AddBankCardViewController *vc = [ZDPay_AddBankCardViewController new];
                             [self.navigationController pushViewController:vc animated:YES];
                         }
                    }
                } else {
                    self.isImageSel = 1;
                    self.third_isImageSel = 1;
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    dispatch_async(queue, ^{
                        self.pay_OrderSurePayListRespModel = (ZDPay_OrderSurePayListRespModel *)model;
                        [self.creditPointDataList removeAllObjects];
                        [self.creditPointDataList addObject:(ZDPay_OrderSurePayListRespModel *)model];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.payTableView reloadData];
                        });
                    });

                }
            } SlideLeftToDelete:^(id  _Nullable info) {
                [self getDataFromNetWorkingUntying:info];
            } withPayListRespModel:self.pay_OrderSurePayListRespModel];
        }
    }
}

/**
    确保tableView滑动的时候选中的支付方式选中图标不被覆盖
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.oldIndexPath) {
        self.oldCell = (ZDPay_OrderSureTableViewCell *)[self.payTableView cellForRowAtIndexPath:self.oldIndexPath];
        self.oldCell.selectImageView.image = [UIImage imageNamed:@"btn_choose"];
    }
}

#pragma mark - actions
- (void)addMoreCreditCardAction:(UIButton *)sender {
    ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:6];
    [popView showPopupMakeViewWithData:nil addCreditCard:^(UIButton * _Nonnull sender, id  _Nonnull info) {
        [self getDataFromNetWorkingSaveVisaCard:info];
    }];
}

#pragma mark - 支付业务处理
- (void)UNIONPAY {
    ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:0];
    [popView showPopupViewWithData:self.pay_OrderSurePayListRespModel payPass:^(NSString * _Nonnull text, BOOL isFinished) {
        self.password = text;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.password forKey:@"password"];
        [userDefaults synchronize];
        
        if (isFinished) {
            [popView closeThePopupView];
            [self getDataFromNetWorkingSurePayPassword];
        }
    } forgetPass:^{
        [popView closeThePopupView];
        ZD_PayForgetPasswordViewController *vc = [ZD_PayForgetPasswordViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)APPLEPAY {
    if (![PKPaymentAuthorizationViewController canMakePayments]) return;
    if (@available(iOS 9.2, *)) {
        if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:
              @[PKPaymentNetworkVisa,PKPaymentNetworkChinaUnionPay,PKPaymentNetworkDiscover]]) {
            //进入设置银行卡界面
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
                PKPassLibrary *library = [[PKPassLibrary alloc] init];
                [library openPaymentSetup];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"shoebox://"]];
            }
            return;
        }
    } else {
        // Fallback on earlier versions
        if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkVisa,PKPaymentNetworkDiscover]]) {
            //进入设置银行卡界面
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3) {
                PKPassLibrary *library = [[PKPassLibrary alloc] init];
                [library openPaymentSetup];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"shoebox://"]];
            }
            return;
        }
    }
    
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getApplePayDictionary];

    //最后，则创建支付请求
    PKPaymentRequest *request = [PKPaymentRequest new];
    request.merchantIdentifier = [dic objectForKey:@"merchantid"];
    request.countryCode = [dic objectForKey:@"countryCode"];
    request.currencyCode = [dic objectForKey:@"currencyCode"];
    request.merchantCapabilities = PKMerchantCapabilityCredit|PKMerchantCapabilityDebit|PKMerchantCapability3DS|PKMerchantCapabilityEMV; //3DS支付方式是必须支持的，其他方式可选
    if (@available(iOS 9.2, *)) {
        request.supportedNetworks = @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkDiscover];
    } else {
        // Fallback on earlier versions
        request.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkDiscover];
    }
    request.shippingType = PKShippingTypeShipping;
    NSDecimalNumber *threemAmout = [NSDecimalNumber decimalNumberWithString:[ZDPayFuncTool formatToTwoDecimal:[dic objectForKey:@"txnAmt"]]];
    NSDecimalNumber *itemTotal = [NSDecimalNumber zero];
    itemTotal = [itemTotal decimalNumberByAdding:threemAmout];
    PKPaymentSummaryItem *itemSum = [PKPaymentSummaryItem summaryItemWithLabel:[[ZDPay_OrderSureModel sharedSingleten] getModelData].BeeMall amount:itemTotal];

    request.paymentSummaryItems = @[itemSum];
    PKPaymentAuthorizationViewController *paymentVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    paymentVC.delegate = self;
    if (!paymentVC) return;
    [self presentViewController:paymentVC animated:YES completion:^{
    }];
}

/**
 *  支付的时候回调
 */
#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion API_DEPRECATED("Use paymentAuthorizationViewController:didAuthorizePayment:handler: instead to provide more granular errors", ios(8.0, 11.0)) {
    if (payment){
        NSData * paymentData = payment.token.paymentData;
        NSError * error = nil;
        NSDictionary *dics = [NSJSONSerialization JSONObjectWithData:paymentData
                                                            options:NSJSONReadingMutableContainers
                                                             error:&error];
        completion(PKPaymentAuthorizationStatusSuccess);
        PKPaymentToken *payToken = payment.token;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getApplePayDictionary];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic setObject:dic forKey:@"paymentData"];
            [mutableDic addEntriesFromDictionary:dic];
            if (dics) {
                NSData *data=[NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [mutableDic setObject:jsonStr forKey:@"paymentData"];
            }
            [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:mutableDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),PAYMENT] suscess:^(id  _Nullable responseObject) {
                if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
                    NSMutableDictionary *dic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付成功"];
                    [dic setValue:@"Applepay" forKey:@"paymentMethod"];
                    self.completionBlock(dic);
                }
            }];
        });
    }
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull ))completion  API_AVAILABLE(ios(11.0)){
    if (payment){
        NSData * paymentData = payment.token.paymentData;
        NSError * error = nil;
        NSDictionary *dics = [NSJSONSerialization JSONObjectWithData:paymentData
                                                            options:NSJSONReadingMutableContainers
                                                             error:&error];
        completion(PKPaymentAuthorizationStatusSuccess);
        PKPaymentToken *payToken = payment.token;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getApplePayDictionary];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic setObject:dic forKey:@"paymentData"];
            [mutableDic addEntriesFromDictionary:dic];
            if (dics) {
                NSData *data=[NSJSONSerialization dataWithJSONObject:dics options:NSJSONWritingPrettyPrinted error:nil];
                NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                [mutableDic setObject:jsonStr forKey:@"paymentData"];
            }
            [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:mutableDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),PAYMENT] suscess:^(id  _Nullable responseObject) {
                if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
                    NSMutableDictionary *dic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付成功"];
                    [dic setValue:@"Applepay" forKey:@"paymentMethod"];
                    self.completionBlock(dic);
                }
            }];
        });
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    
    //支付页面关闭
    //点击支付/取消按钮调用该代理方法
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - get data
- (void)getDataFromNetWorkingOrderSure:(BOOL)isRefresh {
    if (isRefresh == YES) {
        [self.payDataList removeAllObjects];
        [self.payPointDataList removeAllObjects];
        [self.bankDataList removeAllObjects];
        [self.bankPointDataList removeAllObjects];
        [self.creditDataList removeAllObjects];
        [self.creditPointDataList removeAllObjects];
        [self.creditChannelCodeDataList removeAllObjects];
    }
    NSDictionary *paramsDic = [self.orderModel mj_keyValues];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic addEntriesFromDictionary:paramsDic];
    [dic setValue:self.orderModel.txnAmt forKey:@"amount"];
    @WeakObj(self)
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),QUERYPAYMETHOD] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_OrderSureRespModel *model = [ZDPay_OrderSureRespModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [[ZDPay_OrderSureRespModel sharedSingleten] setModelProcessingDic:[responseObject objectForKey:@"data"]];
            self.pay_OrderSureRespModel = model;
            if (![self.pay_OrderSureRespModel.bankList isKindOfClass:[NSString class]]) {
                [self.pay_OrderSureRespModel.bankList.Token enumerateObjectsUsingBlock:^(ZDPay_OrderBankListTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                    [self.bankDataList addObject:model];
                }];

                if (self.bankDataList.count > 0) {
                    [self.bankPointDataList addObject:self.bankDataList[0]];
                }
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[NSString stringWithFormat:@"%lu",(unsigned long)self.bankDataList.count] forKey:@"bankDataListCount"];
                [userDefaults synchronize];
            }
            
            if ([self.pay_OrderSureRespModel.payList isKindOfClass:[NSArray class]]) {
                [self.pay_OrderSureRespModel.payList enumerateObjectsUsingBlock:^(ZDPay_OrderSurePayListRespModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                    if (![model.channelCode isEqualToString:@"UNIONPAY"] && ![model.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
                        [self.payDataList addObject:model];
                    }

                    if ([model.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
                        [self.creditChannelCodeDataList addObject:model];
                        [model.Token enumerateObjectsUsingBlock:^(ZDPay_OrderBankListTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            
                            ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                            [self.creditDataList addObject:model];
                        }];

                        if (self.creditDataList.count > 0) {
                            [self.creditPointDataList addObject:self.creditDataList[0]];
                        }
                    }
                }];
                if (self.payDataList.count > 2) {
                    [self.payPointDataList addObject:self.payDataList[0]];
                    [self.payPointDataList addObject:self.payDataList[1]];
                } else {
                    [self.payPointDataList addObjectsFromArray:self.payDataList];
                }
            }
            if (isRefresh == YES) {
                [self.payTableView reloadData];
            } else {
                [self payTableView];
            }
        }
    }];
}

- (void)getDataFromNetWorkingOrderSureRefresh {
    [self.payDataList removeAllObjects];
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    NSDictionary *paramsDic = [model mj_keyValues];
    @WeakObj(self)
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:paramsDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),QUERYPAYMETHOD] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            ZDPay_OrderSureRespModel *model = [ZDPay_OrderSureRespModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [[ZDPay_OrderSureRespModel sharedSingleten] setModelProcessingDic:[responseObject objectForKey:@"data"]];
            self.pay_OrderSureRespModel = model;
            if (self.pay_OrderSureRespModel.bankList.Token) {
                [self.pay_OrderSureRespModel.bankList.Token enumerateObjectsUsingBlock:^(ZDPay_OrderBankListTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                    [self.bankDataList addObject:model];
                }];
                
                if (self.bankDataList.count > 0) {
                    [self.bankPointDataList addObject:self.bankDataList[0]];
                }
            }
            if ([self.pay_OrderSureRespModel.payList isKindOfClass:[NSArray class]]) {
                [self.pay_OrderSureRespModel.payList enumerateObjectsUsingBlock:^(ZDPay_OrderSurePayListRespModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ZDPay_OrderSurePayListRespModel *model = [ZDPay_OrderSurePayListRespModel mj_objectWithKeyValues:obj];
                    if (![model.channelCode isEqualToString:@"UNIONPAY"]) {
                        [self.payDataList addObject:model];
                    }
                }];
                if (self.payDataList.count > 2) {
                    [self.payPointDataList addObject:self.payDataList[0]];
                    [self.payPointDataList addObject:self.payDataList[1]];
                } else {
                    [self.payPointDataList addObjectsFromArray:self.payDataList];
                }
            }
            [self.payTableView reloadData];
        }
    }];
}

- (void)getDataFromNetWorkingPutPay {

    NSDictionary *dic = nil;
    NSInteger payMethod = 0;
    if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"ALIPAY"]) {
        dic = [[ZDPayFuncTool sharedSingleton] getPutPayDictionary];
        payMethod = Alipay;
    }

    if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"UNIONCLOUDPAY"]) {
        dic = [[ZDPayFuncTool sharedSingleton] getUnionCloudPayDictionary];
        payMethod = UPPay;
    }

    if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"WECHAT"]) {
        NSLog(@"%@",[[ZDPay_OrderSureModel sharedSingleten] getModelData].subAppid);
        [WXApi registerApp:[[ZDPay_OrderSureModel sharedSingleten] getModelData].subAppid universalLink:[[ZDPay_OrderSureModel sharedSingleten] getModelData].associate_domain];
        dic = [[ZDPayFuncTool sharedSingleton] getWechatDictionary];
        payMethod = WeiXin;
    }

    @WeakObj(self)
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),PAYMENT] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        PayModel *model = [PayModel new];
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"ALIPAY"]) {
                NSString *str = [[responseObject objectForKey:@"data"] objectForKey:@"payInfo"];
                NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                model.goodsName =  [dic objectForKey:@"payRequest"];
            }

            if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"UNIONCLOUDPAY"]) {
                model.tn = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"tn"]];
            }

            if ([[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode isEqualToString:@"WECHAT"]) {
                NSString *str = [[responseObject objectForKey:@"data"] objectForKey:@"payInfo"];
                NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                model.timeStamp =  [dic objectForKey:@"timeStamp"];
                model.partnerid = @"352466557";
                model.prepayId = [dic objectForKey:@"prepayId"];
                model.nonceStr = [dic objectForKey:@"nonceStr"];
                model.packageValue = [dic objectForKey:@"packageValue"];
                model.paySign = [dic objectForKey:@"paySign"];
            }

            [[ZDGPayManagerTool shareTool] startPaymentWithPayMethod:payMethod payParametersModel:model viewController:self PaySuccess:^(id  _Nonnull responseObject){
                NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:responseObject withMessage:@"支付成功"];
                [mutableDic setValue:[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode forKey:@"paymentMethod"];
                self.completionBlock(mutableDic);
            } payCancel:^(id  _Nonnull desc) {
                NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"3000" withData:desc withMessage:@"支付取消"];
                [mutableDic setValue:[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode forKey:@"paymentMethod"];             self.completionBlock(mutableDic);
            } PayFailed:^(id  _Nonnull desc) {
                NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"2000" withData:desc withMessage:@"支付失败"];
                [mutableDic setValue:[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode forKey:@"paymentMethod"];                self.completionBlock(mutableDic);
            }];
            return ;
        }
     }];
}

- (void)getDataFromNetWorkingSurePayPassword {
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getSurePayPasswordDictionary];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setDictionary:dic];
    [mutableDic setValue:self.pay_OrderSurePayListRespModel.cardId forKey:@"cardNum"];
    @WeakObj(self)
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:mutableDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),PAYMENT] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        NSLog(@"responseObject:%@",responseObject);
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付成功"];
            [mutableDic setValue:[[ZDPay_OrderSurePayListRespModel sharedSingleten] getModelData].channelCode forKey:@"paymentMethod"];
            self.completionBlock(mutableDic);
        }
    }];
}

//信用卡支付
- (void)getDataFromNetWorkingCreditCards {
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getCreditCardsDictionary];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setDictionary:dic];
    [mutableDic setValue:_third_Model.cardId forKey:@"cardNum"];
    @WeakObj(self)
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:mutableDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),PAYMENT] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        NSLog(@"responseObject:%@",responseObject);
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
    
            ZDWKWebViewController *vc = [ZDWKWebViewController new];
            vc.third_Model = self.third_Model;
            vc.payInfo = [[responseObject objectForKey:@"data"] objectForKey:@"payInfo"];
            vc.webViewBlock = ^(id  _Nullable message,BOOL paySuccess) {
                if (paySuccess == YES) {
                    NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:responseObject withMessage:@"支付成功"];
                    [mutableDic setValue:@"MASTERCARD_PAYMENT_GATEWAY" forKey:@"paymentMethod"];
                    self.completionBlock(mutableDic);
                    //[self.navigationController popViewControllerAnimated:YES];
                } else {
                    
                    [self showMessage:[message objectForKey:@"message"] target:nil];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
//            NSMutableDictionary *mutableDic = [ZDPayFuncTool getPayResultDicToClientWithCode:@"1000" withData:[responseObject objectForKey:@"data"] withMessage:@"支付成功"];
//            [mutableDic setValue:self.pay_OrderSurePayListRespModel.channelCode forKey:@"paymentMethod"];
//            self.completionBlock(mutableDic);
        }
    }];
}

//保存信用卡
- (void)getDataFromNetWorkingSaveVisaCard:(NSDictionary *)info {
    NSLog(@"%@",info);
    @WeakObj(self)
    NSString *nameOnCard = [NSString stringWithFormat:@"%@%@",[info objectForKey:@"zd_lastname"],[info objectForKey:@"name"]];
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getSaveVisaCard];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    [mutableDic setObject:[info objectForKey:@"cardNumber"] forKey:@"cardNum"];
    [mutableDic setObject:nameOnCard forKey:@"nameOnCard"];
    [mutableDic setObject:[info objectForKey:@"month"] forKey:@"expiryMonth"];
    [mutableDic setObject:[info objectForKey:@"year"] forKey:@"expiryYear"];
    [mutableDic setObject:[info objectForKey:@"CVC"] forKey:@"cvn"];
    [mutableDic setValuesForKeysWithDictionary:dic];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:mutableDic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),SAVEVISACARD] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            //做别的处理
            [self showMessage:@"添加成功" target:nil];
            [self getDataFromNetWorkingOrderSure:YES];
        }
    }];
}

//解绑信用卡
- (void)getDataFromNetWorkingUntying:(_Nullable id)info {
    ZDPay_OrderSureModel *model = [[ZDPay_OrderSureModel sharedSingleten] getModelData];
    ZDPay_OrderSurePayListRespModel *listModel = info;
    NSDictionary *dic = @{
        @"language": model.language,
        @"registerCountryCode": model.registerCountryCode,
        @"registerMobile": model.registerMobile,
        @"cardNum":listModel.cardId,
        @"merId": model.merId,
        @"payType": listModel.cardType,
        @"bankName":listModel.bankName,
    };

    @WeakObj(self);
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),UNBINDBANKCARD] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            NSLog(@"解绑成功");
            [self showMessage:@"解绑成功" target:nil];
            [self getDataFromNetWorkingOrderSure:YES];
        }
    }];
}


//国际化
- (void)getDataFromNetWorkingAppInternationalization {
    @WeakObj(self)
    NSDictionary *dic = [[ZDPayFuncTool sharedSingleton] getAppInternationalizationDictionary];
    [[ZDPayNetRequestManager sharedSingleton] zd_netRequestVC:self Params:dic postUrlStr:[NSString stringWithFormat:@"%@%@",DOMAINNAME([[ZDPay_OrderSureModel sharedSingleten] getModelData].urlStr),GETALLLANGUAGES] suscess:^(id  _Nullable responseObject) {
        @StrongObj(self)
        if ([[responseObject objectForKey:@"code"] isEqualToString:@"200"]) {
            [[ZDPayInternationalizationModel sharedSingleten] setModelProcessingDic:[responseObject objectForKey:@"data"]];
            self.naviTitle = [[ZDPayInternationalizationModel sharedSingleten] getModelData].PAYMENT;
            [self getDataFromNetWorkingOrderSure:NO];
        }
    }];
}

@end
