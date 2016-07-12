//
//  SatellitesEntity+CoreDataProperties.h
//  Planets
//
//  Created by Fedor Solovev on 16.05.16.
//  Copyright © 2016 FedorX. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SatellitesEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SatellitesEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *discovery;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) DescriptionEntity *descrp;
@property (nullable, nonatomic, retain) PlanetsEntity *planet;

@end

NS_ASSUME_NONNULL_END
