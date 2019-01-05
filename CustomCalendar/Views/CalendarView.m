//
//  CalendarView.m
//  CustomCalendar
//
//  Created by Pulkit Rohilla on 26/08/15.
//  Copyright (c) 2015 PulkitRohilla. All rights reserved.
//

#import "CalendarView.h"

#pragma mark - CustomDay
@implementation CustomDay
// Custom Day class for GridView
@end

@implementation CalendarGrid{
    
    Theme calendarTheme;
    
    DateMode mode;
    
    int rowCount, columnCount;
    
    NSArray *headerArray;
    
    NSMutableArray *daysArray;
    NSArray *monthsArray;
    NSMutableArray *yearsArray;
    
    int currentDate;
    int month;
    int currentMonth;
    int year;
    int currentYear;
    
    NSDate *selectedDate, *selectedMonth, *selectedYear;
    
    float cellWidth, cellHeight;
    int selectedIndex;
    
    NSMutableArray *rowRects;
    
    CGRect selectedRect;
    CGRect prevSelectedRect;
    
    BOOL isTouchDown;
    
    UIFont *generalFont;
    NSDictionary *generalAttributes, *selectedAttributes, *headerAttributes, *disabledAttributes, *interactionAttributes;

    UILabel *titleLabel;
}

-(id)initCalendarWithDate:(NSDate *)date andTitleLabel:(UILabel *)label andTheme:(Theme)theme{
    
    self = [super init];
    
    if (self) {
    
        selectedDate = date;
        self.backgroundColor = [UIColor clearColor];
        titleLabel = label;
        calendarTheme = theme;
        
        [self initValues];
        
        UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionNextDate:)];
        [swipeLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        [swipeLeftGesture setDelaysTouchesBegan:YES];
        [swipeLeftGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:swipeLeftGesture];
        
        UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionPrevDate:)];
        [swipeRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [swipeRightGesture setDelaysTouchesBegan:YES];
        [swipeRightGesture setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:swipeRightGesture];
    }
    
    return self;
}

#pragma mark - Init Calendar Variables

-(void)initValues{

    isTouchDown = false;
    
    headerArray = [[NSArray alloc] initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];

    rowRects = [NSMutableArray new];

    generalFont = [UIFont systemFontOfSize:15.0];
    UIFont *headerFont = [UIFont systemFontOfSize:17.0f weight:0.5];
    UIFont *selectedFont = [UIFont systemFontOfSize:15.0f weight:0.5];

    NSMutableParagraphStyle *paraStyle = [NSMutableParagraphStyle new];
    paraStyle.alignment = NSTextAlignmentCenter;

    UIColor *genColor, *disabledColor, *selectedColor, *headerRowColor;
;
    
    if (calendarTheme == Light) {
        
        genColor = [UIColor colorWithWhite:1 alpha:1.0];
        disabledColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        selectedColor = [UIColor whiteColor];
        headerRowColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1.0];
    }
    else
    {
        genColor = [UIColor darkGrayColor];
        disabledColor = [UIColor lightGrayColor];
        selectedColor = [UIColor whiteColor];
        headerRowColor = [UIColor colorWithRed:128.0/255.0 green:128.0/255.0 blue:128.0/255.0 alpha:1.0];

    }
    
    generalAttributes = @{ NSFontAttributeName: generalFont,
                           NSForegroundColorAttributeName: genColor,
                           NSParagraphStyleAttributeName: paraStyle};

    disabledAttributes = @{ NSFontAttributeName: generalFont,
                            NSForegroundColorAttributeName: disabledColor,
                            NSParagraphStyleAttributeName: paraStyle};

    selectedAttributes = @{ NSFontAttributeName: selectedFont,
                            NSForegroundColorAttributeName: selectedColor,
                            NSParagraphStyleAttributeName: paraStyle};

    headerAttributes = @{ NSFontAttributeName: headerFont,
                          NSForegroundColorAttributeName: headerRowColor,
                          NSParagraphStyleAttributeName: paraStyle};

    interactionAttributes =  @{ NSFontAttributeName: generalFont,
                                NSForegroundColorAttributeName: [[UIColor darkGrayColor] colorWithAlphaComponent:0.3],
                                NSParagraphStyleAttributeName: paraStyle};
    
    if (!selectedDate) {
    
        selectedDate = [NSDate date];
    }
    
    if(!selectedMonth)
    {
        selectedMonth = selectedDate;
    }
    
    if (!selectedYear) {
    
        selectedYear = selectedDate;
    }
    
    [self initDateView];
    
}


