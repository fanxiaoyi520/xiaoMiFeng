//
//  XMFThemeDetailController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/27.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFThemeDetailController.h"
#import "XMFHomePartGoodsCell.h"
#import "CHTCollectionViewWaterfallLayout.h"//布局
#import "XMFThemeDetailModel.h"//主题详情列表model
#import "XMFGoodsDetailViewController.h"//商品详情
#import "XMFSelectGoodsTypeView.h"//商品属性弹框
#import "XMFHomeGoodsPropertyModel.h"//商品属性的model
#import "XMFThemeDetailHeaderView.h"//头部view
#import "XMFGoodsSpecInfoModel.h"//商品规格model
#import "XMFHomeGoodsDetailModel.h"//商品详情的总model


@interface XMFThemeDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout,XMFHomePartGoodsCellDelegate,XMFSelectGoodsTypeViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;


@property (weak, nonatomic) IBOutlet UILabel *topTitleLB;


/** 商品collectionview */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;


/** 顶部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewTopSpace;


/** 布局 */
//@property (nonatomic, strong) CHTCollectionViewWaterfallLayout *flowLayout;

/** 上次Y轴偏移量 */
@property (nonatomic, assign) CGFloat lastOffSetY;


/** 专题id */
@property (nonatomic, copy) NSString *topicIdStr;

/** 主题详情列表model */
@property (nonatomic, strong) XMFThemeDetailModel *detailModel;

/** 商品详情的model */
@property (nonatomic, strong) XMFHomeGoodsDetailModel *goodsDetailModel;

/** 商品规格弹窗 */
@property (nonatomic, strong) XMFSelectGoodsTypeView *selectGoodsTypeView;

@end

@implementation XMFThemeDetailController



-(instancetype)initWithTopicId:(NSString *)topicId{
    
    self = [super init];
    
    if (self) {
        
        self.topicIdStr = topicId;
        
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
        
        self.myCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    
    self.topViewHeight.constant = kTopHeight;

    
    /*
    self.flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    //    self.flowLayout.headerHeight = 15;
    //    self.flowLayout.footerHeight = 10;
    self.flowLayout.minimumColumnSpacing = 10;
    self.flowLayout.minimumInteritemSpacing = 10;
    self.flowLayout.columnCount = 1;
     
     */
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // line 跟滚动方向相同的间距
    flowLayout.minimumLineSpacing = 10;
    
     // item 跟滚动方向垂直的间距
    flowLayout.minimumInteritemSpacing = 10;
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    
    self.myCollectionView.collectionViewLayout = flowLayout;
    
//    self.myCollectionView.backgroundColor = UIColorFromRGB(0xF2F2F2);
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;
    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFHomePartGoodsCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFHomePartGoodsCell class])];
    
    
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFThemeDetailHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFThemeDetailHeaderView class])];
    
    
    /*
    self.myCollectionView.mj_footer = [XMFRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        
        [self.myCollectionView reloadData];
        
        [self.myCollectionView.mj_footer endRefreshing];
        
    }];
    */
    
    
    [self getTopicInfo];
    
}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    [self popAction];
}


#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.detailModel.goodsList.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFHomePartGoodsCell *themeCell = (XMFHomePartGoodsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFHomePartGoodsCell class]) forIndexPath:indexPath];
    
    themeCell.delegate = self;
    
    themeCell.themeListModel = self.detailModel.goodsList[indexPath.item];
    
    
    return themeCell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
//    [collectionView reloadData];
    
    
    XMFThemeDetailListModel *model = self.detailModel.goodsList[indexPath.item];
    
    XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:model.goodsId];
    
    [self.navigationController pushViewController:VCtrl animated:YES];
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(KScreenW - 20, KScaleWidth(137));

}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
   
    kWeakSelf(self)
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){

        
//        UICollectionReusableView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];

        XMFThemeDetailHeaderView * headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([XMFThemeDetailHeaderView class]) forIndexPath:indexPath];
        
        headView.bgImgURLStr = self.detailModel.backgroundPic;
        
        
        return headView;

    
    }else {
        
         return nil;
    }
    
    
   
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    CGSize bgImageSize = [UIImage getImageSizeWithURL:self.detailModel.backgroundPic];
    
    CGFloat headerViewHeigth;
    
    //防止被除数小于0
    if (bgImageSize.width > 0){
        
        headerViewHeigth = bgImageSize.height/bgImageSize.width * KScreenW - KScaleWidth(84);
        
    }else{
        
        headerViewHeigth = 0;
    }
    

    return CGSizeMake(KScreenWidth, headerViewHeigth);
    
    
    
}


