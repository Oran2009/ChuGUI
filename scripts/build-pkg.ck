@import "Chumpinate"

// instantiate a Chumpinate package
Package pkg("ChuGUI");

// add our metadata here
["Ben Hoang"] => pkg.authors;

"https://ccrma.stanford.edu/~hoangben/ChuGUI/" => pkg.homepage;
"https://github.com/Oran2009/ChuGUI/" => pkg.repository;

"ChuGUI is a flexible immediate-mode 2D GUI toolkit for ChuGL." => pkg.description;
"MIT" => pkg.license;

["GUI", "immediate-mode", "2D", "UI", "ChuGL", "ChuGUI"] => pkg.keywords;

"./" => pkg.generatePackageDefinition;

PackageVersion ver("ChuGUI", "1.0.0");

"1.5.5.0" => ver.languageVersionMin;

"any" => ver.os;
"all" => ver.arch;