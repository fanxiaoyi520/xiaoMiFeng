//
//  XMFGuidePageView.h
//  XiaoMiFeng
//
//  Created by đĺ°ččđ on 2020/9/1.
//  Copyright ÂŠ 2020 đĺ°ččđ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XMFGuidePageView : UIView

//čŞĺŽäšĺ č˝˝ćšćł
+(instancetype)xibLoadViewWithFrame:(CGRect)frame;

/** ĺŻĺ¨ĺžçéžćĽ */
@property (nonatomic, copy) NSString *URLStr;

@end

NS_ASSUME_NONNULL_END
