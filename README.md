# NLA Physical Carriers Report - ArchivesSpace Plugin

An ArchivesSpace plugin that adds a report on Archival Objects with physical
carriers.

----

Developed by Hudson Molonglo for the National Library of Australia.

&copy; 2024 Hudson Molonglo Pty Ltd.

----

## Compatibility

This plugin was developed against ArchivesSpace v3.3.1. Although it has not
been tested against other versions, it will probably work as expected on all
3.x versions.


## Installation

This plugin has no special installation requirements. It has no database
migrations and no external gems.

1.  Download the latest [release](../../releases).
2.  Unpack it into `/path/to/your/archivesspace/plugins/`
3.  Add the plugin to your `config.rb` like this: `AppConfig[:plugins] << 'nla_physical_carriers_report'`
4.  Restart ArchivesSpace

To confirm installation has been successful, navigate to the Reports screen.
You should see a report called 'Physical Carriers'.
