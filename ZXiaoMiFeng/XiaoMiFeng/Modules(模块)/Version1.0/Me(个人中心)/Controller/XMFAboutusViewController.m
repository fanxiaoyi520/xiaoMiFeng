//
//  XMFAboutusViewController.m
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/6/4.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import "XMFAboutusViewController.h"

@interface XMFAboutusViewController ()

//็ๆฌๅท
@property (weak, nonatomic) IBOutlet UILabel *versionLB;





@end

@implementation XMFAboutusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.naviTitle = XMFLI(@"ๅณไบๆไปฌ");
    
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    self.versionLB.text = [NSString stringWithFormat:@"ๅฐ่่็ตๅ V%@",oldVersion];
    
}


//ๆๅกๅ่ฎฎใ้็งๅ่ฎฎ
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
//    ๆๅกๅ่ฎฎๅฐๅ: http://test19.qtopay.cn/client#/Serviceagreement
//    ้็งๅ่ฎฎๅฐๅ:http://test19.qtopay.cn/client#/Privacy
    
    NSString *aboutusURLStr;
    
    switch (sender.tag) {
        case 0:{//ๆๅกๅ่ฎฎ
            
            aboutusURLStr = [NSString stringWithFormat:@"%@/client#/Serviceagreement",XMF_BASE_URL];
            
        }
            break;
            
        case 1:{//้็งๅ่ฎฎ
            
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
