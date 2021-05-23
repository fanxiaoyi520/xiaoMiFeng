//
//  XMFGoodsDetailViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsDetailViewController.h"
#import "XMFGoodsDetailCommentCell.h"//评价的cell
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFGoodsCommentController.h"//商品评价
#import "XMFPurchaseTipsView.h"//购买说明
#import "XMFGoodsShareView.h"//分享页面
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model
#import "XMFGoodsDetailInfoCell.h"//商品信息的cell
#import "XMFSelectGoodsTypeView.h"//商品属性弹框
#import "XMFHomeGoodsPropertyModel.h"//商品属性的model
#import "XMFConfirmOrderController.h"//订单确认
#import "XMFConfirmOrderModel.h"//订单确认总model
#import "XMFGoodsCommentDetailController.h"//评论详情
#import "XMFGoodsCommentModel.h"//评论的model
#import "XMFGoodsSpecInfoModel.h"//商品规格model
#import <WebKit/WebKit.h>//wkwebview
#import "XMFGoodsDeletedPageView.h"//商品不存在view
#import "XMFHomeGoodsCellModel.h"//商品cell的model
#import "XMFHomeAllGoodsCell.h"//首页推荐cell
#import "XMFCommonPicPopView.h"//图片文本提示框
#import "XMFShoppingSplitOrdersView.h"//体积多大弹窗view
#import "XMFShoppingSplitOrdersModel.h"//体积多大弹窗view的model



@class XMFHomeGoodsDetailGallerysModel;


@interface XMFGoodsDetailViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,XMFGoodsShareViewDelegate,UITableViewDelegate,UITableViewDataSource,XMFSelectGoodsTypeViewDelegate,XMFGoodsDeletedPageViewDelegate,XMFShoppingSplitOrdersViewDelegate>



@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


/** 透明的返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backTransparentBtn;

/** 透明的分享按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shareTransparentBtn;



@property (weak, nonatomic) IBOutlet UIView *headerView;


@property (weak, nonatomic) IBOutlet UIButton *backBtn;


@property (weak, nonatomic) IBOutlet UIButton *shareBtn;


@property (weak, nonatomic) IBOutlet UIView *goodsInfoBtnsBgView;


@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


@property (weak, nonatomic) IBOutlet UIButton *parameterBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *parameterBtnWidth;


@property (weak, nonatomic) IBOutlet UIButton *detailBtn;


/**
 *  按钮选中,中间值
 */
@property (nonatomic,strong) UIButton *selectedBtn;


/** 轮播器 */
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

/** 轮播器的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cycleScrollViewHeight;

/** 图片数量 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *picNumLB;



//第二部分

/** 商品来源的图标 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsResourceImgView;


/** 产地国家 */
@property (weak, nonatomic) IBOutlet UIImageView *fromImgView;

/** 产地 */
@property (weak, nonatomic) IBOutlet UILabel *fromLB;

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** 实际价格 */
@property (weak, nonatomic) IBOutlet UILabel *actPriceLB;

/** 标价 */
@property (weak, nonatomic) IBOutlet UILabel *origPriceLB;

/** 供应商 */
@property (weak, nonatomic) IBOutlet UIButton *supplierBtn;

/** 仓库 */
@property (weak, nonatomic) IBOutlet UIButton *warehouseBtn;



/** 包税 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *taxTagLB;

/** 包税的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxTagLBHeight;


/** 包税的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxTagLBWidth;

/** 包邮 */
@property (weak, nonatomic) IBOutlet KKPaddingLabel *postageTagLB;

/** 包邮的左边间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageTagLBLeftSpace;

/** 包邮的宽度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *postageTagLBWidth;



/** 销量 */
@property (weak, nonatomic) IBOutlet UILabel *salesLB;

/** 购物说明 */
@property (weak, nonatomic) IBOutlet UIButton *shoppingTipsBtn;

/** 税费和运费 */
@property (weak, nonatomic) IBOutlet UILabel *taxPostFeeLB;

/** 税费和运费的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *taxPostFeeLBHeight;




//第三部分：商品评价

/** 商品评价的背景view */
@property (weak, nonatomic) IBOutlet UIView *goodsCommentBgView;

/** 商品评价数量  */
@property (weak, nonatomic) IBOutlet UILabel *commentCountLB;



/** 查看全部的商品评价 */
@property (weak, nonatomic) IBOutlet UIButton *moreCommentBtn;

/** 商品评价的列表 */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

/** 商品评价的列表的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


//第四部分：商品信息



/** 商品信息列表 */
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

/** 商品信息背景view */
@property (weak, nonatomic) IBOutlet UIView *goodsInfoBgView;

/** 商品信息背景view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsInfoBgViewHeight;


/** 查看更多的商品信息 */
@property (weak, nonatomic) IBOutlet UIButton *moreParaBtn;




//第五部分：图文详情

/** 图文详情的背景view */
@property (weak, nonatomic) IBOutlet UIView *imgTextDetaiBgView;

/** 图文详情的背景view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgTextDtailBgViewHeight;


/** 图文详情的浏览器 */
@property (nonatomic,strong) WKWebView *detailWebView;



//第六部分：底部

/** 底部背景view */
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;

/** 底部背景view的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBgViewHeight;


/** 客服 */
@property (weak, nonatomic) IBOutlet UIButton *serviceBtn;

/** 收藏 */
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;

/** 加入购物车 */
@property (weak, nonatomic) IBOutlet UIButton *addCartBtn;

/** 立即购买 */
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

/** 商品售罄 */
@property (weak, nonatomic) IBOutlet UILabel *goodsOutLB;


/** 商品下架 */
@property (weak, nonatomic) IBOutlet UILabel *goodsOffLB;

/** 返回首页按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backHomeBtn;


//第七部分：自定义属性

/** 上次Y轴偏移量 */
@property (nonatomic, assign) CGFloat lastOffSetY;

/** 商品id */
@property (nonatomic, copy) NSString *goodsID;

/** 商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *detailModel;

/** tableview的高度 */
@property (nonatomic, assign) CGFloat tableViewHeight;

/** 是否是按钮点击 */
@property (nonatomic, assign) BOOL isBtnClick;


/** 购物说明model数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsDetailPurchaseInstructionsModel *> *instructionsModelArr;

/** 商品规格弹窗 */
@property (nonatomic, strong) XMFSelectGoodsTypeView *selectGoodsTypeView;

/** 评论列表 */
@property (nonatomic, strong) NSMutableArray<XMFGoodsCommentModel *> *commentModelArr;


/** 区分是否是加入购物车和立即购买 */
@property (nonatomic, assign) BOOL isAddCart;

/** 商品被删除view */
@property (nonatomic, strong) XMFGoodsDeletedPageView *goodsDeletedView;


/** 数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFHomeGoodsCellModel *> *dataSourceArr;


/** 推荐商品获取规格 */
@property (nonatomic, strong) XMFSelectGoodsTypeView *recommendSelectGoodsTypeView;


/** 推荐商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *recommendDetailModel;


/** 体积过大拆分订单的model数据数组 */
@property (nonatomic, strong) NSMutableArray<XMFShoppingSplitOrdersModel *> *SplitOrdersDataArr;

