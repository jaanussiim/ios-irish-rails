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

#import "NetworkOperation.h"
#import "Constants.h"
#import "AFHTTPRequestOperation.h"

@implementation NetworkOperation

- (NSString *)activityDescription {
  ABSTRACT_METHOD;
  return nil;
}

- (void)start {
  ABSTRACT_METHOD;
}

- (void)fetchDataFromURL:(NSURL *)url {
  JSLog(@"fetchDataFromURL:%@", url);
  NSURLRequest *request = [NSURLRequest requestWithURL:url];

  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setThreadPriority:0.1];
  [operation setQueuePriority:NSOperationQueuePriorityLow];

  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
    JSLog(@"Success:%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
  } failure:^(AFHTTPRequestOperation *op, NSError *error) {
    JSLog(@"Failure:%@", error);
  }];

  [operation start];
}

@end
