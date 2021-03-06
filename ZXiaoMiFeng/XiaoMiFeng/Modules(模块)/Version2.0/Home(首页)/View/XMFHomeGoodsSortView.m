//
//  XMFHomeGoodsSortView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2020/9/8.
//  Copyright Â© 2020 ðå°èèð. All rights reserved.
//

#import "XMFHomeGoodsSortView.h"
#import "XMFHomeGoodsSortCell.h"


//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFHomeGoodsSortView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>




//ç¹å»æå¿
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;


@property (nonatomic, assign) CGRect sortViewFrame;

/** æ é¢æ°ç» */
@property (nonatomic, strong) NSArray<NSString *> *titlesArr;

/** éä¸­çæ ç­¾å­å¸ */
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


//æ¾ç¤ºå¨æ´ä¸ªçé¢ä¸
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

//éèå¼¹æ¡
-(void)hide{
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0);

    [UIView animateWithDuration:0.5 animations:^{
        
        self.frame = CGRectMake(0,KScreenH, KScreenW, self.sortViewFrame.size.height);
        
    } completion:^(BOOL finished) {
        

    }];
    
    
    
}

//ç¹å»æå¿ç»å®æ¹æ³
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //å¤æ­ç¹å»çç¹æ¯å¦å¨æä¸ªåºåèå´å
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.myTableView.bounds fromView:self.myTableView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
        if (_GoodsSortViewIsShowBlock) {
            
            _GoodsSortViewIsShowBlock(NO);
            
        }
        
    }
    
}




#pragma mark - âââââââ UITableViewçä»£çåæ°æ®æº ââââââââ

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
 //è§£å³æå¿å²çªï¼è¿ä¸ªä»£çæ¹æ³é»è®¤è¿åNOï¼ä¼é»æ­ç»§ç»­åä¸è¯å«æå¿ï¼å¦æè¿åYESåå¯ä»¥ç»§ç»­åä¸ä¼ æ­è¯å«ã
 1ãéµå¾ªUIGestureRecognizerDelegate
 2ãéåç¸åºä»£çæ¹æ³
 3ãæå®æå¿ä»£çè
 4ãå©ç¨ä»£çæ¹æ³
 */
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]){
        
        //å¤æ­å¦æç¹å»çæ¯tableViewçcellï¼å°±ææå¿ç»å³é­äº
        return NO;//å³é­æå¿
    }
    return YES;//å¦åæå¿å­å¨
   
}


#pragma mark - âââââââ æå è½½ ââââââââ


-(NSArray<NSString *> *)titlesArr{
    
    if (_titlesArr == nil) {
        _titlesArr = @[XMFLI(@"ç»¼å"),XMFLI(@"ä»·æ ¼ååº"),XMFLI(@"ä»·æ ¼éåº")];
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
