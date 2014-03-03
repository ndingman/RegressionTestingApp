//
//  Stories.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Stories : NSManagedObject

@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSString * storynumber;
@property (nonatomic, retain) NSString * storycomments;
@property (nonatomic, retain) NSString * stepstoexecute;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * actualresults;
@property (nonatomic, retain) NSString * passfailipad;
@property (nonatomic, retain) NSString * passfailiphone;
@property (nonatomic, retain) NSString * bugnumber;
@property (nonatomic, retain) NSString * testingcomments;
@property (nonatomic, retain) Project *project;

@end