-(void)initDateView{

    rowCount = 7;
    columnCount = 7;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSRange days = [cal rangeOfUnit:NSCalendarUnitDay
                               inUnit:NSCalendarUnitMonth
                              forDate:selectedMonth];
    
    int numDays = (int)days.length;
    
    NSDateComponents * currentDateComponents = [cal components: NSCalendarUnitYear|NSCalendarUnitMonth fromDate:selectedMonth];
    NSDate * startOfMonth = [cal dateFromComponents: currentDateComponents];
    
    NSDateComponents *comps = [cal components:NSCalendarUnitWeekday fromDate:startOfMonth];
    
    int firstDay = (int) [comps weekday]; // 1 for Sunday, 2 for Monday, and so on...

    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:selectedDate];

    NSDateComponents* monthComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:selectedMonth];
    NSDateComponents* yearComponents = [calendar components:NSCalendarUnitYear fromDate:selectedYear];

    NSRange prevMonthdays = [calendar rangeOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitMonth
                                          forDate:[calendar dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:selectedMonth options:0]];

    currentMonth = (int)[components month];
    currentYear = (int)[components year];
    currentDate = (int)[components day];

    int date = 1;
    month = (int)[monthComponents month];
    year = (int)[yearComponents year];

    int nextMonthDate = 1;
    int prevMonthLastDate = (int)prevMonthdays.length - firstDay + 2;

    daysArray = [NSMutableArray new];

    for (int i = 0 ; i < 42; i++) {

        CustomDay *dayObj = [CustomDay new];

        if (i >= firstDay-1 && date<=numDays) {

            [dayObj setDay:date];
            [dayObj setIsCurrent:YES];

            date++;

        }
        else if(date > numDays)
        {
            [dayObj setDay:nextMonthDate];
            [dayObj setIsNext:YES];

            nextMonthDate++;
        }
        else if(i <= firstDay-1)
        {
            [dayObj setDay:prevMonthLastDate];
            [dayObj setIsPrevious:YES];

            prevMonthLastDate++;
        }

        [daysArray addObject:dayObj];
    }

    mode = DaysMode;
    
    [self displayMonthTitle];
    
    [rowRects removeAllObjects];


}

-(void)initMonthView{

    rowCount = 3;
    columnCount = 4;

    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* components = [calendar components:NSCalendarUnitYear fromDate:selectedYear];
    NSDateComponents* dateComponents = [calendar components:NSCalendarUnitMonth|NSCalendarUnitYear fromDate:selectedDate];

    year = (int)[components year];

    currentYear = (int)[dateComponents year];
    currentMonth = (int)[dateComponents month];

    monthsArray = [[NSArray alloc] initWithObjects:@"Jan",@"Feb",@"Mar",@"Apr",@"May",@"Jun",@"Jul",@"Aug",@"Sep",@"Oct",@"Nov",@"Dec", nil];

    mode = MonthsMode;
    
    [self displayYearTitle];

    [rowRects removeAllObjects];

}

-(void)initYearView{

    rowCount = 3;
    columnCount = 4;

    int minYr = year - 6;
    int maxYr = year + 5;
    
    if (minYr < 0) {
        
        maxYr = maxYr - minYr;
        minYr = 0;
    }
    
    yearsArray = [NSMutableArray new];
    
    for (int yr = minYr; yr <= maxYr; yr++) {
        
        [yearsArray addObject:[NSNumber numberWithInt:yr]];
    }

    mode = YearsMode;
    
    [self displayYearRangeTitle];

    [rowRects removeAllObjects];

}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    
    cellWidth = self.frame.size.width/ columnCount;
    cellHeight = self.frame.size.height/ rowCount;
    
    CGRect textRect;
    CGFloat xPoint = 0;
    CGFloat yPoint = 0;

    if (mode == DaysMode) {

        for (int i = 0; i < columnCount; i++) {

            textRect = CGRectMake(xPoint, yPoint, cellWidth, cellHeight);

            [self drawHeaderRow:i inRect:textRect withAttributes:headerAttributes];

            xPoint = xPoint + cellWidth;

        }

        for (int i = 0; i < daysArray.count; i++) {

            if (i % 7 == 0) {

                xPoint = 0;
                yPoint = yPoint + cellHeight;
            }

            textRect = CGRectMake(xPoint, yPoint, cellWidth, cellHeight);

            [self drawDayRows:i inRect:textRect];

            xPoint = xPoint + cellWidth;

        }

    }
    else if(mode == MonthsMode)
    {
        for (int i = 0; i < monthsArray.count; i++) {

            if (i % 4 == 0) {

                xPoint = 0;

                if (i != 0) {

                    yPoint = yPoint + cellHeight;

                }
            }

            textRect = CGRectMake(xPoint, yPoint, cellWidth, cellHeight);

            [self drawMonthRows:i inRect:textRect];

            xPoint = xPoint + cellWidth;

        }

    }
    else if(mode == YearsMode)
    {
        for (int i = 0; i < yearsArray.count; i++) {

            if (i % 4 == 0) {

                xPoint = 0;

                if (i != 0) {

                    yPoint = yPoint + cellHeight;

                }
            }

            textRect = CGRectMake(xPoint, yPoint, cellWidth, cellHeight);

            [self drawYearRows:i inRect:textRect];

            xPoint = xPoint + cellWidth;

        }

    }
}


