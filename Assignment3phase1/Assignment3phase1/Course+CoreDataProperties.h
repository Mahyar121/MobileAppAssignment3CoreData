//
//  Course+CoreDataProperties.h
//  Assignment3phase1
//
//  Created by mahyar babaie on 11/17/16.
//  Copyright © 2016 mahyar babaie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Course.h"

NS_ASSUME_NONNULL_BEGIN

@interface Course (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *finalWeight;
@property (nullable, nonatomic, retain) NSString *hwWeight;
@property (nullable, nonatomic, retain) NSString *midtermWeight;
@property (nullable, nonatomic, retain) NSSet<CourseEnrollment *> *sendCourseInfo;

@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addSendCourseInfoObject:(CourseEnrollment *)value;
- (void)removeSendCourseInfoObject:(CourseEnrollment *)value;
- (void)addSendCourseInfo:(NSSet<CourseEnrollment *> *)values;
- (void)removeSendCourseInfo:(NSSet<CourseEnrollment *> *)values;

@end

NS_ASSUME_NONNULL_END
