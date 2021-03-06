# gcloud

Idiomatic Ruby client for [Google Cloud Platform](https://cloud.google.com/) services.

[![Travis Build Status](https://travis-ci.org/GoogleCloudPlatform/gcloud-ruby.svg)](https://travis-ci.org/GoogleCloudPlatform/gcloud-ruby/)
[![Coverage Status](https://img.shields.io/coveralls/GoogleCloudPlatform/gcloud-ruby.svg)](https://coveralls.io/r/GoogleCloudPlatform/gcloud-ruby?branch=master)
[![Gem Version](https://badge.fury.io/rb/gcloud.svg)](http://badge.fury.io/rb/gcloud)

* [Homepage](http://googlecloudplatform.github.io/gcloud-ruby/)
* [API Documentation](http://googlecloudplatform.github.io/gcloud-ruby/docs/master/)

## Ruby API Client library for Google Cloud

This client supports the following Google Cloud Platform services:

* [Google Cloud BigQuery](#bigquery)
* [Google Cloud Datastore](#datastore)
* [Google Cloud Pub/Sub](#pubsub)
* [Google Cloud Storage](#storage)

If you need support for other Google APIs, check out the [Google API Ruby Client library](https://github.com/google/google-api-ruby-client).

## Quick Start

```sh
$ gem install gcloud
```

### Authentication

Gcloud uses Service Account credentials to connect to Google Cloud services. When running on Compute Engine the credentials will be discovered automatically. When running on other environments the Service Account credentials can be specified by providing the path to the JSON file, or the JSON itself, in environment variables. Additionally, Cloud SDK credentials can also be discovered automatically, but this is only recommended during development.

Instructions and configuration options are covered in the [Authentication guide](AUTHENTICATION.md). The examples in Quick Start will demonstrate providing the **Project ID** and **Credentials JSON file path** in code.

### BigQuery

- [gcloud-ruby BigQuery API Documentation](http://googlecloudplatform.github.io/gcloud-ruby/docs/master/Gcloud/Bigquery.html)
- [Google Cloud BigQuery Documentation](https://cloud.google.com/bigquery/docs)

#### Preview

```ruby
require "gcloud"

gcloud = Gcloud.new "my-todo-project-id",
                    "/path/to/keyfile.json"
bigquery = gcloud.bigquery

# Create a new table to archive todos
dataset = bigquery.dataset "my-todo-archive"
table = dataset.create_table "todos",
          name: "Todos Archive",
          description: "Archive for completed TODO records"

# Load data into the table
file = File.open "/archive/todos/completed-todos.csv"
load_job = table.load file

# Run a query for the number of completed todos by owner
count_sql = "SELECT owner, COUNT(*) AS complete_count FROM todos GROUP BY owner"
data = bigquery.query count_sql
data.each do |row|
  puts row["name"]
end
```

### Datastore

- [gcloud-ruby Datastore API Documentation](http://googlecloudplatform.github.io/gcloud-ruby/docs/master/Gcloud/Datastore.html)
- [Google Cloud Datastore Documentation](https://cloud.google.com/datastore/docs)

*Follow the [activation instructions](https://cloud.google.com/datastore/docs/activate) to use the Google Cloud Datastore API with your project.*

#### Preview

```ruby
require "gcloud"

gcloud = Gcloud.new "my-todo-project-id",
                    "/path/to/keyfile.json"
dataset = gcloud.datastore

# Create a new task to demo datastore
demo_task = Gcloud::Datastore::Entity.new
demo_task.key = Gcloud::Datastore::Key.new "Task", "datastore-demo"
demo_task[:description] = "Demonstrate Datastore functionality"
demo_task[:completed] = false

# Save the new task
dataset.save demo_task

# Run a query for all completed tasks
query = Gcloud::Datastore::Query.new.kind("Task").
  where("completed", "=", true)
completed_tasks = dataset.run query
```

### Pub/Sub

- [gcloud-ruby Pub/Sub API documentation](http://googlecloudplatform.github.io/gcloud-ruby/docs/master/Gcloud/Pubsub.html)
- [Google Cloud Pub/Sub Documentation](https://cloud.google.com/pubsub/docs)

#### Preview

```ruby
require "gcloud"

gcloud = Gcloud.new "my-todo-project-id",
                    "/path/to/keyfile.json"
pubsub = gcloud.pubsub

# Retrieve a topic
topic = pubsub.topic "my-topic"

# Publish a new message
msg = topic.publish "new-message"

# Retrieve a subscription
sub = pubsub.subscription "my-topic-sub"

# Pull available messages
msgs = sub.pull
```

### Storage

- [gcloud-ruby Storage API documentation](http://googlecloudplatform.github.io/gcloud-ruby/docs/master/Gcloud/Storage.html)
- [Google Cloud Storage Documentation](https://cloud.google.com/storage/docs)

#### Preview

```ruby
require "gcloud"

gcloud = Gcloud.new "my-todo-project-id",
                    "/path/to/keyfile.json"
storage = gcloud.storage

bucket = storage.bucket "task-attachments"

file = bucket.file "path/to/my-file.ext"

# Download the file to the local file system
file.download "/tasks/attachments/#{file.name}"

# Copy the file to a backup bucket
backup = storage.bucket "task-attachment-backups"
file.copy backup, file.name
```

## Supported Ruby Versions

gcloud is supported on Ruby 1.9.3+.

## Versioning

This library follows [Semantic Versioning](http://semver.org/).

It is currently in major version zero (0.y.z), which means that anything may change at any time and the public API should not be considered stable.

## Contributing

Contributions to this library are always welcome and highly encouraged.

See [CONTRIBUTING](CONTRIBUTING.md) for more information on how to get started.

Please note that this project is released with a Contributor Code of Conduct. By participating in this project you agree to abide by its terms. See [Code of Conduct](CODE_OF_CONDUCT.md) for more information.

## License

This library is licensed under Apache 2.0. Full license text is
available in [LICENSE](LICENSE).

## Support

Please [report bugs at the project on Github](https://github.com/GoogleCloudPlatform/gcloud-ruby/issues).
Don't hesitate to [ask questions](http://stackoverflow.com/questions/tagged/gcloud-ruby) about the client or APIs on [StackOverflow](http://stackoverflow.com).
