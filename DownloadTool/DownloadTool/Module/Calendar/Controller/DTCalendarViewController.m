//
//  DTCalendarViewController.m
//  DownloadTool
//
//  Created by wangshuailong on 2020/12/1.
//  Copyright © 2020 DownloadTool. All rights reserved.
//

#import "DTCalendarViewController.h"
#import <FSCalendar/FSCalendar.h>
#import "DTCalendarDetailsModel.h"
#import "DTYellContentView.h"

@interface DTCalendarViewController () <FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) DTYellContentView *yellowView;
@property (nonatomic, strong) FSCalendar *myCalendar;
@property (nonatomic, strong) NSCalendar *chineseCalendar;
@property (nonatomic, strong) NSCalendar *solarCalendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *yearDateFormatter;

@property (nonatomic, strong) NSArray *dayListDatas;
@property (nonatomic, strong) NSArray *monthListDatas;
@property (nonatomic, strong) NSDictionary *jsonListDict;
@property (nonatomic, strong) NSArray *allKeys;

@property (nonatomic, strong) NSDate *currentLookDate;
@property (nonatomic, strong) UIButton *openButton;

@property (nonatomic, strong) UILabel *dateTextLabel;

@end

@implementation DTCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    self.title = @"日历";
    
    [self setCalendarViewUI];
    [self clickTodayButton];
}

- (void)setCalendarViewUI{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:UIBarButtonItemStyleDone target:self action:@selector(clickTodayButton)];
    
    self.currentLookDate = [NSDate date];
    [self clickSelectDateWithDate:[NSDate date]];

    
    //
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.myCalendar];
    [self.contentScrollView addSubview:self.dateTextLabel];
    [self.contentScrollView addSubview:self.openButton];
    [self.contentScrollView addSubview:self.yellowView];

    self.dateTextLabel.frame = CGRectMake(15, self.myCalendar.frame.origin.y + 15, self.contentScrollView.bounds.size.width-30, 30);
    self.openButton.frame = CGRectMake(0, CGRectGetMaxY(self.myCalendar.frame), self.contentScrollView.bounds.size.width, 30);
    self.yellowView.frame = CGRectMake(15, CGRectGetMaxY(self.openButton.frame)+20, self.contentScrollView.bounds.size.width-30, 300);
    
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.bounds.size.width, CGRectGetMaxY(self.yellowView.frame)+ 30);
}


#pragma mark - CLick
//今天
- (void)clickTodayButton{
    [self.myCalendar setCurrentPage:[NSDate date] animated:NO];
    [self.myCalendar selectDate:[NSDate date]];
    [self clickSelectDateWithDate:[NSDate date]];
}

- (void)clickOpenButton:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (self.myCalendar.scope == FSCalendarScopeMonth) {
        self.myCalendar.scope = FSCalendarScopeWeek;
    } else {
        self.myCalendar.scope = FSCalendarScopeMonth;
    }
}

//点击的日期
- (void)clickSelectDateWithDate:(NSDate*)date{
    self.dateTextLabel.text = [self.dateFormatter stringFromDate:date];
    
    NSInteger day = [self.solarCalendar components:NSCalendarUnitDay fromDate:date].day;
    NSArray *list = [self.jsonListDict objectForKey:[self.yearDateFormatter stringFromDate:date]];
    DTCalendarDetailsModel *model = list[day-1];
    [self.yellowView yellowContentWithDate:[self.dateFormatter stringFromDate:date] chinese:model.dayInfo[2] yiList:model.yi jiList:model.ji];
}

#pragma mark - FSCalendarDelegate
//是否允许点击日期
- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    return YES;
}
//点击的日期
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    [self clickSelectDateWithDate:date];
}
//是否点击取消选择
- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    return YES;
}
//取消选择的日期
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
}
//要改变bounds
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated{
    CGRect frame = self.myCalendar.frame;
    frame.size.height = bounds.size.height;
    self.myCalendar.frame = frame;
    
    //
    self.openButton.frame = CGRectMake(0, CGRectGetMaxY(self.myCalendar.frame), self.contentScrollView.bounds.size.width, 30);
    self.yellowView.frame = CGRectMake(20, CGRectGetMaxY(self.openButton.frame), self.contentScrollView.bounds.size.width-40, 200);
    [self.view layoutIfNeeded];
}
//单元格将要显示的时候
- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    
}
//滑动日历
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    self.currentLookDate = calendar.currentPage;
    [self getJsonListWithDate:calendar.currentPage];
}

