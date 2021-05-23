//
//  XMFGoodsCommentDetailController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/8/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFGoodsCommentDetailController.h"
#import "XMFGoodsCommentDetailCell.h"
#import "XMFGoodsCommentModel.h"//评论的model
#import "XMFGoodsDetailViewController.h"//商品详情
#import "YYStarView.h"//星星view


@interface XMFGoodsCommentDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


/** 轮播图 */
@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

/** 轮播图的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cycleScroollViewHeight;



/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;

/** 昵称 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLB;

/** 评价星星的view */
@property (weak, nonatomic) IBOutlet YYStarView *starView;


/** 时间和规格 */
@property (weak, nonatomic) IBOutlet UILabel *timeSpecifiLB;

/** 评论内容 */
@property (weak, nonatomic) IBOutlet UILabel *commentLB;

/** 多少天后 */
@property (weak, nonatomic) IBOutlet UILabel *afterDaysLB;

/** 追评内容 */
@property (weak, nonatomic) IBOutlet UILabel *addCommentLB;


/** 追评的顶部间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addCommentLBBottomSpace;



/** 评论图片 */
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

/** 评论图片的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myCollectionViewHeight;


/** 底部view */
@property (weak, nonatomic) IBOutlet UIView *bottomView;



/** 商品图片 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;

/** 商品名称 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLB;

/** 商品价格 */
@property (weak, nonatomic) IBOutlet UILabel *priceLB;

/** 商品评论model */
@property (nonatomic, strong) XMFGoodsCommentModel *model;

/** 追加评论的model */
@property (nonatomic, strong) XMFGoodsCommentAppendModel *appendModel;

/** 追加评论的图片数组 */
@property (nonatomic, strong) NSMutableArray *picUrlsArr;


@end

@implementation XMFGoodsCommentDetailController


-(instancetype)initWithCommentModel:(XMFGoodsCommentModel *)commentModel{
    
    self = [super init];
    
    if (self) {
        
        self.model = commentModel;
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
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(8, 5, 8, 0);
    
    // line 跟滚动方向相同的间距
    flowLayout.minimumLineSpacing = 10;
    
     // item 跟滚动方向垂直的间距
    flowLayout.minimumInteritemSpacing = 0;
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    

    self.myCollectionView.collectionViewLayout = flowLayout;
    
    self.myCollectionView.delegate = self;
    
    self.myCollectionView.dataSource = self;

    
    [self.myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFGoodsCommentDetailCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([XMFGoodsCommentDetailCell class])];
    
    
    
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
    
    
    
    //规格选择添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self.bottomView addGestureRecognizer:tap];
    
    
    //评价星星view设置参数
    self.starView.userInteractionEnabled = NO;
    self.starView.starSize = CGSizeMake(20, 20);
    self.starView.starSpacing = 5;
    self.starView.starBrightImageName = @"icon_comment_star_y";
    self.starView.starDarkImageName = @"icon_comment_star_n";
    
    

    
    [self setDataForView:self.model];
    
    
    [self getRecommandGoods];
    
    
}

-(void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    [self.avatarImgView cornerWithRadius:self.avatarImgView.height/2.0];
    
}


//手势绑定方法
-(void)tapAction:(UIGestureRecognizer *)gesture{
    

//    UIView *tapView = (UIView *)gesture.view;
    
//    [self popAction];
    
    
    //跳转到指定页面
    for(UIViewController *temVC in self.navigationController.viewControllers){
        
        if([temVC isKindOfClass:[XMFGoodsDetailViewController class]]){
            
            [self.navigationController popToViewController:temVC animated:YES];
            
        }
        
    }

    
}

#pragma mark - ——————— UICollectionViewDataSource ————————

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
//    return self.appendModel.picUrls.count;
    
    return self.picUrlsArr.count;
}


-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFGoodsCommentDetailCell *commentCell = (XMFGoodsCommentDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XMFGoodsCommentDetailCell class]) forIndexPath:indexPath];
    
    
    commentCell.picURLStr = [NSString stringWithFormat:@"%@",self.picUrlsArr[indexPath.item]];
    
    
    return commentCell;
            
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
 
//    [collectionView reloadData];
    
    
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.myCollectionView.height - 16, self.myCollectionView.height - 16);

}


//页面上的按钮被点击
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    [self popAction];
    
}

#pragma mark - ——————— 网络请求 ————————

//获取底部推荐商品
-(void)getRecommandGoods{
    
    NSDictionary *dic = @{
        
        @"goodsId":self.model.goodsId
        
    };
    

    MBProgressHUD * hud = [MBProgressHUD showOnlyLoadToView:self.view];
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendGETRequestMethod:URL_goods_goods_commentGoods parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"获取推荐商品：%@",responseObject);
        
        [hud hideAnimated:YES];
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {

            
            [self setDataForGoods:responseObjectModel.data];
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:self.view];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
        [hud hideAnimated:YES];

        
    }];
    
    
}


