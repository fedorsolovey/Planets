//
//  LocalDatastoreService.m
//  Planets
//
//  Created by Fedor Solovev on 28.04.16.
//

#import "LocalDatastoreService.h"

@implementation LocalDatastoreService

@synthesize mainQueueContext = _mainQueueContext;
@synthesize backgroundQueueContext = _backgroundQueueContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (nonnull instancetype)initWithInMemoryStorage
{
    self = [super init];
    if (self) {
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        _persistentStoreCoordinator = coordinator;
    }
    return self;
}

#pragma mark - Advanced Saving 

- (void)saveSyncWithBlock:(nonnull ContextActionsHandler)block
{
    NSManagedObjectContext *localContext = [self createNewContextWithParent:self.backgroundQueueContext];
    
    [localContext performBlockAndWait:^{
        [self assignWorkingParamsForContext:localContext];
        
        if (block) {
            block(localContext);
        }
        [self saveContext:localContext completion:nil];
    }];
}

- (void)saveAsyncWithBlock:(nonnull ContextActionsHandler)actionsBlock
                completion:(nullable SaveCompletionHandler)completionBlock
{
    NSManagedObjectContext *localContext = [self createNewContextWithParent:self.backgroundQueueContext];
    
    [localContext performBlock:^{
        [self assignWorkingParamsForContext:localContext];
        
        if (actionsBlock) {
            actionsBlock(localContext);
        }
        [self saveContext:localContext completion:completionBlock];
    }];
}

#pragma mark - Contexts

- (void)saveContext:(nonnull NSManagedObjectContext*)context
         completion:(nullable SaveCompletionHandler)completion
{
    NSAssert([context isEqual:self.mainQueueContext] == NO,
             @"Saving of the default main queue context is prohibited.");
        
    if ([context hasChanges] == NO) {
        NSLog(@"No changes in context: %@", context);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
                completion(NO, nil);
        });
        return;
    }
    
    NSError *error = nil;
    if ([context save:&error] == NO) {
        NSLog(@"Unresolved error %@, %@ during saving the context %@", error, [error userInfo], context);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
                completion(NO, error);
        });
    }
    else {
        NSLog(@"Context %@ is saved", context);
        
        if (context.parentContext)
            [self saveContext:context.parentContext completion:completion];
        else
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion)
                    completion(YES, nil);
            });
    }
}

- (void)saveCurrentContext
{
    [self saveContext:self.backgroundQueueContext completion:nil];
}

- (nonnull NSManagedObjectContext*)createNewBackgroundContext
{
    return [self createNewContextWithParent:self.backgroundQueueContext];
}

- (nonnull NSManagedObjectContext*)createNewContextWithParent:(nonnull NSManagedObjectContext*)parentContext
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:parentContext];
    [self obtainPermanentIDsBeforeSaving:context];
    
    return context;
}

#pragma mark - Contexts additional routines

- (void)contextWillSave:(NSNotification *)notification
{
    NSManagedObjectContext *context = [notification object];
    NSSet *insertedObjects = [context insertedObjects];
    
    if ([insertedObjects count])
    {
        NSLog(@"Context %@ is about to save. Obtaining permanent IDs for new %lu inserted objects", context, (unsigned long)[insertedObjects count]);
        NSError *error = nil;
        BOOL success = [context obtainPermanentIDsForObjects:[insertedObjects allObjects] error:&error];
        if (success == NO) {
            NSLog(@"Error Message: %@", [error localizedDescription]);
            NSLog(@"Error Domain: %@", [error domain]);
            NSLog(@"Recovery Suggestion: %@", [error localizedRecoverySuggestion]);
        }
    }
}

- (void)assignWorkingParamsForContext:(NSManagedObjectContext*)context
{
    [[context userInfo] setObject:NSStringFromSelector(_cmd) forKey:@"ContextWorkingName"];
    [[context userInfo] setObject:([NSThread isMainThread] ? @"Main" : @"Background") forKey:@"ContextType"];
}

- (void)obtainPermanentIDsBeforeSaving:(NSManagedObjectContext*)context
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contextWillSave:)
                                                 name:NSManagedObjectContextWillSaveNotification
                                               object:context];
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)mainQueueContext
{
    if (_mainQueueContext == nil) {
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainQueueContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [self obtainPermanentIDsBeforeSaving:_mainQueueContext];
    }
    return _mainQueueContext;
}

- (NSManagedObjectContext *)backgroundQueueContext
{
    if (_backgroundQueueContext == nil) {
        _backgroundQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundQueueContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        [self obtainPermanentIDsBeforeSaving:_backgroundQueueContext];
    }
    return _backgroundQueueContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Planets" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        // Create the coordinator and store
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Planets.sqlite"];
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption : @YES,
                                  NSInferMappingModelAutomaticallyOption : @YES};
        
        NSError *error = nil;
        if ([_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:storeURL
                                                            options:options
                                                              error:&error] == nil)
        {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = @"There was an error creating or loading the application's saved data.";;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"PlanetsErrorDomain" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
