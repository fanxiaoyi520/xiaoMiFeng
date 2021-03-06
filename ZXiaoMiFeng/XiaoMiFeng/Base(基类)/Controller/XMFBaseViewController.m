//
//  XMFBaseViewController.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/4/9.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFBaseViewController.h"
#import "MMWebView.h"


@interface XMFBaseViewController ()<UIGestureRecognizerDelegate>

//å°åºmodelæ°ç»
@property (nonatomic, strong) NSMutableArray<XMFAreaCodeModel *> *areaModelArr;

@end

@implementation XMFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // æ·»å åå³æ»å¨è¿åä¸ä¸çº§é¡µé¢æå¿
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        // æ·»å åå³æ»å¨è¿åä¸ä¸çº§é¡µé¢æå¿
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

/*
 
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    DLog(@" gestureRecognizerShouldBegin : %@ \n %@",gestureRecognizer,[gestureRecognizer class]);
  
    
    BOOL result = FALSE;
    // æå¿
    if(gestureRecognizer == self.navigationController.interactivePopGestureRecognizer){
        // æ§å¶å¨å æ 
        if(self.navigationController.viewControllers.count >= 2){
            result = TRUE;
        }
    }
    return result;
}
 
 */



#pragma mark -- åå§åæ¹æ³
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)popAction {
    
    
    if (self.navigationController.topViewController == self) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark -- ç»å­ç±»æä¾çæ¹æ³
- (void)pushViewController:(UIViewController *)vc {
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)setNaviTitle:(NSString *)naviTitle {
    
     self.topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kTopHeight)];
     
    
    // è¿åæé®
    UIButton *closeBtn = [UIButton new];
    closeBtn.frame = CGRectMake(0, kStatusBarHeight, 50, kNavBarHeight);
    [closeBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:closeBtn];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(KScreenWidth*0.2, kStatusBarHeight, KScreenWidth*0.6, kTopHeight -kStatusBarHeight);

    titleLabel.text = naviTitle;
//        titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.topBgView addSubview:titleLabel];
    
    //è¿åå¾
    UIImageView *backImageV = [[UIImageView alloc] init];
    
    //èªå®ä¹å¯¼èªèæ¯é¢è²
    if (self.topBgViewbgColor) {
        
        
        self.topBgView.backgroundColor = self.topBgViewbgColor;
        
        backImageV.image = [UIImage imageNamed:@"icon_common_return_white"];
        
        titleLabel.textColor = KWhiteColor;
        
    }else{
        
        
        self.topBgView.backgroundColor = [UIColor whiteColor];
        
        backImageV.image = [UIImage imageNamed:@"icon_common_return"];
    }
    
    [self.view addSubview:self.topBgView];
    
    [backImageV sizeToFit];
    backImageV.origin = CGPointMake(20, kStatusBarHeight +(kNavBarHeight-backImageV.height)/2);
    [self.topBgView addSubview:backImageV];
}

- (void)setHomeNaviTitle:(NSString *)naviTitle {
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kTopHeight)];
    _topBgView.backgroundColor = KWhiteColor;
    [self.view addSubview:_topBgView];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(KScreenWidth*0.2, kStatusBarHeight, KScreenWidth*0.6, kTopHeight-kStatusBarHeight);
    titleLabel.text = naviTitle;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [_topBgView addSubview:titleLabel];
}


-(void)setNoneBackNaviTitle:(NSString *)noneBackNaviTitle{
 
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kTopHeight)];
    [self.view addSubview:_topBgView];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(KScreenWidth*0.2, kStatusBarHeight, KScreenWidth*0.6, kTopHeight-kStatusBarHeight);
    titleLabel.text = noneBackNaviTitle;
    
    //èªå®ä¹å¯¼èªèæ¯é¢è²
    if (self.topBgViewbgColor) {
        
        _topBgView.backgroundColor = self.topBgViewbgColor;
        
        titleLabel.textColor = KWhiteColor;

        
    }else{
        
        
        _topBgView.backgroundColor = KWhiteColor;
        
        titleLabel.textColor = UIColorFromRGB(0x333333);

        
    }
    
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [_topBgView addSubview:titleLabel];

}

