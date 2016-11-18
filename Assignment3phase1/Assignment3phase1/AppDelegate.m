//
//  AppDelegate.m
//  Assignment3phase1
//
//  Created by mahyar babaie on 11/17/16.
//  Copyright © 2016 mahyar babaie. All rights reserved.
//

#import "AppDelegate.h"
#import "Student.h"
#import "CourseEnrollment.h"
#import "Course.h"
#import <sqlite3.h>

@interface AppDelegate ()
@property sqlite3 * db;
@property (weak) IBOutlet NSWindow *window;
- (IBAction)saveAction:(id)sender;

@end

@implementation AppDelegate

NSFetchRequest *fetchRequest;
NSArray *personArray = nil;

- (void) dumpObjectModel
{
    NSArray * entities = [[self managedObjectModel] entities];
    NSEntityDescription * entDesc;
    for (entDesc in entities) {
        NSLog(@"***  The Entity Name %@", entDesc.name);
        NSArray * properties = [entDesc properties];
        NSPropertyDescription * property;
        for (property in properties) {
            NSLog(@"     The Property Name %@", property.name);
            
            if ([property isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeDescription * attribute = (NSAttributeDescription *) property;
                NSLog(@"          The property is an Attribute.");
                NSLog(@"          The Attribute Name %@", attribute.attributeValueClassName);
                NSLog(@"          The Attribute Type %ld", attribute.attributeType);
            }
            
            if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                NSRelationshipDescription * relation = (NSRelationshipDescription *) property;
                Boolean isToMany = relation.isToMany;
                NSLog(@"          The property is an Relationship.");
                NSLog(@"          The destination entity %@", relation.destinationEntity.name);
                NSLog(@"          Is to many relation? %hhu", isToMany);
            }
        }
        NSLog(@"***********");
    }
    
}

-(NSMutableArray *)fetchTableNames
{
    sqlite3_stmt* statement;
    NSString *query = @"SELECT name FROM sqlite_master WHERE type=\'table\'";
    int retVal = sqlite3_prepare_v2(_db,
                                    [query UTF8String],
                                    -1,
                                    &statement,
                                    NULL);
    
    NSMutableArray *selectedRecords = [NSMutableArray array];
    if ( retVal == SQLITE_OK )
    {
        while(sqlite3_step(statement) == SQLITE_ROW )
        {
            NSString *value = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, 0)
                                                 encoding:NSUTF8StringEncoding];
            [selectedRecords addObject:value];
        }
    }
    
    sqlite3_clear_bindings(statement);
    sqlite3_finalize(statement);
    
    return selectedRecords;
}

- (void) populateStudentEntities:(NSString *)FirstName andLast:(NSString *)LastName andCWID:(NSString *)studentID {
    Student *newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    
    newStudent.firstName = FirstName;
    newStudent.lastName = LastName;
    newStudent.studentID = studentID;
    NSError *saveError = nil;
    if ([self.managedObjectContext save:&saveError]) {
        NSLog(@"Successfully persist Student objects.");
    } else {
        NSLog(@"Failed to persist Student objects due to %@", saveError);
    }
    
}

- (void) establishCourseByStudentName: (NSString *) name
{
    NSEntityDescription *studentEntity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:studentEntity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstName CONTAINS[cd] %@", name];
    fetchRequest.predicate = predicate;
    
    NSError *retrieveError = nil;
    NSArray *students = nil;
    students = [self.managedObjectContext executeFetchRequest:fetchRequest error:&retrieveError];
    
    Student *student = students[0];
    if (retrieveError != nil) {
        NSLog(@"Failed to retrieve 'Student' object due to %@", retrieveError);
    } else {
        CourseEnrollment *courseEnrollment;
        NSMutableSet * cSet;
        for (courseEnrollment in personArray) {
            cSet = [[NSMutableSet alloc] initWithSet:student.courseEnrolling];
            [cSet addObject:courseEnrollment];
            student.courseEnrolling = cSet;
        }
    }
}


- (void) establishStudentRelation:(NSString *)name
{
    fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *courseEnrollmentEntity = [NSEntityDescription entityForName:@"CourseEnrollment" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:courseEnrollmentEntity];
    
    NSError *retrieveError = nil;
    personArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&retrieveError];
    if (retrieveError != nil) {
        NSLog(@"Failed to retrieve all Person objects due to %@", retrieveError);
    }
    
    [self establishCourseByStudentName:name];
    
    NSError *saveError = nil;
    if ([self.managedObjectContext save:&saveError]) {
        NSLog(@"Successfully persist Student and Course relation.");
    } else {
        NSLog(@"Failed to Student and Course relation due to %@", saveError);
    }
}

