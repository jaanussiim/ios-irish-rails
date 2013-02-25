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

#import "MainViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "PullAllStations.h"

@interface MainViewController ()

@property (nonatomic, strong) NSArray *stations;
@property (nonatomic, strong) NSArray *trainTimes;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NetworkOperation *runningOperation;

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

  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;

  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }

  // Configure the cell...

  return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)pullNearestTrainTimes {
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [self setHud:hud];

  JSLog(@"pullNearestTrainTimes");
  if ([self.stations count] == 0) {
    [self pullAllStations];
  } else {

  }
}

- (void)pullAllStations {
  JSLog(@"pullAllStations");
  PullAllStations *pullStations = [[PullAllStations alloc] init];
  [self executeOperation:pullStations];
}

- (void)executeOperation:(NetworkOperation *)operation {
  [self setRunningOperation:operation];
  [self.hud setLabelText:[operation activityDescription]];
  [operation start];
}

@end
