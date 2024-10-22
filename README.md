# menu-api

The project provides a RESTful API for manage restaurant, menu and menu items.

## Table of Contents

- [Installation](#installation)
- [API](#api)
- [Test](#test)
- [Rake](#rake)


## Run project
To run the project you need the following:

- Docker && Docker Compose

1. Clone the repository:

```
git clone https://github.com/username/project.git
```

2. Create .env file in root with content:

```
DB_USERNAME=menuapi
DB_PASSWORD=menuapi123
DB_DEV_NAME=database_for_development_name
DB_TEST_NAME=database_for_test_name
```

4. Install the dependencies:

```
bundle install
```

5. Start the project:

```
rails s
```

## Test

Run the command:

```
rspec
```

## API

* **POST /v1/import**: Creates new data.

201
```json
{ message: "Import successful" }
```

422
```json
{ error: "Invalid JSON data" }
```

* **POST /v1/restaurants**: Creates a new restaurant.

201
```json
{
  id: 1,
  name: "Mc Donalds",
  menus: []
}
```

422
```json
{ "Validation failed: Name can't be blank" }
```

* **GET /v1/restaurants**: Retrieves a list of all restaurants.

```json
[
  {
    id: 1,
    name: "Mc Donalds",
    menus: [
      {
        id: 1,
        title: "Burguers"
      }
    ]
  },
  {
    id: 2,
    name: "Burguer King",
    menus: [
      {
        id: 1,
        title: "Burguers"
      }
    ]
  }
]
```

* **GET /v1/restaurants/:id**: Retrieves a specific restaurant.

200
```json
{
  id: 1,
  name: "Mc Donalds",
  menus: []
}
```

404
```json
{ "Couldn't find Restaurant with 'id'=999999" }
```

* **PUT /v1/restaurants/:id**: Updates a specific restaurant.

200
```json
{
  id: 1,
  name: "Mc Donalds",
  menus: []
}
```

404
```json
{ "Couldn't find Restaurant with 'id'=999999" }
```

* **DELETE /v1/restaurants/:id**: Deletes a specific restaurant.

204
```json
{}
```

404
```json
{ "Couldn't find Restaurant with 'id'=999999" }
```

* **POST v1/menus**: Creates a new menu.

201
```json
{
  id: 1,
  title: "Burguers",
  menu_items: [],
  restaurants: []
}
```

422
```json
{ "Validation failed: Title can't be blank" }
```

* **GET v1/menus**: Retrieves a list of all menus.

200
```json
[
  {
    id: 1,
    title: "Burguers",
    menu_items: [],
    restaurants: []
  },
  {
    id: 2,
    title: "Lunch",
    menu_items: [],
    restaurants: []
  }
]
```

* **GET v1/menus/:id**: Retrieves a specific menu.

200
```json
{
  id: 1,
  title: "Burguers",
  menu_items: [],
  restaurants: []
}
```

404
```json
{ "Couldn't find Menu with 'id'=999999" }
```

* **PUT v1/menus/:id**: Updates a specific menu.

200
```json
{
  id: 1,
  title: "Burguers",
  menu_items: [],
  restaurants: []
}
```

404
```json
{ "Couldn't find Menu with 'id'=999999" }
```

* **DELETE v1/menus/:id**: Deletes a specific menu.

204
```json
{}
```

404
```json
{ "Couldn't find Menu with 'id'=999999" }
```

* **POST v1/menu_items**: Creates a new menu item.

201
```json
{
  id: 1,
  name: "Big Mac",
  description: "Buns, patties, cheese, lettuce pickles, onions, sauce, paprika",
  price: 5.69,
  menus: []
}
```

422
```json
{ "Validation failed: Name can't be blank" }
```

* **GET v1/menu_items**: Retrieves a list of all menus items.

200
```json
[
  {
    id: 1,
    name: "Big Mac",
    description: "Buns, patties, cheese, lettuce pickles, onions, sauce paprika",
    price: 5.69,
    menus: []
  },
  {
    id: 2,
    name: "The Classic",
    description: "Buns, patties, chopped onions, ketchup, mustard",
    price: 2.19,
    menus: []
  }
]
```

* **GET v1/menu_items/:id**: Retrieves a specific menu item.

200
```json
{
  id: 1,
  name: "Big Mac",
  description: "Buns, patties, cheese, lettuce pickles, onions, sauce, paprika",
  price: 5.69,
  menus: []
}
```

404
```json
{ "Couldn't find Menu with 'id'=999999" }
```

* **PUT v1/menu_items/:id**: Updates a specific menu item.

200
```json
{
  id: 1,
  name: "Big Mac",
  description: "Buns, patties, cheese, lettuce pickles, onions, sauce, paprika",
  price: 5.69,
  menus: []
}
```

404
```json
{ "Couldn't find Menu with 'id'=999999" }
```

* **DELETE v1/menu_items/:id**: Deletes a specific menu.

204
```json
{}
```

404
```json
{ "Couldn't find Menu with 'id'=999999" }
```

## Rake

To run the ImportService with a JSON file, follow these steps:

1. Open a terminal and navigate to the root of your Rails project.
2. Run the following command, replacing path/to/json/file.json with the actual path to your JSON file:

```
rails import:run[path/to/json/file.json]
```

This will run the ImportService with the specified JSON file and import the data into your application models.
