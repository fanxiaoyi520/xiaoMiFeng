//
//  XMFGoodsDetailHeaderView.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/5/8.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMFGoodsDatailModel;

@class XMFGoodsDatailProductListModel;

@class XMFGoodsDetailHeaderView;

@protocol XMFGoodsDetailHeaderViewDelegate<NSObject>

@optional//้ๆฉๅฎ็ฐ็ๆนๆณ

-(void)viewsOnXMFGoodsDetailHeaderViewDidTap:(XMFGoodsDetailHeaderView *)headerView view:(UIView *)view;

-(void)buttonsOnXMFGoodsDetailHeaderViewDidClick:(XMFGoodsDetailHeaderView *)headerView button:(UIButton *)button;

//ๅพ็้ๆฉ
-(void)imageViewOnXMFGoodsDetailHeaderView:(XMFGoodsDetailHeaderView *)headerView didSelectItemAtIndex:(NSInteger)index;


@required//ๅฟ้กปๅฎ็ฐ็ๆนๆณ

@end

@interface XMFGoodsDetailHeaderView : UIView

@property (nonatomic, strong) XMFGoodsDatailModel *detailModel;

@property (nonatomic, weak) id<XMFGoodsDetailHeaderViewDelegate> delegate;

//ๅๅ่งๆ ผ
@property (weak, nonatomic) IBOutlet UILabel *goodsTypeLB;

//็จ่ดน
@property (weak, nonatomic) IBOutlet UILabel *goodsTaxsLB;


//ๅๅไฟกๆฏ
@property (nonatomic, strong) XMFGoodsDatailProductListModel *productListModel;

@end

NS_ASSUME_NONNULL_END
