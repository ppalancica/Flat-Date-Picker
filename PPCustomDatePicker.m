//
//  PPCustomDatePicker.m
//  Zen Awake
//
//  Created by App Dev Wizard on 11/15/14.
//  Copyright (c) 2014 Pavel Palancica. All rights reserved.
//
//http://stackoverflow.com/questions/11862653/how-to-make-infinite-scroll-view-in-iphone

#import "PPCustomDatePicker.h"


#define BORDER_WIDTH 5.0f

#define HOURS_PICKER_TAG 10001
#define MINUTES_PICKER_TAG 10002
#define SECONDS_PICKER_TAG 10003


@interface PPCustomDatePicker () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *hoursPicker;
@property (nonatomic, strong) UIScrollView *minutesPicker;
@property (nonatomic, strong) UIScrollView *amOrPmPicker;
@property (nonatomic, strong) UIView *greenOverlayView;

@property (nonatomic, strong) NSMutableArray *hoursArray;
@property (nonatomic, strong) NSMutableArray *minutesArray;

@end


@implementation PPCustomDatePicker

//@synthesize hour = _hour;
//@synthesize minute = _minute;
@synthesize dateTime = _dateTime;

- (void)setHour:(NSInteger)hour
{
    _hour = hour;
    
    [self animateScrollView:self.hoursPicker toIndex:(hour - 1 + 60) animated:NO];
}

- (void)setMinute:(NSInteger)minute
{
    _minute = minute;
    
    [self animateScrollView:self.minutesPicker toIndex:(minute + 1 + 60) animated:NO];
}

- (void)setDateTime:(PPDayTime)dateTime
{
    _dateTime = dateTime;
    
    CGFloat labelHeight = self.amOrPmPicker.frame.size.height / 3;
    
    self.amOrPmPicker.contentOffset = CGPointMake(0.0f, self.dateTime * labelHeight - labelHeight);
    
//    if (_dateTime == DayTimeNone || _dateTime == DayTimeAM) {
//        
//        
//    } else if (_dateTime == DayTimePM) {
//        
//        
//    }
}

- (PPDayTime)dateTime
{
    if (_dateTime == DayTimeNone) {
        _dateTime = DayTimeAM;
    }
    
    return _dateTime;
}

- (NSMutableArray *)hoursArray
{
    if (!_hoursArray) {
        _hoursArray = [NSMutableArray arrayWithCapacity:120];
        
        for (NSInteger i = 0; i < 10; i++) {
            
            for (NSInteger j = 1; j <= 12; j++) {
                
                [_hoursArray addObject:@(j)];
            }
        }
    }
    
    return _hoursArray;
}