-(void)drawHeaderRow:(int)index inRect:(CGRect)rect withAttributes:(NSDictionary *)attributes{

    CGFloat fontHeight = generalFont.pointSize;
    CGFloat yOffset = (cellHeight - fontHeight) / 2.0 - 2;

    CGRect textRect = CGRectMake(rect.origin.x, rect.origin.y + yOffset, cellWidth, cellHeight);

    NSString *text = [headerArray objectAtIndex:index];
    [text drawInRect:textRect withAttributes:attributes];
}

-(void)drawDayRows:(int)index inRect:(CGRect)rect{

    [rowRects addObject:[NSValue valueWithCGRect:rect]];

    CustomDay *dayObj = [daysArray objectAtIndex:index];
    int day = dayObj.day;

    CGFloat fontHeight = generalFont.pointSize;
    CGFloat yOffset = (cellHeight - fontHeight) / 2.0 - 2;

    CGRect textRect = CGRectMake(rect.origin.x, rect.origin.y + yOffset, cellWidth, cellHeight);

    if (dayObj.isCurrent) {

        if (day == currentDate && month == currentMonth && year == currentYear) {

            CGContextRef context = UIGraphicsGetCurrentContext();

            [[UIColor orangeColor] setFill];
            CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect),
                            CGRectGetHeight(rect)/2, 0, 2*M_PI, YES);
            CGContextFillPath(context);

            NSString *text = [NSString stringWithFormat:@"%i",day];
            [text drawInRect:textRect withAttributes:selectedAttributes];

            prevSelectedRect = rect;

        }
        else
        {
            NSString *text = [NSString stringWithFormat:@"%i",day];

            if (isTouchDown) {

                [text drawInRect:textRect withAttributes:interactionAttributes];

            }
            else
            {
                [text drawInRect:textRect withAttributes:generalAttributes];

            }
        }

    }
    else
    {
        if (dayObj.isPrevious) {
            
            if (day == currentDate &&  month == currentMonth + 1 && year == currentYear) {
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
                CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect),
                                CGRectGetHeight(rect)/2, 0, 2*M_PI, YES);
                CGContextFillPath(context);
                
                NSString *text = [NSString stringWithFormat:@"%i",day];
                [text drawInRect:textRect withAttributes:selectedAttributes];
                
                prevSelectedRect = rect;

            }
            else
            {
                NSString *text = [NSString stringWithFormat:@"%i",day];
                [text drawInRect:textRect withAttributes:disabledAttributes];
            }
        }
        else if(dayObj.isNext){
            
            if (day == currentDate &&  month == currentMonth - 1 && year == currentYear) {
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                
                [[UIColor colorWithWhite:0.5 alpha:1.0] setFill];
                CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect),
                                CGRectGetHeight(rect)/2, 0, 2*M_PI, YES);
                CGContextFillPath(context);
                
                NSString *text = [NSString stringWithFormat:@"%i",day];
                [text drawInRect:textRect withAttributes:selectedAttributes];
                
                prevSelectedRect = rect;

            }
            else
            {
                NSString *text = [NSString stringWithFormat:@"%i",day];
                [text drawInRect:textRect withAttributes:disabledAttributes];
            }
        }

    }

}

