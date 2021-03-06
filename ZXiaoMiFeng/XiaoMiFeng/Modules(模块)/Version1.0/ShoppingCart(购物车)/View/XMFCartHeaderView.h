//
//  XMFCartHeaderView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/21.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFCartHeaderView;

@class XMFShopCartMiddleModel;

@protocol XMFCartHeaderViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFCartHeaderViewDidClick:(XMFCartHeaderView *)headerView button:(UIButton *)button section:(NSInteger)section;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end


@interface XMFCartHeaderView : UIView


/** ่ฎฐๅฝ็ปๆฐ */
@property (nonatomic,assign)NSInteger  section;

@property (nonatomic, weak) id<XMFCartHeaderViewDelegate> delegate;

@property (nonatomic, strong) XMFShopCartMiddleModel *middleModel;

@end

NS_ASSUME_NONNULL_END
