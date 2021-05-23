
//
//  ZDPayPopView.m
//  ReadingEarn
//
//  Created by FANS on 2020/4/15.
//  Copyright © 2020 FANS. All rights reserved.
//

#import "ZDPayPopView.h"
#import "ZDPayFuncTool.h"
#import "ZDPay_OrderSurePayListRespModel.h"
#define kPC_INFO_SHOWTEXT @"showText"
#define kPC_INFO_UPSTRING @"uploadString"

CGFloat getHeightForLableString(NSString *value,CGRect frame,UIFont * font)
{
    UILabel * lable=[[UILabel alloc]initWithFrame:frame];
    lable.text= value;
    lable.numberOfLines =  0;
    lable.font = font;
    return  [lable sizeThatFits:CGSizeMake(frame.size.width, MAXFLOAT)].height;
}

@interface ZDPayPopView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZDPickerViewDelegate>

@property (nonatomic ,assign)ZDPayPopViewEnum type;
@property (nonatomic ,copy)NSString *data;
@property (nonatomic ,strong)NSDictionary *model;
@property (nonatomic ,strong)ZDPay_OrderSurePayListRespModel *pay_OrderSurePayListRespModel;
@property (nonatomic ,strong)NSString *boxInputViewstr;
@property (nonatomic ,strong)UIButton *certainButton;
@property (nonatomic ,strong)NSArray *gratypeArray;
@property (nonatomic ,copy)NSString *gratype_idStr;
@property (nonatomic ,assign)NSInteger btnTag;

@property (nonatomic ,strong)UITableView *popTableView;
@property (nonatomic ,strong)NSMutableArray *dataList;
@property (nonatomic ,strong)NSMutableArray *dataPointList;
@property (nonatomic ,strong)NSIndexPath *oldIndexPath;
@property (nonatomic ,strong)UITableViewCell *oldCell;
@property (nonatomic ,strong)ZDPickerView *myPickerView;
@property (nonatomic ,strong)ZDPickerView *myYearPickerView;
@property (nonatomic ,strong)NSArray *pickerArray;
@property (nonatomic ,copy)NSString *bankCardNumStr;
@property (nonatomic ,strong)UITextField *contentTextField;
@property (nonatomic ,strong)ZDPayPopViewModel *infoModel;
@property (nonatomic ,strong)NSMutableDictionary *mutableDic;
@property (nonatomic ,assign)NSInteger tips_type;
@end
@implementation ZDPayPopView

#pragma mark - private
- (instancetype)initWithFrame:(CGRect)frame withType:(ZDPayPopViewEnum)type
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        [self initialize];
        [self keyBoardAutoSize];
    }
    return self;
}

- (void)initialize {
    if (self.type != AddCreditCard) {
        self.tips_type = 0;
        self.myWindow = [UIApplication sharedApplication].keyWindow;
        self.coverView = [UIView new];
        [self.myWindow addSubview:self.coverView];
        self.coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
        [self.coverView addGestureRecognizer:tap];
    }
    
    if (self.type == SetPaymentPassword) {
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.coverView.alpha = 0.5;

        [self re_loadSetPaymentPasswordUI];
    } else if (self.type == DocumentType) {
        self.coverView.backgroundColor = [UIColor clearColor];

        [self re_loadDocumentTypeUI];
    } else if (self.type == CellPhoneAreaCode) {
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.coverView.alpha = 0.5;

        [self re_loadCellPhoneAreaCodeUI];
    } else if (self.type == SelectPayMethod) {
        self.coverView.backgroundColor = COLORWITHHEXSTRING(@"#000000", .5);
        
        [self re_loadSelectPayMethodUI];
    } else if (self.type == CreditCardInputdemonstration) {
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.coverView.alpha = 0.5;
        [self re_loadCreditCardInputdemonstrationUI];
    } else if (self.type == Reminder) {
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.coverView.alpha = 0.5;
        [self re_loadReminderUI];
    } else if (self.type == AddCreditCard) {
        self.mutableDic = [NSMutableDictionary dictionary];
        ZDPayRootViewController*vc = (ZDPayRootViewController *)[ZDPayFuncTool getCurrentVC];
        self.coverView = [UIView new];
        [vc.view addSubview:self.coverView];
        self.coverView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.coverView.alpha = 0.5;
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
        [self.coverView addGestureRecognizer:tap1];
        self.tips_type = 1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        [self re_loadAddCreditCardUI];
    }
}

