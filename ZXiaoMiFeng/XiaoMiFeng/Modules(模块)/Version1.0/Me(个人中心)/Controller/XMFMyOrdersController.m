//
//  XMFMyOrdersController.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/5/14.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFMyOrdersController.h"
#import "SGPagingView.h"//æ é¢æ»å¨è§å¾
#import "XMFAllOrdersViewController.h"//å¨é¨è®¢åç­



@interface XMFMyOrdersController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

//æ»å¨æå­view
@property (nonatomic, strong) SGPageTitleView *pageTitleView;

//é¡µé¢åå®¹view
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;



@end

@implementation XMFMyOrdersController

- (instancetype)initWithMyOrdersJumpFromType:(myOrdersJumpFromType)type{
    
    if (self = [super init]) {
        
        self.fromType = type;
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
//    self.view.backgroundColor = KWhiteColor;
    
    //æ¥æ¶æ¯ä»ç»æé¡µçéç¥
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSelectIndex:) name:KPost_PayResultVc_Notice_MyOrdersVc_SelectIndex object:nil];
    
    
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

//éåè¿åæ¹æ³
-(void)popAction{
    
    //é»è®¤éä¸­é¡µé¢
    switch (self.fromType) {
            
        case myOrdersJumpFromHomeVc:{
            
            
        }
            break;
        case myOrdersJumpFromCancelPay:{//æ¯ä»å¤±è´¥æèåæ¶æ¯ä»
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
        case myOrdersJumpFromPaySuccess:{//æ¯ä»æå
            
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
            
        default:{
            
            [super popAction];
        }
            break;
    }
    
    
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
    
    NSArray *titleArr = @[@"å¨é¨", @"å¾ä»æ¬¾", @"å¾åè´§", @"å¾æ¶è´§", @"å¾è¯ä»·"];
    
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
        
        
        XMFAllOrdersViewController  *VCtrl = [[XMFAllOrdersViewController alloc]initWithOrdersShowType:i];
        
       [childArr addObject:VCtrl];

    }
    
   
     
    /// pageContentScrollView
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    [self.view addSubview:_pageContentScrollView];
    
    _pageContentScrollView.isAnimated = YES;
    
    
    
    //é»è®¤éä¸­é¡µé¢
    switch (self.fromType) {
            
        case myOrdersJumpFromHomeVc:{
            
            
        }
            break;
        case myOrdersJumpFromCancelPay:{//æ¯ä»å¤±è´¥æèåæ¶æ¯ä»
            
            self.pageTitleView.selectedIndex = 1;

            
        }
            break;
        case myOrdersJumpFromPaySuccess:{//æ¯ä»æå
            
            self.pageTitleView.selectedIndex = 2;
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    
        
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