/** 体积拆分的view */
@property (nonatomic, strong) XMFShoppingSplitOrdersView *splitOrdersView;


@end

@implementation XMFGoodsDetailViewController


//自定义初始化方法
-(instancetype)initWithGoodsID:(NSString *)goodsID{
    
    self = [super init];
    
    if (self) {
        
        self.goodsID = goodsID;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
    
}


-(void)setupUI{
    
    //防止设置了myScrollView顶到状态栏但是没到的问题
    if (@available(iOS 11.0, *)) {
        
        self.myScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.myScrollView.delegate = self;
    
    
    self.myScrollView.mj_header = [XMFRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self.myScrollView.mj_header endRefreshing];
        
        
    }];
    
     self.myScrollView.bounces = NO;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 20, 0);
    
    // line 跟滚动方向相同的间距
    flowLayout.minimumLineSpacing = 10;
    
     // item 跟滚动方向垂直的间距
    flowLayout.minimumInteritemSpacing = 0;
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    

    self.myCollectionView.collectionViewLayout = flowLayout;
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;

    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsDetailCommentCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFGoodsDetailCommentCell class])];
    
    
    //禁止商品参数滚动
    self.myTableView.scrollEnabled = NO;
    
    
    
    //轮播图
    self.cycleScrollView.delegate = self;
    
    self.cycleScrollView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    //当前分页控件小图标颜色
    
    self.cycleScrollView.currentPageDotColor = UIColorFromRGB(0xF7CF20);
    
    //其他分页控件小图标颜色
    
    self.cycleScrollView.pageDotColor = UIColorFromRGBA(0xFFFFFF, 0.5);
    
    //自动滚动时间间隔,默认2s
    
    self.cycleScrollView.autoScrollTimeInterval = 3;
    
    //是否自动滚动, 默认YES
    
    self.cycleScrollView.autoScroll = YES;
    
    //占位图
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"icon_common_placeRect"];
    
    //轮播图片的ContentMode, 默认为UIViewContentModeScaleToFill
    
    self.cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    
    //是否无限循环,默认YES: 滚动到第四张图就不再滚动了
    
    self.cycleScrollView.infiniteLoop = YES;
    
    
    self.cycleScrollView.pageControlBottomOffset = 10;
    
    
    self.cycleScrollView.showPageControl = NO;
    
    
    //商品信息
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsDetailInfoCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFGoodsDetailInfoCell class])];
    
    //默认都不显示
    self.goodsOffLB.hidden = YES;
        
    self.bottomBgView.hidden = YES;
    
    self.bottomBgViewHeight.constant = 0.f;
    
    
    self.cycleScrollViewHeight.constant = KScreenW;
    
    
    //商品详情
    [self getGoodsDetail];
    
    //商品评论数据
    [self getCommentData];

    //购物说明
    [self getPurchaseInstructions];
    
    //添加监听
    [self addWebViewObserver];
    

}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    
    CGFloat imgTextSpace = 8.f;
    
    [self.commentBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleBottom imageTitleSpace:imgTextSpace];
    
    [self.parameterBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleBottom imageTitleSpace:imgTextSpace];
    
    [self.detailBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleBottom imageTitleSpace:imgTextSpace];
    
    
    [self.shoppingTipsBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imgTextSpace/2];
    
    [self.moreCommentBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imgTextSpace/2];
    
    [self.moreParaBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleRight imageTitleSpace:imgTextSpace/2];
    
    
    [self.serviceBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:imgTextSpace/2];
    
    [self.collectBtn layoutButtonWithEdgeInsetsStyle:XMFButtonEdgeInsetsStyleTop imageTitleSpace:imgTextSpace/2];
    
//    [self.buyBtn cornerWithRadius:5.f];
    
    
    
    [self.addCartBtn xw_roundedCornerWithCornerRadii:CGSizeMake(5, 5) cornerColor:KWhiteColor corners:UIRectCornerAllCorners borderColor:UIColorFromRGB(0xF7CF20) borderWidth:1.f];
    
    
//    [self.goodsOutLB cornerWithRadius:5.f];
    
    [self.goodsOutLB xw_roundedCornerWithRadius:5.f cornerColor:KWhiteColor];
    
    
}



//头部里面的类型按钮被点击
- (IBAction)buttonsOnHeaderViewDidClick:(UIButton *)sender {

  
    if (sender!= self.selectedBtn) {
        
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        
    }else{
        
        self.selectedBtn.selected = YES;
    }
    
    //设置为用户主动点击
    self.isBtnClick = YES;

    
    switch (sender.tag) {
        case 0:{//商品评价
            
            [self.myScrollView setContentOffset:CGPointMake(0, self.goodsCommentBgView.y - self.headerView.height) animated:NO];
            
        }
            break;
            
        case 1:{//商品参数
            
            [self.myScrollView setContentOffset:CGPointMake(0, self.goodsInfoBgView.y - self.headerView.height) animated:NO];
            
        }
            break;
            
        case 2:{//图文详情
            
            [self.myScrollView setContentOffset:CGPointMake(0, self.imgTextDetaiBgView.y - self.headerView.height) animated:NO];
        }
            break;
            
        default:
            break;
    }
    

}



//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    kWeakSelf(self)
    
    switch (sender.tag) {
        case 0:{//返回
                        
            [self popAction];
            
        }
            break;
            
        case 1:{//分享
            
            
            XMFGoodsShareView *shareView = [XMFGoodsShareView XMFLoadFromXIB];
            
            shareView.delegate = self;
            
            
            shareView.detailModel = self.detailModel;
            
            [shareView show];
            
            
            
        }
            break;
        case 2:{//头部view里的返回
            
            [self popAction];
        }
            break;
        case 3:{//头部view里的分享
            
            XMFGoodsShareView *shareView = [XMFGoodsShareView XMFLoadFromXIB];
            
            shareView.delegate = self;
            
            shareView.detailModel = self.detailModel;
            
            [shareView show];
            
        }
            break;
        case 4:{//购物说明
            
            XMFPurchaseTipsView *tipsView = [XMFPurchaseTipsView XMFLoadFromXIB];
            
//            tipsView.detailModel = self.detailModel;
            
            tipsView.instructionsModelArr = [self.instructionsModelArr copy];
           
            [tipsView show];
            
            
           
        }
            break;
        case 5:{//查看全部评价
            
            XMFGoodsCommentController  *VCtrl = [[XMFGoodsCommentController alloc]initWithGoodsId:self.goodsID];
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }
            break;
        case 6:{//查看更多商品信息
            
            
            
        }
            break;
        case 7:{//客服
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = @"https://im.7x24cc.com/phone_webChat.html?accountId=N000000013029&chatId=6aded8fa-f405-4371-8aba-c982f8fb7f8d";
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
        case 8:{//收藏
            
            
            [self getGoodsCollectAddOrDelete:sender];
        }
            break;
        case 9:{//加入购物车
            
//            [self getGoodsSpecification:self.goodsID button:sender goodsName:self.detailModel.goodsName];
            
            //是否是加入购物车或者立即购买
            self.isAddCart = YES;
            
            //先判断是否是组合商品
            if (self.detailModel.isGroupGoods) {
                
                
                [self getGoodsSpecInfo:self.isAddCart];
                
                
            }else{
                
                
                [self getCartAdd:self.detailModel.productId goodsNum:@"1"];
                
            }
            
            
            
        }
            break;
        case 10:{//立即购买
            
//            [self getFastAddCartGoodsSpecification:self.goodsID button:sender goodsName:self.detailModel.goodsName];
            
            //是否是加入购物车或者立即购买
            self.isAddCart = NO;
            
            
            if (self.detailModel.isGroupGoods) {
                
                
                [self getGoodsSpecInfo:self.isAddCart];
                
                
            }else{
                
                
                [self postCartFastAddGoods:self.detailModel.productId goodsAmount:@"1"];
                
            }
            
            
        }
            break;
            
        case 11:{//返回首页
            
            //选中首页
            XMFBaseUseingTabarController *tabBarVc = (XMFBaseUseingTabarController *)kAppWindow.rootViewController;
            
            tabBarVc.selectedIndex = 0;
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
            break;
            
        default:
            break;
    }
    
    
    
}

#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    return self.detailModel.goodsComments.count;
    
    return self.commentModelArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFGoodsDetailCommentCell *commentCell = (XMFGoodsDetailCommentCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFGoodsDetailCommentCell class]) forIndexPath:indexPath];

