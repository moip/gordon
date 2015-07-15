# Gordon

We all know that build application packages is a pain. A lot of pain.

Of course, [fpm](https://github.com/jordansissel/fpm) is a awesome tool to abstract package building for a lot of Operational Systems. Period.

Of course, [fpm-cookery](https://github.com/bernd/fpm-cookery) is another great tool to approach building as a simple recipe.

Of course, [foreman](https://github.com/ddollar/foreman) is a great tool to handle Procfile-based applications and have the amazing feature of export to init files (systemd, runit, inittab).

But, unfortunately, create fpm-cookery recipes for each application can be boring and repetitious. You need to create init files (inittab, systemd, etc) for each project and, if a webserver changes (example: from Thin to Unicorn) you need to change script again, again and again.

And when you are in front with a web application that breaks Nginx or Apache conventions? Do you remember that feel, bro?

Gordon is a try to automagically create init files using Foreman and build artifacts using fpm-cookery, on the shoulder of conventions. Make developers free to develop, while you have apps under a minimal control in ops side of view.

## How it works?

Gordon have a lot of restrictions, because they are liberating. These restrictions are a result of years packaging apps, since code generation to minimal security & ops conventions.

Per example: create a user that will run app with credentials, whose $HOME is the directory of application, is a good practice. Therefore, any web app will follow this rule with Gordon. Period.

## How are the options?

* Http Servers: Nginx or Apache;

* Web Servers: Tomcat or Jetty;

* Init scripts: Systemd;

* Apps supported:

    * Ruby Web (resides based on Http Server of choice)
    * Ruby Standalone (resides on /opt/*app_name*)
    * Java Web (resides based on Web Server of choice)
    * Java Standalone (resides on /opt/*app_name*)

## Installation

Add this line to your application's Gemfile:

    gem 'gordon'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gordon

## Usage

First, you need to vendorize all gems in deployment mode:

    $ ruby -S bundle package --all

    $ ruby -S bundle install --deployment --without development test debug

Here a simple example to build a Ruby Web App that runs Nginx and uses Systemd as init process. Just enter on source folder of your app and run in your terminal:

    $ ruby -S gordon                                      \
      --app-type         web                              \
      --app-name         my-app                           \
      --app-description  "my app"                         \
      --app-homepage     https://github.com/myuser/my-app \
      --app-version      1.0.0                            \
      --app-source       .                                \
      --runtime-name     ruby                             \
      --runtime-version  2.2.0                            \
      --http-server-type nginx                            \
      --init-type        systemd                          \
      --package-type     rpm                              \
      --output           pkg

It will generate a RPM package in pkg/ with the following structure:

* /usr/share/nginx/html/*all-app-stuff*
* /usr/lib/systemd/system/*all-systemd-stuff*
* /var/log/*app-name*

Due for conventions, remember:

* /usr/share/nginx/html is $HOME of user *app-name*;
* Systemd will run app using user *app-name.target*

Sounds good?

## And for Java Web applications?

First, generate war files. After, do the following steps:

* Set `--app-type` with "web"
* Set `--app-source` with the path of war file;
* Set `--runtime-name` to oracle-jre / oracle-jdk (only for CentOS platform at this time) or openjdk;
* Set `--runtime-version` (1.7.0_60, 1.8.0_31 etc; Gordon checks and inject correct version into package metadata);
* Set `--web-server-type` to `tomcat` or `jetty`;
* You must avoid `--init-type` because war files are handled by application server of choice (Tomcat or Jetty).

## And Java standalone apps?

Generate jar files before and after pass some parameters:

* Set `--app-type` with "standalone";
* Set `--app-source` with the path of jar file;
* Other options as described above for web apps.

## Why you not use Omnibus or Heroku buildpacks?

Because I want a tool able to create Linux packages that can be extensible based on my needs.

## Why you use fpm-cookery templates instead of fpm?

Because I not found a trivial way to use fpm when you need to package a application under different directories (Apache2 and Systemd per example). If you show to me, I will think to abolish templates.

## Why you can't handle all recipes into a single one and abstract build and install?

Because I need to call some protected methods on FPM::Cookery::Recipe and adding dynamic mixins will be a nightmare due for complexity to maintain.

## Why Gordon?

Because I like Gordon Ramsay.

## TODO

* Export init files to other formats supported by foreman;
* Add Oracle JRE / JDK support for Debian (maybe oracle-jre-installer?)
* Validate inputs
* Debian check (gem heavly developed under CentOS environment)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