- (void)re_loadAddCreditCardUI {
    
    [_mutableDic setValue:@"" forKey:@"zd_lastname"];
    [_mutableDic setValue:@"" forKey:@"name"];
    [_mutableDic setValue:@"" forKey:@"cardNumber"];
    [_mutableDic setValue:@"" forKey:@"month"];
    [_mutableDic setValue:@"" forKey:@"year"];
    [_mutableDic setValue:@"" forKey:@"CVC"];
    
    UILabel *headerLab = [UILabel new];
    [self addSubview:headerLab];
    headerLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17];
    headerLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    headerLab.tag = 10;
    headerLab.textAlignment = NSTextAlignmentCenter;
    
    NSArray *titleArray = @[[[ZDPayInternationalizationModel sharedSingleten] getModelData].Enter_credit_card_information,[[ZDPayInternationalizationModel sharedSingleten] getModelData].EXPIRATION_DATA_1,[[ZDPayInternationalizationModel sharedSingleten] getModelData].valid_period];
    NSArray *placeholderArray = @[[[ZDPayInternationalizationModel sharedSingleten] getModelData].Please_fill_in_the_name,[[ZDPayInternationalizationModel sharedSingleten] getModelData].Please_fill_out_the_last_name,[[ZDPayInternationalizationModel sharedSingleten] getModelData].credit_card_number];
    NSArray *validityPlaceholderArray = @[[[ZDPayInternationalizationModel sharedSingleten] getModelData].month,[[ZDPayInternationalizationModel sharedSingleten] getModelData].year,@"CVC"];

    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *leftLab = [UILabel new];
        [self addSubview:leftLab];
        leftLab.tag = 20+idx;
        leftLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:16];
        leftLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
        
        UITextField *textField = [[UITextField alloc] init];
        [self addSubview:textField];
        textField.tag = 30+idx;
        textField.placeholder = placeholderArray[idx];
        [textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#DCDCDC", 1);
        [self addSubview:lineView];
        lineView.tag = 40+idx;
        if (idx == 2) {
            textField.delegate = self;
            self.contentTextField = textField;
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.clearsOnBeginEditing = NO;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }
        
        UITextField *validityTextField = [[UITextField alloc] init];
        [self addSubview:validityTextField];
        validityTextField.tag = 50+idx;
        validityTextField.placeholder = validityPlaceholderArray[idx];
        validityTextField.borderStyle = UITextBorderStyleLine;
        validityTextField.layer.borderColor = COLORWITHHEXSTRING(@"#DCDCDC", 1).CGColor;
        validityTextField.layer.borderWidth = 1.0f;
        validityTextField.layer.cornerRadius = 4;
        validityTextField.layer.masksToBounds = YES;
        validityTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        validityTextField.leftViewMode = UITextFieldViewModeAlways;
        validityTextField.delegate = self;
        if (idx == 2) [validityTextField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
        
        UIButton *selBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (idx < 2)[validityTextField addSubview:selBtn];
        [selBtn setImage:[UIImage imageNamed:@"icon_pay_lower"] forState:UIControlStateNormal];
        selBtn.tag = 80+idx;

        UIButton *selBtn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
        if (idx < 2)[self addSubview:selBtn_1];
        selBtn_1.tag = 90+idx;
        [selBtn_1 addTarget:self action:@selector(selBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }];

    UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:tipBtn];
    [tipBtn addTarget:self action:@selector(tipBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    tipBtn.tag = 60;
    [tipBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", 1) forState:UIControlStateNormal];
    tipBtn.titleLabel.font = ZD_Fout_Regular(14);
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnAction_info:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.tag = 70;
    [sureBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = ZD_Fout_Regular(18);
    sureBtn.layer.cornerRadius = 22;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.backgroundColor = COLORWITHHEXSTRING(@"#ADADAD", 1);
    sureBtn.userInteractionEnabled = NO;
    
    _myPickerView = [[ZDPickerView alloc] init];
    _myPickerView.delegate = self;
    _myPickerView.tag = 100;
    self.myWindow = [UIApplication sharedApplication].keyWindow;
    [self.myWindow addSubview:_myPickerView];
    
    _myYearPickerView = [[ZDPickerView alloc] init];
    _myYearPickerView.delegate = self;
    _myYearPickerView.tag = 101;
    [self.myWindow addSubview:_myYearPickerView];
    
    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton addTarget:self action:@selector(scanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    scanButton.tag = 110;
    UIImage *background = REImageName(@"icon_scancard");
    UIImage *backgroundOn = REImageName(@"icon_scancard");
    [scanButton setImage:background forState:UIControlStateNormal];
    [scanButton setImage:backgroundOn forState:UIControlStateHighlighted];
    [self addSubview:scanButton];
}

- (NSArray *)getDataArray:(NSArray *)dataArray {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in dataArray) {
        [tempArray addObject:dic[kPC_INFO_SHOWTEXT]];
    }
    return tempArray;
}

- (void)re_loadReminderUI {
    UILabel *tipLab = [UILabel new];
    [self addSubview:tipLab];
    tipLab.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:17];
    tipLab.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1/1.0];
    tipLab.tag = 10;
    tipLab.textAlignment = NSTextAlignmentCenter;
    
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
    lineView.tag = 20;
    
    UILabel *contentLab = [UILabel new];
    [self addSubview:contentLab];
    contentLab.font = ZD_Fout_Regular(17);
    contentLab.textColor = [UIColor colorWithRed:87/255.0 green:86/255.0 blue:86/255.0 alpha:1/1.0];
    contentLab.tag = 30;
    contentLab.numberOfLines = 0;

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sureBtn];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1);
    [sureBtn setTitleColor:COLORWITHHEXSTRING(@"#FFFFFF", 1) forState:UIControlStateNormal];
    sureBtn.layer.cornerRadius = 4;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.tag = 40;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:cancelBtn];
    cancelBtn.backgroundColor = [UIColor clearColor];
    [cancelBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:COLORWITHHEXSTRING(@"#333333", 1) forState:UIControlStateNormal];
    cancelBtn.layer.borderColor = COLORWITHHEXSTRING(@"#333333", 1).CGColor;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 4.0f;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.tag = 50;
}

- (void)re_loadCreditCardInputdemonstrationUI {
    UIImageView *backImage = [UIImageView new];
    [self addSubview:backImage];
    backImage.tag = 10;
    backImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeThePopupView)];
    tap.delegate = self;
    [backImage addGestureRecognizer:tap];
    
    UILabel *tishiLabel = [UILabel new];
    tishiLabel.tag = 20;
    [self addSubview:tishiLabel];
    tishiLabel.textAlignment = NSTextAlignmentLeft;
    tishiLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    tishiLabel.numberOfLines = 0;
    tishiLabel.preferredMaxLayoutWidth = ScreenWidth;
    tishiLabel.font = ZD_Fout_Medium(15);
    tishiLabel.textColor = COLORWITHHEXSTRING(@"#666666", 1.0);
}

- (void)re_loadSelectPayMethodUI {
    [self popTableView];
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)dataPointList {
    if (!_dataPointList) {
        _dataPointList = [NSMutableArray array];
    }
    return _dataPointList;
}

- (UITableView *)popTableView {
    if (!_popTableView) {
        _popTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self addSubview:_popTableView];
        _popTableView.delegate = self;
        _popTableView.dataSource = self;
        _popTableView.bounces = NO;
        _popTableView.showsVerticalScrollIndicator = NO;
        _popTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _popTableView.showsHorizontalScrollIndicator = YES;
        _popTableView.backgroundColor = [UIColor whiteColor];
    }
    return _popTableView;
}

- (void)re_loadCellPhoneAreaCodeUI {
    [self popTableView];
}

- (void)re_loadDocumentTypeUI {
    UIView *bgView = [UIView new];
    [self addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        btn.tag = 10+i;
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [btn setTitleColor:COLORWITHHEXSTRING(@"#333333", 1.0) forState:UIControlStateNormal];
        btn.titleLabel.font = ZD_Fout_Regular(16);
        [btn addTarget:self action:@selector(documentTypeAction:) forControlEvents:UIControlEventTouchUpInside];
       
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        lineView.tag = 100 + i;
        [self addSubview:lineView];
        
    }
}