-(void)drawMonthRows:(int)index inRect:(CGRect)rect{

    CGFloat fontHeight = generalFont.pointSize;
    CGFloat yOffset = (cellHeight - fontHeight) / 2.0 - 2;

    CGRect textRect = CGRectMake(rect.origin.x, rect.origin.y + yOffset, cellWidth, cellHeight);

    [rowRects addObject:[NSValue valueWithCGRect:rect]];

    NSString *monthName = [monthsArray objectAtIndex:index];

    if (index == currentMonth - 1 && year == currentYear) {

        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [[UIColor orangeColor] setFill];
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect),
                        CGRectGetHeight(rect)/3, 0, 2*M_PI, YES);
        CGContextFillPath(context);


        NSString *text = monthName;
        [text drawInRect:textRect withAttributes:selectedAttributes];

        prevSelectedRect = rect;

    }
    else
    {
        NSString *text = monthName;

        if (isTouchDown) {

            [text drawInRect:textRect withAttributes:interactionAttributes];

        }
        else
        {
            [text drawInRect:textRect withAttributes:generalAttributes];

        }
    }


}


-(void)drawYearRows:(int)index inRect:(CGRect)rect{

    CGFloat fontHeight = generalFont.pointSize;
    CGFloat yOffset = (cellHeight - fontHeight) / 2.0 - 2;

    CGRect textRect = CGRectMake(rect.origin.x, rect.origin.y + yOffset, cellWidth, cellHeight);
    
    [rowRects addObject:[NSValue valueWithCGRect:rect]];

    int yearValue = [[yearsArray objectAtIndex:index] intValue];

    if (yearValue == currentYear) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        [[UIColor orangeColor] setFill];
        CGContextAddArc(context, CGRectGetMidX(rect), CGRectGetMidY(rect),
                        CGRectGetHeight(rect)/3, 0, 2*M_PI, YES);
        CGContextFillPath(context);


        NSString *text = [NSString stringWithFormat:@"%i",yearValue];
        [text drawInRect:textRect withAttributes:selectedAttributes];

        prevSelectedRect = rect;

    }
    else
    {
        NSString *text = [NSString stringWithFormat:@"%i",yearValue];

        if (isTouchDown) {

            [text drawInRect:textRect withAttributes:interactionAttributes];

        }
        else
        {
            [text drawInRect:textRect withAttributes:generalAttributes];

        }
    }


}


#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    isTouchDown = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    for (NSValue *rect in rowRects) {
        
        CGRect dayRect = [rect CGRectValue];
        
        if (CGRectContainsPoint(dayRect,point)){
            
            selectedRect = dayRect;
            selectedIndex = (int)[rowRects indexOfObject:rect] + 1;
            
            break;
        }
        else
        {
            selectedIndex = 0;
        }
    }
    
