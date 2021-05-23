//
//  XMFShoppingCartViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2021/1/20.
//  Copyright © 2021 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFShoppingCartViewController.h"
#import "XMFInternationalShoppingController.h"//蜜蜂国际
#import "XMFOverseaShoppingController.h"//蜜蜂海淘
#import "SGPagingView.h"//标题滚动视图
#import "XMFShoppingCartCellModel.h"//购物车的总model


@interface XMFShoppingCartViewController ()<SGPageTitleViewDelegate, SGPageContentScrollViewDelegate>

/** 滚动文字view */
@property (nonatomic, strong) SGPageTitleView *pageTitleView;

/** 页面内容view */
@property (nonatomic, strong) SGPageContentScrollView *pageContentScrollView;

@end

@implementation XMFShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
    
    [self setupPageView];
}

-(void)setupUI{
    
    self.noneBackNaviTitle = XMFLI(@"购物车");
    
    //防止push的时候卡顿
    self.view.backgroundColor = KWhiteColor;
    

    
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




//创建和设置滚动栏
- (void)setupPageView {
    
//     self.naviTitle = @"我的订单";
    
    kWeakSelf(self)
    
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat pageTitleViewY = 0;
    if (statusHeight == 20.0) {
        
        pageTitleViewY = 64;
        
    } else {
        
        pageTitleViewY = 88;
    }
    
    NSArray *titleArr = @[XMFLI(@"蜜蜂海淘"), XMFLI(@"蜜蜂国际")];
    
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
    
    self.pageTitleView.backgroundColor = KWhiteColor;
    
    
    [self.view addSubview:_pageTitleView];
    
//   self.pageTitleView.selectedIndex = 0;// 选中下标
    
    
    
    NSMutableArray *childArr = [[NSMutableArray alloc]init];
    
    
    //蜜蜂海淘
    XMFOverseaShoppingController  *overseaVCtrl = [[XMFOverseaShoppingController alloc]init];
    
    overseaVCtrl.overseaShoppingBlock = ^(XMFShoppingCartCellModel * _Nullable overseaModel) {
      
        if ([overseaModel.goodsNum integerValue] > 0) {
            
            self.noneBackNaviTitle = [NSString stringWithFormat:@"%@(%@)",XMFLI(@"购物车"),overseaModel.goodsNum];


        }else{
            
            self.noneBackNaviTitle = XMFLI(@"购物车");
        }
        
        
    };
    
    
    [childArr addObject:overseaVCtrl];
    
    //蜜蜂国际
    XMFInternationalShoppingController  *internationalVCtrl = [[XMFInternationalShoppingController alloc]init];

    internationalVCtrl.internationalShoppingBlock = ^(XMFShoppingCartCellModel * _Nullable internationalModel) {
      
        if ([internationalModel.goodsNum integerValue] > 0) {
            
            self.noneBackNaviTitle = [NSString stringWithFormat:@"%@(%@)",XMFLI(@"购物车"),internationalModel.goodsNum];


        }else{
            
            self.noneBackNaviTitle = XMFLI(@"购物车");
        }
        
    };
    
    
    
    [childArr addObject:internationalVCtrl];

   
     
    /// pageContentScrollView
    CGFloat ContentCollectionViewHeight = self.view.frame.size.height - CGRectGetMaxY(_pageTitleView.frame);
    self.pageContentScrollView = [[SGPageContentScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_pageTitleView.frame), self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
    _pageContentScrollView.delegatePageContentScrollView = self;
    
    self.pageContentScrollView.isScrollEnabled = NO;
    
    [self.view addSubview:_pageContentScrollView];
    
    _pageContentScrollView.isAnimated = YES;
    
    

        
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