- (void)re_loadSetPaymentPasswordUI {
    //1.
    UILabel *titleLabel = [UILabel new];
    titleLabel.tag = 10;
    titleLabel.textColor = COLORWITHHEXSTRING(@"#666666;", 1.0);
    [self addSubview:titleLabel];
    
    //2.
    UILabel *moneyNumberLab = [UILabel new];
    moneyNumberLab.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    moneyNumberLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:moneyNumberLab];
    moneyNumberLab.tag = 20;
    
    //线条
    UIView *lineView = [UIView new];
    [self addSubview:lineView];
    lineView.tag = 60;
    lineView.backgroundColor = COLORWITHHEXSTRING(@"#DDDDDD", 1.0);
    
    //支付银行
    UIImageView *bankImageView = [UIImageView new];
    [self addSubview:bankImageView];
    bankImageView.tag = 70;
    
    UILabel *bankLabel = [UILabel new];
    [self addSubview:bankLabel];
    bankLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
    bankLabel.textAlignment = NSTextAlignmentLeft;
    bankLabel.tag = 80;

    //4.
    UIButton *forgetPassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.certainButton = forgetPassBtn;
    forgetPassBtn.titleLabel.font = ZD_Fout_Regular(14);
    forgetPassBtn.tag = 40;
    forgetPassBtn.layer.cornerRadius = 17.5;
    [forgetPassBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].FORGOT_PASSWORD forState:UIControlStateNormal];
    [forgetPassBtn addTarget:self action:@selector(forgetPassBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPassBtn setTitleColor:COLORWITHHEXSTRING(@"#FFB300", 1.0) forState:UIControlStateNormal];
    [self addSubview:forgetPassBtn];
    
    //3.
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.tag = 50;
    [closeButton addTarget:self action:@selector(closeThePopupView) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:REImageName(@"icon_close") forState:UIControlStateNormal];
    [self addSubview:closeButton];
}

- (void)layoutAndLoadDataCreditCardInputdemonstration:(NSString *)imageStr labStr:(NSString *)labStr {
    UIImageView *backImage = [self viewWithTag:10];
    backImage.frame = CGRectMake(0, 0, self.width, self.height);
    backImage.image = [UIImage imageNamed:imageStr];
    
    UILabel *tishiLabel = [self viewWithTag:20];
    tishiLabel.text = labStr;
    CGSize maximumLabelSize = CGSizeMake(self.width-40, 9999);
    CGSize expectSize = [tishiLabel sizeThatFits:maximumLabelSize];
    if (expectSize.width<self.width-40) {
        expectSize.width = self.width - 40;
    }
    
    if (self.tips_type == 1) {
        tishiLabel.frame = CGRectMake(20, (self.height-expectSize.height-20.5), expectSize.width, expectSize.height);
        [ZDPayFuncTool LabelAttributedString:tishiLabel FontNumber:ZD_Fout_Medium(13) AndRange:NSMakeRange(15, 6) AndColor:COLORWITHHEXSTRING(@"#FFB300", 1.0)];
    } else {
        
        tishiLabel.frame = CGRectMake(20, (self.height-(expectSize.height+45) * (self.height/175)), expectSize.width, expectSize.height);
    }
}

- (void)layoutAndLoadDataPaymentPassword {
    //1.
    CGRect titleRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSWORD withFont:ZD_Fout_Regular(16)];
    UILabel *titleLabel = [self viewWithTag:10];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *titleLabelstring = [[NSMutableAttributedString alloc] initWithString:[[ZDPayInternationalizationModel sharedSingleten] getModelData].PASSWORD attributes:@{NSFontAttributeName: ZD_Fout_Regular(16), NSForegroundColorAttributeName: COLORWITHHEXSTRING(@"#666666", 1.0)}];
    titleLabel.attributedText = titleLabelstring;
    titleLabel.frame = CGRectMake((self.width-titleRect.size.width)/2, 24, titleRect.size.width, 25);
    
    //2.
    UILabel *moneyNumberLab = [self viewWithTag:20];
    NSString *amountMoneyStr = [ZDPayFuncTool formatToTwoDecimal:[[ZDPay_OrderSureModel sharedSingleten] getModelData].txnAmt];
    moneyNumberLab.frame = CGRectMake(0, titleLabel.bottom+20, self.width, 24);
    
    moneyNumberLab.text = [NSString stringWithFormat:@"%@ %@",[[ZDPay_OrderSureModel sharedSingleten] getModelData].txnCurr,amountMoneyStr];
    [ZDPayFuncTool LabelAttributedString:moneyNumberLab FontNumber:ZD_Fout_Medium(30) AndRange:NSMakeRange(4, amountMoneyStr.length-2) AndColor:nil];
    NSLog(@"%@",[[ZDPay_OrderSureModel sharedSingleten] getModelData].txnCurr);
    //线条
    UIView *lineview = [self viewWithTag:60];
    lineview.frame = CGRectMake(0, 121, self.width, .5);
    
    //支付银行
    UIImageView *banImageview = [self viewWithTag:70];
    banImageview.frame = CGRectMake(21, lineview.bottom + 23, 17, 17);
    
    
    UILabel *bankLabel = [self viewWithTag:80];
    bankLabel.frame = CGRectMake(banImageview.right + 10, lineview.bottom + 24, self.width-58, 16);
    
    if (![self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@""]) {
        if (self.pay_OrderSurePayListRespModel.imgUrl) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.pay_OrderSurePayListRespModel.imgUrl]];
                UIImage *image = [[UIImage alloc]initWithData:data];
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        banImageview.image = image;
                    });
                }
            });
        } else {
            banImageview.image = DEFAULT_IMAGE;
        }
        
        bankLabel.text = self.pay_OrderSurePayListRespModel.name;
    } else {
        if (self.pay_OrderSurePayListRespModel.cardBgImage) {
            banImageview.image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.pay_OrderSurePayListRespModel.cardMsg]]];
        } else {
            banImageview.image = DEFAULT_IMAGE;
        }
        bankLabel.text = self.pay_OrderSurePayListRespModel.bankName;
    }

    CGFloat spacing = (self.width-42-44*6)/6;
    NNValidationCodeView *view = [[NNValidationCodeView alloc] initWithFrame:CGRectMake(21, lineview.bottom + 64, self.width-42, 44) andLabelCount:6 andLabelDistance:spacing];
    [self addSubview:view];
    @WeakObj(self)
    view.codeBlock = ^(NSString *codeString) {
        @StrongObj(self)
        BOOL isFinished = NO;
        if (codeString.length == 6) {
            isFinished = YES;
            self.boxInputViewstr = codeString;
            if (self.setPaymentPassword) {
                self.setPaymentPassword(codeString, isFinished);
            }
        }
    };

    //4.
    UIButton *certainButton = [self viewWithTag:40];
    CGRect forgetPassBtnRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].FORGOT_PASSWORD withFont:ZD_Fout_Regular(14)];
    certainButton.frame = CGRectMake(self.width-19-forgetPassBtnRect.size.width, lineview.bottom + 128, forgetPassBtnRect.size.width, 14);
    
    //5.
    UIButton *closeButton = [self viewWithTag:50];
    closeButton.frame = CGRectMake(self.width - 30, 10, 20, 20);
}