- (void) populateCourseData
{
    char courseName[100];
    float courseLimit, hwScore, midtermScore, finalScore;
    float hwWeight, midtermWeight, finalWeight;
    float total = 0;
    Course *courseinfo1 = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
    NSMutableSet *courseSet = [[NSMutableSet alloc] init];
    CourseEnrollment *course1 = [NSEntityDescription insertNewObjectForEntityForName:@"CourseEnrollment" inManagedObjectContext:self.managedObjectContext];
    // Checks how many courses they are taking to set the limit on the for loop
    NSLog(@"How many courses did you take?");
    scanf("%f", &courseLimit);
    // will loop for each course they took until it gets all the proper numbers
    for (int i = 0; i < courseLimit; i++)
    {
        // gets the Course ID
        NSLog(@"Enter the Course Name");
        scanf("%s", courseName);
        NSString *CourseName = [NSString stringWithFormat:@"%s",courseName];
        course1.courseName = CourseName;
        // Gets the Avg HW Score
        NSLog(@"Enter your Avg HW Score");
        scanf("%f", &hwScore);
        NSLog(@"Enter the weight for hw");
        scanf("%f", &hwWeight);
        hwScore = hwScore * hwWeight;
        NSString *HWScore = [NSString stringWithFormat:@"%f",hwScore];
        course1.hwGrade = HWScore;
        // Gets the Mid Term Score
        NSLog(@"Enter your MidTerm Score");
        scanf("%f", &midtermScore);
        NSLog(@"Enter the weight for midterm");
        scanf("%f", &midtermWeight);
        midtermScore = midtermScore * midtermWeight;
        NSString *MidTermScore = [NSString stringWithFormat:@"%f",midtermScore];
        course1.midtermGrade = MidTermScore;
        // Gets the Final Score
        NSLog(@"Enter your Final Score");
        scanf("%f", &finalScore);
        NSLog(@"Enter the weight for final");
        scanf("%f", &finalWeight);
        finalScore = finalScore * finalWeight;
        NSString *FinalScore = [NSString stringWithFormat:@"%f",finalScore];
        course1.finalGrade = FinalScore;
        total = hwScore + midtermScore + finalScore;
        NSString *TotalGrade = [NSString stringWithFormat:@"%f",total];
        course1.totalGrade = TotalGrade;
        [courseSet addObject:course1];
    }
    courseinfo1.sendCourseInfo = courseSet;
    
    
    
    
    
    NSError *saveError = nil;
    if ([self.managedObjectContext save:&saveError]) {
        NSLog(@"Successfully persist Course objects.");
    } else {
        NSLog(@"Failed to persist objects due to %@", saveError);
    }
    
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * _databasePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"CoreData_Project.sqlite"];
    NSLog(@"%@", _databasePath);
    char fName[100];
    char lName[100];
    char CWID[100];
    // Prompts user for first name and then turns it into a NSString Object
    NSLog(@"Enter your First Name: ");
    scanf("%s", fName);
    NSString *FirstName = [NSString stringWithFormat:@"%s", fName];
    // Promps user for last name and then turns it into a NSString Object
    NSLog(@"Enter your Last Name: ");
    scanf("%s", lName);
    NSString *LastName = [NSString stringWithFormat:@"%s", lName];
    // Prompts user for CWID and stores it into the CWID variable
    NSLog(@"Enter your CWID:");
    scanf("%s", CWID);
    NSString *studentID = [NSString stringWithFormat:@"%s", CWID];
    [self populateStudentEntities:FirstName andLast:LastName andCWID:studentID];
    [self populateCourseData];
    [self establishStudentRelation:FirstName];
    
    
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - Core Data stack

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "fullerton.edu.Assignment3phase1" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"fullerton.edu.Assignment3phase1"];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
	
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Assignment3phase1" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    BOOL shouldFail = NO;
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    // Make sure the application files directory is there
    NSDictionary *properties = [applicationDocumentsDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];
    if (properties) {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            failureReason = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationDocumentsDirectory path]];
            shouldFail = YES;
        }
    } else if ([error code] == NSFileReadNoSuchFileError) {
        error = nil;
        [fileManager createDirectoryAtPath:[applicationDocumentsDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (!shouldFail && !error) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *url = [applicationDocumentsDirectory URLByAppendingPathComponent:@"OSXCoreDataObjC.storedata"];
        if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
            coordinator = nil;
        }
        _persistentStoreCoordinator = coordinator;
    }
    
    if (shouldFail || error) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        if (error) {
            dict[NSUnderlyingErrorKey] = error;
        }
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}

#pragma mark - Core Data Saving and Undo support

- (IBAction)saveAction:(id)sender {
    // Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }
    
    NSError *error = nil;
    if ([[self managedObjectContext] hasChanges] && ![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    // Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
    return [[self managedObjectContext] undoManager];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.
    
    if (!_managedObjectContext) {
        return NSTerminateNow;
    }
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }
    
    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }
    
    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        
        if (answer == NSAlertFirstButtonReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
