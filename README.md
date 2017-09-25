# Nod

An __easy-to-use__, __no-fuss__ command line application to pump out more Nod screen assets than you could possibly ever use. In this day and age, the need to highlight and present business-critical information and key data on electronic screens has never been higher.

This is where Nod comes in. Initialise a project, write frontend code, and bundle. It's simple and it's straightforward. What more could you ask for. (*Don't forget to upload!*)

## Usage

### New Project

To create a new Nod project, simply run ``` $ nod init <project-name> ```.

This will create a new Nod project in your current directory. It will generate a basic template for you to hit the ground running. You'll be making Nod screens in no time.

### Packaging the Project

When you are ready to push your project to the Nod dashboard, change directory one level above the Nod project and run  ``` $ nod bundle <project-name> ```.

This will zip up all assets within the Nod project, and generate and include a manifest.xml file that contains meta information about the files included, data feeds, and field values.

Grab this zipped Nod asset and upload it to Nod. The Nod backend will handle the rest. Enjoy!

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nod. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Nod project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/theomarkkuspaul/nod/blob/master/CODE_OF_CONDUCT.md).