- (void)layoutAndLoadDataDocumentType:(NSArray *)array myCell:(UITableViewCell *)myCell {
    
    for (int i=0; i<array.count; i++) {
        UIButton *btn = (UIButton *)[self viewWithTag:10+i];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0+i*(self.height/5), self.width, myCell.size.height);
        UIView *lineView = [self viewWithTag:100+i];
        lineView.frame = CGRectMake(10, i*(.5+(self.height/5-.5)), self.width-10, .5);
    }
}

- (void)layoutAndLoadDataCellPhoneAreaCode {
    self.popTableView.frame = CGRectMake(0, 0, self.width, self.height);
    [ZDPayFuncTool setupRoundedCornersWithView:self.popTableView cutCorners:UIRectCornerTopLeft | UIRectCornerTopRight borderColor:nil cutCornerRadii:CGSizeMake(10, 10) borderWidth:0 viewColor:nil];
}

- (void)layoutAndLoadDataSelectPayMethod {
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(self.width-20-20, 20, 20, 20);
    
    self.popTableView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)layoutAndLoadDataReminder {
    
    UILabel *tipsLab = [self viewWithTag:10];
    tipsLab.text = [[ZDPay_OrderSureModel sharedSingleten] getModelData].title;
    tipsLab.frame = CGRectMake(0, 20, self.width, 17);
    
    UIView *lineView = [self viewWithTag:20];
    lineView.frame = CGRectMake(0, tipsLab.bottom+9, self.width, 2);
    
    UILabel *contentLab = [self viewWithTag:30];
    CGRect contentRect = [[[ZDPay_OrderSureModel sharedSingleten] getModelData].massage boundingRectWithSize:CGSizeMake(self.width-40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:ZD_Fout_Regular(17)} context:nil];
    CGFloat contentHeight = contentRect.size.height;
    contentLab.frame = CGRectMake(20, lineView.bottom+9, self.width-40, contentHeight);
    contentLab.text = [[ZDPay_OrderSureModel sharedSingleten] getModelData].massage;
    
    UIButton *sureBtn = [self viewWithTag:40];
    sureBtn.frame = CGRectMake(30, contentLab.bottom+20, (self.width-30-30-20)/2, 40);
    [sureBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].confirm forState:UIControlStateNormal];
    
    UIButton *cancelBtn = [self viewWithTag:50];
    cancelBtn.frame = CGRectMake(sureBtn.right+20, contentLab.bottom+20, (self.width-30-30-20)/2, 40);
    [cancelBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].cancel forState:UIControlStateNormal];

    CGFloat selfHeight = 57+contentHeight+20+40+29;
    self.frame = CGRectMake(37, (ScreenHeight - selfHeight)/2, ScreenWidth-37*2, selfHeight);
}

- (void)layoutAndLoadDataAddCreditCard {
    
    UILabel *headerLab = [self viewWithTag:10];
    headerLab.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].Add_a_credit_card;
    headerLab.frame = CGRectMake(0, 20, ScreenWidth, 17);
    
    NSArray *titleArray = @[[[ZDPayInternationalizationModel sharedSingleten] getModelData].Enter_credit_card_information,[[ZDPayInternationalizationModel sharedSingleten] getModelData].EXPIRATION_DATA_1,[[ZDPayInternationalizationModel sharedSingleten] getModelData].valid_period];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *leftLab = [self viewWithTag:20+idx];
        leftLab.text = titleArray[idx];
        leftLab.frame = CGRectMake(20, headerLab.bottom+20+idx*(22+120), ScreenWidth-40, 22);
        if (idx == 2) leftLab.frame = CGRectMake(20, headerLab.bottom+20+idx*(22+120), ScreenWidth-40, 22);
        
        UITextField *textField = [self viewWithTag:30+idx];
        if (idx == 0) textField.frame = CGRectMake(20, headerLab.bottom+62-14, 100, 44);
        if (idx == 1) textField.frame = CGRectMake(150, headerLab.bottom+62-14, ScreenWidth-150-20, 44);
        if (idx == 2) textField.frame = CGRectMake(20, headerLab.bottom+111-14, ScreenWidth-40-80, 44);
        
        UIView *lineView = [self viewWithTag:40+idx];
        if (idx == 0) lineView.frame = CGRectMake(20, headerLab.bottom+92, 100, 1);
        if (idx == 1) lineView.frame = CGRectMake(150, headerLab.bottom+92, ScreenWidth-150-20, 1);
        if (idx == 2) lineView.frame = CGRectMake(20, headerLab.bottom+141, ScreenWidth-40, 1);
        
        UITextField *validityTextField = [self viewWithTag:50+idx];
        if (idx == 0) validityTextField.frame = CGRectMake(20, headerLab.bottom+198, 140, 30);
        if (idx == 1) validityTextField.frame = CGRectMake(181, headerLab.bottom+198, 140, 30);
        if (idx == 2) validityTextField.frame = CGRectMake(20, headerLab.bottom+246, 140, 30);
        
        UIButton *selBtn = [self viewWithTag:80+idx];
        selBtn.frame = CGRectMake(validityTextField.width-20, 10, 10, 10);
        
        UIButton *selBtn_1 = [self viewWithTag:90+idx];
        selBtn_1.frame = validityTextField.frame;
    }];
    
    UIButton *tipBtn = [self viewWithTag:60];
    CGRect tipBtnRect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[NSString stringWithFormat:@"%@?",[[ZDPayInternationalizationModel sharedSingleten] getModelData].what_s_this] withFont:ZD_Fout_Regular(14)];
    tipBtn.frame = CGRectMake(ScreenWidth-tipBtnRect.size.width-14, headerLab.bottom+308, tipBtnRect.size.width, 16);
    [tipBtn setTitle:[NSString stringWithFormat:@"%@?",[[ZDPayInternationalizationModel sharedSingleten] getModelData].what_s_this] forState:UIControlStateNormal];
    
    UIButton *sureBtn = [self viewWithTag:70];
    sureBtn.frame = CGRectMake(28, self.height-44-40, ScreenWidth-56, 44);
    [sureBtn setTitle:[[ZDPayInternationalizationModel sharedSingleten] getModelData].Confirm_to_add forState:UIControlStateNormal];
    
    UIButton *scanButton = [self viewWithTag:110];
    scanButton.frame = CGRectMake(ScreenWidth-15-44, headerLab.bottom+92+(48-44)/2, 44, 44);
}

