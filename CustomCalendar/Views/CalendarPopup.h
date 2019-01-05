//
//  CalendarPopup.h
//  CustomCalendar
//
//  Created by Pulkit Rohilla on 11/09/15.
//  Copyright (c) 2015 PulkitRohilla. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarPopup : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnNextMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevMonth;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIView *viewButtonBack;

@property (weak, nonatomic) IBOutlet UIButton *BtnClose;
@property (weak, nonatomic) IBOutlet UIButton *BtnDone;
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *gestureTitleLongPress;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

-(void)show;
-(void)close;

@end
