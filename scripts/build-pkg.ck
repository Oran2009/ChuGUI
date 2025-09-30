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

PackageVersion ver("ChuGUI", "0.1.0-alpha");

"1.5.5.0" => ver.languageVersionMin;

"any" => ver.os;
"all" => ver.arch;

ver.addFile("../src/components/Button.ck");
ver.addFile("../src/components/Checkbox.ck");
ver.addFile("../src/components/ColorPicker.ck");
ver.addFile("../src/components/Dropdown.ck");
ver.addFile("../src/components/Icon.ck");
ver.addFile("../src/components/Input.ck");
ver.addFile("../src/components/Knob.ck");
ver.addFile("../src/components/Label.ck");
ver.addFile("../src/components/Meter.ck");
ver.addFile("../src/components/Radio.ck");
ver.addFile("../src/components/Rect.ck");
ver.addFile("../src/components/Slider.ck");

ver.addFile("../src/gmeshes/GIcon.ck");
ver.addFile("../src/gmeshes/GRect.ck");

ver.addFile("../src/lib/Cache.ck");
ver.addFile("../src/lib/GComponent.ck");
ver.addFile("../src/lib/MouseState.ck");
ver.addFile("../src/lib/Util.ck");

ver.addFile("../src/materials/RectMaterial.ck");

ver.addFile("../src/ChuGUI.ck");
ver.addFile("../src/UIStyle.ck");

ver.addExampleFile("../examples/components/button/basic.ck", "components/button");
ver.addExampleFile("../examples/components/button/style.ck", "components/button");
ver.addExampleFile("../examples/components/checkbox/basic.ck", "components/checkbox");
ver.addExampleFile("../examples/components/checkbox/style.ck", "components/checkbox");
ver.addExampleFile("../examples/components/colorpicker/basic.ck", "components/colorpicker");
ver.addExampleFile("../examples/components/dropdown/basic.ck", "components/dropdown");
ver.addExampleFile("../examples/components/icon/basic.ck", "components/icon");
ver.addExampleFile("../examples/components/input/basic.ck", "components/input");
ver.addExampleFile("../examples/components/input/style.ck", "components/input");
ver.addExampleFile("../examples/components/knob/basic.ck", "components/knob");
ver.addExampleFile("../examples/components/knob/style.ck", "components/knob");
ver.addExampleFile("../examples/components/meter/basic.ck", "components/meter");
ver.addExampleFile("../examples/components/meter/style.ck", "components/meter");
ver.addExampleFile("../examples/components/radio/basic.ck", "components/radio");
ver.addExampleFile("../examples/components/slider/basic.ck", "components/slider");
ver.addExampleFile("../examples/components/slider/style.ck", "components/slider");
ver.addExampleFile("../examples/hud/hud.ck", "hud");

"ChuGUI/files/" + ver.version() + "/ChuGUI.zip" => string path; // path?

// wrap up all our files into a zip file, and tell Chumpinate what URL
// this zip file will be located at.
ver.generateVersion("./", "ChuGUI", "https://chuck.stanford.edu/release/chump/" + path);

ver.generateVersionDefinition("ChuGUI", "./");