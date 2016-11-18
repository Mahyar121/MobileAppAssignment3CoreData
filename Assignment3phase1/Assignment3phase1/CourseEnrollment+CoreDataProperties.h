//
//  CourseEnrollment+CoreDataProperties.h
//  Assignment3phase1
//
//  Created by mahyar babaie on 11/17/16.
//  Copyright © 2016 mahyar babaie. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CourseEnrollment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CourseEnrollment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *courseName;
@property (nullable, nonatomic, retain) NSString *finalGrade;
@property (nullable, nonatomic, retain) NSString *hwGrade;
@property (nullable, nonatomic, retain) NSString *midtermGrade;
@property (nullable, nonatomic, retain) NSString *totalGrade;
@property (nullable, nonatomic, retain) NSManagedObject *calcGrade;
@property (nullable, nonatomic, retain) NSManagedObject *sendUpdatedGrades;

@end

NS_ASSUME_NONNULL_END