#pragma mark - actions
- (void)sureBtnAction_info:(UIButton *)sender {
    NSLog(@"%@",_infoModel);
    [self closeThePopupView];
    NSDictionary *dic = [ZDPayFuncTool dicFromObject:_infoModel];
    if (self.addCreditCard) {
        self.addCreditCard(sender,dic);
    }
}

- (void)textFieldAction:(UITextField *)textField {

    switch (textField.tag) {
        case 30:
            [_mutableDic setValue:textField.text forKey:@"zd_lastname"];
            _infoModel = [ZDPayPopViewModel mj_objectWithKeyValues:_mutableDic];
            break;
        case 31:
            [_mutableDic setValue:textField.text forKey:@"name"];
            _infoModel = [ZDPayPopViewModel mj_objectWithKeyValues:_mutableDic];
            break;
        case 52:
            [_mutableDic setValue:textField.text forKey:@"CVC"];
            _infoModel = [ZDPayPopViewModel mj_objectWithKeyValues:_mutableDic];
            break;
    }
    if (![_infoModel.CVC isEqualToString:@""] && ![_infoModel.name isEqualToString:@""] && ![_infoModel.zd_lastname isEqualToString:@""] && ![_infoModel.month isEqualToString:@""] && ![_infoModel.year isEqualToString:@""] && ![_infoModel.cardNumber isEqualToString:@""]) {
        UIButton *sureBtn = [self viewWithTag:70];
        sureBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1);
        sureBtn.userInteractionEnabled = YES;
    } else {
        UIButton *sureBtn = [self viewWithTag:70];
        sureBtn.backgroundColor = COLORWITHHEXSTRING(@"#ADADAD", 1);
        sureBtn.userInteractionEnabled = NO;
    }
}

- (void)scanButtonAction:(UIButton *)sender {
    [self endEditing:YES];
    @WeakObj(self)
    UITextField *textField = [self viewWithTag:32];
    JYBDBankCardVC *vc = [[JYBDBankCardVC alloc]init];
    vc.finish = ^(JYBDBankCardInfo *info, UIImage *image) {
        @StrongObj(self)
        textField.text = info.bankNumber;
        self.bankCardNumStr = textField.text;
    };
    [[ZDPayFuncTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}

- (void)tipBtnAction:(UIButton *)sender {
    NSArray *array = @[@"icon_yinhangkayangshi",[[ZDPayInternationalizationModel sharedSingleten] getModelData].The_back_of_the_card_is_valid_such_as_08_08];
    ZDPayPopView *popView = [ZDPayPopView readingEarnPopupViewWithType:CreditCardInputdemonstration];
    [popView showPopupMakeViewWithData:array];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self endEditing:YES];
}

- (void)closeBtnAction:(UIButton *)sender {
    [self closeThePopupView];
}

- (void)forgetPassBtnAction:(UIButton *)sender {
    if (self.forgetPassword) {
        self.forgetPassword();
    }
}

- (void)documentTypeAction:(UIButton *)sender {
    if (self.documentType) {
        self.documentType(sender);
    }
}

- (void)sureBtnAction:(UIButton *)sender {
    if (self.reminder) {
        self.reminder(sender);
    }
}

- (void)selBtnAction:(UIButton *)sender {
    [self endEditing:YES];
    if (sender.tag == 90) {
        _myPickerView.title = [[ZDPayInternationalizationModel sharedSingleten] getModelData].month;
        _myPickerView.dataArray = [ZDPayFuncTool pickerArray:0];
        [_myPickerView show];
    } else {
        _myYearPickerView.title = [[ZDPayInternationalizationModel sharedSingleten] getModelData].year;
        _myYearPickerView.dataArray = [ZDPayFuncTool pickerArray:1];
        [_myYearPickerView show];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.contentTextField) {
        // 4位分隔银行卡卡号
        NSString *text = [textField text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }

        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        if ([newString stringByReplacingOccurrencesOfString:@" " withString:@""].length >= 17) {
            return NO;
        }
        [textField setText:newString];
        self.bankCardNumStr = [NSString stringWithFormat:@"%@",textField.text];
        [_mutableDic setValue:textField.text forKey:@"cardNumber"];
        _infoModel = [ZDPayPopViewModel mj_objectWithKeyValues:_mutableDic];
        if (![_infoModel.CVC isEqualToString:@""] && ![_infoModel.name isEqualToString:@""] && ![_infoModel.zd_lastname isEqualToString:@""] && ![_infoModel.month isEqualToString:@""] && ![_infoModel.year isEqualToString:@""] && ![_infoModel.cardNumber isEqualToString:@""]) {
            UIButton *sureBtn = [self viewWithTag:70];
            sureBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1);
            sureBtn.userInteractionEnabled = YES;
        } else {
            UIButton *sureBtn = [self viewWithTag:70];
            sureBtn.backgroundColor = COLORWITHHEXSTRING(@"#ADADAD", 1);
            sureBtn.userInteractionEnabled = NO;
        }
        return NO;
    }
    return YES;
}

#pragma mark --- ZFPickerViewDelegate
- (void)selectZFPickerViewTag:(NSInteger)tag index:(NSInteger)index {
    UITextField *textField1 = [self viewWithTag:50];
    UITextField *textField2 = [self viewWithTag:51];
    switch (tag) {
        case 100:
            textField1.text = [ZDPayFuncTool pickerArray:0][index];
            [_mutableDic setValue:textField1.text forKey:@"month"];
            _infoModel = [ZDPayPopViewModel mj_objectWithKeyValues:_mutableDic];
            break;
        case 101:
            textField2.text = [ZDPayFuncTool pickerArray:1][index];
            [_mutableDic setValue:textField1.text forKey:@"year"];
            _infoModel = [ZDPayPopViewModel mj_objectWithKeyValues:_mutableDic];
            break;
    }
    if (![_infoModel.CVC isEqualToString:@""] && ![_infoModel.name isEqualToString:@""] && ![_infoModel.zd_lastname isEqualToString:@""] && ![_infoModel.month isEqualToString:@""] && ![_infoModel.year isEqualToString:@""] && ![_infoModel.cardNumber isEqualToString:@""]) {
        UIButton *sureBtn = [self viewWithTag:70];
        sureBtn.backgroundColor = COLORWITHHEXSTRING(@"#333333", 1);
        sureBtn.userInteractionEnabled = YES;
    } else {
        UIButton *sureBtn = [self viewWithTag:70];
        sureBtn.backgroundColor = COLORWITHHEXSTRING(@"#ADADAD", 1);
        sureBtn.userInteractionEnabled = NO;
    }
}

