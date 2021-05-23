//
//  XMFMMWebViewController.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/5/2.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XMFMMWebViewController : XMFBaseViewController

@property (nonatomic, copy) NSString *urlStr;//URL

@property (nonatomic, copy) NSString *htmlString;//识别HTML标签语言

/** 标题 */
@property (nonatomic, copy) NSString *titleStr;


@end

NS_ASSUME_NONNULL_END