//    commentCell.commentModel = self.detailModel.goodsComments[indexPath.item];
    commentCell.commentModel = self.commentModelArr[indexPath.item];
    
    return commentCell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    

//    XMFGoodsCommentModel *commentModel = self.detailModel.goodsComments[indexPath.item];
    
    XMFGoodsCommentModel *commentModel = self.commentModelArr[indexPath.item];

    
    commentModel.goodsId = self.goodsID;
    
    
    XMFGoodsCommentDetailController  *VCtrl = [[XMFGoodsCommentDetailController alloc]initWithCommentModel:commentModel];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KScaleWidth(120), self.myCollectionView.height - 20);

}



#pragma mark - ——————— UIScrollView的代理方法 ————————
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    self.lastOffSetY = scrollView.contentOffset.y;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat gap = scrollView.contentOffset.y - self.lastOffSetY;

     if (gap < 0) {//向下滚动
         
         self.backTransparentBtn.hidden = NO;
         
         self.shareTransparentBtn.hidden = NO;
         
         self.headerView.hidden = YES;
         
         
     }else{//向上滚动
         
         self.backTransparentBtn.hidden = YES;
         
         self.shareTransparentBtn.hidden = YES;
         
         self.headerView.hidden = NO;
         
     }
    
    // 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    
    /**
     
     将myScrollView中的goodsCommentBgView的frame转换到目标self.view，返回goodsCommentBgView在self.view中的frame值
     
     */

    CGRect commentBgFrame = [self.myScrollView convertRect:self.goodsCommentBgView.frame toView:self.view];
    
    CGRect infoBgFrame = [self.myScrollView convertRect:self.goodsInfoBgView.frame toView:self.view];
    
    CGRect imgTextBgFrame = [self.myScrollView convertRect:self.imgTextDetaiBgView.frame toView:self.view];
    
    
    CGFloat viewCenterY = self.view.centerY;
    
    
    //当是用户主动点击的时候就不执行下面的代码
    if (!self.isBtnClick) {
        
        
        if ((imgTextBgFrame.origin.y) < viewCenterY) {
            
            //        [self buttonsOnHeaderViewDidClick:self.detailBtn];
            
            self.selectedBtn.selected = NO;
            
            self.detailBtn.selected = YES;
            
            self.selectedBtn = self.detailBtn;
            
            
        }else if ((infoBgFrame.origin.y) < viewCenterY){
            
            //        [self buttonsOnHeaderViewDidClick:self.parameterBtn];
            
            self.selectedBtn.selected = NO;
            
            self.parameterBtn.selected = YES;
            
            self.selectedBtn = self.parameterBtn;
            
        }else{
            
            //        [self buttonsOnHeaderViewDidClick:self.commentBtn];
            
            self.selectedBtn.selected = NO;
            
            self.commentBtn.selected = YES;
            
            self.selectedBtn = self.commentBtn;
        }
        
    }
   
    
    //执行完后恢复为默认的不是点击
    self.isBtnClick = NO;

    

}



#pragma mark - ——————— XMFGoodsShareView的代理方法 ————————

- (void)buttonsOnXMFGoodsShareViewDidClick:(XMFGoodsShareView *)shareView button:(UIButton *)button{
    
    
    switch (button.tag) {
        case 1:{//分享
            
            
            shareView.tipsStr = @"扫码看看我推荐的商品吧!";

              
              CGSize size = shareView.screenshotBgView.bounds.size;
              UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
              CGRect rect = shareView.screenshotBgView.frame;
              [shareView.screenshotBgView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
              UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
              UIGraphicsEndImageContext();
              

              shareView.tipsStr = @"长按屏幕保存二维码";
            

            [self shareShowInViewController:snapshotImage];
            
        }
            break;
            
            
            break;
            
        default:
            break;
    }
    
    
}


//长按代理方法
-(void)viewsOnXMFGoodsShareViewDidLongPress:(XMFGoodsShareView *)shareView{
    
    /*
    shareView.tipsStr = @"扫码看看我推荐的商品吧!";
    
    //截图
    UIGraphicsBeginImageContext(shareView.screenshotBgView.bounds.size);
    
    [shareView.screenshotBgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
    shareView.tipsStr = @"长按屏幕保存二维码";
    
    */
    
    
    
    shareView.tipsStr = @"扫码看看我推荐的商品吧!";

    
    CGSize size = shareView.screenshotBgView.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rect = shareView.screenshotBgView.frame;
    [shareView.screenshotBgView drawViewHierarchyInRect:rect afterScreenUpdates:YES];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(snapshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    shareView.tipsStr = @"长按屏幕保存二维码";

    
}

//参数1:图片对象
//参数2:成功方法绑定的target
//参数3:成功后调用方法
//参数4:需要传递信息(成功后调用方法的参数)
//UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    
    if(error){
        
        msg = @"保存图片失败" ;
        
        [MBProgressHUD showError:XMFLI(@"保存失败，请先获取相册权限") toView:kAppWindow];

        
    }else{
        
        msg = @"保存图片成功" ;
        
        [MBProgressHUD showSuccess:XMFLI(@"保存成功") toView:kAppWindow];
        
    }
}


#pragma mark - ——————— XMFSelectGoodsTypeView ————————

//规格点击的方法
-(void)selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView goodsId:(NSString *)goodsId{
    
    if (typeView == self.selectGoodsTypeView) {
        
        //商品详情选取多规格的时候
        self.goodsID = goodsId;
        
        [self getGoodsDetail];
        
        
    }else{
        
        //推荐商品列表切换规格的时候
        [self getGoodsDetail:goodsId];
        
    }
    

    
}

//确定按钮点击方法
-(void)buttonsXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView productId:(NSString *)productId selectedGoodCount:(NSString *)selectedGoodCount{
    
    
    if (typeView == self.selectGoodsTypeView) {
        
        //是否是加入购物车或者立即购买
        if (self.isAddCart) {
            
            [self getCartAdd:productId goodsNum:selectedGoodCount];

            
        }else{
            
            /** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
            if ([self.detailModel.taxType isEqualToString:@"1"] && [selectedGoodCount integerValue] > 1) {
                
                //当且仅当是bc类型，选择数量大于1的时候拆单
                
                [self getGoodsSplitOrders:productId goodsAmount:selectedGoodCount];
                
                
            }else{
                
                
                [self postCartFastAddGoods:productId goodsAmount:selectedGoodCount];
                
            }

        }
        
    }
     
    
}


#pragma mark - ——————— XMFShoppingSplitOrdersView的代理方法 ————————
-(void)buttonsOnXMFShoppingSplitOrdersViewDidClick:(XMFShoppingSplitOrdersView *)splitOrdersView button:(UIButton *)button{
    
    XMFShoppingSplitOrdersModel *selectedModel = self.SplitOrdersDataArr[splitOrdersView.selectedIndexPathRow];

    
    //因为单个商品拆单里面也只有这一个商品
    XMFShoppingSplitOrdersGoodsModel *goodsModel = [selectedModel.ordersGoods firstObject];
    
    
    [self postCartFastAddGoods:goodsModel.productId goodsAmount:goodsModel.number];
    
    
}



#pragma mark - ——————— tableView的代理方法和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.detailModel.goodsAttributes.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /*
    static NSString *identifier = @"cell";
    
    XMFGoodsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFGoodsDetailInfoCell class]) owner:nil options:nil] firstObject];;
    }*/
    
    XMFGoodsDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFGoodsDetailInfoCell class])];
        

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setModelOfCell:cell atIndexPath:indexPath];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    return 33;
    
    kWeakSelf(self)
    
    CGFloat cellHeight = [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFGoodsDetailInfoCell class]) configuration:^(XMFGoodsDetailInfoCell *cell) {
        
        
        [weakself setModelOfCell:cell atIndexPath:indexPath];
          
    }];
    
    
    if (cellHeight < 33) {
        
        cellHeight = 33;
        
    }
    
    
    //计算tableview的高度
    self.tableViewHeight += cellHeight;
    
    self.goodsInfoBgViewHeight.constant = self.tableViewHeight + 48;
    
    
    return cellHeight;

    
}

