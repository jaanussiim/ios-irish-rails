/*
 * Copyright 2013 JaanusSiim
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <CoreLocation/CoreLocation.h>
#import "MainViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "PullAllStations.h"
#import "Station.h"
#import "PullStationData.h"
#import "StationData.h"
#import "StationDataCell.h"

static NSUInteger const kNumberOfTmesToShow = 10;

NSString *const kStationDataCellIentifier = @"kStationDataCellIentifier";

@interface MainViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) NSArray *trainTimes;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NetworkOperation *runningOperation;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) NSUInteger checkedStationIndex;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *refreshButton;

- (IBAction)refreshPressed:(id)sender;

@end

@implementation MainViewController

- (id)init {
  self = [super initWithNibName:@"MainViewController" bundle:nil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  CLLocationManager *locationManager = [[CLLocationManager alloc] init];
  [locationManager setDelegate:self];
  [locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
  [self setLocationManager:locationManager];

  [self setDefaultLocation];

  [self.tableView registerNib:[UINib nibWithNibName:@"StationDataCell" bundle:nil] forCellReuseIdentifier:kStationDataCellIentifier];
  [self.navigationItem setTitle:NSLocalizedString(@"main.controller.title", nil)];
  [self.navigationItem setRightBarButtonItem:self.refreshButton];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if ([self.trainTimes count] == 0) {
    [self pullNearestTrainTimes];
  }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.trainTimes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  StationDataCell *cell = [tableView dequeueReusableCellWithIdentifier:kStationDataCellIentifier];

  StationData *data = [self.trainTimes objectAtIndex:indexPath.row];
  [cell configureWithData:data];

  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)pullNearestTrainTimes {
  JSLog(@"pullNearestTrainTimes");

  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
  [self setHud:hud];

  [hud setLabelText:NSLocalizedString(@"checking.location", nil)];

  [self setTrainTimes:[NSArray array]];
  [self checkLocation];
}

- (void)checkLocation {
  [self.locationManager startUpdatingLocation];
}

- (void)pullAllStations {
  JSLog(@"pullAllStations");
  PullAllStations *pullStations = [[PullAllStations alloc] initWithCompletionHandler:^(NSArray *stations, NSError *error) {
    dispatch_async(dispatch_get_main_queue(), ^{
      if (error) {
        [self showError:NSLocalizedString(@"stations.pull.error", nil)];
        [self.hud hide:YES];
        return;
      }

      JSLog(@"%d stations pulled", [stations count]);
      [self setStations:stations];
      [self orderStationsByDistance];
    });
  }];
  [self executeOperation:pullStations];
}

- (void)showError:(NSString *)errorMessage {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"data.retrieve.error.message.title", nil)
                                                      message:errorMessage
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"button.title.ok", nil)
                                            otherButtonTitles:nil];
  [alertView show];
}

- (void)orderStationsByDistance {
  dispatch_async(dispatch_get_main_queue(), ^{
    JSLog(@"orderStationsByDistance");
    JSLog(@"Location:%@", self.location);
    CLLocation *userLocation = self.location;
    NSArray *sorted = [self.stations sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
      Station *one = obj1;
      Station *two = obj2;

      CLLocation *locationOne = [one location];
      CLLocation *locationTwo = [two location];

      CLLocationDistance distanceOne = [userLocation distanceFromLocation:locationOne];
      CLLocationDistance distanceTwo = [userLocation distanceFromLocation:locationTwo];

      return [[NSNumber numberWithDouble:distanceOne] compare:[NSNumber numberWithDouble:distanceTwo]];
    }];

    [self setStations:sorted];

    [self pullDataForStationAtIndex:0];
  });
}

- (void)pullDataForStationAtIndex:(NSUInteger)stationIndex {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self setCheckedStationIndex:stationIndex];
    Station *station = [self.stations objectAtIndex:stationIndex];

    PullStationData *stationData = [[PullStationData alloc] initWithStation:station completionHandler:^(NSArray *data, NSError *error) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
          [self showError:NSLocalizedString(@"station.data.pull.error", nil)];
          [self.hud hide:YES];
          return;
        }

        [self appendStationData:data];
      });
    }];
    [self executeOperation:stationData];
  });
}

- (void)appendStationData:(NSArray *)array {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableArray *presentData = [NSMutableArray arrayWithArray:self.trainTimes];
    [presentData addObjectsFromArray:array];
    [presentData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
      StationData *one = obj1;
      StationData *two = obj2;

      return [one.dueIn compare:two.dueIn options:NSNumericSearch];
    }];

    if ([presentData count] > kNumberOfTmesToShow) {
      NSRange clipRange = NSMakeRange(0, kNumberOfTmesToShow);
      [presentData setArray:[presentData subarrayWithRange:clipRange]];
    }

    [self setTrainTimes:[NSArray arrayWithArray:presentData]];
    [self.tableView reloadData];

    if ([self.trainTimes count] < kNumberOfTmesToShow) {
      [self pullDataForStationAtIndex:self.checkedStationIndex + 1];
    } else {
      [self.hud hide:YES];
    }
  });
}

- (void)executeOperation:(NetworkOperation *)operation {
  [self setRunningOperation:operation];
  [self.hud setLabelText:[operation activityDescription]];
  [operation start];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  [self setLocation:newLocation];

  JSLog(@"didUpdateToLocation:%@", newLocation);

  if ([newLocation horizontalAccuracy] <= 3000) {
    [self.locationManager stopUpdatingLocation];
    [self pullAllStations];
  }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  JSLog(@"didFailWithError:%@", error);
  [self showError:NSLocalizedString(@"location.error", nil)];
  [self setDefaultLocation];
  [self pullAllStations];
}

- (void)setDefaultLocation {
  //Set location to Dublin
  [self setLocation:[[CLLocation alloc] initWithLatitude:53.347778 longitude:-6.259722]];
}

- (IBAction)refreshPressed:(id)sender {
  [self pullNearestTrainTimes];
}

@end
