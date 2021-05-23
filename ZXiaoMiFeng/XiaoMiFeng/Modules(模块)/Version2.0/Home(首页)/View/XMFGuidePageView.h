//
//  XMFGuidePageView.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/1.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGuidePageView : UIView

//自定义加载方法
+(instancetype)xibLoadViewWithFrame:(CGRect)frame;

/** 启动图的链接 */
@property (nonatomic, copy) NSString *URLStr;

@end

NS_ASSUME_NONNULL_END