/*
#pragma mark - ——————— CHTCollectionViewDelegateWaterfallLayout ————————

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake(KScreenW - 20, 137);

    
}*/

#pragma mark - ——————— UIScrollView的代理方法 ————————
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    self.lastOffSetY = scrollView.contentOffset.y;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if(scrollView.contentOffset.y == 0){//向上滚动
        
       self.topView.hidden = YES;
        
    }else{
        
        self.topView.hidden = NO;
    }

    /*
    CGFloat gap = scrollView.contentOffset.y - self.lastOffSetY;
    
    DLog(@"偏移量：%f",scrollView.contentOffset.y);
    
    DLog(@"偏移量2：%f",gap);

     if (gap < 0) {//向下滚动
         
         
     }else{//向上滚动
         
         
     }
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY > self.bannerImgView.height) {
        
         self.myCollectionViewTopSpace.constant = - self.bannerImgView.height;
        
    }else{
        
        self.myCollectionViewTopSpace.constant = - self.bannerImgView.height + offsetY;
    }*/
    

    
}


#pragma mark - ——————— XMFHomePartGoodsCell的代理方法 ————————
-(void)buttonsOnXMFHomePartGoodsCellDidClick:(XMFHomePartGoodsCell *)cell button:(UIButton *)button{
    
    
//    [self getGoodsSpecification:cell.themeListModel.goodsId button:button goodsName:cell.themeListModel.goodsName];
    
    
    NSIndexPath *selectedIndexPath = [self.myCollectionView indexPathForCell:cell];
    

    //先判断是否是组合商品
    if (cell.themeListModel.isGroupGoods) {
        
        
        [self getGoodsSpecInfo:cell.themeListModel.goodsId button:button indexPath:selectedIndexPath];
        
        
    }else{
        
        
        [self getCartAdd:cell.themeListModel.productId goodsNum:@"1" button:button indexPath:selectedIndexPath];
        
    }
    
}


#pragma mark - ——————— XMFSelectGoodsTypeView的代理方法 ————————

-(void)selectGoodsTypeCellOnXMFSelectGoodsTypeViewDidClick:(XMFSelectGoodsTypeView *)typeView goodsId:(NSString *)goodsId{
    
    
    [self getGoodsDetail:goodsId];
}


#pragma mark - ——————— 网络请求 ————————

//获取主题详情列表
-(void)getTopicInfo{
    
    
    NSDictionary *dic = @{
        
        @"topicId":self.topicIdStr
        
    };
    
    
    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_topic_info parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"主题详情：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        [self.view hideErrorPageView];
        [self.view hideServerErrorPageView];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            
            
            self.detailModel = [XMFThemeDetailModel yy_modelWithDictionary:responseObjectModel.data];
            
            
            //背景颜色
            self.topView.backgroundColor = [GlobalManager colorWithHexString:self.detailModel.backgroundColor];
            
         
            self.view.backgroundColor =  [GlobalManager colorWithHexString:self.detailModel.backgroundColor];
            
            
            //标题名称
            self.topTitleLB.text = self.detailModel.topicName;
            
            [self.myCollectionView reloadData];
    
            
        }else if (responseObjectModel.code == XMFHttpReturnServerError){//服务器报错
            
            [self.view showServerErrorPageViewWithY:kTopHeight];
            [self.view configServerErrorReloadAction:^{
                
                [self getTopicInfo];
            }];
            
        }else{
            
           
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];
        
        [self.view hideErrorPageView];

        [self.view showErrorPageView];

        [self.view configReloadAction:^{
            
            [self getTopicInfo];
            
            
        }];

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
                
//                typeView.delegate = self;
                
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
    
}*/


//添加或者减少购物车
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
            XMFThemeDetailListModel *model = self.detailModel.goodsList[indexPath.item];
            
            model.cartNum = [NSString stringWithFormat:@"%zd",[model.cartNum integerValue] + [numStr integerValue]];
            
        
            [MBProgressHUD showSuccess:responseObjectModel.message toView:self.view];
            
//            [self getCartNum];
            
            //发送通知告诉购物车刷新
            KPostNotification(KPost_HomeVc_Notice_ShoppingcartVc_Refresh, nil, nil)
            
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