//    if (selectedIndex > 0 && mode == DaysMode) {
//        
//        CustomDay *dayObj = [daysArray objectAtIndex:selectedIndex-1];
//        if (dayObj.isCurrent) {
//            
//            [self setNeedsDisplayInRect:selectedRect];
//            
//        }
//        
//    }
//    else if(selectedIndex > 0 && mode != DaysMode)
//    {
//        [self setNeedsDisplayInRect:selectedRect];
//    }
    
    [self setNeedsDisplayInRect:selectedRect];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (selectedIndex > 0 && mode == DaysMode) {
        
        if (CGRectContainsPoint(selectedRect,point)){
            
            isTouchDown = YES;
            
//            CustomDay *dayObj = [daysArray objectAtIndex:selectedIndex-1];
//            if (dayObj.isCurrent)
//            {
                [self setNeedsDisplayInRect:selectedRect];
                
//            }
        }
        else
        {
            isTouchDown = NO;
            
//            CustomDay *dayObj = [daysArray objectAtIndex:selectedIndex-1];
//            if (dayObj.isCurrent)
//            {
                [self setNeedsDisplayInRect:selectedRect];
//            }
            
        }
        
    }
    else if(selectedIndex > 0 && mode != DaysMode)
    {
        if (CGRectContainsPoint(selectedRect,point)){
            
            isTouchDown = YES;
            [self setNeedsDisplayInRect:selectedRect];
            
        }
        else
        {
            isTouchDown = NO;
            [self setNeedsDisplayInRect:selectedRect];
        }
    }
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    isTouchDown = NO;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    int touchEndIndex = 0;
    
    for (NSValue *rect in rowRects) {
        
        CGRect dayRect = [rect CGRectValue];
        
        if (CGRectContainsPoint(dayRect,point)){
            
            touchEndIndex = (int)[rowRects indexOfObject:rect] + 1;
            
            break;
        }
        else
        {
            touchEndIndex = 0;
        }
    }
    
    
    if (touchEndIndex > 0 && selectedIndex == touchEndIndex && mode == DaysMode) {
        
        CustomDay *dayObj = [daysArray objectAtIndex:selectedIndex-1];
        if (dayObj.isCurrent) {
            
            currentDate = dayObj.day;
            currentMonth = month;
            currentYear = year;
            
            [self setNeedsDisplayInRect:selectedRect];
            [self setNeedsDisplayInRect:prevSelectedRect];
            
            prevSelectedRect = selectedRect;
            
            [self didChangeSelectedDay:dayObj.day];
            
        }
        else if (dayObj.isPrevious){
            
            currentDate = dayObj.day;
            currentMonth = month - 1;
            currentYear = year;
            
            [self setNeedsDisplayInRect:selectedRect];
            [self setNeedsDisplayInRect:prevSelectedRect];
            
            prevSelectedRect = selectedRect;
            
            [self didChangeSelectedDay:dayObj.day andMonth:currentMonth];
            
        }
        else if(dayObj.isNext){
            
            currentDate = dayObj.day;
            currentMonth = month + 1;
            currentYear = year;
            
            [self setNeedsDisplayInRect:selectedRect];
            [self setNeedsDisplayInRect:prevSelectedRect];
            
            prevSelectedRect = selectedRect;
            
            [self didChangeSelectedDay:dayObj.day andMonth:currentMonth];
        }
    }
    else if(selectedIndex == touchEndIndex && mode != DaysMode)
    {
        if (mode == MonthsMode){
            
            month = selectedIndex;
            currentMonth = month;
            currentYear = year;
            
            [self didChangeSelectedMonth];
        }
        else
        {
            year = [[yearsArray objectAtIndex:selectedIndex - 1] intValue];
            currentYear = year;
            
            [self didChangeSelectedYear];
            
        }
        
        [self setNeedsDisplayInRect:selectedRect];
        [self setNeedsDisplayInRect:prevSelectedRect];
        
        prevSelectedRect = selectedRect;
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
    isTouchDown = NO;
}

#pragma mark - Other Methods

-(void)slideRight:(UIView *)view{

    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:transition forKey:nil];

    [view setNeedsDisplay];

}

-(void)slideLeft:(UIView *)view{

    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:transition forKey:nil];

    [view setNeedsDisplay];

}

-(void)fadeInTo:(UIView *)view{

    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:transition forKey:nil];

    [view setNeedsDisplay];
}

-(void)displayMonthTitle{

    NSDateFormatter *monthFormat = [[NSDateFormatter alloc] init];
    [monthFormat setDateFormat:@"MMMM"];

    NSDateFormatter *yearFormat = [[NSDateFormatter alloc] init];
    [yearFormat setDateFormat:@"yyyy"];

    NSString *monthString = [monthFormat stringFromDate:selectedMonth];
    NSString *yearString = [yearFormat stringFromDate:selectedYear];

    NSString *monthTitleString = [NSString stringWithFormat:@"%@ %@",monthString,yearString];

    [titleLabel setText:monthTitleString];
}

-(void)displayYearTitle{

    NSDateFormatter *yearFormat = [[NSDateFormatter alloc] init];
    [yearFormat setDateFormat:@"yyyy"];
    NSString *yearString = [yearFormat stringFromDate:selectedYear];

    [titleLabel setText:yearString];
}

-(void)displayYearRangeTitle{

    int minYr = [[yearsArray firstObject] intValue];
    int maxYr = [[yearsArray lastObject] intValue];

    NSString *yearString = [NSString stringWithFormat:@"%i - %i",minYr,maxYr];

    [titleLabel setText:yearString];
}

-(void)didChangeSelectedDay:(int)day{

    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* monthComponents = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear fromDate:selectedMonth];
    NSDateComponents* yearComponents = [calendar components:NSCalendarUnitYear fromDate:selectedYear];

    month = (int)[monthComponents month];
    year = (int)[yearComponents year];

    NSDateComponents* components = [calendar components:0 fromDate:selectedDate];
    [components setDay:day];
    [components setMonth:month]; //set month
    [components setYear:year]; // gives you year

    selectedDate = [calendar dateFromComponents:components];
}