- (void)setThemeNaviTitle:(NSString *)themeNaviTitle {
    
//    UIView *topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IPhoneXTopHeight)];
    
    self.topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kTopHeight)];
    
    self.topBgView.backgroundColor = KWhiteColor;
    [self.view addSubview:self.topBgView];
    
    //è¿åå¾
    UIImageView *backImageV = [[UIImageView alloc] init];
    backImageV.image = [UIImage imageNamed:@"icon_common_return_white"];
    [backImageV sizeToFit];
    backImageV.origin = CGPointMake(20, kStatusBarHeight+(kNavBarHeight-backImageV.height)/2);
    [self.topBgView addSubview:backImageV];
    
    
    //èªå®ä¹å¯¼èªèæ¯é¢è²
    if (self.topBgViewbgColor) {
        
        self.topBgView.backgroundColor = self.topBgViewbgColor;
        
        backImageV.image = [UIImage imageNamed:@"icon_common_return_white"];
        
    }else{
        
        
        self.topBgView.backgroundColor = KWhiteColor;
        
        backImageV.image = [UIImage imageNamed:@"icon_common_return"];
    }
    
    // è¿åæé®
    UIButton *closeBtn = [UIButton new];
    closeBtn.frame = CGRectMake(0, kStatusBarHeight, 50, kNavBarHeight);
    [closeBtn addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:closeBtn];
    
    // title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(KScreenWidth*0.2, kStatusBarHeight, KScreenWidth*0.6, kTopHeight-kStatusBarHeight);
    titleLabel.text = themeNaviTitle;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.topBgView addSubview:titleLabel];
}

//å³è¾¹æ·»å æå­æé®
- (void)addRightItemWithTitle:(NSString *)title action:(SEL)selector {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.topBgView.width-70-20, kStatusBarHeight, 70, kTopHeight-kStatusBarHeight)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:UIColorFromRGB(0x3F454B) forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
    [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
     self.rightBtn = rightBtn;
    
    [_topBgView addSubview:rightBtn];
}

//å³è¾¹æ·»å å¸¦é¢è²çæå­æé®
- (void)addRightItemWithTitle:(NSString *)title action:(SEL)selector titleColor:(UIColor *)titleColor {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.topBgView.width-70-20, kStatusBarHeight, 70, kTopHeight - kStatusBarHeight)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
     self.rightBtn = rightBtn;
    
    [_topBgView addSubview:rightBtn];
}

//å³è¾¹æ·»å å¾çæé®
- (void)addRightItemWithImage:(NSString *)imageName action:(SEL)selector {
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.topBgView.width-70-20, kStatusBarHeight, 70, kNavBarHeight-kStatusBarHeight)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.0];
    [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
     self.rightBtn = rightBtn;
    
    [_topBgView addSubview:rightBtn];
}

//å³è¾¹æ·»å å¸¦é¢è²çæå­åå¾çæé®ï¼å¹¶ä¸å¸¦æå­å¾çæåä½ç½®
- (void)addRightItemWithTitle:(NSString *)title action:(SEL)selector titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont image:(NSString *)imageName imageTitleStyle:(XMFButtonEdgeInsetsStyle)style{
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.topBgView.width-70-20, kStatusBarHeight, 70, kTopHeight-kStatusBarHeight)];
//    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
     rightBtn.titleLabel.font = titleFont;
     [rightBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [rightBtn layoutButtonWithEdgeInsetsStyle:style imageTitleSpace:0.f];
    
    [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = rightBtn;
    
    [_topBgView addSubview:rightBtn];
    

}


-(void)addRightItemWithTitle:(NSString *)title selectedTitle:(NSString *)selectedTitle action:(SEL)selector titleColor:(UIColor *)titleColor{
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.topBgView.width-70-20, kStatusBarHeight, 70, kTopHeight - kStatusBarHeight)];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [rightBtn setTitle:title forState:UIControlStateNormal];
    [rightBtn setTitle:selectedTitle forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14.0];
    [rightBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    
    self.rightBtn = rightBtn;
    
    [_topBgView addSubview:rightBtn];
    
    
}

#pragma mark - âââââââ ç½ç»è¯·æ± ââââââââ

