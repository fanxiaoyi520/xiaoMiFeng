//
//  ZFAppUpdateModel.m
//  XzfPos
//
//  Created by wd on 2017/10/20.
//  Copyright © 2017年 ideasforHK. All rights reserved.
//

#import "ZFAppUpdateManager.h"
#import "ZFAppUpdateView.h"//版本更新提示框
#import "ZFAppTipsView.h"//提示框


@interface ZFAppUpdateManager ()

@property (nonatomic, strong) NSDictionary *appUpdateInfo;//APP更新信息

@property (nonatomic, strong) ZFAppUpdateView *updateView;

@property (nonatomic, strong) ZFAppTipsView *tipsView;//提示框

@end

static ZFAppUpdateManager *instance = nil;

@implementation ZFAppUpdateManager
+ (ZFAppUpdateManager *)sharedManager {
    return [[ZFAppUpdateManager alloc] init];
}

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
            
             [[NSNotificationCenter defaultCenter] addObserver:instance selector:@selector(resignActive) name:UIApplicationWillResignActiveNotification object:nil];
        }
    });
    return instance;
}

-(id)copyWithZone:(NSZone *)zone
{
    return instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return instance;
}

#pragma mark - APP更新检查
- (void)checkAppUpdate:(UpdateType)type {
//    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
//    NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    // platform=0/1（0=安卓；1=苹果）
    // category=0/1（0=本地；1=市场）
    
    NSDictionary *dic = @{
        
        @"platform":@"1",
        @"category":@"1"
        
    };
    
    [[XMFUserHttpHelper sharedManager] XMFUserSendPOSTRequestMethod:URL_upgrade parameters:dic success:^(id  _Nonnull responseObject, NSURLSessionDataTask * _Nonnull operation, XMFResponseModel * _Nonnull responseObjectModel) {
        
        DLog(@"版本更新：%@",[responseObject description]);
        
        if (responseObjectModel.code == XMFHttpReturnCodeSuccess) {
            
            self.appUpdateInfo = [NSDictionary dictionaryWithDictionary:responseObjectModel.data];
            
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            NSString *oldVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            NSString *newVersion = [self.appUpdateInfo notNullObjectForKey:@"lastVersion"];
            
            //去除版本号里的.
            oldVersion = [oldVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            newVersion = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            //如果新版本号大，则需要升级
            BOOL needUpdate = NO;
            
            if ([newVersion integerValue] > [oldVersion integerValue]) {
                
                needUpdate = YES;
                
            }
            
            
            self.isUpdate = needUpdate;
            
            [self forceUpVersion:type];
            
            
            
        }else{
            
            [MBProgressHUD showError:responseObjectModel.message toView:kAppWindow];
        }
        
        
    } failure:^(NSError * _Nonnull error, NSURLSessionDataTask * _Nullable operation) {
        
    }];
    
   
}


- (void)forceUpVersion:(UpdateType)type{
    if (_isUpdate) { //有新版本，需要更新
        BOOL isForce = [[_appUpdateInfo notNullObjectForKey:@"forceUpdate"] boolValue];
        //版本号
        NSString *versionStr = [NSString stringWithFormat:@"已有最新版本%@可更新",[_appUpdateInfo notNullObjectForKey:@"lastVersion"]];
        self.updateView.versionLB.text = versionStr;
        //更新说明
        NSString *notesStr = [_appUpdateInfo notNullObjectForKey:@"updateContent"];
        notesStr = [notesStr stringByReplacingOccurrencesOfString:@"|" withString:@"\n\n"];
        self.updateView.notesLB.text = notesStr;
        
        //去更新
        @weakify(self)
        //itms-apps://itunes.apple.com/cn/app/id1516567999?mt=8
        self.updateView.updateBtnBlock = ^(UIButton * _Nonnull button) {
            NSURL *url = [NSURL URLWithString:[weak_self.appUpdateInfo notNullObjectForKey:@"appUrl"]];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        };
        
        //取消
        self.updateView.cancelBtnBlock = ^(UIButton * _Nonnull button) {
            
             [[NSNotificationCenter defaultCenter] removeObserver:instance];
        };
        
        
        if (isForce) {//强制更新就不展示取消按钮
            self.updateView.cancelBtnWidth.constant = 0;
        }
        [self.updateView show];

    } else {
        
        [[NSNotificationCenter defaultCenter] removeObserver:instance];
        
        if (type == UpdateManual) {
            
            self.tipsView.tipsLB.text = XMFLI(@"当前已是最新版本");
            
             [self.tipsView show];
        }
        
    }
}

#pragma mark - 流氓式
- (void)resignActive {
//    [[ZFAppUpdateManager sharedManager] forceUpVersion];
}

#pragma mark - ——————— 懒加载 ————————
-(ZFAppUpdateView *)updateView{
    
    if (_updateView == nil) {
        _updateView = [[[NSBundle mainBundle] loadNibNamed:@"ZFAppUpdateView" owner:nil options:nil] firstObject];
        _updateView.frame = [UIScreen mainScreen].bounds;
    }
    return _updateView;
    
}

-(ZFAppTipsView *)tipsView{
    
    if (_tipsView == nil) {
        _tipsView = [[[NSBundle mainBundle] loadNibNamed:@"ZFAppTipsView" owner:nil options:nil] firstObject];
        _tipsView.frame = [UIScreen mainScreen].bounds;
    }
    return _tipsView;
    
}

@end