#pragma mark - FSCalendarDataSource
//日期
- (nullable NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date{
//    if ([self.chineseCalendar isDateInToday:date]) {
//        return @"今";
//    }
    return nil;
}
////日期子标题
- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
//   //农历
//    NSInteger day = [self.chineseCalendar components:NSCalendarUnitDay fromDate:date].day;
//    NSInteger month = [self.chineseCalendar component:NSCalendarUnitMonth fromDate:date];
//
//    if (day == 1) { //判断农历月份
//        return self.monthListDatas[month-1];
//    }
//    //农历天
//    return self.dayListDatas[day-1];
    
    //
    NSInteger day = [self.solarCalendar components:NSCalendarUnitDay fromDate:date].day;
    NSArray *list = [self.jsonListDict objectForKey:[self.yearDateFormatter stringFromDate:date]];
    DTCalendarDetailsModel *model = list[day-1];
    return model.day.lastObject;
}
//最小日期
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
    return [self.dateFormatter dateFromString:@"1980-01-01"];
}
//最大日期
- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar{
    return [self.dateFormatter dateFromString:@"2050-12-31"];
}

#pragma mark - FSCalendarDelegateAppearance
//子标题默认颜色
- (nullable UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date{
//    NSLog(@"date => %@", [self.dateFormatter stringFromDate:date]);
//    NSLog(@"currentLookDate = %@", [self.dateFormatter stringFromDate:self.currentLookDate]);
    
//    //日期一样
//    if ([[self.yearDateFormatter stringFromDate:date] isEqualToString:[self.yearDateFormatter stringFromDate:self.currentLookDate]]) {
        NSInteger day = [self.solarCalendar components:NSCalendarUnitDay fromDate:date].day;
        NSArray *list = [self.jsonListDict objectForKey:[self.yearDateFormatter stringFromDate:date]];

    DTCalendarDetailsModel *model = list[day-1];
        if ([self.dayListDatas containsObject:model.day.lastObject] == NO && [self.monthListDatas containsObject:model.day.lastObject] == NO) {
            return [UIColor colorWithRed:238/255.0 green:142/255.0 blue:103/255.0 alpha:1];
        }
//    }
    
    return nil;
}


#pragma mark - Lazy
- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _contentScrollView.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
    }
    return _contentScrollView;
}

- (DTYellContentView *)yellowView{
    if (!_yellowView) {
        _yellowView = [[DTYellContentView alloc] init];
        _yellowView.layer.cornerRadius = 10;
        _yellowView.layer.masksToBounds = YES;
        _yellowView.backgroundColor = [UIColor whiteColor];
    }
    return _yellowView;
}

- (FSCalendar *)myCalendar{
    if (!_myCalendar) {
        CGFloat height = 430;
        CGFloat width = self.contentScrollView.bounds.size.width;
        _myCalendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _myCalendar.delegate = self;
        _myCalendar.dataSource = self;
        _myCalendar.allowsMultipleSelection = NO;//是否可以选中多个日期
        _myCalendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];    //中
        _myCalendar.adjustsBoundingRectWhenChangingMonths = NO;
        _myCalendar.placeholderType = FSCalendarPlaceholderTypeFillSixRows;     //默认六行
        _myCalendar.scope = FSCalendarScopeMonth;   //展示月份
        _myCalendar.pagingEnabled = YES;
        
        //header
        //_myCalendar.appearance.headerMinimumDissolvedAlpha = 1; //顶部左右两边
        _myCalendar.calendarHeaderView.hidden = YES;    //隐藏头部日期
        
        //week
        //_myCalendar.calendarWeekdayView.hidden = YES;   //星期
        _myCalendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;   //格式，日，六..
        _myCalendar.appearance.weekdayFont = [UIFont systemFontOfSize:13];  //字号
        _myCalendar.appearance.weekdayTextColor = [UIColor blackColor];      //文字颜色
        
        //day
        _myCalendar.appearance.titleFont = [UIFont systemFontOfSize:17];        //字号
        _myCalendar.appearance.subtitleFont = [UIFont systemFontOfSize:10];
        _myCalendar.appearance.titleDefaultColor = [UIColor blackColor];        //标题文字颜色
        _myCalendar.appearance.subtitleDefaultColor = [UIColor grayColor];      //子标题文字颜色
        _myCalendar.appearance.titleTodayColor = [UIColor blackColor];          //今天的文字颜色
        _myCalendar.appearance.subtitleTodayColor = [UIColor grayColor];        //今天的子标题文字颜色
        _myCalendar.appearance.subtitleOffset = CGPointMake(0, 3);  //偏移量
        _myCalendar.appearance.selectionColor = [UIColor colorWithRed:236/255.0 green:116/255.0 blue:92/255.0 alpha:1];  //选中圆的颜色
        _myCalendar.appearance.borderSelectionColor = [UIColor clearColor]; //圆型边框
        //_myCalendar.appearance.todaySelectionColor = [UIColor whiteColor];  //当天选中的圆背景色
        _myCalendar.appearance.todayColor = [UIColor clearColor];        //选中今天的圆背景色
    }
    return _myCalendar;
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (NSDateFormatter *)yearDateFormatter{
    if (!_yearDateFormatter) {
        _yearDateFormatter = [[NSDateFormatter alloc] init];
        _yearDateFormatter.dateFormat = @"yyyy-MM";
    }
    return _yearDateFormatter;
}

