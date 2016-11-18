//
//  Student+CoreDataProperties.h
//  Assignment3phase1
//
//  Created by mahyar babaie on 11/17/16.
//  Copyright © 2016 mahyar babaie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Student.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *studentID;
@property (nullable, nonatomic, retain) NSSet<CourseEnrollment *> *courseEnrolling;

@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addCourseEnrollingObject:(CourseEnrollment *)value;
- (void)removeCourseEnrollingObject:(CourseEnrollment *)value;
- (void)addCourseEnrolling:(NSSet<CourseEnrollment *> *)values;
- (void)removeCourseEnrolling:(NSSet<CourseEnrollment *> *)values;

@end

NS_ASSUME_NONNULL_END
