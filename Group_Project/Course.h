//
//  Course.h
//  Group_Project
//
//  Created by White, Jordan on 7/23/14.
//  Copyright (c) 2014 Gannett Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (nonatomic) NSString *CRN;

@property (nonatomic) NSString *day1;            //MF
@property (nonatomic) NSString *day2;            //W
@property (nonatomic) NSString *day3;            //T

@property (nonatomic) NSString *timeBegin1;
@property (nonatomic) NSString *timeBegin2;
@property (nonatomic) NSString *timeBegin3;

@property (nonatomic) NSString *timeEnd1;
@property (nonatomic) NSString *timeEnd2;
@property (nonatomic) NSString *timeEnd3;

@property (nonatomic) NSString *course;     //MSE  CPE  CS  IDS
@property (nonatomic) NSString *num;        //1114
@property (nonatomic) NSString *teacher;    //Preston Durrill
@property (nonatomic) NSString *title;      //Physical Ceramics
@property (nonatomic) NSString *type;       //research | Lecture | Lab
@property (nonatomic) NSString *location1;  //TORG 2150
@property (nonatomic) NSString *location2;
@property (nonatomic) NSString *location3;

#pragma - improvement
//may need to have a custom setter that takes in a string
//then spits out an integer and assigns that integer
//I'll also need to
@property (nonatomic) NSString *credits;

- (instancetype)initWithCRN:(NSString *)aCRN;


@end
