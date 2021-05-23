//
//  XMFAboutusViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/6/4.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFAboutusViewController.h"

@interface XMFAboutusViewController ()

//版本号
@property (weak, nonatomic) IBOutlet UILabel *versionLB;





@end

@implementation XMFAboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.naviTitle = XMFLI(@"关于我们");
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versionLB.text = [NSString stringWithFormat:@"小蜜蜂电商 V%@",oldVersion];
    
}


//服务协议、隐私协议
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
//    服务协议地址: http://test19.qtopay.cn/client#/Serviceagreement
//    隐私协议地址:http://test19.qtopay.cn/client#/Privacy
    
    NSString *aboutusURLStr;
    
    switch (sender.tag) {
        case 0:{//服务协议
            
            aboutusURLStr = [NSString stringWithFormat:@"%@/client#/Serviceagreement",XMF_BASE_URL];
            
        }
            break;
            
        case 1:{//隐私协议
            
            aboutusURLStr = [NSString stringWithFormat:@"%@/client#/Privacy",XMF_BASE_URL];
        }
            break;
        default:
            break;
    }
    

    
    XMFMMWebViewController  *VCtrl = [[XMFMMWebViewController alloc]init];
    
    VCtrl.urlStr = aboutusURLStr;
    
    
    [self.navigationController pushViewController:VCtrl animated:YES];
               
        
    
    
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
