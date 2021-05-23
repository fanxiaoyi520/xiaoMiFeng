//
//  ZFAppUpdateModel.h
//  XzfPos
//
//  Created by wd on 2017/10/20.
//  Copyright © 2017年 ideasforHK. All rights reserved.
//

#import <UIKit/UIKit.h>

//更新方式
typedef enum : NSUInteger {
    UpdateAuto,//自动
    UpdateManual,//手动
   
} UpdateType;

@interface ZFAppUpdateManager : NSObject

+ (ZFAppUpdateManager *)sharedManager;


/**
 APP更新检查
 */
- (void)checkAppUpdate:(UpdateType)type;


/** 是否需要升级 */
@property(nonatomic, assign) BOOL isUpdate;


@end
