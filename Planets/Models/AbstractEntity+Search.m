//
//  AbstractEntity+Search.m
//  SON
//
//  Created by Pavel Zhuravlev on 18.12.15.
//  Copyright © 2015 Digipeople. All rights reserved.
//

#import "AbstractEntity.h"

@implementation AbstractEntity (Search)

#pragma mark - Items fetching

+ (nullable instancetype)findByPk:(NSString*)pk inContext:(NSManagedObjectContext*)context
{
    if (pk.length == 0)
        return nil;
    
    NSFetchRequest *request = [self fetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", kPrimaryKeyField, pk]];
    [request setFetchLimit:1];
    
    return [self executeFetchRequest:request inContext:context].firstObject;
}

- (nullable instancetype)fetchInContext:(NSManagedObjectContext *)context
{
    NSError *error = nil;
    AbstractEntity *object = (AbstractEntity*)[context existingObjectWithID:[self objectID] error:&error];
    if (error)
        NSLog(@"%@, error: %@", NSStringFromClass(self.class), error);
    return object;
}

#pragma mark - Conditional fetching

+ (NSArray*)findWithPredicate:(nullable NSPredicate*)predicate
                       sortBy:(nullable NSString*)searchField
                    ascending:(BOOL)ascending
                    inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self fetchRequestInContext:context];
    if (predicate)
        [request setPredicate:predicate];
    
    NSString *searchBy = (searchField ? searchField : kPrimaryKeyField);
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:searchBy ascending:ascending]];
    
    return [self executeFetchRequest:request inContext:context];
}

+ (instancetype)findFirstWithPredicate:(nullable NSPredicate*)predicate
                                sortBy:(nullable NSString*)searchField
                             ascending:(BOOL)ascending
                             inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self fetchRequestInContext:context];
    request.fetchLimit = 1;
    
    if (predicate)
        [request setPredicate:predicate];
    
    NSString *searchBy = (searchField ? searchField : kPrimaryKeyField);
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:searchBy ascending:ascending]];
    
    return [self executeFetchRequest:request inContext:context].firstObject;
}

#pragma mark - Aggregation

+ (NSUInteger)countOfEntitiesWithPredicate:(nullable NSPredicate*)predicate
                                 inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self fetchRequestInContext:context];
    if (predicate)
        [request setPredicate:predicate];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    if (error)
        NSLog(@"%@, error: %@", NSStringFromClass(self.class), error);
    return count;
}

+ (NSUInteger)countOfEntitiesInContext:(NSManagedObjectContext *)context
{
    return [self countOfEntitiesWithPredicate:nil inContext:context];
}

#pragma mark - Fetch requests helpers

+ (NSFetchRequest*)fetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:NSStringFromClass(self)
                                   inManagedObjectContext:context]];
    return request;
}

+ (nullable NSArray *)executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        NSError *error = nil;
        results = [context executeFetchRequest:request error:&error];
        if (error)
            NSLog(@"%@, error: %@", NSStringFromClass(self.class), error);
    }];
    return results;
}

@end
