//
//  LocalDatastoreService.h
//  SON
//
//  Created by Pavel Zhuravlev on 18.12.15.
//  Copyright © 2015 Digipeople. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ContextActionsHandler)(NSManagedObjectContext *_Nonnull localContext);
typedef void (^SaveCompletionHandler)(BOOL success, NSError *_Nullable error);


@interface LocalDatastoreService : NSObject

/** @name Core */

@property (nonatomic, strong, nullable, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, nullable, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (nonnull instancetype)initWithInMemoryStorage;


/** @name Contexts */

/// Context just for fetching data for displaying in UI. Attempts to save this context though provided methods will cause an error (throws an exception or assert).
@property (nonatomic, strong, nullable, readonly) NSManagedObjectContext *mainQueueContext;
/// Context for fetching and saving data in background. All child contexts should be created from this context.
@property (nonatomic, strong, nullable, readonly) NSManagedObjectContext *backgroundQueueContext;

/** Wrapper for contextWithParent: method. Returns new background context with the current backgroundQueueContext as a parent. */
- (nonnull NSManagedObjectContext*)createNewBackgroundContext;

/** Returns new background context with the given context as a parent. */
- (nonnull NSManagedObjectContext*)createNewContextWithParent:(nonnull NSManagedObjectContext*)parentContext;

/** Synchronously saves the current backgroundQueueContext. */
- (void)saveCurrentContext;

/** Synchronously saves the given context and calls the given completion block in the main thread. */
- (void)saveContext:(nonnull NSManagedObjectContext*)context
         completion:(nullable SaveCompletionHandler)completion;


/** @name Advanced Saving */

/** Asynchronously performs actions from the given actionsBlock and calls the given completionBlock after saving. Provides NSManagedObjectContext with NSPrivateQueueConcurrencyType in the actionsBlock. */
- (void)saveAsyncWithBlock:(nonnull ContextActionsHandler)actionsBlock
                completion:(nullable SaveCompletionHandler)completionBlock;

/** Synchronously performs actions from the given actionsBlock and returns after saving. Provides NSManagedObjectContext with NSPrivateQueueConcurrencyType in the actionsBlock.*/
- (void)saveSyncWithBlock:(nonnull ContextActionsHandler)block;

@end
