//
//  CalendarPopup.m
//  CustomCalendar
//
//  Created by Pulkit Rohilla on 11/09/15.
//  Copyright (c) 2015 PulkitRohilla. All rights reserved.
//

#import "CalendarPopup.h"
#import "CalendarView.h"

@implementation CalendarPopup{

    UIView *mainView;
}
@synthesize BtnDone,viewButtonBack,lblTitle,BtnClose,btnNextMonth,btnPrevMonth,viewContainer,gestureTitleLongPress;

const static CGSize contentShadowSize = {0.0f,0.0f};
const static float contentShadowOpacity = 0.5f;
const static float contentShadowRadius = 5.0f;

-(id)init{

    self = [super init];

    if (self) {

        UIWindow* currentWindow = [[[UIApplication sharedApplication] delegate]window];
        self = [[CalendarPopup alloc] initWithFrame:currentWindow.frame];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];

        NSArray *mainViewArray = [[NSBundle mainBundle] loadNibNamed:@"CalendarView" owner:self options:nil];
        mainView = [mainViewArray objectAtIndex:0];
        [mainView setClipsToBounds:NO];
        [mainView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [mainView setAutoresizesSubviews:YES];
        [mainView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

        self.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
        self.layer.shadowOffset = contentShadowSize;
        self.layer.shadowOpacity = contentShadowOpacity;
        self.layer.shadowRadius = contentShadowRadius;

        [self addSubview:mainView];
        
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        NSDictionary *viewsDictionary = @{@"mainView":mainView};


        
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(15)-[mainView]-(15)-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary];
        
        [self addConstraints:constraint_POS_H];

        NSArray *constraint_POS_Y = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=15)-[mainView]-(>=15)-|"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:viewsDictionary];

        [self addConstraints:constraint_POS_Y];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:0
                                                            toItem:mainView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];

        [mainView layoutIfNeeded];
        
        CALayer *TopBorder = [CALayer layer];
        TopBorder.frame = CGRectMake(0.0f, 0.0f, viewButtonBack.bounds.size.width, 0.7f);
        TopBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
        [viewButtonBack.layer addSublayer:TopBorder];


        CALayer *MiddleLine = [CALayer layer];
        MiddleLine.frame = CGRectMake(viewButtonBack.bounds.size.width/2 -2, 0.0f, 0.5f, viewButtonBack.bounds.size.height);
        MiddleLine.backgroundColor = [UIColor lightGrayColor].CGColor;
        [viewButtonBack.layer addSublayer:MiddleLine];

        [self addEffect];

        CalendarGrid *calendar = [[CalendarGrid alloc] initCalendarWithDate:[NSDate date] andTitleLabel:lblTitle andTheme:Light];
        [calendar setFrame:viewContainer.bounds];
        [calendar setAutoresizesSubviews:NO];
        [calendar setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        [viewContainer addSubview:calendar];
        [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:viewContainer
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:0
                                                                  toItem:calendar
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1
                                                                constant:0]];
        
        [viewContainer addConstraint:[NSLayoutConstraint constraintWithItem:viewContainer
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:0
                                                                  toItem:calendar
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0]];
        [calendar setNeedsDisplay];
        
        [btnNextMonth addTarget:calendar action:@selector(actionNextDate:) forControlEvents:UIControlEventTouchUpInside];
        [btnPrevMonth addTarget:calendar action:@selector(actionPrevDate:) forControlEvents:UIControlEventTouchUpInside];
        [gestureTitleLongPress addTarget:calendar action:@selector(actionChangeMode:)];
   
    }

    return self;
}

-(void)addEffect{

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];

    UIVibrancyEffect *viewInducingVibrancy = [UIVibrancyEffect effectForBlurEffect:effect]; // must be the same effect as the blur view

    UIVisualEffectView *effectView2 = [[UIVisualEffectView alloc] initWithEffect:viewInducingVibrancy];

    [effectView.contentView addSubview:effectView2];

    effectView.frame = mainView.bounds;

    [mainView insertSubview:effectView atIndex:0];

}


-(void)show
{
    UIWindow* currentWindow = [[[UIApplication sharedApplication] delegate] window];
    [currentWindow addSubview:self];

    [UIView animateWithDuration:0.45
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 1.0;
                         mainView.frame = CGRectMake(mainView.frame.origin.x, self.frame.size.height, mainView.frame.size.width, mainView.frame.size.height);
                     }
                     completion:^(BOOL finished){

                     }];

}

-(void)close{

    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.alpha = 0.0;
                     }
                     completion:^(BOOL finished){

                         [self removeFromSuperview];

                     }];
}

- (IBAction)cancel:(id)sender {

    [self close];
}

- (IBAction)done:(id)sender {

    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         mainView.frame = CGRectMake(mainView.frame.origin.x,self.frame.size.height, mainView.frame.size.width, mainView.frame.size.height);
                         //                         mainView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){

                         [self removeFromSuperview];

                     }];
}

#pragma mark - Dummy Actions

- (void)actionPrevDate:(id)sender {
    
}

- (void)actionNextDate:(id)sender {
    
}

- (void)actionChangeMode:(UILongPressGestureRecognizer *)sender{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
