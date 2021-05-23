//
//  XMFMyOrdersController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/14.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMyOrdersController.h"
#import "SGPagingView.h"//标题滚动视图
#import "XMFAllOrdersViewController.h"//全部订单等



@interface XMFMyOrdersController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

//滚动文字view
@property (nonatomic, strong) SGPageTitleView *pageTitleView;

//页面内容view
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
    
    self.naviTitle = @"我的订单";
    
    //防止push的时候卡顿
//    self.view.backgroundColor = KWhiteColor;
    
    //接收支付结果页的通知
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoSelectIndex:) name:KPost_PayResultVc_Notice_MyOrdersVc_SelectIndex object:nil];
    
    
}

//移除通知
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - ——————— 通知方法 ————————
-(void)gotoSelectIndex:(NSNotification *)info{
    

    NSDictionary *dic = info.userInfo;
        
    NSInteger selectedIndex = [dic[@"index"] integerValue];
        

    //顶部的标题栏选中第几个
    /**
     
     设置过selectedIndex之后需要重新代码选中其它的时候使用方法
     
     */
     self.pageTitleView.resetSelectedIndex = selectedIndex;

    
}

//重写返回方法
-(void)popAction{
    
    //默认选中页面
    switch (self.fromType) {
            
        case myOrdersJumpFromHomeVc:{
            
            
        }
            break;
        case myOrdersJumpFromCancelPay:{//支付失败或者取消支付
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
        case myOrdersJumpFromPaySuccess:{//支付成功
            
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
            
        default:{
            
            [super popAction];
        }
            break;
    }
    
    
}


//创建和设置滚动栏
- (void)setupPageView {
    
//     self.naviTitle = @"我的订单";
    
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        
        pageTitleViewY = 64;
        
    } else {
        
        pageTitleViewY = 88;
    }
    
    NSArray *titleArr = @[@"全部", @"待付款", @"待发货", @"待收货", @"待评价"];
    
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
    
//   self.pageTitleView.selectedIndex = 0;// 选中下标
    
    
    
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
    
    
    
    //默认选中页面
    switch (self.fromType) {
            
        case myOrdersJumpFromHomeVc:{
            
            
        }
            break;
        case myOrdersJumpFromCancelPay:{//支付失败或者取消支付
            
            self.pageTitleView.selectedIndex = 1;

            
        }
            break;
        case myOrdersJumpFromPaySuccess:{//支付成功
            
            self.pageTitleView.selectedIndex = 2;
            
            
        }
            break;
            
        default:
            break;
    }
    
    
    
    
    
        
}

#pragma mark - ——————— SGPagingView的代理方法 ————————

- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    
    [self.pageContentScrollView setPageContentScrollViewCurrentIndex:selectedIndex];
    

}


- (void)pageContentScrollView:(SGPageContentScrollView *)pageContentScrollView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

/// 说明：1、这里的处理是为了滚动过程中（手指未离开屏幕）点击标题再滚动造成标题与内容短暂的不一致
/// 说明：2、了解了一下市场上的 app，大致分为二种情况：一种是滚动过程中标题可以点击（网易新闻、今日头条）；另一种是滚动过程中标题不可以点击（贝贝、汽车之家）
/// 说明：3、淘宝->微淘界面（带动画）也会存在这种情况但相对来说比我处理得好；所以我只能让动画与说明：2、的后一种情况相结合来做处理（美其名也：为了用户体验）
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
