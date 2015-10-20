opentsdb_handler Cookbook
==============================
This cookbook sets up a handler that reports to [OpenTSDB](http://opentsdb.net/) at the end of a chef run

Requirements
------------
The only requirement is the chef_handler cookbook

Attributes
----------
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['opentsdb_handler']['handlers']</tt></td>
    <td>Hash</td>
    <td>this is where each handler is defined</td>
    <td><tt>{}</tt></td>
  </tr>
  <tr>
    <td><tt>['opentsdb_handler']['handlers'][handler_name]['metric']</tt></td>
    <td>String</td>
    <td>Metric to send</td>
    <td><tt>None</tt></td>
  </tr>
  <tr>
    <td><tt>['opentsdb_handler']['handlers'][handler_name]['value']</tt></td>
    <td>Hash</td>
    <td>Value of metric</td>
    <td><tt>None</tt></td>
  </tr>
  <tr>
    <td><tt>['opentsdb_handler']['handlers'][handler_name]['tags']</tt></td>
    <td>Hash</td>
    <td>Key => Value hash of tags for the metric.</td>
    <td><tt>{'hostname' => Socket.gethostname}(IN HANDLER SCRIPT)</tt></td>
  </tr>
  <tr>
    <td><tt>['opentsdb_handler'][handler_name]['run_status_tag']</tt></td>
    <td>Boolean</td>
    <td>Will add run_status=0|1 tag if true</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['opentsdb_handler']['hostname']</tt></td>
    <td>opentsdb</td>
    <td>Hostname of OpenTSDB server</td>
    <td><tt>opentsdb (IN HANDLER SCRIPT)</tt></td>
  </tr>
  <tr>
    <td><tt>['opentsdb_handler']['port']</tt></td>
    <td>Integer</td>
    <td>Port of OpenTSDB server</td>
    <td><tt>4242 (IN HANDLER SCRIPT)</tt></td>
  </tr>
  <tr>
    <td><tt>['opentsdb_handler']['timeout']</tt></td>
    <td>Integer</td>
    <td>Timeout before failing to send to metric</td>
    <td><tt>10 (IN HANDLER SCRIPT)</tt></td>
  </tr>
</table>

Usage
-----
#### opentsdb_handler::default

Include `opentsdb_handler` in your node's `run_list` and add the following attributes:

```ruby
node.default['opentsdb_hander']['your_handler_name']['metric'] = 'flying_puppy.metric'
node.default['opentsdb_hander']['your_handler_name']['value'] = 10
# Optional
node.default['opentsdb_hander']['your_handler_name']['tags'] = {"breed" => "corgi"}
```

You can add as many metrics to this hash as you want. The timestamp will be created at the start of the handler.

Contributing
------------
1. Fork the repository on Github
2. `bundle install`
3. Make changes
4. Test your changes [Testing](#Testing)

Testing
-------
Integration tests are run with [test-kitchen](https://github.com/test-kitchen/test-kitchen), [kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant), and [serverspec](serverspec.org) for integration testing. You can take a look at [.kitchen.yml] for how tests are set up. Run with:
```
rake kitchen:all
```

Unit testing is run with [ChefSpec](https://github.com/sethvargo/chefspec)

Linting is done with [foodcritic](https://acrmp.github.io/foodcritic/) and [rubocop](https://github.com/bbatsov/rubocop)

Run unit and linting with:
```
rake test
```


License and Authors
-------------------
Authors: michael.wood@optimizely.com