-(void)setModelOfCell:(XMFGoodsDetailInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath{
 

    cell.model = self.detailModel.goodsAttributes[indexPath.row];
    
}


#pragma mark - ——————— SDCycleScrollView的代理方法 ————————
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cycleScrollView.frame];
        
    [cycleScrollView addSubview:imageView];
    
    [cycleScrollView sendSubviewToBack:imageView];
    
    
    [imageView sd_setImageWithURL:cycleScrollView.imageURLStringsGroup[index] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        imageView.hidden = YES;
        
        [HUPhotoBrowser showFromImageView:imageView withURLStrings:cycleScrollView.imageURLStringsGroup atIndex:index];
        
    }];

    
    /*
    NSMutableArray *photos = [NSMutableArray new];
    
    [cycleScrollView.imageURLStringsGroup enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        GKPhoto *photo = [GKPhoto new];
        
        photo.url = [NSURL URLWithString:obj];
        
        [photos addObject:photo];
        
        
    }];
    
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
    
    browser.showStyle = GKPhotoBrowserShowStyleNone;
    
    browser.loadStyle = GKPhotoBrowserLoadStyleDeterminate;
    
    [browser showFromVC:self];
    */
    
}


-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    
    self.picNumLB.text = [NSString stringWithFormat:@"%zd/%zd",index + 1,cycleScrollView.imageURLStringsGroup.count];
    
    
}


#pragma mark - ——————— XMFGoodsDeletedPageView的代理方法 ————————

//返回按钮
-(void)buttonsOnXMFGoodsDeletedPageViewDidClick:(XMFGoodsDeletedPageView *)pageView button:(UIButton *)button{
    
    
    [self popAction];
    
}


//cell点击
-(void)cellOnXMFGoodsDeletedPageViewDidSelected:(XMFGoodsDeletedPageView *)pageView model:(XMFHomeGoodsCellModel *)model{
    
    
    self.goodsID = model.goodsId;
    
    
    [self getGoodsDetail];
    

    
}


//加入购物车按钮被点击
-(void)addBtnOnCellDidClick:(XMFGoodsDeletedPageView *)pageView cell:(XMFHomeAllGoodsCell *)goodsCell button:(UIButton *)button indexPath:(NSIndexPath *)selectedIndexPath{
    
    
    //先判断是否是组合商品
    if (goodsCell.recommendModel.isGroupGoods) {
        
        
        [self getGoodsSpecInfo:goodsCell.recommendModel.goodsId button:button indexPath:selectedIndexPath];
        
        
    }else{
        
        
        [self getCartAdd:goodsCell.recommendModel.productId goodsNum:@"1" button:button indexPath:selectedIndexPath];
        
    }
    
    
    
}


#pragma mark - ——————— 分享 ————————
- (void)shareShowInViewController:(UIImage *)shareImage{
    

    NSString *shareURLBaseStr;
    
#if defined(LOCAL_TEST)
    
    //测试环境
    shareURLBaseStr = @"http://test19.qtopay.cn/client#/";
    
#elif defined(PRODUCTION)
    
    //正式环境
   shareURLBaseStr = @"http://test19.qtopay.cn/client#/";
    
#endif
    
    
    //设置网页地址
    
    NSString *strUrl = shareURLBaseStr;
    
    
    // 分享的title
    
    NSString *textToShare = @"标题";
    
    // 分享的图片
    
    UIImage *imageToShare = shareImage;
    
    // 分享的链接地址
    
    NSURL *urlToShare = [NSURL URLWithString:strUrl];
    
    // 顺序可以混乱，系统会自动识别类型
    
//    NSArray*activityItems =@[textToShare,urlToShare,imageToShare];
    
    NSArray*activityItems =@[imageToShare];
    
    // 调起系统分享视图
    
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:@[]];
    
    // 设置忽略分享App的属性
    
    //    vc.excludedActivityTypes = @[UIActivityTypePostToVimeo];
    
    // 分享结果后的回调Block
    
    vc.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType,BOOL completed,NSArray*_NullablereturnedItems,NSError*_NullableactivityError) {
        
        NSLog(@"活动类型：%@", activityType);
        NSLog(@"分享错误:%@",_NullableactivityError);
        
        if(completed) {
            
            
            [MBProgressHUD showSuccess:XMFLI(@"分享成功") toView:self.view];
            
            
        }else{
            
            [MBProgressHUD showError:XMFLI(@"分享失败") toView:self.view];
            
        }
        
    };
    
    [self presentViewController:vc animated:YES completion:nil];
    
}




#pragma mark - ——————— 网络请求 ————————

