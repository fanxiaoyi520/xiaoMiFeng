//
//  XMFAboutusController.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/19.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFAboutusController.h"

@interface XMFAboutusController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;

//็ๆฌ
@property (weak, nonatomic) IBOutlet UILabel *versionLB;


@property (weak, nonatomic) IBOutlet UILabel *versionStatusLB;



@end

@implementation XMFAboutusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];

}

-(void)setupUI{
    
    self.naviTitle = XMFLI(@"ๅณไบๆไปฌ");
    
    self.topSpace.constant = kNavBarHeight;
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versionLB.text = [NSString stringWithFormat:@"V %@",oldVersion];
    
    //ๆฃๆฅๆฐ็
    [self checkAppUpdate];
    
}


//้กต้ขไธ็ๆ้ฎ่ขซ็นๅป
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    //    ๆๅกๅ่ฎฎๅฐๅ: http://test19.qtopay.cn/client#/Serviceagreement
    //    ้็งๅ่ฎฎๅฐๅ:http://test19.qtopay.cn/client#/Privacy
        
    switch (sender.tag) {
        case 0:{//ๆๅกๅ่ฎฎ
            
            
            NSString *aboutusURLStr = @"http://bmall.xmfstore.com/h5/pages/my/Serviceagreement?type=0";
            
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = aboutusURLStr;
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
        }
            break;
            
        case 1:{//้็งๅ่ฎฎ
            
        
            NSString *aboutusURLStr = @"http://bmall.xmfstore.com/h5/pages/my/Privacy?type=0";
            
            XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
            
            VCtrl.urlStr = aboutusURLStr;
            
            
            [self.navigationController pushViewController:VCtrl animated:YES];
            
        }
            break;
            
        case 2:{//็ๆฌๆดๆฐ
            
            
            [[ZFAppUpdateManager sharedManager] checkAppUpdate:UpdateManual];
            
        
            
        }
            break;
            
        default:
            break;
    }
    
    
}



#pragma mark - โโโโโโโ ็ฝ็ป่ฏทๆฑ โโโโโโโโ
// APPๆดๆฐๆฃๆฅ
- (void)checkAppUpdate{
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
//    NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // platform=0/1๏ผ0=ๅฎๅ๏ผ1=่นๆ๏ผ
    // category=0/1๏ผ0=ๆฌๅฐ๏ผ1=ๅธๅบ๏ผ
    
    NSDictionary *dic = @{
        
        @"platform":@"1",
        @"category":@"1"
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_upgrade parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"็ๆฌๆดๆฐ๏ผ%@",[responseObject description]);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            NSDictionary *appUpdateInfo = [NSDictionary dictionaryWithDictionary:responseObjectModel.data];
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSString *newVersion = [appUpdateInfo notNullObjectForKey:@"lastVersion"];
            
            //ๅป้ค็ๆฌๅท้็.
            oldVersion = [oldVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            newVersion = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            //ๅฆๆๆฐ็ๆฌๅทๅคง๏ผๅ้่ฆๅ็บง
            BOOL needUpdate = NO;
            
            if ([newVersion integerValue] > [oldVersion integerValue]) {
                
                needUpdate = YES;
                
            }
            
            if (needUpdate) {
                
                 self.versionStatusLB.text = XMFLI(@"ๆๆฐ็ๆฌๅฏๆดๆฐ");
                
            }else{
                
                self.versionStatusLB.text = XMFLI(@"ๅทฒๆฏๆๆฐ็ๆฌ");
            }
            
  
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:kAppWindow];
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