-(void)didChangeSelectedDay:(int)day andMonth:(int)npMonth{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* yearComponents = [calendar components:NSCalendarUnitYear fromDate:selectedYear];
    year = (int)[yearComponents year];
    
    NSDateComponents* components = [calendar components:0 fromDate:selectedDate];
    [components setDay:day];
    [components setMonth:npMonth]; //set month
    [components setYear:year]; // gives you year
    
    selectedDate = [calendar dateFromComponents:components];
}

-(void)didChangeSelectedMonth{

    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* yearComponents = [calendar components:NSCalendarUnitYear fromDate:selectedYear];

    year = (int)[yearComponents year];

    NSDateComponents* components = [calendar components:0 fromDate:selectedMonth]; // Get necessary date components
    [components setMonth:month]; //set month
    [components setYear:year]; // gives you year

    selectedMonth = [calendar dateFromComponents:components];

    [self initDateView];
    
    [self fadeInTo:self];

}

-(void)didChangeSelectedYear{

    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDateComponents* components = [calendar components:0 fromDate:selectedYear]; // Get necessary date components
    [components setYear:year]; // set year

    selectedYear = [calendar dateFromComponents:components];

    [self initMonthView];
    
    [self fadeInTo:self];
}

#pragma mark - IBActions

- (IBAction)actionNextDate:(id)sender {

    if (mode == DaysMode) {

        NSCalendar *cal = [NSCalendar currentCalendar];
        selectedMonth = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:selectedMonth options:0];
        selectedYear = selectedMonth;

        [self initDateView];
        [self slideLeft:self];
    }
    else if(mode == MonthsMode)
    {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        selectedYear = [calendar dateByAddingUnit:NSCalendarUnitYear value:1 toDate:selectedYear options:0];

        [self initMonthView];
        [self slideLeft:self];
    }
    else if(mode == YearsMode)
    {
        year = [[yearsArray lastObject] intValue] + 7;
        
        [self initYearView];
        [self slideLeft:self];
    }

}

- (IBAction)actionPrevDate:(id)sender {

    if (mode == DaysMode) {

        NSCalendar *cal = [NSCalendar currentCalendar];
        selectedMonth = [cal dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:selectedMonth options:0];
        selectedYear = selectedMonth;
        
        [self initDateView];
        [self slideRight:self];

    }
    else if(mode == MonthsMode)
    {
        NSCalendar* calendar = [NSCalendar currentCalendar];
        selectedYear = [calendar dateByAddingUnit:NSCalendarUnitYear value:-1 toDate:selectedYear options:0];

        [self initMonthView];
        [self slideRight:self];
    }
    else if(mode == YearsMode)
    {
        if([[yearsArray firstObject] intValue] > 0){

            year = [[yearsArray firstObject] intValue] - 6;

            [self initYearView];
            [self slideRight:self];
        }

    }

}

- (IBAction)actionChangeMode:(UILongPressGestureRecognizer *)sender{

    if (mode != YearsMode) {
        
        switch (sender.state) {
            case UIGestureRecognizerStateBegan: {
                
                [titleLabel setAlpha:0.3];
                
            } break;
            case UIGestureRecognizerStateChanged:{
                
                CGPoint location = [sender locationInView:titleLabel];
                BOOL touchInside = CGRectContainsPoint(titleLabel.bounds, location);
                if (!touchInside) {
                    [titleLabel setAlpha:1.0];
                }
                else
                {
                    [titleLabel setAlpha:0.3];
                }
                
            }break;
            case UIGestureRecognizerStateEnded: {
                
                [titleLabel setAlpha:1.0];
                CGPoint location = [sender locationInView:titleLabel];
                BOOL touchInside = CGRectContainsPoint(titleLabel.bounds, location);
                
                if (touchInside) {
                    
                    if (mode == DaysMode) {
                        
                        [self initMonthView];
                        
                        [self fadeInTo:self];
                    }
                    else if(mode == MonthsMode)
                    {
                        [self initYearView];
                        
                        [self fadeInTo:self];
                    }
                }
                
            } break;
            case UIGestureRecognizerStateCancelled: {
                
                [titleLabel setAlpha:1.0];
                
            } break;
            default: {
            } break;
        }

    }
}
@end
