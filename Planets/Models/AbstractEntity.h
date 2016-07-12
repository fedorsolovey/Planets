//
//  AbstractEntity.h
//  SON
//
//  Created by Pavel Zhuravlev on 07.12.15.
//  Copyright © 2015 Digipeople. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kPrimaryKeyField;
extern NSString * const kCreatedAtField;
extern NSString * const kUpdatedAtField;


@interface AbstractEntity : NSManagedObject

@end


@interface AbstractEntity (Management)

+ (instancetype)createByPk:(NSString*)pk inContext:(NSManagedObjectContext*)context;
+ (instancetype)findOrCreateByPk:(NSString*)pk inContext:(NSManagedObjectContext*)context;

+ (void)deleteByPk:(NSString*)pk inContext:(NSManagedObjectContext*)context;

@end


@interface AbstractEntity (Search)

/** @name Items fetching */

+ (nullable instancetype)findByPk:(NSString*)pk inContext:(NSManagedObjectContext*)context;

/** Returns new instance of the current entity fetched in the given context. */
- (nullable instancetype)fetchInContext:(NSManagedObjectContext *)context;


/** @name Conditional fetching */

/** Fetches list of entities filtered and sorted by given parameters in the given context. If the searchField is not set, sorts by kPrimaryKeyField. */
+ (NSArray*)findWithPredicate:(nullable NSPredicate*)predicate
                       sortBy:(nullable NSString*)searchField
                    ascending:(BOOL)ascending
                    inContext:(NSManagedObjectContext *)context;

/** Fetches the first of entities filtered and sorted by given parameters in the given context. If the searchField is not set, sorts by kPrimaryKeyField. */
+ (instancetype)findFirstWithPredicate:(nullable NSPredicate*)predicate
                                sortBy:(nullable NSString*)searchField
                             ascending:(BOOL)ascending
                             inContext:(NSManagedObjectContext *)context;

/** @name Aggregation */

+ (NSUInteger)countOfEntitiesWithPredicate:(nullable NSPredicate*)predicate inContext:(NSManagedObjectContext *)context;
+ (NSUInteger)countOfEntitiesInContext:(NSManagedObjectContext *)context;

/** @name Fetch requests helpers */

+ (NSFetchRequest*)fetchRequestInContext:(NSManagedObjectContext *)context;
+ (nullable NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context;

@end


NS_ASSUME_NONNULL_END

#import "AbstractEntity+CoreDataProperties.h"
