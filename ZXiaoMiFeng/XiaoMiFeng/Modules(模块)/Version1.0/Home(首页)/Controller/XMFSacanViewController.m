//
//  XMFSacanViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/24.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFSacanViewController.h"
#import "SGQRCode.h"
//#import "XMFGoodsDetailController.h"//商品详情
#import "XMFGoodsDetailViewController.h"//商品详情


@interface XMFSacanViewController (){
    SGQRCodeObtain *obtain;
}
@property (nonatomic, strong) SGQRCodeScanView *scanView;
@property (nonatomic, strong) UILabel *promptLabel;

@property (nonatomic, assign) BOOL stop;

@end

@implementation XMFSacanViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_stop) {
        [obtain startRunningWithBefore:nil completion:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanView removeTimer];
}

- (void)dealloc {
    DLog(@"XMFSacanViewController - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    obtain = [SGQRCodeObtain QRCodeObtain];
    
    [self setupQRCodeScan];
    [self setupUI];
    [self.view addSubview:self.scanView];
    [self.view addSubview:self.promptLabel];
}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"扫一扫");
    
//    [self addRightItemWithTitle:XMFLI(@"相册") action:@selector(rightBarButtonItenAction)];
    
    
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;

    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.openLog = YES;
    configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    // 这里只是提供了几种作为参考（共：13）；需什么类型添加什么类型即可
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    configure.metadataObjectTypes = arr;
    
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain startRunningWithBefore:^{
        
        [MBProgressHUD showLoadToView:weakSelf.view title:@"正在加载..."];
        
    } completion:^{
       
        [MBProgressHUD hideHUDForView:weakSelf.view];
    }];
    [obtain setBlockWithQRCodeObtainScanResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result) {
   
            
            /*
            NSString *productURLStr = [NSString stringWithFormat:@"%@/client#/product/",XMF_BASE_URL];
            
            NSString *productURLStr2 = [NSString stringWithFormat:@"%@/client/#/product/",XMF_BASE_URL];
            
            productURLStr = @"http://test72.qtopay.cn";

            productURLStr2 = @"https://bemall.xmfstore.com";
            */
            
             NSString *productURLStr;
                
            #if defined(LOCAL_TEST)
                
                //测试环境
                productURLStr = @"http://test72.qtopay.cn";
                
            #elif defined(PRODUCTION)
                
                //正式环境
               productURLStr = @"http://bmall.xmfstore.com";

            #endif
            
            
            
            NSString *goodsId = [weakSelf getParamByName:@"goodsId" URLString:result];
            
            if ([result containsString:productURLStr] && (goodsId.length > 0)) {
                
                [obtain stopRunning];
                
                weakSelf.stop = YES;
                
                [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
                
                //截取商品ID
//                NSString *goodsId = [result substringWithRange:NSMakeRange(result.length - 7, 7)];
                
                
                //扫描结果跳转
                XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:goodsId];

                
                [weakSelf.navigationController pushViewController:VCtrl animated:YES];
                
            }else{
                
                [MBProgressHUD showError:XMFLI(@"不存在该商品") toView:weakSelf.view];
            }

            
        }
    }];
}



- (void)rightBarButtonItenAction {
    __weak typeof(self) weakSelf = self;

    [obtain establishAuthorizationQRCodeObtainAlbumWithController:nil];
    if (obtain.isPHAuthorization == YES) {
        [self.scanView removeTimer];
    }
    [obtain setBlockWithQRCodeObtainAlbumDidCancelImagePickerController:^(SGQRCodeObtain *obtain) {
        [weakSelf.view addSubview:weakSelf.scanView];
    }];
    [obtain setBlockWithQRCodeObtainAlbumResult:^(SGQRCodeObtain *obtain, NSString *result) {
        if (result == nil) {
            DLog(@"暂未识别出二维码");
        } else {
            if ([result hasPrefix:@"http"]) {
                
                /*
                ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
                jumpVC.jump_URL = result;
                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
                 */
                
            } else {
                
                /*
                ScanSuccessJumpVC *jumpVC = [[ScanSuccessJumpVC alloc] init];
                jumpVC.comeFromVC = ScanSuccessJumpComeFromWB;
                jumpVC.jump_bar_code = result;
                [weakSelf.navigationController pushViewController:jumpVC animated:YES];
                 */
            }
        }
    }];
}

- (SGQRCodeScanView *)scanView {
    if (!_scanView) {
        _scanView = [[SGQRCodeScanView alloc] initWithFrame:CGRectMake(0, kTopHeight, self.view.frame.size.width, self.view.frame.size.height - kTopHeight)];
        // 静态库加载 bundle 里面的资源使用 SGQRCode.bundle/QRCodeScanLineGrid
        // 动态库加载直接使用 QRCodeScanLineGrid
        _scanView.scanImageName = @"SGQRCode.bundle/QRCodeScanLineGrid";
        _scanView.scanAnimationStyle = ScanAnimationStyleGrid;
        _scanView.cornerLocation = CornerLoactionOutside;
        _scanView.cornerColor = [UIColor orangeColor];
    }
    return _scanView;
}
- (void)removeScanningView {
    [self.scanView removeTimer];
    [self.scanView removeFromSuperview];
    self.scanView = nil;
}

- (UILabel *)promptLabel {
    if (!_promptLabel) {
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        CGFloat promptLabelX = 0;
        CGFloat promptLabelY = 0.83 * self.view.frame.size.height;
        CGFloat promptLabelW = self.view.frame.size.width;
        CGFloat promptLabelH = 25;
        _promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptLabelW, promptLabelH);
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.font = [UIFont boldSystemFontOfSize:13.0];
        _promptLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        _promptLabel.text = @"将二维码放入框内, 即可自动扫描";
    }
    return _promptLabel;
}




//获取H5的URL链接中的参数
- (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
     
    // 执行匹配的过程
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"";
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
