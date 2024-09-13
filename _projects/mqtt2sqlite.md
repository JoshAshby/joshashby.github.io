---
title: mqtt2sqlite.rb
cover:
  description: A small utility which logs MQTT messages into a SQLite DB table.
tags:
  - Home Automation
status: Active (2024 --- now)
links:
  - url: https://github.com/JoshAshby/mqtt2sqlite.rb
    content: GitHub Repository
---

I use MQTT heavily within my Home Automation journey, but sometimes I want to
chart and log the state of devices, such as their battery levels or the last
time a device was seen. This single-file utility aims to make that easy, by
connecting to the MQTT bus and listening to configured topics. When a message
comes in for one of those topics, it uses a set of rules to parse the message
into a structured row and dumps the result into a table.

---

mqtt2sqlite.rb is configured through a single TOML file, and has two
parts to this configuration:
- Tables
- Subscriptions

The "tables" section details the structure of the available tables within SQLite
and acts as a migration guide for the tool, and a documentation aid for the
rest of the configuration. A column within a table can be marked as a
"generated" column which makes it easy to expose, for example, Fahrenheit
temperatures for a sensor that measures in Celsius, without requiring the
querying end user to know about needing to do the conversion on their own.

The "subscriptions" section lists entries with the MQTT topic to listen to for
new messages, the destination table for any rows that the subscription
produces, an optional filter which can act on the topic or the message payload,
and a set of columns which dictates how a message's payload is parsed into a
row for the destination table.

This arraignment allows mqtt2sqlite.rb to write messages from one topic to
multiple tables (through multiple subscription entries in the config that set
different filter options for each entry) or multiple topics to a single table,
providing a wide range of flexibility.

The use of a regex filter against the topic works well when used in combination
with wildcard subscriptions, and a JSONPath filter works well to avoid rows
that are all null values if a device publishes a variety of JSON payload structures.

Columns can make use of the same regex and JSONPath expressions to extract
values, or be set to a static value which comes in handy when a table might be
getting populated by multiple topics.


## Technology
- Ruby (inline Bundler, Sequel gem)
- SQLite, MQTT, TOML

<!--## Neat Details-->
<!----->