//为底部商品赋值
-(void)setDataForGoods:(NSDictionary *)dataDic{
    
    /**
      
      {
        "goodsPic" : "https:\/\/kuajingdianshang.oss-cn-shenzhen.aliyuncs.com\/ttev2kgcs944hqr48xe9bsnf2fm0.jpg",
        "goodsId" : 1182504,
        "price" : 80,
        "goodsName" : "liyou-test"
      }
      
      */
    
    [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dataDic[@"goodsPic"]]] placeholderImage:[UIImage imageNamed:@"icon_common_placeRect"]];
    
    self.goodsNameLB.text = [NSString stringWithFormat:@"%@",dataDic[@"goodsName"]];
    
    
    self.priceLB.text = [NSString stringWithFormat:@"HK$ %@",[NSString removeSuffix:dataDic[@"price"]]];
    
    
}


//为除了底部商品外的控件赋值
-(void)setDataForView:(XMFGoodsCommentModel *)commentModel{
    
    //获取轮播图
    NSMutableArray *gallerysURLArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dic in commentModel.picUrls) {
        
        NSString *urlStr = [NSString stringWithFormat:@"%@",dic[@"image"]];
        
        [gallerysURLArr addObject:urlStr];
        
    }
    
    
    //获取图片尺寸
    CGSize banerImgSize = [UIImage getImageSizeWithURL:[NSURL URLWithString:[gallerysURLArr firstObject]]];
    
    //防止被除数为0导致闪退
    if (banerImgSize.width > 0) {
        
        self.cycleScroollViewHeight.constant = banerImgSize.height/banerImgSize.width * KScreenWidth;
        
    }
    
            
    
    self.cycleScrollView.imageURLStringsGroup = gallerysURLArr;

    
        
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:commentModel.userIcon] placeholderImage:[UIImage imageNamed:@"icon_me_touxiang"]];
    
    self.nickNameLB.text = commentModel.userName;
    
    //评价星星
    self.starView.starCount = [commentModel.star integerValue];
    self.starView.starScore = [commentModel.star integerValue];
    
    
    NSString *addTimeFormaterStr = @"yyyy-MM-dd";
    
    
    NSString *addTimeStr = [DateUtils getDateByTimeStamp:commentModel.addTime formatter:addTimeFormaterStr];
    
    self.timeSpecifiLB.text = [NSString stringWithFormat:@"%@ %@",addTimeStr,[NSString returnNonemptyString:commentModel.specifications]];
    
    self.commentLB.text = commentModel.content;
    
    
    //字符串转字典
    
    NSDictionary *appendDic;
    
    if (commentModel.appendComment.length > 0) {
        //防止没有数据闪退
        
        NSData *jsonData = [commentModel.appendComment dataUsingEncoding:NSUTF8StringEncoding];
        
        
        //data转json
//        NSMutableDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        
        appendDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        DLog(@"数据字典：%@",appendDic);
        
        //不能再使用yymodel会导致闪退
//        self.appendModel = [XMFGoodsCommentAppendModel yy_modelWithDictionary:appendDic];
        
        NSString *formaterStr = @"yyyy-MM-dd";
        
        NSString *createTimeStampStr = [appendDic stringWithKey:@"createTime"];
        
        NSString *createTimeStr = [DateUtils getDateByTimeStamp:createTimeStampStr formatter:formaterStr];
        
        DLog(@"时间戳：%@",createTimeStr);
        
        /*
         
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
       
        [formater setDateFormat:formaterStr];
        
        //当前时间的NSDate
        NSDate* currentDate = [NSDate date];
        
        NSString *currentTimeString = [formater stringFromDate:currentDate];
       
         */
        
        
        
        NSInteger afterDay = [DateUtils compareBeginTime:addTimeStr endTime:createTimeStr];
        
    
        self.afterDaysLB.text = [NSString stringWithFormat:@"用户%zd天后追评",afterDay];
                
        self.addCommentLB.text = [appendDic stringWithKey:@"content"];
        
        self.addCommentLBBottomSpace.constant = 0;
        
        self.afterDaysLB.hidden = NO;
        
        self.addCommentLB.hidden = NO;

        
    }else{
        
        self.afterDaysLB.hidden = YES;
        
        self.addCommentLB.hidden = YES;
        
        self.addCommentLBBottomSpace.constant = -43;
        
    }
    
    
    self.picUrlsArr = [appendDic notNullObjectForKey:@"picUrls"];

    //当没有图片的时候不显示
    if (self.picUrlsArr.count == 0) {
        
        self.myCollectionViewHeight.constant = 0.f;
        
    }else{
        
        self.myCollectionViewHeight.constant = 124.f;
        
        [self.myCollectionView reloadData];

    }
 
    
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
