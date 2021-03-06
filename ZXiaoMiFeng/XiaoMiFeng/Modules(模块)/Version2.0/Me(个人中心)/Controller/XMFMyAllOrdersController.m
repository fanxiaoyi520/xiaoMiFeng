//
//  XMFMyAllOrdersController.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/8/28.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFMyAllOrdersController.h"
#import "SGPagingView.h"//æ é¢æ»å¨è§å¾
#import "XMFMyOrdersListController.h"
#import "XMFMyOrdersPopView.h"//è®¢ååæé®å¼¹çª


@interface XMFMyAllOrdersController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

/** æ»å¨æå­view */
@property (nonatomic, strong) SGPageTitleView *pageTitleView;

/** é¡µé¢åå®¹view */
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

/** æ¥æºçç±»å */
@property (nonatomic, assign) myAllOrdersJumpFromType type;


@end

@implementation XMFMyAllOrdersController


-(instancetype)initWithFromType:(myAllOrdersJumpFromType)fromType{
    
    self = [super init];
    
    if (self) {
        
        self.type = fromType;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [self setupPageView];

}

-(void)setupUI{
    
    self.naviTitle = @"æçè®¢å";
    
    //é²æ­¢pushçæ¶åå¡é¡¿
    self.view.backgroundColor = KWhiteColor;
    
    //æ¥æ¶æ¯ä»ç»æé¡µçéç¥
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSelectIndex:) name:KPost_PayResultVc_Notice_MyOrdersVc_SelectIndex object:nil];
    
    
}



-(void)popAction{
    
    //é»è®¤éä¸­é¡µé¢
    switch (self.type) {
        
        case fromCancelPay:{//æ¯ä»å¤±è´¥æèåæ¶æ¯ä»
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
        case fromPaySuccess:{//æ¯ä»æå
            
        
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
            
        default:{
            
            [super popAction];
        }
            break;
    }
    
    
    //è¿åçblock
    if (_myAllOrdersBackBlock) {
        _myAllOrdersBackBlock();
    }
    
}


//ç§»é¤éç¥
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - âââââââ éç¥æ¹æ³ ââââââââ
-(void)gotoSelectIndex:(NSNotification *)info{
    

    NSDictionary *dic = info.userInfo;
        
    NSInteger selectedIndex = [dic[@"index"] integerValue];
        

    //é¡¶é¨çæ é¢æ éä¸­ç¬¬å ä¸ª
    /**
     
     è®¾ç½®è¿selectedIndexä¹åéè¦éæ°ä»£ç éä¸­å¶å®çæ¶åä½¿ç¨æ¹æ³
     
     */
     self.pageTitleView.resetSelectedIndex = selectedIndex;

    
}




//åå»ºåè®¾ç½®æ»å¨æ 
- (void)setupPageView {
    
//     self.naviTitle = @"æçè®¢å";
    
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        
        pageTitleViewY = 64;
        
    } else {
        
        pageTitleViewY = 88;
    }
    
    NSArray *titleArr = @[XMFLI(@"å¨é¨"), XMFLI(@"å¾ä»æ¬¾"), XMFLI(@"å¾åè´§"), XMFLI(@"å¾æ¶è´§"), XMFLI(@"å·²å®æ")];
    
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    
    configure.showBottomSeparator = NO;
    configure.indicatorStyle = SGIndicatorStyleFixed;
    configure.indicatorFixedWidth = 16;
    configure.indicatorColor = UIColorFromRGB(0xF7CF20);
    configure.indicatorHeight = 2;
    configure.indicatorCornerRadius = 1;
    configure.indicatorToBottomDistance = 2;
    configure.titleColor = UIColorFromRGB(0x666666);
    configure.titleFont = [UIFont systemFontOfSize:15.f];
     configure.titleSelectedColor = UIColorFromRGB(0x333333);
    configure.titleSelectedFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:15.f];
    
    
    
    /// pageTitleView
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, pageTitleViewY, self.view.frame.size.width, 44) delegate:self titleNames:titleArr configure:configure];
    
    self.pageTitleView.backgroundColor = UIColorFromRGB(0xF3F3F5);
    
    
    [self.view addSubview:_pageTitleView];
    
