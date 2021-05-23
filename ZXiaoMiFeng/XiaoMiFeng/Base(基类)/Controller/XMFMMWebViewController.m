//
//  XMFMMWebViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFMMWebViewController.h"
#import "MMWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface XMFMMWebViewController ()<MMWebViewDelegate>

@property (nonatomic, strong) MMWebView *mmWebView;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) JSContext *context;


@end

@implementation XMFMMWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KWhiteColor;
    
    // 添加视图
    [self.view addSubview:self.mmWebView];
    
//    self.urlStr = [self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    if (self.urlStr) {
        
        //        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        //        [request setHTTPMethod:@"POST"];
        //        [request setValue:@"http://paytest.1an.com" forHTTPHeaderField: @"Referer"];
        //         [_webView loadRequest:request];
        
        [_mmWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
        
       
        
    }else if (self.htmlString){
        
        self.htmlString = [self htmlEntityDecode:self.htmlString];
        [_mmWebView loadHTMLString:self.htmlString baseURL:nil];
        
    }
    
   
}

-(void)popAction{
    
    //判断是否能返回到H5上级页面
    if (self.mmWebView.canGoBack==YES) {
        //返回上级页面
        [self.mmWebView goBack];
        
    }else{
        //退出控制器
        [super popAction];
    }
    
    
}

#pragma mark - MMWebViewDelegate
// 网页加载进度
- (void)webView:(MMWebView *)webView estimatedProgress:(CGFloat)progress{
    
    DLog(@"%f",progress);
    
}

// 网页标题更新
- (void)webView:(MMWebView *)webView didUpdateTitle:(NSString *)title{
    
    
    
    //判断是否需要显示标题为网页的标题
    if (self.titleStr.length > 0) {
        
        self.naviTitle = self.titleStr;
        
    }else{
        
//        self.noneBackNaviTitle = @"资讯";
        self.naviTitle = webView.title;

        
    }
    
}

// 网页开始加载
- (BOOL)webView:(MMWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(WKNavigationType)navigationType
{
    //DLog(@"shouldStartLoadWithRequest");
    
    //NSString *strRequest = [request.URL.absoluteString stringByRemovingPercentEncoding];
    //DLog(@"当前网址：%@",strRequest);
    
    
    return YES;

}

// 网页开始加载
- (void)webViewDidStartLoad:(MMWebView *)webView
{
    DLog(@"webViewDidStartLoad");
    
}

// 网页完成加载
- (void)webViewDidFinishLoad:(MMWebView *)webView
{
    DLog(@"webViewDidFinishLoad");
   
    /***
     // 获取到点击js按钮的事件
     self.context[@"clickAction0"] = ^(){
     DLog(@"获取到点击js按钮的事件");
     };
     // oc调用js函数 并传参 js无返回值
     NSString *jsAction = @"clickAction1(555)";
     [self.context evaluateScript:jsAction];
     
     // oc调用js函数 并传参 接收js返回值
     NSString *str1 = [webView stringByEvaluatingJavaScriptFromString:@"clickAction2(666);"];
     DLog(@"js函数给我的返回值：%@", str1);
     **/
    

    
}


// 网页加载出错
- (void)webView:(MMWebView *)webView didFailLoadWithError:(NSError *)error{
    
    DLog(@"didFailLoadWithError");
    
    [self.mmWebView ly_showEmptyView];
    
}

//拦截支付链接打开APP
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
//    NSString *urlString = [[navigationAction.request URL] absoluteString];
    
    //DLog(@" === %@", urlString);
    
    /**
     static/payRedirect/index-dev.html
     static/payRedirect/index-produce.html
     */

    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
    }
    
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
}


#pragma mark - ——————— html文件编码————————

//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}

#pragma mark - ——————— 懒加载 ————————
-(MMWebView *)mmWebView{
 
    if (_mmWebView == nil) {
        
        _mmWebView = [[MMWebView alloc] initWithFrame:CGRectMake(0, kTopHeight, KScreenWidth, KScreenHeight - kTopHeight)];
  
        // 代理
        _mmWebView.delegate = self;
        
        // 显示进度条
        _mmWebView.displayProgressBar = YES;
        // 允许侧滑返回
        _mmWebView.allowsBackForwardNavigationGestures = YES;
        
        //初始化一个无数据的emptyView 點擊重試
        LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"pic_nodata"
                                                                 titleStr:@""
                                                                detailStr:@""
                                                              btnTitleStr:@""
                                                            btnClickBlock:^{
                                                                
                                                                
                                                            }];
        
        emptyView.autoShowEmptyView = NO;
        
        _mmWebView.ly_emptyView = emptyView;
    }
    
    return _mmWebView;
    
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
