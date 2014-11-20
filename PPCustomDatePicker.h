//
//  PPCustomDatePicker.h
//  Zen Awake
//
//  Created by App Dev Wizard on 11/15/14.
//  Copyright (c) 2014 Pavel Palancica. All rights reserved.
//
//http://blog.deeplink.me/post/81386967477/how-to-easily-customize-uidatepicker-for-ios
//http://code4app.net/ios/FlatDatePicker/51cce1d76803fa4b0c000003
//http://stackoverflow.com/questions/878775/uipickerview-that-scrolls-horizontally-on-the-iphone
//https://www.dropbox.com/home/Mockups
//http://horseshoe7.wordpress.com/2013/12/20/how-to-know-when-a-uiscrollview-is-scrolling-moving/

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, PPDayTime)
{
    DayTimeNone,
    DayTimeAM,
    DayTimePM
};


//@protocol PPCustomDatePickerDelegate <NSObject>
//
//@optional
//
//
//@end


@interface PPCustomDatePicker : UIView

@property (nonatomic, assign) NSInteger hour;
@property (nonatomic, assign) NSInteger minute;

@property (nonatomic, assign) PPDayTime dateTime;

@end
