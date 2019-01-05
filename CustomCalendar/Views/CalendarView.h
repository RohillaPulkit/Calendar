//
//  CalendarView.h
//  CustomCalendar
//
//  Created by Pulkit Rohilla on 26/08/15.
//  Copyright (c) 2015 PulkitRohilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDay : NSObject

@property (nonatomic) int day;
@property (nonatomic) BOOL isCurrent;
@property (nonatomic) BOOL isPrevious;
@property (nonatomic) BOOL isNext;

@end

typedef enum{
    
    DaysMode= 1,
    MonthsMode,
    YearsMode
    
}DateMode;

typedef enum{
    
    Light= 1,
    Dark
    
}Theme;

@interface CalendarGrid : UIView <UIGestureRecognizerDelegate>

-(id)initCalendarWithDate:(NSDate *)selectedDate andTitleLabel:(UILabel *)label andTheme:(Theme)theme;

- (IBAction)actionNextDate:(id)sender;
- (IBAction)actionPrevDate:(id)sender;
- (IBAction)actionChangeMode:(UILongPressGestureRecognizer *)sender;

@end

