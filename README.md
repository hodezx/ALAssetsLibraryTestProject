ALAssetsLibraryTestProject
==========================

A simple test project using ALAssetsLibrary

Directory AssetsLibWithARC
Deployment Target:  5.1
iOS SDK:            5.1
Autolayout:         False
ARC:                True

-- iPhone 4S --
Result:
Number of photos:   3033
Used time:          16s
Memory:             

LOG:
1. Using NSLog to show every asset, used up 16s
2. Without NSLog to access every asset, used up ? seconds
	Used around 5MB of RAM, not accurate maybe

-- iOS Simulator --
Number of photos:   1000+
LOG:
1. Using NSLog to show every asset, used up 1.96s
2. Without NSLog to access every asset, used up 0.05s
	Get information(metadata, createDate, takenDate(if exists), location(Problem1)) from every asset without NSLog, used up 2.6s
	Get information(metadata, createDate, takenDate(if exists), location(Problem1)) from every asset with NSLog, takes 9.74s!!!
