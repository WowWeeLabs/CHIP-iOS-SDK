WowWee CHIP iOS SDK
================================

![](Images/CHIP.png)

The free CHIP iOS SDK lets you control your [WowWee CHIP (http://wowwee.com/chip/) on devices running iOS 9.0 and above and Xcode 8. To use this SDK you will also need a physical CHIP robot.

For information on WowWee products visit: <http://www.wowwee.com>

Table of Contents
---------------------------------------

- [Quick Installation](#quick-installation)
- [Using the SDK](#using-the-sdk)
	- [Scan and Connect CHIP](#scan-and-connect-chip)
	- [Control CHIP](#control-chip)
- [Notes about the SDK](#notes-about-the-sdk)
- [License](#license)
- [Contributing](#contributing)
- [Credits](#credits)
- [Projects using this SDK](#projects-using-this-sdk)

Quick Installation
---------------------------------

1. Clone the repository

		git clone https://github.com/WowWeeLabs/CHIP-iOS-SDK.git

2. In XCode, create a new project. The simplest application is a Single-View application.

3. Open the project navigator in Xcode and drag the **WowWeeChipSDK.framework** file from the Mac OS Finder to the Frameworks directory for your project in XCode.

![](Images/Project-Navigator-Example.png)

4. Confirm that the framework is added to your project by going into _Project Settings_ (first item in the project navigator), then click the first target (e.g. _chipsampleproject_), then _Build Phases_. If there is not a _"Copy Files"_ phase., click the top left + to add one. Set the destination to _"Frameworks"_ and add the framework file under the _"Name"_ section.

![](Images/Copy-Framework-Example.png)

Also make that the framework is present under the _"Link Binary With Libraries"_ section.
	
![](Images/Link-Frameworks-Example.png)

5. In the DeviceHub.h file, add the following line at the top of the file:

		#import <WowWeeChipSDK/WowWeeChipSDK.h>
	
Alternatively you can add this line into your Project-Prefix.pch (e.g. _Chip-Prefix.pch_) file so that you don't need to import in each class your planning to use the SDK in.
	
6. Check that the project compiles successfully after completing the above steps by pressing ⌘+b in Xcode to build the project. The project should build successfully.
			
7. You should be now ready to go! Plug in an iOS device then compile and run the project using ⌘+r . When you turn on a CHIP you should see some debug messages in the logs.


Using the SDK
---------------------------------

7. Choose the classes you want to handle the delegate callbacks from a CHIP Robot, these classes will receive callbacks for when events happen (such as finding a new robot, robot connected, robot falls over etc) in this case we will simply choose our DeviceHub class.

		Scan
			- (void)startScaning{
				[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChipRobotFinderNotification:) name:ChipRobotFinderNotificationID object:nil];
				[[ChipRobotFinderSDK sharedInstance] scanForRobots];
			}


			-(void)stopScaning{
				[[ChipRobotFinderSDK sharedInstance] stopScanForRobots];
				[[NSNotificationCenter defaultCenter] removeObserver:self name: ChipRobotFinderNotificationID object:nil];
			}

		Connect directly when found available device via -(void)onChipRobotFinderNotification:(NSNotification *)note
			- (void)onChipRobotFinderNotification: (NSNotification *)notification {
    				NSDictionary *info = notification.userInfo;
				    if(info){
				        NSNumber *code = [info objectForKey: @"code"];
				        //id data = [info objectForKey: @"data"];
				        if (code.intValue == ChipRobotFinderNote_ChipRobotFound){
						[peripheralList removeAllObjects];
            
				        NSMutableArray* arr = [[ChipRobotFinder sharedInstance] robotsFound];
				        for (int i=0; i<[arr count]; i++) {
				                BluetoothRobot *robot = [arr objectAtIndex:i];
				                [peripheralList addObject:robot];
			                }
			                [self.tableView reloadData];
				    } else if (code.intValue == ChipRobotFinderNote_ChipRobotListCleared) {
				            [self.tableView reloadData];
				            [peripheralList removeAllObjects];
				    } else if (code.intValue == ChipRobotFinderNote_BluetoothError) {
				            NSLog(@"Bluetooth error!");
				    } else if (code.intValue == ChipRobotFinderNote_BluetoothIsOff) {
				            NSLog(@"Bluetooth is off!");
				    } else if (code.intValue == ChipRobotFinderNote_BluetoothIsAvailable) {
					    NSLog(@“ChipRobotFinderNote_BluetoothIsAvailable");
				    }
				}
			}

		Connect via devices array [[ChipRobotFinderSDK sharedInstance]devicesFound] 
			- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
			    ChipRobot *robot = nil;
			    robot = [[[ChipRobotFinder sharedInstance] robotsFound] objectAtIndex:indexPath.row];
			    robot.delegate = self;
			    [robot connect];
			    [viewLoading show];
			}
			
			
		Drive ChipRobot
			[robot chipDrive:CGVectorMake(0, 1) spinVector:CGVectorMake(0, 0)];
                        [robot chipDrive:CGVectorMake(0, -1) spinVector:CGVectorMake(0, 0)];
                        [robot chipDrive:CGVectorMake(-1, 0) spinVector:CGVectorMake(0, 0)];
                        [robot chipDrive:CGVectorMake(1, 0) spinVector:CGVectorMake(0, 0)];

		Play animation
			[robot chipPlayBodycon:kChipBodyconSit]; // animationIndex = kChipBodyconReset - kChipBodyconFaceDownForControllingChippies (Type: kChipBodyconType)
		Play sound
			[robot playSoundWithSoundIndex:kChipSoundFile_BARK_X1_ANGRY_A34]; // soundIndex = kChipSoundFile_BARK_X1_ANGRY_A34 - kChipSoundFile_SHORT_MUTE_FOR_STOP (Type: kChipSoundFileValue)
                Stop sound
			[robot chipStopSound];
                    
			    

Notes about the SDK
---------------------------------

### CocoaPods Compatible

For now we do not support CocoaPods. Pull requests are welcome.


### Apple Watch Support

At present we don't have an Apple Watch device to test with. When it becomes available we are open to adding support for WatchKit.

### Full Source Code

At this stage we do not plan on releasing our full library source code. 

### Are there any restrictions on releasing my own application?

The SDK is currently and will always be free for you to build and release your own applications. Your welcome to charge money or release free applications using our SDK without restrictions.

If you create a great application, all we ask is that you provide a link for people to purchase their own Chip so they can enjoy your product.

### OSX Support

Currently the SDK is not available for OSX however we will make this available if it's important to you. If that's the case please open up an issue in the bug tracker.
.
### Can I use your cool joystick class?

Yes we have provided the source code in our sample project, feel free to use this or make changes as you want. We would love pull requests.


License
---------------------------------
Chip iOS SDK is available under the Apache License, Version 2.0 license. See the [LICENSE.txt](https://raw.githubusercontent.com/WowWeeLabs/CHIP-iOS-SDK/master/LICENSE.md) file for more info.

You are free to use our SDK in your own projects whether free or paid. There are no restrictions on releasing into the Apple App Store or Google Play.


Contributing
---------------------------------
We happily accept any pull requests and monitor issues on GitHub regularly. Please feel free to give us your suggestions or enhancements. Please note that due to resource constraints we most likely cannot add new features to the Chip robot himself, but we will certainly consider them for inclusion to future robots/versions.

Tell your friends, fork our project, buy our robot and share with us your own projects! These are the best kinds of positive feedback to us.

Credits
---------------------------------
* [YMSCoreBluetooth](https://github.com/kickingvegas/YmsCoreBluetooth.git) & [Our Fork](https://github.com/WowWeeLabs/YmsCoreBluetooth)
* [MSWeakTimer](https://github.com/mindsnacks/MSWeakTimer)
* [NSTimer-Blocks](https://github.com/jivadevoe/NSTimer-Blocks)
* [OWQueueStack](https://github.com/yangyubo/OWQueueStack)

Projects using this SDK
---------------------------------
* [WowWee Chip Official App](https://itunes.apple.com/us/app/chip-your-new-best-friend/id1137040079?mt=8) - Official app developed by WowWee using this SDK.
* Send us a pull request to add your app here