#pragma mark delegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.type == SelectPayMethod) {
        if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
            if (self.dataList.count > 5) {
                return self.dataList.count;
            } else {
                if (self.dataPointList.count < 5) {
                     return self.dataList.count;
                }
                
                if (self.dataPointList.count >= 5){
                    return self.dataList.count+1;
                }
            }
        } else {
            if (self.dataList.count > 5) {
                return self.dataList.count+1;
            } else {
                if (self.dataPointList.count < 5) {
                     return self.dataList.count+1;
                }
                
                if (self.dataPointList.count >= 5){
                    return self.dataList.count+2;
                }
            }
        }
    }
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SelectPayMethod) {
        static NSString *cellid = @"cellids";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundView = nil;
            cell.backgroundColor = [UIColor clearColor];
            
            UIView *lineView = [UIView new];
            lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
            [cell.contentView addSubview:lineView];
            lineView.tag = 200;

            UIImageView *selImageView = [UIImageView new];
            selImageView.tag = 300;
            //[cell.contentView addSubview:selImageView];
        }

        UIView *lineView  = [cell.contentView viewWithTag:200];
        lineView.frame = CGRectMake(17, 60.5, self.width-17, .5);

        if (![self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
            if (indexPath.row>=0 && indexPath.row< self.dataList.count){
                ZDPay_OrderSurePayListRespModel *model = self.dataList[indexPath.row];

                UIImage *image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.cardMsg]]];
                UIImage *newImage = [ZDPayFuncTool scaleToSize:image size:CGSizeMake(16, 16)];
                cell.imageView.image = newImage;

                cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.bankName,model.cardNum];
                cell.textLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
                cell.textLabel.font = [UIFont systemFontOfSize:16];

                UIImageView *selImageView = [cell.contentView viewWithTag:300];
                selImageView.frame = CGRectMake(self.width-20-17, 20, 17, 17);
                if ([self.pay_OrderSurePayListRespModel.cardNum isEqualToString:model.cardNum]) {
                    selImageView.image = [UIImage imageNamed:@"btn_choose"];
                    self.oldCell = cell;
                    self.oldIndexPath = indexPath;
                } else {
                    selImageView.image = [UIImage imageNamed:@"btn_unch"];
                }
            }

            if (indexPath.row == self.dataList.count){

                UIImage *image = [UIImage imageNamed:@"icon_card_add"];
                UIImage *newImage = [ZDPayFuncTool scaleToSize:image size:CGSizeMake(19, 16)];
                cell.imageView.image = newImage;

                cell.textLabel.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].ADD_BANK_CARD;
                cell.textLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
                cell.textLabel.font = [UIFont systemFontOfSize:16];


                UIImageView *selImageView = [cell.contentView viewWithTag:300];
                selImageView.image = [UIImage imageNamed:@"icon_add"];
                selImageView.frame = CGRectMake(self.width-20-17, 20, 17, 17);
            }


            if (self.dataList.count <= 5 && self.dataPointList.count > 5) {
                if (indexPath.row == self.dataList.count+1) {
                    UIImage *image = [UIImage imageNamed:@""];
                    UIImage *newImage = [ZDPayFuncTool scaleToSize:image size:CGSizeMake(19, 16)];
                    cell.imageView.image = newImage;

                    NSString *AND_MORE_BANK_CARD = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].AND_MORE_BANK_CARD];
                    cell.textLabel.text = AND_MORE_BANK_CARD;
                    cell.textLabel.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                }
            }
        } else {
            if (indexPath.row>=0 && indexPath.row< self.dataList.count){
                ZDPay_OrderSurePayListRespModel *model = self.dataList[indexPath.row];

                UIImage *image = [UIImage imageWithData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.cardMsg]]];
                UIImage *newImage = [ZDPayFuncTool scaleToSize:image size:CGSizeMake(16, 16)];
                cell.imageView.image = newImage;

                cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)",model.bankName,model.cardNum];
                cell.textLabel.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
                cell.textLabel.font = [UIFont systemFontOfSize:16];

                UIImageView *selImageView = [cell.contentView viewWithTag:300];
                selImageView.frame = CGRectMake(self.width-20-17, 20, 17, 17);
                if ([self.pay_OrderSurePayListRespModel.cardNum isEqualToString:model.cardNum]) {
                    selImageView.image = [UIImage imageNamed:@"btn_choose"];
                    self.oldCell = cell;
                    self.oldIndexPath = indexPath;
                } else {
                    selImageView.image = [UIImage imageNamed:@"btn_unch"];
                }
            }

            if (self.dataList.count <= 5 && self.dataPointList.count > 5) {
                if (indexPath.row == self.dataList.count) {
                    UIImage *image = [UIImage imageNamed:@""];
                    UIImage *newImage = [ZDPayFuncTool scaleToSize:image size:CGSizeMake(19, 16)];
                    cell.imageView.image = newImage;

                    NSString *AND_MORE_BANK_CARD = [NSString stringWithFormat:@"%@ >",[[ZDPayInternationalizationModel sharedSingleten] getModelData].AND_MORE_BANK_CARD];
                    cell.textLabel.text = AND_MORE_BANK_CARD;
                    cell.textLabel.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
                    cell.textLabel.font = [UIFont systemFontOfSize:14];
                }
            }
        }

        return cell;
    } else {
        static NSString *cellid = @"cellid";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            UIView *lineView = [UIView new];
            lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
            [cell.contentView addSubview:lineView];
            lineView.tag = 200;
        }
        
        UIView *lineView  = [cell.contentView viewWithTag:200];
        lineView.frame = CGRectMake(0, 49.5, self.width, .5);
        cell.textLabel.textColor = COLORWITHHEXSTRING(@"#999999", 1.0);
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataList[indexPath.row]];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == SelectPayMethod) {
        return 61;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    if (self.type == SelectPayMethod) {
        view.backgroundColor = [UIColor whiteColor];
        
        CGRect rect = [ZDPayFuncTool getStringWidthAndHeightWithStr:[[ZDPayInternationalizationModel sharedSingleten] getModelData].SELECTE_PAYMENT_METHOD withFont:[UIFont boldSystemFontOfSize:16]];
        UILabel *label = [UILabel new];
        label.frame = CGRectMake((self.width-rect.size.width)/2, 17.5, rect.size.width, 16);
        label.textColor = COLORWITHHEXSTRING(@"#333333", 1.0);
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:16];
        label.text = [[ZDPayInternationalizationModel sharedSingleten] getModelData].SELECTE_PAYMENT_METHOD;
        [view addSubview:label];
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = COLORWITHHEXSTRING(@"#E9EBEE", 1.0);
        [view addSubview:lineView];
        lineView.frame = CGRectMake(0, 50.5, self.width, .5);
        return view;
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.type == SelectPayMethod) {
        return 51;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.type == SelectPayMethod) {
        if (![self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
            if (indexPath.row >=0 && indexPath.row < self.dataList.count) {
                [self closeThePopupView];
                //获取上一个cell，改变选择支付方式图标
                if (self.oldIndexPath) {
                    self.oldCell = [tableView cellForRowAtIndexPath:self.oldIndexPath];
                    UIImageView *selImageView = [self.oldCell.contentView viewWithTag:300];
                    selImageView.image = [UIImage imageNamed:@"btn_unch"];
                }

                UIImageView *selImageView = [cell.contentView viewWithTag:300];
                selImageView.image = [UIImage imageNamed:@"btn_choose"];
                self.oldIndexPath = indexPath;
                
                ZDPay_OrderSurePayListRespModel *model = self.dataList[indexPath.row];
                self.selectPayMethod(tableView, indexPath, model);
            }
            
            if (indexPath.row == self.dataList.count) {
                [self closeThePopupView];
                self.selectPayMethod(tableView, indexPath, @"addBankCard");
            }
            
            if (self.dataList.count <= 5 && self.dataPointList.count > 5) {
                if (indexPath.row == self.dataList.count + 1) {
                    [self.dataList removeAllObjects];
                    [self.dataList addObjectsFromArray:self.dataPointList];
                    [self.popTableView reloadData];
                }
            }
        } else {
            if (indexPath.row >=0 && indexPath.row < self.dataList.count) {
                [self closeThePopupView];
                //获取上一个cell，改变选择支付方式图标
                if (self.oldIndexPath) {
                    self.oldCell = [tableView cellForRowAtIndexPath:self.oldIndexPath];
                    UIImageView *selImageView = [self.oldCell.contentView viewWithTag:300];
                    selImageView.image = [UIImage imageNamed:@"btn_unch"];
                }

                UIImageView *selImageView = [cell.contentView viewWithTag:300];
                selImageView.image = [UIImage imageNamed:@"btn_choose"];
                self.oldIndexPath = indexPath;
                
                ZDPay_OrderSurePayListRespModel *model = self.dataList[indexPath.row];
                self.selectPayMethod(tableView, indexPath, model);
            }
            
            if (self.dataList.count <= 5 && self.dataPointList.count > 5) {
                if (indexPath.row == self.dataList.count) {
                    [self.dataList removeAllObjects];
                    [self.dataList addObjectsFromArray:self.dataPointList];
                    [self.popTableView reloadData];
                }
            }
        }
    } else {
        self.cellPhoneAreaCode(tableView, indexPath, cell.textLabel.text);
    }
}