- (NSMutableArray *)minutesArray
{
    if (!_minutesArray) {
        _minutesArray = [NSMutableArray arrayWithCapacity:120];
        
        for (NSInteger i = 0; i < 10; i++) {
            
            for (NSInteger j = 0; j < 12; j++) {
                
                [_minutesArray addObject:@(j * 5)];
            }
        }
    }
    
    return _minutesArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIColor *blackColor = [UIColor colorWithRed:56 / 255.0f
                                              green:56 / 255.0f
                                               blue:56 / 255.0f
                                              alpha:1.0f];
        
        UIColor *darkGrayColor = [UIColor colorWithRed:216 / 255.0f
                                                 green:216 / 255.0f
                                                  blue:216 / 255.0f
                                                 alpha:1.0f];
        
        UIColor *greenColor = [UIColor colorWithRed:61 / 255.0f
                                              green:144 / 255.0f
                                               blue:119 / 255.0f
                                              alpha:0.5f];
        
        // Hours Picker Component
        
        CGRect hoursComponentFrame = frame;
        
        hoursComponentFrame.origin = CGPointMake(0.0f, 0.0f);
        hoursComponentFrame.size.width = (frame.size.width - BORDER_WIDTH * 2) / 3;
        
        self.hoursPicker = [[UIScrollView alloc] initWithFrame:hoursComponentFrame];
        
//        self.hoursPicker.contentSize = CGSizeMake(self.hoursPicker.frame.size.width, (self.hoursArray.count + 2) * self.hoursPicker.frame.size.height / 3);
        
        self.hoursPicker.contentSize = CGSizeMake(self.hoursPicker.frame.size.width, self.hoursArray.count * self.hoursPicker.frame.size.height / 3);
        
        self.hoursPicker.tag = HOURS_PICKER_TAG;
        self.hoursPicker.delegate = self;
        self.hoursPicker.backgroundColor = blackColor;
        self.hoursPicker.showsHorizontalScrollIndicator = NO;
        self.hoursPicker.showsVerticalScrollIndicator = NO;
        self.hoursPicker.bounces = NO;
        
        CGFloat labelWidth = self.hoursPicker.frame.size.width;
        CGFloat labelHeight = self.hoursPicker.frame.size.height / 3;
        
        for (int i = 0; i < self.hoursArray.count; i++) {
            
//            CGRect hoursLabelFrame = CGRectMake(0, labelHeight + i * labelHeight, labelWidth, labelHeight);
            CGRect hoursLabelFrame = CGRectMake(0, i * labelHeight, labelWidth, labelHeight);
            
            UILabel *labelNumber = [[UILabel alloc] initWithFrame:hoursLabelFrame];
            
            labelNumber.tag = 1000 + i;
            
            labelNumber.text = [self.hoursArray[i] stringValue];
            labelNumber.font = [UIFont boldSystemFontOfSize:31.0f];
            labelNumber.textAlignment = NSTextAlignmentCenter;
            labelNumber.textColor = darkGrayColor;
            labelNumber.backgroundColor = [UIColor clearColor];
            
            [self.hoursPicker addSubview:labelNumber];
        }
        
//        self.hoursPicker.contentOffset = CGPointMake(0, self.hoursPicker.contentSize.height / 2 - self.hoursPicker.frame.size.height / 3);
        
        _hour = 7;
        
        [self animateScrollView:self.hoursPicker toIndex:(self.hour - 1 + 60) animated:NO]; // 7 hours
        
        NSLog(@"self.hoursPicker.contentOffset %@", NSStringFromCGPoint(self.hoursPicker.contentOffset));
        
        // Minutes Picker Component
        
        CGRect minutesComponentFrame = hoursComponentFrame;
        
        minutesComponentFrame.origin.x += hoursComponentFrame.size.width + BORDER_WIDTH;
        
        self.minutesPicker = [[UIScrollView alloc] initWithFrame:minutesComponentFrame];
        
        self.minutesPicker.contentSize = self.hoursPicker.contentSize;
        
        self.minutesPicker.tag = MINUTES_PICKER_TAG;
        self.minutesPicker.delegate = self;
        self.minutesPicker.backgroundColor = blackColor;
        self.minutesPicker.showsHorizontalScrollIndicator = NO;
        self.minutesPicker.showsVerticalScrollIndicator = NO;
        self.minutesPicker.bounces = NO;
        
        for (int i = 0; i < self.minutesArray.count; i++) {
            
            CGRect minutesLabelFrame = CGRectMake(0, labelHeight + i * labelHeight, labelWidth, labelHeight);
            
            UILabel *labelNumber = [[UILabel alloc] initWithFrame:minutesLabelFrame];
            
            labelNumber.tag = 1000 + i;
            
            labelNumber.text = [self.minutesArray[i] stringValue];
            labelNumber.font = [UIFont boldSystemFontOfSize:31.0f];
            labelNumber.textAlignment = NSTextAlignmentCenter;
            labelNumber.textColor = darkGrayColor;
            labelNumber.backgroundColor = [UIColor clearColor];
            
            [self.minutesPicker addSubview:labelNumber];
        }
        
//        self.minutesPicker.contentOffset = CGPointMake(0, self.minutesPicker.contentSize.height / 2 - self.minutesPicker.frame.size.height / 3);
        
        _minute = 0;
        
        [self animateScrollView:self.minutesPicker toIndex:(self.minute + 1 + 60) animated:NO]; // 0 minutes
        
        // AM/PM Picker Component
        
        CGRect amOrPmComponentFrame = minutesComponentFrame;
        
        amOrPmComponentFrame.origin.x += minutesComponentFrame.size.width + BORDER_WIDTH;
        
        self.amOrPmPicker = [[UIScrollView alloc] initWithFrame:amOrPmComponentFrame];
        
        self.amOrPmPicker.contentSize = CGSizeMake(self.amOrPmPicker.frame.size.width, 4 * self.hoursPicker.frame.size.height / 3);
        
        self.amOrPmPicker.tag = SECONDS_PICKER_TAG;
        self.amOrPmPicker.delegate = self;
        self.amOrPmPicker.backgroundColor = blackColor;
        self.amOrPmPicker.showsHorizontalScrollIndicator = NO;
        self.amOrPmPicker.showsVerticalScrollIndicator = NO;
        
        CGRect amLabelFrame = CGRectMake(0, labelHeight, labelWidth, labelHeight);
        UILabel *amLabel = [[UILabel alloc] initWithFrame:amLabelFrame];
        
        amLabel.tag = 101;
        amLabel.text = @"am";
        amLabel.font = [UIFont boldSystemFontOfSize:31.0f];
        amLabel.textAlignment = NSTextAlignmentCenter;
        amLabel.backgroundColor = [UIColor clearColor];
        amLabel.textColor = darkGrayColor;
        
        CGRect pmLabelFrame = CGRectMake(0, labelHeight * 2, labelWidth, labelHeight);
        UILabel *pmLabel = [[UILabel alloc] initWithFrame:pmLabelFrame];
        
        pmLabel.tag = 102;
        pmLabel.text = @"pm";
        pmLabel.font = [UIFont boldSystemFontOfSize:31.0f];
        pmLabel.textAlignment = NSTextAlignmentCenter;
        pmLabel.backgroundColor = [UIColor clearColor];
        pmLabel.textColor = darkGrayColor;
        
        [self.amOrPmPicker addSubview:amLabel];
        [self.amOrPmPicker addSubview:pmLabel];
        
        _dateTime = DayTimeNone;
        
        // Green Overlay View
        
        CGRect greenOverlayViewFrame = frame;
        
        greenOverlayViewFrame.origin.x = 0.0f;
        greenOverlayViewFrame.origin.y = frame.size.height / 3;
        greenOverlayViewFrame.size.height = frame.size.height / 3;
        
        self.greenOverlayView = [[UIView alloc] initWithFrame:greenOverlayViewFrame];
        
        self.greenOverlayView.userInteractionEnabled = NO;
        self.greenOverlayView.backgroundColor = greenColor;

        [self addSubview:self.hoursPicker];
        [self addSubview:self.minutesPicker];
        [self addSubview:self.amOrPmPicker];
        [self addSubview:self.greenOverlayView];
    }
    
    return self;
}