//获取商品详情的数据
-(void)getGoodsDetail{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":self.goodsID
    };
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [self showGIFImageView];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"商品详情：%@",responseObject);
        
//        [hud hideAnimated:YES];
        
        [self hideGIFImageView];
        
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            if ([responseObject[@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"] isEqual:[NSNull null]]) {
                
                
                [self getRecommendGoods];
                
                
            }else{
                
                //先要把上次可能存在的view删掉
                [self.goodsDeletedView hide];
               
                [self setDataForView:responseObjectModel.data];

                
            }

        
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];
        
        [self hideGIFImageView];

    }];
    
}

//为页面上的控件赋值
-(void)setDataForView:(NSDictionary *)detailDic{
    

    XMFHomeGoodsDetailModel *detailModel = [XMFHomeGoodsDetailModel yy_modelWithDictionary:detailDic];
    
    
    self.detailModel = detailModel;
    
    
    //规格弹窗的数据
    self.selectGoodsTypeView.detailModel = detailModel;
    
    
    //获取轮播图
    NSMutableArray *gallerysURLArr = [[NSMutableArray alloc]init];
    
    for (XMFHomeGoodsDetailGallerysModel *model in self.detailModel.gallerys) {
        
        [gallerysURLArr addObject:model.image];
    }
    
    
    //获取图片尺寸
    CGSize banerImgSize = [UIImage getImageSizeWithURL:[NSURL URLWithString:[gallerysURLArr firstObject]]];
    
    //防止被除数为0导致闪退
    if (banerImgSize.width > 0) {
        
        
        self.cycleScrollViewHeight.constant = banerImgSize.height/banerImgSize.width * KScreenWidth;
    }
    
    
    self.cycleScrollView.imageURLStringsGroup = gallerysURLArr;
    
    //默认赋值
    self.picNumLB.text = [NSString stringWithFormat:@"1/%zd",self.cycleScrollView.imageURLStringsGroup.count];
   
    
    //产地
    [self.fromImgView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.countryIcon]];
    
    self.fromLB.text = self.detailModel.country;
    
    
    //商品名称
//    self.goodsNameLB.text = self.detailModel.goodsName;
    
    //商品归属分类
    /** 税号类型 1-蜜蜂国际-bc 2-蜜蜂海淘-cc */
    
    NSString *goodsResourceImgName;
    
    if ([self.detailModel.taxType isEqualToString:@"2"]) {
        
//        self.goodsResourceImgView.image = [UIImage imageNamed:@"icon_haitao_60x17"];
        
        goodsResourceImgName = @"icon_haitao_60x17";
        
    }else{
        
//        self.goodsResourceImgView.image = [UIImage imageNamed:@"icon_guoji_60x17"];
        
        goodsResourceImgName = @"icon_guoji_60x17";

    }
       
    
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",self.detailModel.goodsName]];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:goodsResourceImgName];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -1.5, 60, 17);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    
    [attri insertAttributedString:string atIndex:0];

    
    self.goodsNameLB.attributedText = attri;
    
    
    //供应商
    [self.supplierBtn setTitle:[NSString stringWithFormat:@"  %@  ",self.detailModel.supplierName] forState:UIControlStateNormal];
    
    
    //仓库
    [self.warehouseBtn setTitle:[NSString stringWithFormat:@"  %@  ",self.detailModel.warehouseName] forState:UIControlStateNormal];
    
    
    /** 是否包税 0-否 1-是p */
    if ([self.detailModel.taxFlag boolValue]) {
        
        self.taxTagLB.hidden = NO;
        
        self.taxTagLBWidth.constant = 40.f;
        
        self.postageTagLBLeftSpace.constant = 5.f;
        
       
        
    }else{
        
        self.taxTagLB.hidden = YES;
        
        self.taxTagLBWidth.constant = 0.f;
        
        self.postageTagLBLeftSpace.constant = 0.f;
        
        self.taxPostFeeLB.text = [NSString stringWithFormat:@"税费：HK$ %@",[NSString removeSuffix:self.detailModel.incomeTax]];


    }
    
    /** 是否包邮 0-否 1-是 */
    if ([self.detailModel.freeShipping boolValue]) {
        
        self.postageTagLB.hidden = NO;
        
        
    }else{
        
        self.postageTagLB.hidden = YES;
        
        
        //防止有税费（即不包税）
        if (![self.detailModel.taxFlag boolValue]) {
            
            self.taxPostFeeLB.text = [NSString stringWithFormat:@"%@   运费：HK$  %@",self.taxPostFeeLB.text,[NSString removeSuffix:self.detailModel.postage]];
            
        }else{
            
            self.taxPostFeeLB.text = [NSString stringWithFormat:@"运费：HK$  %@",[NSString removeSuffix:self.detailModel.postage]];
        }


    }
    
    
    //只有当包邮且包税的时候不显示
    if ([self.detailModel.freeShipping boolValue] && [self.detailModel.taxFlag boolValue]) {
        
        self.taxPostFeeLB.hidden = YES;
        
        self.taxPostFeeLBHeight.constant = 0.f;
                

        
    }else{
        
        self.taxPostFeeLB.hidden = NO;
        
        self.taxPostFeeLBHeight.constant = 24.f;
        

    }
    
    
    //只有当不包邮且不包税的时候
    if (![self.detailModel.freeShipping boolValue] && ![self.detailModel.taxFlag boolValue]) {
        
        self.taxTagLBHeight.constant = 0.f;

    }else{
        
        self.taxTagLBHeight.constant = 18.f;

    }
    
    
    //标价
    self.origPriceLB.attributedText = [GlobalManager textAddLine:[NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:self.detailModel.counterPrice]]];
    
    //实际价格
    self.actPriceLB.attributedText = [GlobalManager changToAttributedStringUpperStr:@"HK$ " upperColor:self.actPriceLB.textColor upperFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.f] lowerStr:[NSString removeSuffix:self.detailModel.retailPrice] lowerColor:self.actPriceLB.textColor lowerFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:24.f]];
    
    
    //销量
    self.salesLB.text = [NSString stringWithFormat:@"销量 %@",self.detailModel.salesNum];
    
    /*
     
    //商品评价
    self.commentCountLB.text = [NSString stringWithFormat:@"商品评价(%@)",self.detailModel.commentCount];
    
    if (self.detailModel.goodsComments.count == 0) {
        //判断有无评价内容
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
        [self.myCollectionView reloadData];

    }
     */
    
    
    //商品信息
    if (self.detailModel.goodsAttributes.count > 0) {
        
        //防止高度叠加先置零
        self.tableViewHeight = 0.f;
        
        self.goodsInfoBgViewHeight.constant = 33 * self.detailModel.goodsAttributes.count + 60.f;
        
        self.goodsInfoBgView.hidden = NO;

        self.parameterBtn.hidden = NO;
        
        self.parameterBtnWidth.constant = 0.333 * self.goodsInfoBtnsBgView.width;

        
        
    }else{
        
        self.goodsInfoBgViewHeight.constant = 0.f;

        self.goodsInfoBgView.hidden = YES;
        
        self.parameterBtn.hidden = YES;
        
        self.parameterBtnWidth.constant = 0.f;

        
    }
    
    [self.myTableView reloadData];
    
    //商品详情
    
    // 设置字体大小，图片宽度适配屏幕，高度自适应
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:36px;}\n"// 字体大小，px是像素
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       "$img[p].style.width = '100%%';\n"// 图片宽度
                       "$img[p].style.maxWidth = '100%%';\n"// 限制图片最大宽度
                       "$img[p].style.height ='auto'\n"// 高度自适应
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>", self.detailModel.detail];
    
    
    [self.detailWebView loadHTMLString:htmls baseURL:nil];

    
    //是否收藏
    self.collectBtn.selected = [self.detailModel.collected boolValue];
    
    
    //商品状态
    /** 商品状态 0-失效 3-上架 4-下架 6-缺货 */
    
    
    if ([self.detailModel.goodsStatus isEqualToString:@"4"]) {
        
        //商品下架
        self.goodsOffLB.hidden = NO;
        
        self.goodsOffLB.text = XMFLI(@"商品已下架");
        
        self.bottomBgView.hidden = YES;
        
        self.bottomBgViewHeight.constant = 0.f;
        
    

        
    }else if ([self.detailModel.goodsStatus isEqualToString:@"0"]) {
        
        //商品失效
        self.goodsOffLB.hidden = NO;
        
        self.goodsOffLB.text = XMFLI(@"商品失效");
        
        self.bottomBgView.hidden = YES;
        
        self.bottomBgViewHeight.constant = 0.f;
        
    }else if ([self.detailModel.goodsStatus isEqualToString:@"6"]){
        
         //商品售罄
         self.goodsOutLB.hidden = NO;
                
        self.goodsOutLB.text = XMFLI(@"已售罄，加急补货中");
        
        self.bottomBgView.hidden = NO;
        
        self.bottomBgViewHeight.constant = 56.f;
        
        self.addCartBtn.userInteractionEnabled = NO;
        
        self.buyBtn.userInteractionEnabled = NO;
        

        
    }else if ([self.detailModel.goodsStatus isEqualToString:@"3"]){
        
        self.bottomBgView.hidden = NO;
        
        self.bottomBgViewHeight.constant = 56.f;
        
    }
    
    
    /*
       //商品下架
       self.goodsOffLB.hidden = NO;
       
       self.bottomBgView.hidden = YES;
       
       self.bottomBgViewHeight.constant = 0.f;
        */
       
       //商品售罄
