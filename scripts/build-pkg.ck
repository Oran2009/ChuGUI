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

ver.addFile("../src/assets/icons/arrow-down.png", "assets/icons");
ver.addFile("../src/assets/icons/arrow-left.png", "assets/icons");
ver.addFile("../src/assets/icons/arrow-right.png", "assets/icons");
ver.addFile("../src/assets/icons/arrow-up.png", "assets/icons");
ver.addFile("../src/assets/icons/check.png", "assets/icons");
ver.addFile("../src/assets/icons/gear.png", "assets/icons");
ver.addFile("../src/assets/icons/magnifying-glass.png", "assets/icons");
ver.addFile("../src/assets/icons/minus.png", "assets/icons");
ver.addFile("../src/assets/icons/plus.png", "assets/icons");
ver.addFile("../src/assets/icons/user.png", "assets/icons");
ver.addFile("../src/assets/icons/x.png", "assets/icons");

ver.addFile("../src/components/Button.ck", "components");
ver.addFile("../src/components/Checkbox.ck", "components");
ver.addFile("../src/components/ColorPicker.ck", "components");
ver.addFile("../src/components/Dropdown.ck", "components");
ver.addFile("../src/components/Icon.ck", "components");
ver.addFile("../src/components/Input.ck", "components");
ver.addFile("../src/components/Knob.ck", "components");
ver.addFile("../src/components/Label.ck", "components");
ver.addFile("../src/components/Meter.ck", "components");
ver.addFile("../src/components/Radio.ck", "components");
ver.addFile("../src/components/Rect.ck", "components");
ver.addFile("../src/components/Slider.ck", "components");

ver.addFile("../src/gmeshes/GIcon.ck", "gmeshes");
ver.addFile("../src/gmeshes/GRect.ck", "gmeshes");

ver.addFile("../src/lib/Cache.ck", "lib");
ver.addFile("../src/lib/GComponent.ck", "lib");
ver.addFile("../src/lib/MouseState.ck", "lib");
ver.addFile("../src/lib/Util.ck", "lib");

ver.addFile("../src/materials/RectMaterial.ck", "materials");

ver.addFile("../src/ChuGUI.ck");
ver.addFile("../src/UIStyle.ck");

ver.addExampleFile("../examples/components/button/basic.ck", "components/button");
ver.addExampleFile("../examples/components/button/style.ck", "components/button");
ver.addExampleFile("../examples/components/checkbox/basic.ck", "components/checkbox");
ver.addExampleFile("../examples/components/checkbox/style.ck", "components/checkbox");
ver.addExampleFile("../examples/components/colorpicker/basic.ck", "components/colorpicker");
ver.addExampleFile("../examples/components/dropdown/basic.ck", "components/dropdown");
ver.addExampleFile("../examples/components/input/basic.ck", "components/input");
ver.addExampleFile("../examples/components/input/style.ck", "components/input");
ver.addExampleFile("../examples/components/knob/basic.ck", "components/knob");
ver.addExampleFile("../examples/components/knob/style.ck", "components/knob");
ver.addExampleFile("../examples/components/meter/basic.ck", "components/meter");
ver.addExampleFile("../examples/components/meter/style.ck", "components/meter");
ver.addExampleFile("../examples/components/radio/basic.ck", "components/radio");
ver.addExampleFile("../examples/components/slider/basic.ck", "components/slider");
ver.addExampleFile("../examples/components/slider/style.ck", "components/slider");

ver.addExampleFile("../examples/components/icon/basic.ck", "components/icon");
ver.addExampleFile("../examples/components/icon/icons/acorn.png", "components/icon/icons");
ver.addExampleFile("../examples/components/icon/icons/bell.png", "components/icon/icons");
ver.addExampleFile("../examples/components/icon/icons/chuck.png", "components/icon/icons");
ver.addExampleFile("../examples/components/icon/icons/cookie.png", "components/icon/icons");
ver.addExampleFile("../examples/components/icon/icons/heart.png", "components/icon/icons");
ver.addExampleFile("../examples/components/icon/icons/music-note.png", "components/icon/icons");
ver.addExampleFile("../examples/components/icon/icons/smiley.png", "components/icon/icons");
ver.addExampleFile("../examples/components/icon/icons/star.png", "components/icon/icons");

ver.addExampleFile("../examples/hud/hud.ck", "hud");
ver.addExampleFile("../examples/hud/assets/bed.png", "hud/assets");
ver.addExampleFile("../examples/hud/assets/cloud-lightning.png", "hud/assets");
ver.addExampleFile("../examples/hud/assets/fire.png", "hud/assets");
ver.addExampleFile("../examples/hud/assets/hand-fist.png", "hud/assets");
ver.addExampleFile("../examples/hud/assets/heartbeat.png", "hud/assets");
ver.addExampleFile("../examples/hud/assets/paw-print.png", "hud/assets");
ver.addExampleFile("../examples/hud/assets/sword.png", "hud/assets");
ver.addExampleFile("../examples/hud/assets/syringe.png", "hud/assets");
ver.addExampleFile("../examples/hud/assets/tornado.png", "hud/assets");

// wrap up all our files into a zip file, and tell Chumpinate what URL
// this zip file will be located at.
ver.generateVersion("../releases/" + ver.version(), "ChuGUI", "https://ccrma.stanford.edu/~hoangben/ChuGUI/releases/" + ver.version() + "/ChuGUI.zip");

ver.generateVersionDefinition("ChuGUI", "./");