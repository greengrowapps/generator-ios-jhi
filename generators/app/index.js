'use strict';
const Generator = require('yeoman-generator');
const chalk = require('chalk');
const yosay = require('yosay');

module.exports = class extends Generator {
  prompting() {
    // Have Yeoman greet the user.
    this.log(
      yosay(`Welcome to the luminous ${chalk.red('generator-ios-jhi')} generator!`)
    );

    const prompts = [
      {
        type: 'input',
        name: 'appName',
        message: 'Type your app name',
        default: 'MyIosApp'
      },
      {
        type: 'input',
        name: 'bundleId',
        message: 'Type your bundleId',
        default: 'com.mycompany.myiosapp'
      }
    ];

    return this.prompt(prompts).then(props => {
      this.props = props;
    });
  }

  writing() {
    let replacements = {
      appName: this.props.appName,
      bundleId: this.props.bundleId,
      bundleIdKey: this.props.appName.toLowerCase()
    };

    let oldAppName = 'MyApp';
    let appName = this.props.appName;

    const templateFiles = [
      ['Podfile'],
      ['Podfile.lock'],
      ['Readme.md'],
      ['_.gitignore', ' .gitignore'],
      [`${oldAppName}`, `${appName}`],
      [`${oldAppName}.xcodeproj`, `${appName}.xcodeproj`],
      [`${oldAppName}.xcworkspace`, `${appName}.xcworkspace`],
      [`${oldAppName}Tests/MyAppTests.swift`, `${appName}Tests/${appName}Tests.swift`],
      [`${oldAppName}Tests/Info.plist`],
      [
        `${oldAppName}UITests/MyAppUITests.swift`,
        `${appName}UITests/${appName}UITests.swift`
      ],
      [`${oldAppName}UITests/Info.plist`]
    ];

    templateFiles.forEach(([src, dest = src]) => {
      this.fs.copyTpl(`${this.sourceRoot()}/${src}`, `${dest}`, replacements);
    });
  }

  install() {}
};