//       self.goodsOutLB.hidden = NO;
    
    
}


//2.1版本：获取规格相关信息
-(void)getGoodsSpecInfo:(BOOL)isAddCart{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":self.goodsID
        
    };
    
    
    DLog(@"数据字典：%@ 商品id:%@",dic,self.goodsID);
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail_specInfo parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品规格：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            if ([responseObject[@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"] isEqual:[NSNull null]]) {
               //先对数据进行一次判空，避免出现商品不是上架状态的异常状态
                
                if (isAddCart) {
                    
                    [self getCartAdd:self.detailModel.productId goodsNum:@"1"];

                    
                }else{
                    
                    [self postCartFastAddGoods:self.detailModel.productId goodsAmount:@"1"];
                }
                

            }else{
                
                
                XMFGoodsSpecInfoModel *model = [XMFGoodsSpecInfoModel yy_modelWithDictionary:responseObjectModel.data];
                
                model.goodsId = self.goodsID;
                
                
                //防止复用出现错位
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                
                typeView.delegate = self;
                
                
                self.selectGoodsTypeView = typeView;
                
                
                self.selectGoodsTypeView.detailModel = self.detailModel;
                
                
                self.selectGoodsTypeView.specInfoModel = model;
                

                [self.selectGoodsTypeView show];
                
                
            }
        

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
    }];
    

    
}



