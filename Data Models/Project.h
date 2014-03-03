//
//  Project.h
//  RegressionTestingApp
//
//  Created by NEIL DINGMAN on 7/17/13.
//  Copyright (c) 2013 NEIL DINGMAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stories;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * projectname;
@property (nonatomic, retain) NSString * platform;
@property (nonatomic, retain) NSString * build;
@property (nonatomic, retain) NSString * ostarget;
@property (nonatomic, retain) NSString * updatedate;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSSet *stories;

@end

@interface Project (CoreDataGeneratedAccessors)

//Project Methods
-(void)addProjectsObject:(NSManagedObject *)value;
-(void)removeProjectsObject:(NSManagedObject *)value;
-(void)addProjects:(NSSet *)values;
-(void)removeProjects:(NSSet *)values;

//Attendees Methods
- (void)addStoriesObject:(NSManagedObject *)value;
- (void)removeStoriesObject:(NSManagedObject *)value;
- (void)addStories:(NSSet *)values;
- (void)removeStories:(NSSet *)values;

@end
