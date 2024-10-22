# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Running the ImportService

To run the ImportService with a JSON file, follow these steps:

1. Open a terminal and navigate to the root of your Rails project.
2. Run the following command, replacing path/to/json/file.json with the actual path to your JSON file:

```
rails import:run[path/to/json/file.json]
```

This will run the ImportService with the specified JSON file and import the data into your application models.