//收藏或者取消收藏商品
-(void)getGoodsCollectAddOrDelete:(UIButton *)button{

    //类型 0商品 或 1专题
    
    NSDictionary *dic = @{
        
        @"type":@"0",
        
        @"valueId":self.goodsID
        
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_collect_addOrDelete parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"收藏：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            NSString *typeStr = [responseObjectModel.data stringWithKey:@"type"];
            
            if ([typeStr isEqualToString:@"add"]) {
                
                button.selected = YES;
                
                [MBProgressHUD showSuccess:XMFLI(@"收藏成功") toView:self.view];
                
            }else if([typeStr isEqualToString:@"delete"]){
                
                button.selected = NO;
                
                [MBProgressHUD showSuccess:XMFLI(@"取消收藏") toView:self.view];
                
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    
    
}


/*
//获取商品规格
-(void)getGoodsSpecification:(NSString *)goodsId button:(UIButton *)button goodsName:(NSString *)name{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
        
    };
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goodsProductSpec parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"商品规格：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            XMFHomeGoodsPropertyModel *model = [XMFHomeGoodsPropertyModel yy_modelWithDictionary:responseObjectModel.data];
            
            //人工加入商品名称
            model.goodsName = name;
            
            if (model.goodsProducts.count == 1) {
                
                
                [self getCartAdd:[model.goodsProducts firstObject] goodsNum:@"1" button:button];
                
                
            }else{
                
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                typeView.propertyModel = model;
                                
                typeView.selectGoodsTypeBlock = ^(XMFHomeGoodsPropertyProductsModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                    
                    
                    
                    
                    [self getCartAdd:productModel goodsNum:selectedGoodCount button:button];
                    
                };
                
                [typeView show];
                
            }

            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
}
 */


//添加或者减少购物车
-(void)getCartAdd:(NSString *)productId goodsNum:(NSString *)numStr{

    //购物车增加就传入增加的数量，减就传-1
    NSDictionary *dic = @{
        
        @"num":numStr,
        @"productId":productId,
        @"returnCartInfo":@(YES)
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物车加数量：%@",responseObject);
        
        [hud hideAnimated:YES];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
        
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            

            //通知个人中心刷新页面
           KPostNotification(KPost_Anyone_Notice_MeVc_Refesh, nil, nil)
            
            //发送通知告诉购物车刷新
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            //通知首页列表进行刷新
              KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    

}


//获取商品数量
-(void)getCartNum{
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_cart_num parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品数量：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSString *goodsCountStr = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            
            XMFBaseUseingTabarController *tabBarVC = (XMFBaseUseingTabarController *)self.tabBarController;
            //            AxcAE_TabBarItem *item = tabBarVC.axcTabBar.currentSelectItem; // 因为已经到这个页面，说明就是当前的选项卡item
            AxcAE_TabBarItem *item = tabBarVC.axcTabBar.tabBarItems[GlobalManager.getShoppingCartIndex];
            // 为0是否自动隐藏
            item.badgeLabel.automaticHidden = YES;
            
            //防止数量小于等于0
            if ([goodsCountStr integerValue] <= 0) {
                
                goodsCountStr = @"";
            }
            
            item.badge = goodsCountStr;
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
    
}


/*
//立即购买获取商品规格
-(void)getFastAddCartGoodsSpecification:(NSString *)goodsId button:(UIButton *)button goodsName:(NSString *)name{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
        
    };
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goodsProductSpec parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"商品规格：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            XMFHomeGoodsPropertyModel *model = [XMFHomeGoodsPropertyModel yy_modelWithDictionary:responseObjectModel.data];
            
            //人工加入商品名称
            model.goodsName = name;
            

            
            if (model.goodsProducts.count == 1) {
                
                
                [self postCartFastAddGoods:[model.goodsProducts firstObject] goodsAmount:@"1"];
                
                
            }else{
                
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                typeView.propertyModel = model;
                
                typeView.selectGoodsTypeBlock = ^(XMFHomeGoodsPropertyProductsModel * _Nonnull productModel, NSString * _Nonnull selectedGoodCount) {
                    
                    
                    [self postCartFastAddGoods:productModel goodsAmount:selectedGoodCount];
                    
                };
                
                [typeView show];
                
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
    }];
    
}*/




//购买添加购物车
-(void)postCartFastAddGoods:(NSString *)productId goodsAmount:(NSString *)goodsAmountStr{
    
    NSDictionary *dic = @{
        
        @"number":goodsAmountStr,
        
        @"productId":productId,
        
        @"sources": @"APP",
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_wx_order_fastAddOrder parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"快速添加购物车：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            //发送通知告诉购物车刷新
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
            
            //通知首页列表进行刷新
            KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
            
            
            XMFConfirmOrderModel *orderModel = [XMFConfirmOrderModel yy_modelWithDictionary:responseObjectModel.data];
            
            
            //传入购物车id
//            NSString *cartIdStr = [NSString stringWithFormat:@"%@",responseObjectModel.data[@"cartIds"]];
            
            
//            XMFConfirmOrderController  *VCtrl = [[XMFConfirmOrderController alloc]initWithCartId:[orderModel.cartIds copy] confirmOrderModel:orderModel confirmOrderType:fromGoodsDetailVc];
            
            XMFConfirmOrderController  *VCtrl = [[XMFConfirmOrderController alloc]initWithCartId:[orderModel.cartIds copy] listArr:nil confirmOrderModel:orderModel confirmOrderType:fromGoodsDetailVc];
            
            //库存不足返回来的时候重新刷新商品详情
            VCtrl.goodsStockoutBlock = ^{
                
                [self getGoodsDetail];
                
            };
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
            
        }else if (responseObjectModel.code == 408){
            //库存不足
            XMFCommonPicPopView *popView = [XMFCommonPicPopView XMFLoadFromXIB];
            
            popView.tipsLB.text = XMFLI(@"手慢啦，商品库存不足…");
            
            
            [popView show];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
    
    
    
}



//购物说明
-(void)getPurchaseInstructions{
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail_purchaseInstructions parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物说明：%@",responseObject);
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            NSArray *dataArr = responseObject[@"data"];
            
            [self.instructionsModelArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFHomeGoodsDetailPurchaseInstructionsModel *model = [XMFHomeGoodsDetailPurchaseInstructionsModel yy_modelWithDictionary:dic];
                
                [self.instructionsModelArr addObject:model];
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
    
            
        } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
            
        }];
    
    
    
}


//获取评论列表数据
-(void)getCommentData{
    
       
    
    NSDictionary *dic = @{
        
        @"goodsId":self.goodsID,
        
        @"pageNo":@(1),
        
        @"pageSize":@(10)
        
    };
    
        
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goods_comment_page parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"评论列表：%@",[responseObject description]);
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            NSArray *dataArr = responseObjectModel.data[@"dataList"];
            
            [self.commentModelArr removeAllObjects];
            
            
            for (NSDictionary *dic in dataArr) {
                
                XMFGoodsCommentModel *model = [XMFGoodsCommentModel yy_modelWithDictionary:dic];
                
                model.goodsId = self.goodsID;
                
                [self.commentModelArr addObject:model];
            }
        
                        
            
            //商品评价
            self.commentCountLB.text = [NSString stringWithFormat:@"商品评价(%@)",[responseObjectModel.data stringWithKey:@"total"]];
            
            if (self.commentModelArr.count == 0) {
                //判断有无评价内容
                self.myCollectionViewHeight.constant = 0.f;
                
            }else{
                
                [self.myCollectionView reloadData];

            }
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
  
        
    }];
    

    
}



//获取推荐商品
-(void)getRecommendGoods{
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_goods_firstPageRecommend parameters:nil success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"首页推荐：%@",[responseObject description]);
        
//        [hud hideAnimated:YES];

        [self.view hideErrorPageView];
        
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self.dataSourceArr removeAllObjects];
            
            NSArray *dataArr = responseObject[@"data"];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFHomeGoodsCellModel *model = [XMFHomeGoodsCellModel yy_modelWithDictionary:dic];
                
                [self.dataSourceArr addObject:model];
            }
            
            self.goodsDeletedView.dataSourceArr = [self.dataSourceArr mutableCopy];
            
            [self.goodsDeletedView showOnView:self.view];

            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageView];
            [self.view configServerErrorReloadAction:^{
                
                [self getRecommendGoods];
                
                
            }];
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        

        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];


        [self.view hideErrorPageView];

        [self.view showErrorPageView];


        [self.view configReloadAction:^{

            [self getRecommendGoods];
            


        }];
        
    }];
    
    
}


//2.1版本：推荐商品获取规格相关信息
-(void)getGoodsSpecInfo:(NSString *)goodsId button:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail_specInfo parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品规格：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFHomeGoodsCellModel *selectedModel = self.dataSourceArr[indexPath.item];
            
            if ([responseObject[@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"] isEqual:[NSNull null]]) {
               //先对数据进行一次判空，避免出现商品不是上架状态的异常状态
                
//                XMFHomeGoodsCellModel *seletedModel = self.dataSourceArr[indexPath.item];
                
                
                [self getCartAdd:selectedModel.productId goodsNum:@"1" button:button indexPath:indexPath];
                
                
                
            }else{
                
                
                /*
                //把列表的model转换为商品详情的model
                NSDictionary *dic = [selectedModel yy_modelToJSONObject];
                
                
                self.detailModel = [XMFHomeGoodsDetailModel yy_modelWithDictionary:dic];
                 
                 */
                
                

                XMFGoodsSpecInfoModel *model = [XMFGoodsSpecInfoModel yy_modelWithDictionary:responseObjectModel.data];
                
                model.goodsId = goodsId;
                
                
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                
                typeView.delegate = self;
                
                
                typeView.specInfoModel = model;
                
                
                //每次都需要重新创建防止数据重用
                self.recommendSelectGoodsTypeView = typeView;
                
                                
                [self getGoodsDetail:selectedModel.goodsId];
                
                
                typeView.selectGoodsSpecInfoBlock = ^(NSString * _Nonnull goodsId, NSString * _Nonnull selectedGoodCount) {
                    
                    
                    [self getCartAdd:self.recommendDetailModel.productId goodsNum:selectedGoodCount button:button indexPath:indexPath];
                    
                    
                };
                
          
                [typeView show];
                
                
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
    }];
    

    
}