//   self.pageTitleView.selectedIndex = 0;// éä¸­ä¸æ 
    
    
    
    NSMutableArray *childArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < titleArr.count; ++i) {
        
        
        XMFMyOrdersListController  *VCtrl = [[XMFMyOrdersListController alloc]initWithFromType:i];
        
       [childArr addObject:VCtrl];

    }
    
   
     
    /// pageContentScrollView
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    
    _pageContentScrollView.isAnimated = YES;
    
    switch (self.type) {
        case fromCancelPay:{//æ¥èªåæ¶ä»æ¬¾
            
            self.pageTitleView.selectedIndex = 1;

        }
            break;
            
        case fromPaySuccess:{//æ¥èªä»æ¬¾æå
            
            self.pageTitleView.selectedIndex = 2;
            
        }
            break;
            
        default:{
            
            self.pageTitleView.selectedIndex = self.type;

        }
            break;
    }
    
    [self getCheckOrder:self.type];

        
}

#pragma mark - âââââââ SGPagingViewçä»£çæ¹æ³ ââââââââ

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
    

}


- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

/// è¯´æï¼1ãè¿éçå¤çæ¯ä¸ºäºæ»å¨è¿ç¨ä¸­ï¼æææªç¦»å¼å±å¹ï¼ç¹å»æ é¢åæ»å¨é ææ é¢ä¸åå®¹ç­æçä¸ä¸è´
/// è¯´æï¼2ãäºè§£äºä¸ä¸å¸åºä¸ç appï¼å¤§è´åä¸ºäºç§æåµï¼ä¸ç§æ¯æ»å¨è¿ç¨ä¸­æ é¢å¯ä»¥ç¹å»ï¼ç½ææ°é»ãä»æ¥å¤´æ¡ï¼ï¼å¦ä¸ç§æ¯æ»å¨è¿ç¨ä¸­æ é¢ä¸å¯ä»¥ç¹å»ï¼è´è´ãæ±½è½¦ä¹å®¶ï¼
/// è¯´æï¼3ãæ·å®->å¾®æ·çé¢ï¼å¸¦å¨ç»ï¼ä¹ä¼å­å¨è¿ç§æåµä½ç¸å¯¹æ¥è¯´æ¯æå¤çå¾å¥½ï¼æä»¥æåªè½è®©å¨ç»ä¸è¯´æï¼2ãçåä¸ç§æåµç¸ç»åæ¥åå¤çï¼ç¾å¶åä¹ï¼ä¸ºäºç¨æ·ä½éªï¼
- (void)pageContentScrollViewWillBeginDragging {
    
    _pageTitleView.userInteractionEnabled = NO;
}

- (void)pageContentScrollViewDidEndDecelerating {
    
    _pageTitleView.userInteractionEnabled = YES;
}

#pragma mark - âââââââ ç½ç»è¯·æ± ââââââââ
//ç»è®¡è®¢åæ¯å¦å­å¨æªä¸ä¼ èº«ä»½è¯çè®¢å
-(void)getCheckOrder:(myAllOrdersJumpFromType)fromType{
   
    NSDictionary *dic = @{
        
        @"showType":@(fromType)
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_wx_order_checkOrder parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"æ¯å¦å­å¨æªä¸ä¼ èº«ä»½è¯çè®¢åï¼%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            BOOL isAddIdentity = [[responseObject stringWithKey:@"data"] boolValue];
            
            if (isAddIdentity) {
                
                XMFMyOrdersPopView *popView = [XMFMyOrdersPopView XMFLoadFromXIB];
                
                popView.tipsLB.text = XMFLI(@"æµ·å³æ¿ç­æ½æ£ï¼è´­ä¹°è·¨å¢è¿å£ååéè¦ä¸ä¼ èº«ä»½è¯ç§çï¼ä»ç¨äºæµ·å³æ¸å³");
                
                
                [popView show];
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
            
        } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
            
        }];
    
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
