//
//  XMFHomeGoodsSortView.m
//  XiaoMiFeng
//
//  Created by 🐝小蜜蜂🐝 on 2020/9/8.
//  Copyright © 2020 🐝小蜜蜂🐝. All rights reserved.
//

#import "XMFHomeGoodsSortView.h"
#import "XMFHomeGoodsSortCell.h"


//在.m文件中添加
@interface  XMFHomeGoodsSortView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>




//点击手势
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;


@property (nonatomic, assign) CGRect sortViewFrame;

/** 标题数组 */
@property (nonatomic, strong) NSArray<NSString *> *titlesArr;

/** 选中的标签字典 */
@property (nonatomic, strong) NSMutableDictionary *selectedTagMutDic;


@end

@implementation XMFHomeGoodsSortView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tapGesture.delegate = self;

    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
}


//显示在整个界面上
-(void)showWithFrame:(CGRect)frame{
    
    self.sortViewFrame = frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        [keyWindow addSubview:self];
        
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
            
        }];
        
    }];
    
    
//    if (_GoodsSortViewIsShowBlock) {
//
//        _GoodsSortViewIsShowBlock(YES);
//
//    }
    
}

//隐藏弹框
-(void)hide{
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0);

    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(0,KScreenH, KScreenW, self.sortViewFrame.size.height);
        
    } completion:^(BOOL finished) {
        

    }];
    
    
    
}

//点击手势绑定方法
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.myTableView.bounds fromView:self.myTableView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
        if (_GoodsSortViewIsShowBlock) {
            
            _GoodsSortViewIsShowBlock(NO);
            
        }
        
    }
    
}




#pragma mark - ——————— UITableView的代理和数据源 ————————

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titlesArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    XMFHomeGoodsSortCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([XMFHomeGoodsSortCell class]) owner:nil options:nil] firstObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    cell.titleLB.text = self.titlesArr[indexPath.row];
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 40;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.selectedTagMutDic setValue:@(indexPath.row + 1) forKey:@"orderType"];
    
    NSString *selectedTitleStr = self.titlesArr[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(cellOnXMFHomeGoodsSortViewDidSelected:selectedDic:seletedTitle:)]) {
        
        [self.delegate cellOnXMFHomeGoodsSortViewDidSelected:self selectedDic:self.selectedTagMutDic seletedTitle:selectedTitleStr];
    }
    
    [self hide];
    
}

#pragma mark - UIGestureRecognizerDelegate
/*
 //解决手势冲突，这个代理方法默认返回NO，会阻断继续向下识别手势，如果返回YES则可以继续向下传播识别。
 1、遵循UIGestureRecognizerDelegate
 2、重写相应代理方法
 3、指定手势代理者
 4、利用代理方法
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        
        //判断如果点击的是tableView的cell，就把手势给关闭了
        return NO;//关闭手势
    }
    return YES;//否则手势存在
   
}


#pragma mark - ——————— 懒加载 ————————


-(NSArray<NSString *> *)titlesArr{
    
    if (_titlesArr == nil) {
        _titlesArr = @[XMFLI(@"综合"),XMFLI(@"价格升序"),XMFLI(@"价格降序")];
    }
    return _titlesArr;
    
    
}

-(NSMutableDictionary *)selectedTagMutDic{
    
    if (_selectedTagMutDic == nil) {
        _selectedTagMutDic = [[NSMutableDictionary alloc] init];
    }
    return _selectedTagMutDic;
    
}


@end
