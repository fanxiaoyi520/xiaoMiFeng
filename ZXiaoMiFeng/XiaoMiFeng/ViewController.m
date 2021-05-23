//
//  ViewController.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLConnectionDelegate,NSURLSessionTaskDelegate>

@property (nonatomic ,strong)NSURLConnection *connection;

@property (nonatomic ,strong)NSURLSession *session;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *httpsURL = [NSURL URLWithString:@"https://www.google.com"];
    self.connection = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:httpsURL] delegate:self];
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    //获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;
    OSStatus status = SecTrustEvaluate(trust, &result);
    
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    
}
@end
