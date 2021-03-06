//
//  XMFShoppingSplitOrdersView.m
//  XiaoMiFeng
//
//  Created by ðå°èèð on 2021/1/27.
//  Copyright Â© 2021 ðå°èèð. All rights reserved.
//

#import "XMFShoppingSplitOrdersView.h"
#import "XMFShoppingSplitOrdersCell.h"
#import "XMFShoppingSplitOrdersModel.h"



//å¨.mæä»¶ä¸­æ·»å 
@interface  XMFShoppingSplitOrdersView()<UITableViewDelegate,UITableViewDataSource,XMFShoppingSplitOrdersCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewHeight;

/** ç»ç® */
@property (weak, nonatomic) IBOutlet UIButton *calculateBtn;



@end

@implementation XMFShoppingSplitOrdersView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.7);
    
    
    self.myTableView.dataSource = self;
    
    self.myTableView.delegate = self;
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.myTableView.showsVerticalScrollIndicator = YES;
    
    
    [self.myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([XMFShoppingSplitOrdersCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([XMFShoppingSplitOrdersCell class])];
    

    self.calculateBtn.enabled = NO;
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.bgView cornerWithRadius:10.f direction:CornerDirectionTypeTopLeft | UIRectCornerTopRight];
    
}

//æ¾ç¤ºå¨æ´ä¸ªçé¢ä¸
-(void)show{
    
    //å¯ä»¥åºé¨å¼¹åº
    [UIView animateWithDuration:0.3 animations:^{
        
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
           self.frame = [UIScreen mainScreen].bounds;
           [keyWindow addSubview:self];
        
        
        self.bgView.centerY = self.bgView.centerY - CGRectGetHeight(self.bgView.frame);

        
    } completion:^(BOOL finished) {
        
       
        
    }];
    
}

//éèå¼¹æ¡
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.centerY = self.bgView.centerY+CGRectGetHeight(self.bgView.frame);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}



//éèå¼¹æ¡
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    //å¤æ­ç¹å»çç¹æ¯å¦å¨æä¸ªåºåèå´å
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.bgView.bounds fromView:self.bgView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
 
    
}


//é¡µé¢ä¸çæé®è¢«ç¹å»
- (IBAction)buttonsOnViewDidClick:(UIButton *)sender {
    
    
    switch (sender.tag) {
        case 0:{//åæ¶
            
            [self hide];
            
        }
            break;
        case 1:{//ç»ç®
            
            [self hide];
            
            if ([self.delegate respondsToSelector:@selector(buttonsOnXMFShoppingSplitOrdersViewDidClick:button:)]) {
                
                [self.delegate buttonsOnXMFShoppingSplitOrdersViewDidClick:self button:sender];
            }
            
        }
            break;
            
        default:
            break;
    }
    
    
}


-(void)setDataSourceArr:(NSArray<XMFShoppingSplitOrdersModel *> *)dataSourceArr{
    
    _dataSourceArr = dataSourceArr;
    
    
    NSInteger cellCount = dataSourceArr.count > 3 ? 3 : dataSourceArr.count;
    
    self.myTableViewHeight.constant = 152 * cellCount;
    
    [self.myTableView reloadData];
    
    
}



#pragma mark - âââââââ tableViewçä»£çæ¹æ³åæ°æ®æº ââââââââ

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        
    return self.dataSourceArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    XMFShoppingSplitOrdersCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XMFShoppingSplitOrdersCell class])];
        

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.delegate = self;
    
    [self setModelOfCell:cell atIndexPath:indexPath];
    
    
    return cell;
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
      
    /*
    kWeakSelf(self)
    
    return [self.myTableView fd_heightForCellWithIdentifier:NSStringFromClass([XMFPurchaseTipsCell class]) configuration:^(XMFPurchaseTipsCell *cell) {
        
        [weakself setModelOfCell:cell atIndexPath:indexPath];
        
    }];*/
    
    return 152;
    
}

-(void)setModelOfCell:(XMFShoppingSplitOrdersCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    
    cell.splitOrdersModel = self.dataSourceArr[indexPath.row];
    
    
}


#pragma mark - âââââââ XMFShoppingSplitOrdersCellçä»£çæ¹æ³ ââââââââ

-(void)buttonsOnXMFShoppingSplitOrdersCellDidClick:(XMFShoppingSplitOrdersCell *)cell button:(UIButton *)button{
    
    //éä¸­çåªç»åå
    NSIndexPath *selectedIndexPath = [self.myTableView indexPathForCell:cell];
    
    self.selectedIndexPathRow = selectedIndexPath.row;
    
    
    self.calculateBtn.enabled = YES;
    
    
    if (button!= self.selectedBtn) {
        
        self.selectedBtn.selected = NO;
        button.selected = YES;
        
        self.selectedBtn = button;
        
    }else{
        
        self.selectedBtn.selected = YES;
    }
    
}


@end
