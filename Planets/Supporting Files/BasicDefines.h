//
//  BasicDefines.h
//  Planets
//
//  Created by Fedor Solovev on 30.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#ifndef BasicDefines_h
#define BasicDefines_h

#define SharedApplication                   [UIApplication sharedApplication]
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define LocalDatastoreObject                ApplicationDelegate.localDatastore

#define call_completion_block(block,value,error) if(nil != block) block(value,error)
#define call_error_block(block,error) if(nil != block) block(error)

#define PlanetsToAddItemSegue           @"PlanetsToAddItemSegue"
#define SattelitesToAddSattelliteSegue  @"SattelitesToAddSattelliteSegue"
#define AddItemToAddSatelliteSegue      @"AddItemToAddSatelliteSegue"
#define AddItemtoSattelitesSegue        @"AddItemtoSattelitesSegue"

#endif /* BasicDefines_h */