//推荐商品获取商品详情的数据
-(void)getGoodsDetail:(NSString *)goodsId{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
    };
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"商品详情：%@",responseObject);
        
//        [hud hideAnimated:YES];
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self setDataForSelectGoodsTypeView:responseObjectModel.data];

        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];
        

    }];
    
}

//推荐商品为页面上的控件赋值
-(void)setDataForSelectGoodsTypeView:(NSDictionary *)detailDic{
    

    XMFHomeGoodsDetailModel *detailModel = [XMFHomeGoodsDetailModel yy_modelWithDictionary:detailDic];
    
    self.recommendDetailModel = detailModel;
    
    //规格弹窗的数据
    self.recommendSelectGoodsTypeView.detailModel = detailModel;
    
  
    
}


//推荐商品添加或者减少购物车
-(void)getCartAdd:(NSString *)productId goodsNum:(NSString *)numStr button:(UIButton *)button indexPath:(NSIndexPath *)indexPath{


    
    NSDictionary *dic = @{
        
        @"num":numStr,
        @"productId":productId,
        @"returnCartInfo":@(YES)
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_cart_add parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"购物车加数量：%@",responseObject);
        
        [hud hideAnimated:YES];

        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            button.selected = YES;
            
            
            //一定要处理本地数据防止页面滑动出现复用问题
            XMFHomeGoodsCellModel *model = self.dataSourceArr[indexPath.item];
            
            model.cartNum = [NSString stringWithFormat:@"%zd",[model.cartNum integerValue] + [numStr integerValue]];

        
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
//            [self getCartNum];
            
            //通知个人中心刷新页面
           KPostNotification(KPost_Anyone_Notice_MeVc_Refesh, nil, nil)
            
            //发送通知告诉购物车刷新
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
    
            
            //通知首页列表进行刷新
              KPostNotification(KPost_CartVc_Notice_HomeVc_Refesh, nil, nil)
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];

        }
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

    }];
    

}


//立即购买拆分商品
-(void)getGoodsSplitOrders:(NSString *)productId goodsAmount:(NSString *)goodsAmountStr{
    
    
    
    
    NSDictionary *dic = @{
        
        @"productId":productId,
        
        @"number":goodsAmountStr
        
    };
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];

    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_splitOrders parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"立即购买拆分商品：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            NSArray *dataArr = responseObject[@"data"];
            
            
            [self.SplitOrdersDataArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFShoppingSplitOrdersModel *splitOrdersModel = [XMFShoppingSplitOrdersModel yy_modelWithDictionary:dic];
                
                [self.SplitOrdersDataArr addObject:splitOrdersModel];
                
            }
            
        
            if (self.SplitOrdersDataArr.count > 1) {
                //当拆分的数量大于1的时候需要拆分
                
                XMFShoppingSplitOrdersView *popView = [XMFShoppingSplitOrdersView XMFLoadFromXIB];
                
                popView.delegate = self;
                
                self.splitOrdersView = popView;
                
                popView.dataSourceArr = [self.SplitOrdersDataArr copy];
                
                [popView show];
                
                
            }else if(self.SplitOrdersDataArr.count == 1){
                //当拆分的数量等于1的时候直接跳转到订单确认
                
                XMFShoppingSplitOrdersModel *selectedModel = [self.SplitOrdersDataArr firstObject];

                //因为单个商品拆单里面也只有这一个商品
                XMFShoppingSplitOrdersGoodsModel *goodsModel = [selectedModel.ordersGoods firstObject];
                
                
                [self postCartFastAddGoods:goodsModel.productId goodsAmount:goodsModel.number];
                
                
            }
        
            
        }else{
            
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        

        
            
        } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
            
            
            [hud hideAnimated:YES];

            
        }];
    
    
    
}



#pragma mark - ——————— 图文详情wkwebview相关的代码 ————————

/** < 方式一:KVO 监听 > */
- (void)addWebViewObserver {
    [self.detailWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

//移除 KVO 监听
- (void)removeWebViewObserver {
    [self.detailWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

//移除 KVO 监听
-(void)dealloc{

    [self removeWebViewObserver];
     
 }
 
#pragma mark ------ < KVO > ------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    /**  < 法2 >  */
    /**  < loading：防止滚动一直刷新，出现闪屏 >  */
    if ([keyPath isEqualToString:@"contentSize"]) {

        CGRect webFrame = self.detailWebView.frame;

        webFrame.origin.y += 48;

        webFrame.size.height = self.detailWebView.scrollView.contentSize.height;

//        self.detailWebView.frame = webFrame;

        self.imgTextDtailBgViewHeight.constant = webFrame.size.height + 48;

    }
}





#pragma mark - ——————— 懒加载 ————————

-(WKWebView *)detailWebView{

    if (_detailWebView == nil) {
        _detailWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _detailWebView.scrollView.scrollEnabled = NO;
//        _detailWebView.navigationDelegate = self;
        _detailWebView.userInteractionEnabled = false;
        
        [self.imgTextDetaiBgView addSubview:_detailWebView];
        
        [_detailWebView mas_makeConstraints:^(MASConstraintMaker *make) {
           
//            make.edges.mas_equalTo(self.imgTextDetaiBgView);
            
            make.top.mas_equalTo(self.imgTextDetaiBgView).offset(48);
            make.left.right.bottom.mas_equalTo(self.imgTextDetaiBgView);
            
            
        }];

    }
    return _detailWebView;
    
    
}



-(NSMutableArray<XMFHomeGoodsDetailPurchaseInstructionsModel *> *)instructionsModelArr{
    
    if (_instructionsModelArr == nil) {
        _instructionsModelArr = [[NSMutableArray alloc] init];
    }
    return _instructionsModelArr;
}


-(XMFSelectGoodsTypeView *)selectGoodsTypeView{
    
    if (_selectGoodsTypeView == nil) {
        
        _selectGoodsTypeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
        
        _selectGoodsTypeView.delegate = self;
        
    }
    return _selectGoodsTypeView;
    
}

-(NSMutableArray<XMFGoodsCommentModel *> *)commentModelArr{
    
    if (_commentModelArr == nil) {
        _commentModelArr = [[NSMutableArray alloc] init];
    }
    return _commentModelArr;
    
    
}


-(XMFGoodsDeletedPageView *)goodsDeletedView{
    
    
    if (_goodsDeletedView == nil) {
        _goodsDeletedView = [XMFGoodsDeletedPageView XMFLoadFromXIB];
        _goodsDeletedView.delegate = self;
    }
    return _goodsDeletedView;
    
}


-(NSMutableArray<XMFHomeGoodsCellModel *> *)dataSourceArr{
    
    if (_dataSourceArr == nil) {
        _dataSourceArr = [[NSMutableArray alloc] init];
    }
    return _dataSourceArr;
    
}


-(NSMutableArray<XMFShoppingSplitOrdersModel *> *)SplitOrdersDataArr{
    
    if (_SplitOrdersDataArr == nil) {
        _SplitOrdersDataArr = [[NSMutableArray alloc] init];
    }
    return _SplitOrdersDataArr;
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