//è·åå½å®¶æå°åºä»£ç 
-(void)getCountryRegionQuery{
    
    NSDictionary *dic = @{
               
        //æç´¢çæ¶åä¼ å¥keywordåæ°
//        @"keyword": @"86",
        
    };
    
    
//    [CommonManager updateMD5Key:@"N5vtLiwyEetpvitXXapwhIa6hYsu4WQ4"];
    
//    [CommonManager updatePlatformCode:@"XMFDS"];
    
    
    [XMFNetworking POSTWithURLContainParams:URL_comm_country_region_query Params:dic success:^(id  _Nonnull responseObject, XMFResponseObjectModel * _Nonnull responseObjectModel) {
        
         DLog(@"è·åå½å®¶æå°åºä»£ç :%@",responseObject);
        
        if (responseObjectModel.code == XMFNetworkingReturnCodeSuccess) {
            
            NSArray *dataArr = responseObject[@"data"];
            
            [self.areaModelArr removeAllObjects];
            
            for (NSDictionary *dic in dataArr) {
                
                XMFAreaCodeModel *model = [XMFAreaCodeModel yy_modelWithDictionary:dic];
                
                [self.areaModelArr addObject:model];
                
            }
   
            [CommonManager updateAreaModelArr:self.areaModelArr];
            
            
        }else{
            
            
            [self.view makeToastOnCenter:responseObjectModel.message];
            
        }
        
        
        
    } failure:^(NSString * _Nonnull error) {
        
        
        
    }];

    
}



//æ¾ç¤ºGIFå è½½å¨ç»
-(void)showGIFImageView{
    
    
    /*
    [self.view addSubview:self.GIFImageView];
    
    [self.view bringSubviewToFront:self.GIFImageView];
    
    
    [self.GIFImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
//        make.centerX.centerY.mas_equalTo(self.view);
        make.edges.mas_equalTo(self.view);
//        make.width.height.mas_equalTo(100);
        
    }];*/
    
    [self.view addSubview:self.loadingView];
    [self.view bringSubviewToFront:self.loadingView];
    
    /*
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(self.view).offset(150);
        
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        
    }];*/

    
}

//éèå è½½å¨ç»
-(void)hideGIFImageView{
    
//    [self.GIFImageView removeFromSuperview];
    
    [self.loadingView removeFromSuperview];
    
}

#pragma mark - âââââââ æå è½½ ââââââââ
-(NSMutableArray<XMFAreaCodeModel *> *)areaModelArr{
    
    if (_areaModelArr == nil) {
        
        _areaModelArr = [[NSMutableArray alloc] init];
    }
    return _areaModelArr;
    
    
}

//èè±
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [self.view addSubview:_activityIndicator];
        _activityIndicator.frame= CGRectMake((KScreenWidth - 100)/2, (KScreenHeight - 100)/2, 100, 100);
        _activityIndicator.color = [UIColor grayColor];
        _activityIndicator.backgroundColor = [UIColor clearColor];
        _activityIndicator.hidesWhenStopped = YES;
    }
    return _activityIndicator;
}



-(SYGifImageView *)GIFImageView{
    
    if (_GIFImageView == nil) {
        
        //1ãGIFå¨å¾
        NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"icon_loading" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:imageFile];
        
        _GIFImageView = [[SYGifImageView alloc] initWithGIFData:imageData];
        
        
        
    }
    return _GIFImageView;
    
}


-(UIView *)loadingView{
    
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] init];
        
        //1ãGIFå¨å¾
        NSString *imageFile = [[NSBundle mainBundle] pathForResource:@"icon_loading" ofType:@"gif"];
        NSData *imageData = [NSData dataWithContentsOfFile:imageFile];
        
        SYGifImageView *gifView = [[SYGifImageView alloc] initWithGIFData:imageData];
        
    
        _loadingView.frame = self.view.bounds;
        
        _loadingView.backgroundColor = UIColorFromRGBA(0x333333, 0.5);
                
        [_loadingView addSubview:gifView];
       
        [gifView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.centerY.mas_equalTo(_loadingView);
            make.width.height.mas_equalTo(60);
            
        }];
        
        
        
    }
    return _loadingView;
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