#pragma mark 1.左滑删除
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"    " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        // 点击删除按钮需要执行的方法
        if (indexPath.row <= [self.dataList count]) {
            if (self.slideLeftToDelete) {
                self.slideLeftToDelete(self.dataList[indexPath.row]);
            }
            [self.dataList removeAllObjects];
            [self.dataPointList removeObjectAtIndex:indexPath.row];
            NSArray *dataList = self.dataPointList;
            if (dataList.count > 5) {
                [dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx < 5) {
                        [self.dataList addObject:obj];
                    }
                }];
            } else {
                [self.dataList addObjectsFromArray:dataList];
            }
            if (self.dataPointList.count > 5) {
                if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
                    self.frame = CGRectMake(30, (ScreenHeight - (162+61*5))/2, ScreenWidth-60, 162+61*4);
                } else {
                    self.frame = CGRectMake(30, (ScreenHeight - (162+61*5))/2, ScreenWidth-60, 162+61*5);
                }
            } else {
                if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
                    self.frame = CGRectMake(30, (ScreenHeight - (162+61*self.dataList.count))/2, ScreenWidth-60, 112+61*(self.dataList.count-1));
                } else {
                 self.frame = CGRectMake(30, (ScreenHeight - (162+61*self.dataList.count))/2, ScreenWidth-60, 112+61*self.dataList.count);
                }
            }
            [self.popTableView reloadData];
        }
        [tableView setEditing:NO animated:YES];
    }];
    action.backgroundColor = [UIColor redColor];
    return @[action];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // 在 iOS11 以下系统,因为方法线程问题,需要放到主线程执行, 不然没有效果
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setupSlideBtnWithEditingIndexPath:indexPath];
    });
}

- (void)setupSlideBtnWithEditingIndexPath:(NSIndexPath *)editingIndexPath {
    // 判断系统是否是 iOS13 及以上版本
    if (@available(iOS 13.0, *)) {
        for (UIView *subView in self.popTableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")] && [subView.subviews count] >= 1) {
                // 修改图片
                UIView *remarkContentView = subView.subviews.firstObject;
                [self setupRowActionView:remarkContentView];
            }
        }
        return;
    }
    
    // 判断系统是否是 iOS11 及以上版本
    if (@available(iOS 11.0, *)) {
        for (UIView *subView in self.popTableView.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subView.subviews count] >= 1) {
                // 修改图片
                UIView *remarkContentView = subView;
                [self setupRowActionView:remarkContentView];
            }
        }
        return;
    }
    
    // iOS11 以下的版本
    UITableViewCell *cell = [self.popTableView cellForRowAtIndexPath:editingIndexPath];
    for (UIView *subView in cell.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subView.subviews count] >= 1) {
            // 修改图片
            UIView *remarkContentView = subView;
            [self setupRowActionView:remarkContentView];
        }
    }
}

- (void)setupRowActionView:(UIView *)rowActionView {
    UIButton *button = rowActionView.subviews.firstObject;
    [button setImage:[UIImage imageNamed:@"icon_shanchu"] forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateNormal];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
        if (self.dataList.count <= 5 && self.dataPointList.count > 5 && indexPath.row == self.dataList.count + 1) {
            return NO;
        }
    } else {
        if (self.dataList.count <= 5 && self.dataPointList.count > 5 && indexPath.row == self.dataList.count ) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - keyboard Monitor
- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.frame = CGRectMake(37,(ScreenHeight-286-height - 30), ScreenWidth-74, 286);
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.frame = CGRectMake(37,(ScreenHeight-286)/2, ScreenWidth-74, 286);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - public
+ (ZDPayPopView *)readingEarnPopupViewWithType:(ZDPayPopViewEnum)type {
    return [[ZDPayPopView alloc] initWithFrame:CGRectZero withType:type];
}

- (void)showPopupMakeViewWithData:(__nullable id)model {
    [self.myWindow addSubview:self];
    NSArray *array = (NSArray *)model;
    if (self.type == CreditCardInputdemonstration) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        float x;
        UIImage *image = [UIImage imageNamed:array[0]];
        x = image.size.height*(ScreenWidth-37)/image.size.width;
        self.frame = CGRectMake(37,(ScreenHeight-x)/2, ScreenWidth-74, x);
        [self layoutAndLoadDataCreditCardInputdemonstration:array[0] labStr:array[1]];
    }
}