//2.1版本：获取规格相关信息
-(void)getGoodsSpecInfo:(NSString *)goodsId button:(UIButton *)button indexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
        
    };
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail_specInfo parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取商品规格：%@",responseObject);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            XMFThemeDetailListModel *selectedModel = self.detailModel.goodsList[indexPath.item];
            
            if ([responseObject[@"data"] isKindOfClass:[NSNull class]] || [responseObject[@"data"] isEqual:[NSNull null]]) {
               //先对数据进行一次判空，避免出现商品不是上架状态的异常状态
                
//                XMFHomeGoodsCellModel *seletedModel = self.dataSourceArr[indexPath.item];
                
                
                [self getCartAdd:selectedModel.productId goodsNum:@"1" button:button indexPath:indexPath];
                
                
                
            }else{
                
                /*
                //把列表的model转换为商品详情的model
                NSDictionary *dic = [selectedModel yy_modelToJSONObject];
                
                
                self.goodsDetailModel = [XMFHomeGoodsDetailModel yy_modelWithDictionary:dic];
                */

                XMFGoodsSpecInfoModel *model = [XMFGoodsSpecInfoModel yy_modelWithDictionary:responseObjectModel.data];
                
                model.goodsId = goodsId;
                
                
                XMFSelectGoodsTypeView *typeView = [XMFSelectGoodsTypeView XMFLoadFromXIB];
                
                
                typeView.delegate = self;
                
                
                typeView.specInfoModel = model;
                
                
                //每次都需要重新创建防止数据重用
                self.selectGoodsTypeView = typeView;
                
                
//                typeView.detailModel = self.goodsDetailModel;
                [self getGoodsDetail:selectedModel.goodsId];
                
                typeView.selectGoodsSpecInfoBlock = ^(NSString * _Nonnull goodsId, NSString * _Nonnull selectedGoodCount) {
                    
                    
                    [self getCartAdd:self.goodsDetailModel.productId goodsNum:selectedGoodCount button:button indexPath:indexPath];
                    
                    
                };
                

                
                
                [typeView show];
                
                
            }
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
            
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        
    }];
    

    
}


//获取商品详情的数据
-(void)getGoodsDetail:(NSString *)goodsId{
    
    
    NSDictionary *dic = @{
        
        @"goodsId":goodsId
    };
    
    
//    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_detail parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        
        DLog(@"商品详情：%@",responseObject);
        
//        [hud hideAnimated:YES];
        
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            [self setDataForView:responseObjectModel.data];

        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
//        [hud hideAnimated:YES];
        

    }];
    
}

//为页面上的控件赋值
-(void)setDataForView:(NSDictionary *)detailDic{
    

    XMFHomeGoodsDetailModel *detailModel = [XMFHomeGoodsDetailModel yy_modelWithDictionary:detailDic];
    
    
    self.goodsDetailModel = detailModel;
    
    
    //规格弹窗的数据
    self.selectGoodsTypeView.detailModel = detailModel;
    
  
    
}



#pragma mark - ——————— 拉伸图片 ————————
/**
 图片只拉伸两侧，不拉伸中间部位

 @param imageViewSize   图片控件size
 @param originImage     要拉伸的图片
 @return 拉伸完成的图片
 */
- (UIImage *)imageStretchLeftAndRightWithContainerSize:(CGSize)imageViewSize image:(UIImage *)originImage {
    
    CGSize imageSize = originImage.size;
    CGSize bgSize = CGSizeMake(imageViewSize.width, imageViewSize.height); //imageView的宽高取整，否则会出现横竖两条缝
    
    UIImage *image = [originImage stretchableImageWithLeftCapWidth:floorf(imageSize.width * 0.8) topCapHeight:imageSize.height * 0.5];
    CGFloat tempWidth = (bgSize.width)/2 + (imageSize.width)/2;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake((NSInteger)tempWidth, (NSInteger)bgSize.height), NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, (NSInteger)tempWidth, (NSInteger)bgSize.height)];
    
    UIImage *firstStrechImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *secondStrechImage = [firstStrechImage stretchableImageWithLeftCapWidth:floorf(imageSize.width * 0.2) topCapHeight:imageSize.height * 0.5];
    
    return secondStrechImage;
}

/*
#pragma mark - ——————— 懒加载 ————————
-(CHTCollectionViewWaterfallLayout *)flowLayout{
    
    if (_flowLayout == nil) {
        
        _flowLayout = [[CHTCollectionViewWaterfallLayout alloc] init];
    }
    return _flowLayout;
    
}*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
