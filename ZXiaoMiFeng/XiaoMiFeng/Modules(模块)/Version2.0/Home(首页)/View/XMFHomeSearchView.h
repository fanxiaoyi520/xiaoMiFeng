//
//  XMFHomeSearchView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/8/13.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeSearchView;

@protocol XMFHomeSearchViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomeHeaderViewDidClick:(XMFHomeSearchView *)searchView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeSearchView : UIView

@property (nonatomic, weak) id<XMFHomeSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
