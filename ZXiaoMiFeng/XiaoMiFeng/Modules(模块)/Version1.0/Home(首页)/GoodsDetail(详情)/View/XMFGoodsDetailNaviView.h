//
//  XMFGoodsDetailNaviView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/11.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDetailNaviView;

@protocol XMFGoodsDetailNaviViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)buttonsOnXMFGoodsDetailNaviViewDidClick:(XMFGoodsDetailNaviView *)naviView button:(UIButton *)button;

@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFGoodsDetailNaviView : UIView

@property (nonatomic, weak) id<XMFGoodsDetailNaviViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
