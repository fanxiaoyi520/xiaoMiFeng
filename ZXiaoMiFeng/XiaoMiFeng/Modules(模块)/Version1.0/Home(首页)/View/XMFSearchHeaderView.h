//
//  XMFSearchHeaderView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/26.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class XMFSearchHeaderView;

@protocol XMFSearchHeaderViewDelegate <NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

- (void)searchWithStr :(NSString *)text;

-(void)buttonsOnXMFSearchHeaderView:(XMFSearchHeaderView *)headerView button:(UIButton *)button;


@end

@interface XMFSearchHeaderView : UIView

@property(nonatomic,copy)NSString *AJPlaceholder;

@property(nonatomic,strong)UIColor *AJCursorColor;

@property(nonatomic,weak) id<XMFSearchHeaderViewDelegate> XMFSearchHeaderViewDelegate;

/*! ่พๅฅๆก */
@property(nonatomic,strong)UITextField *textField;

//ๆฏๅฆ้่ๅ ไฝlabel
- (void)isHiddenLabel:(UITextField *)textField;


@end

NS_ASSUME_NONNULL_END
