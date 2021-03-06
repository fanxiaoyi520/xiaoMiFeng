//
//  XMFSearchViewModel.h
//  XiaoMiFeng
//
//  Created by ๐ๅฐ่่๐ on 2020/4/26.
//  Copyright ยฉ 2020 ๐ๅฐ่่๐. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^searchBlock)(BOOL isSuccess,NSArray *array);

@interface XMFSearchViewModel : NSObject


/*! ๅณ้ฎ่ฏๆ็ดข */
//- (void)netWorkForsearch:(NSString *)str searchBlock:(searchBlock)searchBlock;




/*! ไฟๅญๅๅฒๆ็ดข */
- (void)saveHistory :(NSString *)text;
/*! ่ฏปๅๅๅฒๆ็ดข */
- (NSArray *)readHistory;
/*! ๅ ้คๅๅฒๆ็ดข */
- (void)deleteHistory:(NSString *)text;
/*! ๅๅฒๆ็ดขๆพ็คบ็่กๆฐ */
- (NSInteger)rowForCollection :(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
