//
//  XMFSelectAreaCodeView.m
//  thirdLgoin
//
//  Created by 🐝小蜜蜂🐝 on 2020/7/8.
//  Copyright © 2020 小蜜蜂. All rights reserved.
//

#import "XMFSelectAreaCodeView.h"
#import "XMFAreaCodeModel.h"


//在.m文件中添加
@interface  XMFSelectAreaCodeView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UIView *keywordsBgView;


@property (weak, nonatomic) IBOutlet UITextField *keywordTfd;


@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTableViewHeight;

//点击手势
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;


//现有的地区model数组
@property (nonatomic, strong) NSMutableArray<XMFAreaCodeModel *> *nowAreaModelArr;



@end

@implementation XMFSelectAreaCodeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    
    self.myTableView.dataSource = self;
    
    self.myTableView.delegate = self;
    
    self.myTableView.tableFooterView = [[UIView alloc]init];
    
    
    //初始化一个无数据的emptyView 點擊重試
    LYEmptyView *emptyView = [LYEmptyView emptyActionViewWithImageStr:@"icon_common_pic"
                                                             titleStr:@""
                                                            detailStr:XMFLI(@"暂无相关数据")
                                                          btnTitleStr:@""
                                                        btnClickBlock:^{
        
        
    }];
    
    emptyView.autoShowEmptyView = NO;
    
    
    self.myTableView.ly_emptyView = emptyView;
    
    
    self.keywordTfd.delegate = self;
    
    
    self.tapGesture.delegate = self;
    
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [self.keywordsBgView cornerWithRadius:self.keywordsBgView.height/2.0];
    
//    self.myTableViewHeight.constant = KScreenHeight * 0.4;
    
    
}


-(void)setAreaArr:(NSArray<XMFAreaCodeModel *> *)areaArr{
    
    _areaArr = areaArr;
    
    self.nowAreaModelArr = [NSMutableArray arrayWithArray:areaArr];
    
    [self.myTableView ly_startLoading];
    
    [self.myTableView reloadData];
    
    [self.myTableView ly_endLoading];
    
    
    
}


//取消按钮被点击
- (IBAction)cancelBtnDidClick:(UIButton *)sender {
    
    [self hide];
    
}

//点击手势隐藏
- (IBAction)hideSelf:(UITapGestureRecognizer *)sender {
    
    
    //判断点击的点是否在某个区域范围内
    CGPoint tapPoint = [sender locationInView:self];
    
    CGRect bgViewRect = [self convertRect:self.myTableView.bounds fromView:self.myTableView];
    
    if (!CGRectContainsPoint(bgViewRect, tapPoint)) {
        
        [self hide];
        
    }
    
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



//显示在整个界面上
-(void)show{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.frame = [UIScreen mainScreen].bounds;
        [keyWindow addSubview:self];
        
    }];
    
    if (_areaViewStatus) {
        _areaViewStatus(YES);
    }
    
}

//隐藏弹框
-(void)hide{
    
    [UIView animateWithDuration:0.3 animations:^{
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
    
    if (_areaViewStatus) {
        _areaViewStatus(NO);
    }
    
}

#pragma mark - ——————— textField的代理方法 ————————

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    NSLog(@"文本框实时内容%@",text);
    
    //搜索框文本有值和无值的时候
    if (text.length > 0) {
        
        [self.nowAreaModelArr removeAllObjects];
        
        //搜索
        for (XMFAreaCodeModel *areaModel in self.areaArr) {
            
            if ([areaModel.countryName containsString:text] || [areaModel.phoneCode containsString:text]) {
                
                [self.nowAreaModelArr addObject:areaModel];
                
            }
            
            
        }
        
    }else{
        
        self.nowAreaModelArr = [NSMutableArray arrayWithArray:self.areaArr];
        
    }
    
    
    [self.myTableView ly_startLoading];
    
    [self.myTableView reloadData];
    
    [self.myTableView ly_endLoading];
    
    
    return YES;
}

//回车按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    [textField resignFirstResponder];
    
    return YES;
    
}

//clearButtonMode清空代理方法
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    self.nowAreaModelArr = [NSMutableArray arrayWithArray:self.areaArr];
    
    [self.myTableView ly_startLoading];
    
    [self.myTableView reloadData];
    
    [self.myTableView ly_endLoading];
    
    return YES;
}

#pragma mark - ——————— tableview的代理方法和数据源 ————————

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.nowAreaModelArr.count;
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    XMFAreaCodeModel *areaModel = self.nowAreaModelArr[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ +%@",areaModel.countryName,areaModel.phoneCode];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //选中的地区
    if (_selectedAreaBlock) {
        _selectedAreaBlock(self.nowAreaModelArr[indexPath.row]);
        
    }
    
    [self hide];
    
}

@end