- (NSCalendar *)chineseCalendar{
    if (!_chineseCalendar) {
        _chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    }
    return _chineseCalendar;
}

- (NSCalendar *)solarCalendar{
    if (!_solarCalendar) {
        _solarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _solarCalendar;
}

- (NSArray *)dayListDatas{
    if (!_dayListDatas) {
        _dayListDatas = @[
            @"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",
            @"初八",@"初九",@"初十",@"十一",@"十二",@"十三",@"十四",
            @"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"廿一",
            @"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",
            @"廿九",@"三十"
        ];
    }
    return _dayListDatas;
}

- (NSArray *)monthListDatas{
    if (!_monthListDatas) {
        _monthListDatas = @[
            @"正月",@"二月",@"三月",@"四月",@"五月",
            @"六月",@"七月",@"八月",@"九月",@"十月",
            @"十一月",@"十二月",  //json中的字段
            @"冬月",@"腊月"
        ];
    }
    return _monthListDatas;
}


- (void)getJsonListWithDate:(NSDate*)date{
    //当前的月份
    NSString *currentMonth = [self.yearDateFormatter stringFromDate:date];
    
    //
    NSDictionary *monthDict;
    if ([self.allKeys containsObject:currentMonth]) {
        //是否到达第一个
        if ([currentMonth isEqualToString:self.allKeys.firstObject]) {
            monthDict = [self addMontehJsonWithDate:date last:YES];
        } else if ([currentMonth isEqualToString:self.allKeys.lastObject]) {    //是否到达最后一个
            monthDict = [self addMontehJsonWithDate:date last:NO];
        } else {
            return;
        }
    }

    //添加
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionaryWithDictionary:self.jsonListDict];
    if (monthDict) {
        [jsonDict addEntriesFromDictionary:monthDict];
    }
    
    self.jsonListDict = jsonDict;
    self.allKeys = [jsonDict.allKeys sortedArrayUsingSelector:@selector(compare:)]; //排序
}

- (NSDictionary *)addMontehJsonWithDate:(NSDate*)date last:(BOOL)last{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *monthComps = [[NSDateComponents alloc] init];
    
    //添加6个月的数据
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    for (int i= 1; i <= 6; i++) {
        if (last) {
            [monthComps setMonth:-i];
        } else {
            [monthComps setMonth:+i];
        }
        NSDate *lastDate = [calendar dateByAddingComponents:monthComps toDate:date options:0];
        NSString *lastMonth = [self.yearDateFormatter stringFromDate:lastDate];
        dictM[lastMonth] = [self getDateJsonWithName:lastMonth];
    }
    
    return dictM.copy;
}

//读取json文件
- (NSArray *)getDateJsonWithName:(NSString*)jsonName{
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        DTCalendarDetailsModel *model = [DTCalendarDetailsModel modelWithDictionary:dict];
        [arrM addObject:model];
    }
    
    return arrM.copy;
}

//默认数据
- (NSDictionary *)jsonListDict{
    if (!_jsonListDict) {
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        
        //前六月
        [jsonDict addEntriesFromDictionary:[self addMontehJsonWithDate:[NSDate date] last:YES]];
        
        //当月
        NSString *currentMonth = [self.yearDateFormatter stringFromDate:[NSDate date]];
        jsonDict[currentMonth] = [self getDateJsonWithName:currentMonth];
        
        //后六月
        [jsonDict addEntriesFromDictionary:[self addMontehJsonWithDate:[NSDate date] last:NO]];

        self.allKeys = [jsonDict.allKeys sortedArrayUsingSelector:@selector(compare:)];
        
        _jsonListDict = jsonDict.copy;
    }
    return _jsonListDict;
}

- (UIButton *)openButton{
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openButton.layer.cornerRadius = 10;
        _openButton.layer.masksToBounds = YES;
        _openButton.selected = YES;
        [_openButton setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
        [_openButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateSelected];
        [_openButton addTarget:self action:@selector(clickOpenButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}

- (UILabel *)dateTextLabel{
    if (!_dateTextLabel) {
        _dateTextLabel = [[UILabel alloc] init];
        _dateTextLabel.textColor = [UIColor colorWithRed:240/255.0 green:151/255.0 blue:58/255.0 alpha:1];
        _dateTextLabel.font = [UIFont boldSystemFontOfSize:30];
    }
    return _dateTextLabel;
}


@end