- (void)showPopupViewWithData:(__nullable id)model
              SelectPayMethod:(void (^)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,id __nullable model))selectPayMethod
            SlideLeftToDelete:(void (^)(_Nullable id info))slideLeftToDelete
         withPayListRespModel:(id __nullable)withPayListRespModel {
    self.pay_OrderSurePayListRespModel = (ZDPay_OrderSurePayListRespModel *)withPayListRespModel;
    self.selectPayMethod = selectPayMethod;
    self.slideLeftToDelete = slideLeftToDelete;
    [self.dataPointList removeAllObjects];
    [self.dataList removeAllObjects];
    [self.dataPointList addObjectsFromArray:(NSArray *)model];
    NSArray *dataList = (NSArray *)model;
    if (dataList.count > 5) {
        [dataList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < 5) {
                [self.dataList addObject:obj];
            }
        }];
    } else {
        [self.dataList addObjectsFromArray:dataList];
    }
    [self.myWindow addSubview:self];
    
    if (self.type == SelectPayMethod) {
        self.backgroundColor = COLORWITHHEXSTRING(@"#FFFFFF", 1.0);
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        if (self.dataPointList.count > 5) {
            if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
                self.frame = CGRectMake(30, (ScreenHeight - (162+61*5))/2, ScreenWidth-60, 162+61*4);
            } else {
                self.frame = CGRectMake(30, (ScreenHeight - (162+61*5))/2, ScreenWidth-60, 162+61*5);
            }
        } else {
            if (self.dataPointList.count >= 0 && self.dataPointList.count <= 5)  {
                if ([self.pay_OrderSurePayListRespModel.channelCode isEqualToString:@"MASTERCARD_PAYMENT_GATEWAY"]) {
                    self.frame = CGRectMake(30, (ScreenHeight - (162+61*self.dataList.count))/2, ScreenWidth-60, 112+61*(self.dataList.count-1));
                } else {
                 self.frame = CGRectMake(30, (ScreenHeight - (162+61*self.dataList.count))/2, ScreenWidth-60, 112+61*self.dataList.count);
                }
            }
        }

        [self layoutAndLoadDataSelectPayMethod];
    }
}

- (void)showPopupViewWithData:(__nullable id)model
                      payPass:(void (^)(NSString *text, BOOL isFinished))payPass
                   forgetPass:(void (^)(void))forgetPass {
    self.setPaymentPassword = payPass;
    self.forgetPassword = forgetPass;
    
    self.pay_OrderSurePayListRespModel = (ZDPay_OrderSurePayListRespModel *)model;
    [self.myWindow addSubview:self];
    if (self.type == SetPaymentPassword) {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(keyboardWillShow:)
        name:UIKeyboardWillShowNotification
        object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(keyboardWillHide:)
        name:UIKeyboardWillHideNotification
        object:nil];

        self.frame = CGRectMake(37,(ScreenHeight-286)/2, ScreenWidth-74, 286);
         [self layoutAndLoadDataPaymentPassword];
    }
}

- (void)showPopupViewWithData:(__nullable id)model
                       myCell:(UITableViewCell *)myCell
                 documentType:(void (^)(UIButton *sender))documentType{
    self.documentType = documentType;
    
    [self.myWindow addSubview:self];
    if (self.type == DocumentType) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(ScreenWidth-150, myCell.origin.y + mcNavBarAndStatusBarHeight+myCell.size.height, 150, (myCell.size.height-10)*5);
         [self layoutAndLoadDataDocumentType:(NSArray *)model myCell:myCell];
    }
}

- (void)showPopupViewWithData:(__nullable id)model
                 phoneAreaCode:(void (^)(UITableView *__nullable tableView,NSIndexPath *__nullable indexPath,NSString *__nullable text))phoneAreaCode {
    self.cellPhoneAreaCode = phoneAreaCode;
    [self.dataList removeAllObjects];
    [self.dataList addObjectsFromArray:(NSArray *)model];
    [self.myWindow addSubview:self];
    
    if (self.type == CellPhoneAreaCode) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, ScreenHeight - 50*self.dataList.count, ScreenWidth, 50*self.dataList.count);
         [self layoutAndLoadDataCellPhoneAreaCode];
    }
}

//温馨提示
- (void)showPopupMakeViewWithData:(__nullable id)model
                         reminder:(void (^)(UIButton *sender))reminder {
    self.reminder = reminder;
    [self.myWindow addSubview:self];
    if (self.type == Reminder) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat contentHeight = getHeightForLableString([[ZDPay_OrderSureModel sharedSingleten] getModelData].massage, CGRectMake(0, 0, self.width, 17), ZD_Fout_Regular(17));
        CGFloat selfHeight = 57+contentHeight+20+40+29;
        self.frame = CGRectMake(37, (ScreenHeight - selfHeight)/2, ScreenWidth-37*2, selfHeight);
        self.layer.cornerRadius = 10;
        [self layoutAndLoadDataReminder];
    }
}

//添加信用卡
- (void)showPopupMakeViewWithData:(__nullable id)model
                    addCreditCard:(void (^)(UIButton *sender,id info))addCreditCard {
    self.addCreditCard = addCreditCard;
    ZDPayRootViewController*vc = (ZDPayRootViewController *)[ZDPayFuncTool getCurrentVC];
    [vc.view addSubview:self];
    
    if (self.type == AddCreditCard) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, ScreenHeight-511, ScreenWidth, 511);
        self.layer.cornerRadius = 10;
        [self layoutAndLoadDataAddCreditCard];
    }
}

- (void)closeThePopupView {
    self.coverView.hidden = YES;
    self.hidden = YES;
    [self removeFromSuperview];
    [self.coverView removeFromSuperview];
}


#pragma mark - 键盘自适应
- (void) keyBoardAutoSize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDOWN:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardUP:(NSNotification *)sender{
    NSDictionary *userInfoDic = sender.userInfo;
    CGRect keyboardRect = [userInfoDic [UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat height = keyboardRect.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, ScreenHeight-511-height, ScreenWidth, 511);
    }];
}

- (void)keyboardDOWN:(NSNotification *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, ScreenHeight-511, ScreenWidth, 511);
    }];
}
@end

@implementation ZDPayPopViewModel;

@end


