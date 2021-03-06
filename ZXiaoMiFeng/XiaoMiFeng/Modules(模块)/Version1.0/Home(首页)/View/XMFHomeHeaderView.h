//
//  XMFHomeHeaderView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/16.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFHomeHeaderView;

@protocol XMFHomeHeaderViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFHomeHeaderViewDidClick:(XMFHomeHeaderView *)headerView button:(UIButton *)button;


@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFHomeHeaderView : UIView

@property (nonatomic, weak) id<XMFHomeHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
