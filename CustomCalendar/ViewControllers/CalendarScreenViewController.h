//
//  CalendarScreenViewController.h
//  CustomCalendar
//
//  Created by Pulkit Rohilla on 10/09/15.
//  Copyright (c) 2015 PulkitRohilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarScreenViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *customView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *prevButton;

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *titleLongPressGesture;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)showCalendar:(id)sender;

@end
