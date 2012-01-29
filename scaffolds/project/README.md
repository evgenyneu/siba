# Developing a SIBA plugin


Follow four simple steps to develop a SIBA extension plugin.

## 1. Generate project skeleton

Generate an empty project for a plugin gem:

        $ siba scaffold CATEGORY plugin-name

where CATEGORY can be: source, archive, encryption or destination. 

## 2. Change `init.rb` file

After the project is generated, add your code to init.rb file located in lib/your-plugin-dir. It already has all necessay methods with instructions and examples.

## 3. Change `options.yml`

Add your plugin options to `options.yml`. It is located in the same directory as `init.rb`. This file is used for `siba generate` command.

## 4. Publish

Publish your plugin gem. If you want your plugin to be shown to users by `siba list` and `siba generate` commands, add its description to /lib/siba/plugins/plugins.yml file in [siba github project](https://github.com/evgenyneu/siba) and send a pull request:


## Testing

The project contains test files with examples. Two types of tests are used: unit and integration. In unit tests file system, shell and other time consuming operations are not performed.

To run unit tests:
        rake

To run integration tests
        rake test:i9n