#pragma mark - UIScrollViewDelegate

//http://stackoverflow.com/questions/11862653/how-to-make-infinite-scroll-view-in-iphone
//https://github.com/Seitk/InfiniteScrollPicker
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.hoursPicker) {
        
        if (scrollView.contentOffset.y < scrollView.contentSize.height / 10) {
            
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y + self.hoursPicker.contentSize.height / 10 * 5);
            
            NSLog(@"HOURS TOP margin");
            
        } else if ((scrollView.contentOffset.y + scrollView.contentSize.height / 10) > scrollView.contentSize.height) {
            
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y - scrollView.contentSize.height / 10 * 5);
            
            NSLog(@"HOURS BOTTOM margin");
        }
    
    } else if (scrollView == self.minutesPicker) {
        
        if (scrollView.contentOffset.y < scrollView.contentSize.height / 10) {
            
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y + self.hoursPicker.contentSize.height / 10 * 5);
            
            NSLog(@"MINUTES TOP margin");
            
        } else if ((scrollView.contentOffset.y + scrollView.contentSize.height / 10) > scrollView.contentSize.height) {
            
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y - scrollView.contentSize.height / 10 * 5);
            
            NSLog(@"MINUTES BOTTOM margin");
        }
        
    } else if (scrollView == self.amOrPmPicker) {
        
//        if (!scrollView.isDragging && !scrollView.isDecelerating) {
//        
//            NSLog(@"PPP");
//            
//        }
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        
        if (scrollView == self.hoursPicker ||
            scrollView == self.minutesPicker ||
            scrollView == self.amOrPmPicker) {
            
            [self animateScrollViewToCorrespondingOffset:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.hoursPicker ||
        scrollView == self.minutesPicker ||
        scrollView == self.amOrPmPicker) {
        
        [self animateScrollViewToCorrespondingOffset:scrollView];
    }
}

//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    NSLog(@"scrollViewDidEndScrollingAnimation");
//}

- (void)animateScrollView:(UIScrollView *)scrollView toIndex:(NSInteger)index animated:(BOOL)animated
{
    CGFloat labelHeight = scrollView.frame.size.height / 3;
    
    if (animated) {
        [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
        //        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    }

    scrollView.contentOffset = CGPointMake(0.0f, index * labelHeight - labelHeight);
    
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)animateScrollViewToCorrespondingOffset:(UIScrollView *)scrollView
{
    if (scrollView == self.hoursPicker) {
        
        CGFloat labelWidth = scrollView.frame.size.width;
        CGFloat labelHeight = scrollView.frame.size.height / 3;
        CGFloat scrollViewOffsetY = scrollView.contentOffset.y;
        NSInteger index;
        
        for (int i = 0; i < self.hoursArray.count; i++) {
            
            UILabel *label = (UILabel *)[scrollView viewWithTag:1000 + i];
            
            CGRect greenRect = CGRectMake(0, scrollViewOffsetY + labelHeight, labelWidth, labelHeight);
            
            if (CGRectContainsPoint(greenRect, label.center)) {
                
                index = label.tag - 1000;
                
                _hour = [self.hoursArray[index] integerValue];
                
                NSLog(@"HOURS label.text = %@", label.text);
                NSLog(@"HOURS label.tag = %ld", (long)label.tag);
                NSLog(@"HOURS _hour = %ld", (long)_hour);
                
                break;
            }
        }
        
        [self animateScrollView:scrollView toIndex:index animated:YES];
        
    } else if (scrollView == self.minutesPicker) {
        
        CGFloat labelWidth = scrollView.frame.size.width;
        CGFloat labelHeight = scrollView.frame.size.height / 3;
        CGFloat scrollViewOffsetY = scrollView.contentOffset.y;
        NSInteger index;
        
        for (int i = 0; i < self.minutesArray.count; i++) {
            
            UILabel *label = (UILabel *)[scrollView viewWithTag:1000 + i];
            
            CGRect greenRect = CGRectMake(0, scrollViewOffsetY + labelHeight, labelWidth, labelHeight);
            
            if (CGRectContainsPoint(greenRect, label.center)) {
                
                index = label.tag - 1000;
                
                _minute = [self.minutesArray[index] integerValue];
                
                NSLog(@"MINUTES label.text = %@", label.text);
                NSLog(@"MINUTES label.tag = %ld", (long)label.tag);
                NSLog(@"MINUTES _minute = %ld", (long)_minute);
                
                break;
            }
        }
        
        [self animateScrollView:scrollView toIndex:(index + 1) animated:YES];
        
    } else if (scrollView == self.amOrPmPicker) {
        
        CGFloat labelWidth = scrollView.frame.size.width;
        CGFloat labelHeight = scrollView.frame.size.height / 3;
        CGFloat scrollViewOffsetY = scrollView.contentOffset.y;

        UILabel *labelAM = (UILabel *)[scrollView viewWithTag:101];
        
        CGRect greenRect = CGRectMake(0, scrollViewOffsetY + labelHeight, labelWidth, labelHeight);
        
        if (CGRectContainsPoint(greenRect, labelAM.center)) {
            NSLog(@"AM Chosen");
            _dateTime = DayTimeAM;
        } else {
            NSLog(@"PM Chosen");
            _dateTime = DayTimePM;
        }
        
        [UIView beginAnimations:@"ScrollViewAnimation" context:nil];
        //        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        scrollView.contentOffset = CGPointMake(0.0f, self.dateTime * labelHeight - labelHeight);
        

        [UIView commitAnimations];
    }
}

@end
