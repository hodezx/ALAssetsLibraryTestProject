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
3. Touching metadata of every asset will cost a lot, I think it takes up at least 2s, which is confirmed.
4. To get taken date, we will have to access the metadata. Looks like it's inevitable. Sorting by created date only takes 0.2s in simulator, while sorting by taken date takes up to 4s. 

-- Thumbnail Size of usual photo --
150 by 150

-- Typical metadata information inside an asset --
{
    ColorModel = RGB;
    DPIHeight = 72;
    DPIWidth = 72;
    Depth = 8;
    Orientation = 1;
    PixelHeight = 3000;
    PixelWidth = 4000;
    "{Exif}" =     {
        ApertureValue = 5;
        BrightnessValue = "7.98";
        ColorSpace = 1;
        ComponentsConfiguration =         (
            0,
            0,
            0,
            1
        );
        CompressedBitsPerPixel = "3.2";
        CustomRendered = 0;
        DateTimeDigitized = "2011:12:29 09:47:23";
        DateTimeOriginal = "2011:12:29 09:47:23";
        ExifVersion =         (
            2,
            3
        );
        ExposureBiasValue = "0.67";
        ExposureMode = 0;
        ExposureProgram = 2;
        ExposureTime = "0.004";
        FNumber = "5.6";
        Flash = 16;
        FlashPixVersion =         (
            1,
            0
        );
        FocalLength = "90.4";
        FocalPlaneResolutionUnit = 3;
        FocalPlaneXResolution = 4554;
        FocalPlaneYResolution = 4554;
        ISOSpeedRatings =         (
            250
        );
        LightSource = 0;
        MaxApertureValue = 3;
        MeteringMode = 5;
        PixelXDimension = "-1609629696";
        PixelYDimension = "-1207238656";
        SceneCaptureType = 0;
        SensingMethod = 2;
        Sharpness = 0;
        ShutterSpeedValue = 8;
        SubjectDistRange = 0;
        WhiteBalance = 0;
    };
    "{TIFF}" =     {
        DateTime = "2011:12:29 09:47:23";
        Make = FUJIFILM;
        Model = "X-S1";
        Orientation = 1;
        ResolutionUnit = 2;
        Software = "Digital Camera X-S1 Ver1.00";
        XResolution = 72;
        YResolution = 72;
        "_YCbCrPositioning" = 2;
    };
}

