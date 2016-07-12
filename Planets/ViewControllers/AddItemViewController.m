//
//  AddItemViewController.m
//  Planets
//
//  Created by Fedor Solovev on 30.04.16.
//  Copyright © 2016 FedorX. All rights reserved.
//

#import "AddItemViewController.h"
#import "PlanetsViewController.h"
#import "AddSatelliteViewController.h"
#import "SatellitesViewController.h"

@interface AddItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;

@end

@implementation AddItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.planetEntity != nil) {
        self.nameTextField.userInteractionEnabled = NO; 
        self.nameTextField.text = self.planetEntity.pk;
        self.numberTextField.text = self.planetEntity.number.stringValue;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:AddItemToAddSatelliteSegue]) {
        
        AddSatelliteViewController *controller = (AddSatelliteViewController *)segue.destinationViewController;
        controller.planetPk = self.planetEntity.pk;
    }
    else if ([segue.identifier isEqualToString:AddItemtoSattelitesSegue]) {
        
        SatellitesViewController *controller = (SatellitesViewController *)segue.destinationViewController;
        controller.planetPk = self.planetEntity.pk;
    }
}

- (IBAction)didTapOnSaveButton:(id)sender
{
    if (self.nameTextField.text.length == 0 || self.numberTextField.text.length == 0) {
        
        [self showAlertWithTitle:@"Ошибка" andMessage:@"Заполните все поля"];
    }
    else {
        
        [LocalDatastoreObject saveAsyncWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            PlanetsEntity *entity = nil;
            
            if (self.planetEntity == nil) {
                entity = [PlanetsEntity createByPk:self.nameTextField.text inContext:localContext];
            }
            else {
                entity = [PlanetsEntity findByPk:self.nameTextField.text inContext:localContext];
            }
            
            entity.number = @(self.numberTextField.text.integerValue);
        }
                                      completion:^(BOOL success, NSError * _Nullable error) {
                                          
            NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
            PlanetsViewController *controller = [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
            [controller reloadTableView]; 

            [self.navigationController popViewControllerAnimated:YES];

        }];
    }
}

@end
