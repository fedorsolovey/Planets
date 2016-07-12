//
//  AddSatelliteViewController.m
//  Planets
//
//  Created by Fedor Solovev on 03.05.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "AddSatelliteViewController.h"

@interface AddSatelliteViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *diameterTextField;
@property (weak, nonatomic) IBOutlet UITextField *periodTextField;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *noteTextField;

@end

@implementation AddSatelliteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap_rec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView:)];
    [self.view addGestureRecognizer:tap_rec];
    
    if (self.satelliteEntity != nil) {
        self.nameTextField.userInteractionEnabled = NO; 
        self.nameTextField.text = self.satelliteEntity.pk;
        self.diameterTextField.text = [NSString stringWithFormat:@"%f", self.satelliteEntity.descrp.diameter.doubleValue];
        self.periodTextField.text = [NSString stringWithFormat:@"%f", self.satelliteEntity.descrp.period.doubleValue];
        self.weightTextField.text = [NSString stringWithFormat:@"%f", self.satelliteEntity.descrp.weight.doubleValue];
        self.dateTextField.text = self.satelliteEntity.discovery;
        self.noteTextField.text = self.satelliteEntity.notes;
    }
}

- (IBAction)didTapOnSaveButton:(UIButton *)sender
{
    if (self.nameTextField.text.length == 0) {
        [self showAlertWithTitle:@"Ошибка" andMessage:@"Заполните название, пожалуйста"];
    }
    else if (self.planetPk.length == 0 && self.satelliteEntity == nil) {
        [self showAlertWithTitle:@"Ошибка" andMessage:@"Заполните сначала планету"];
    }
    else {
        
        [LocalDatastoreObject saveAsyncWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            SatellitesEntity *satellite = nil;
            if (self.satelliteEntity == nil) {
                
                satellite = [SatellitesEntity createByPk:self.nameTextField.text inContext:localContext];
                satellite.discovery = self.dateTextField.text;
                satellite.notes = self.noteTextField.text;
                PlanetsEntity *planet_entity = [PlanetsEntity findByPk:self.planetPk inContext:localContext];
                [planet_entity addSatellitesObject:satellite];

                NSNumber *time_number = @(CACurrentMediaTime());
                DescriptionEntity *descrp = [DescriptionEntity createByPk:time_number.stringValue inContext:localContext];

                descrp.diameter = @(self.diameterTextField.text.doubleValue);
                descrp.weight = @(self.weightTextField.text.doubleValue);
                descrp.period = @(self.periodTextField.text.doubleValue);
                satellite.descrp = descrp;
            }
            else {
                
                satellite = [SatellitesEntity findByPk:self.nameTextField.text inContext:localContext];
                satellite.discovery = self.dateTextField.text;
                satellite.notes = self.noteTextField.text;
                
                DescriptionEntity *descrp = satellite.descrp;
                
                descrp.diameter = @(self.diameterTextField.text.doubleValue);
                descrp.weight = @(self.weightTextField.text.doubleValue);
                descrp.period = @(self.periodTextField.text.doubleValue);
            }
        }
                                      completion:^(BOOL success, NSError * _Nullable error) {
                                          
              if (error != nil || !success) {
                  NSLog(@"WRONG RECORD");
              }
              else {
                  [self.navigationController popViewControllerAnimated:YES];
              }
        }];
    }
}

- (void)didTapOnView:(id)sender
{
    [self.view endEditing:YES];
}

@end
