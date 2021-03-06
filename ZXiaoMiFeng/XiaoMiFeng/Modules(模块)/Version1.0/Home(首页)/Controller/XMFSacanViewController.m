//
//  XMFSacanViewController.m
//  XiaoMiFeng
//
//  Created by πε°θθπ on 2020/4/24.
//  Copyright Β© 2020 πε°θθπ. All rights reserved.
//

#import "XMFSacanViewController.h"
#import "SGQRCode.h"
//#import "XMFGoodsDetailController.h"//εεθ―¦ζ
#import "XMFGoodsDetailViewController.h"//εεθ―¦ζ


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
    
    self.naviTitle = XMFLI(@"ζ«δΈζ«");
    
//    [self addRightItemWithTitle:XMFLI(@"ηΈε") action:@selector(rightBarButtonItenAction)];
    
    
}

- (void)setupQRCodeScan {
    __weak typeof(self) weakSelf = self;

    SGQRCodeObtainConfigure *configure = [SGQRCodeObtainConfigure QRCodeObtainConfigure];
    configure.openLog = YES;
    configure.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.6);
    // θΏιεͺζ―ζδΎδΊε η§δ½δΈΊεθοΌε±οΌ13οΌοΌιδ»δΉη±»εζ·»ε δ»δΉη±»εε³ε―
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    configure.metadataObjectTypes = arr;
    
    [obtain establishQRCodeObtainScanWithController:self configure:configure];
    [obtain startRunningWithBefore:^{
        
        [MBProgressHUD showLoadToView:weakSelf.view title:@"ζ­£ε¨ε θ½½..."];
        
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
                
                //ζ΅θ―η―ε’
                productURLStr = @"http://test72.qtopay.cn";
                
            #elif defined(PRODUCTION)
                
                //ζ­£εΌη―ε’
               productURLStr = @"http://bmall.xmfstore.com";

            #endif
            
            
            
            NSString *goodsId = [weakSelf getParamByName:@"goodsId" URLString:result];
            
            if ([result containsString:productURLStr] && (goodsId.length > 0)) {
                
                [obtain stopRunning];
                
                weakSelf.stop = YES;
                
                [obtain playSoundName:@"SGQRCode.bundle/sound.caf"];
                
                //ζͺεεεID
//                NSString *goodsId = [result substringWithRange:NSMakeRange(result.length - 7, 7)];
                
                
                //ζ«ζη»ζθ·³θ½¬
                XMFGoodsDetailViewController  *VCtrl = [[XMFGoodsDetailViewController alloc]initWithGoodsID:goodsId];

                
                [weakSelf.navigationController pushViewController:VCtrl animated:YES];
                
            }else{
                
                [MBProgressHUD showError:XMFLI(@"δΈε­ε¨θ―₯εε") toView:weakSelf.view];
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
            DLog(@"ζζͺθ―ε«εΊδΊη»΄η ");
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
        // ιζεΊε θ½½ bundle ιι’ηθ΅ζΊδ½Ώη¨ SGQRCode.bundle/QRCodeScanLineGrid
        // ε¨ζεΊε θ½½η΄ζ₯δ½Ώη¨ QRCodeScanLineGrid
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
        _promptLabel.text = @"ε°δΊη»΄η ζΎε₯ζ‘ε, ε³ε―θͺε¨ζ«ζ";
    }
    return _promptLabel;
}




//θ·εH5ηURLιΎζ₯δΈ­ηεζ°
- (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url{
    
    NSError *error;
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)", name];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
     
    // ζ§θ‘εΉιηθΏη¨
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches) {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // εη»2ζε―ΉεΊηδΈ²
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
