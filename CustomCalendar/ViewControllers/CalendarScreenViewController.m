//
//  CalendarScreenViewController.m
//  CustomCalendar
//
//  Created by Pulkit Rohilla on 10/09/15.
//  Copyright (c) 2015 PulkitRohilla. All rights reserved.
//

#import "CalendarScreenViewController.h"
#import "CalendarView.h"
#import "CalendarPopup.h"

@implementation CalendarScreenViewController{
    
}

@synthesize customView, nextButton, prevButton, titleLongPressGesture,titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addEffect];

    [self initCustomCalendar];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIButton

- (IBAction)showCalendar:(id)sender {
    
    CalendarPopup *calendarPopup = [[CalendarPopup alloc] init];
    [calendarPopup show];
}

#pragma mark - Calendar View

-(void)initCustomCalendar{
    
    CalendarGrid *calendar = [[CalendarGrid alloc] initCalendarWithDate:[NSDate date] andTitleLabel:titleLabel andTheme:Light];
    [calendar setFrame:customView.bounds];
    [calendar setAutoresizesSubviews:NO];
    [calendar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    [customView addSubview:calendar];
    [customView addConstraint:[NSLayoutConstraint constraintWithItem:customView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:0
                                                              toItem:calendar
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1
                                                            constant:0]];
    
    [customView addConstraint:[NSLayoutConstraint constraintWithItem:customView
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:0
                                                              toItem:calendar
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1
                                                            constant:0]];
    [calendar setNeedsDisplay];

    [nextButton addTarget:calendar action:@selector(actionNextDate:) forControlEvents:UIControlEventTouchUpInside];
    [prevButton addTarget:calendar action:@selector(actionPrevDate:) forControlEvents:UIControlEventTouchUpInside];
    [titleLongPressGesture addTarget:calendar action:@selector(actionChangeMode:)];
 
}

-(void)addEffect{

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];

    UIVibrancyEffect *viewInducingVibrancy = [UIVibrancyEffect effectForBlurEffect:effect]; // must be the same effect as the blur view

    UIVisualEffectView *effectView2 = [[UIVisualEffectView alloc] initWithEffect:viewInducingVibrancy];

    [effectView.contentView addSubview:effectView2];

    effectView.frame = self.view.bounds;

    [effectView setAutoresizesSubviews:NO];
    [effectView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [self.view insertSubview:effectView belowSubview:customView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:0
                                                              toItem:effectView
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1
                                                            constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:0
                                                              toItem:effectView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1
                                                            constant:0]];

}
#pragma mark - Dummy Actions

- (void)actionPrevDate:(id)sender {
    
}

- (void)actionNextDate:(id)sender {

}

- (void)actionChangeMode:(UILongPressGestureRecognizer *)sender{
    
}

@end
