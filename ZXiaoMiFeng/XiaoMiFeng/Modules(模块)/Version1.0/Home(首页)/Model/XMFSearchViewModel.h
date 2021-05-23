//
//  XMFSearchViewModel.h
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/4/26.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^searchBlock)(BOOL isSuccess,NSArray *array);

@interface XMFSearchViewModel : NSObject


/*! 关键词搜索 */
//- (void)netWorkForsearch:(NSString *)str searchBlock:(searchBlock)searchBlock;




/*! 保存历史搜索 */
- (void)saveHistory :(NSString *)text;
/*! 读取历史搜索 */
- (NSArray *)readHistory;
/*! 删除历史搜索 */
- (void)deleteHistory:(NSString *)text;
/*! 历史搜索显示的行数 */
- (NSInteger)rowForCollection :(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
