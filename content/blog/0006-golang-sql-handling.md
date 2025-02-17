+++
date = "2025-02-14"
title = "My favourite way to handle SQL in Golang"
slug = "best-golang-sql-handling"
tags = ["Golang", "SQL"]
categories = ["Backend"]
[params]
  metadescription = 'How to best handle SQL logic in Golang applications for migrations and queries'
  metakeywords = 'golang, sqlc, go, sql, migrations, code generation'
+++

_tl;dr: using sqlc and golang-migrate allows plain easy SQL in your application_

Golang is a great language when building web/API services. And that makes a lot of sense, as Go was created for building scalable, performant applications. The language is very cohesive, compiles fast, has great performance and has a great ecosystem in addition to its rich standard library and great toolchain. Whenever I need to build a web service or API, I tend to reach for Go when possible, hence why I built quite a lot of applications with it so far, including around a dozen or so application back-ends.

But this is not an article about why Go is great, but rather on how to handle SQL. Considering Golang is not made to be used in Ruby on Rails-type frameworks, you'll most likely have to set up the SQL-logic yourself.

My approach to SQL handling in Golang is the result of trying out a lot of approaches and seeing what works and what doesn't. This approach is mostly aimed at building API services, backed by a database. In my case, I use Postgresql, though other SQL databases should also work with a few tweaks.

As most applications that I build deal with quite a lot of data, I don't want to work with ORMs like Gorm, due to the performance impact and unnecessary abstractions that it introduces. In general, I'm not the biggest fan of ORMs, as I already know SQL and don't like learning additional tools to abstract away the actual SQL code, using SQL directly for me is simply faster, both in terms of performance as well as writing the application.

So how then do I approach SQL in Golang?

## Code generation with sqlc

One of the things I like about the Go ecosystem is that there are a lot of code generation tools. Code generation is something that is quite underused in my opinion, and [sqlc](https://sqlc.dev/) is an amazing example of how code generation can be very powerful.

With sqlc, you can write plain sql, and then run a command that generates the Go code in a module you can use in your application.

## Configuring sqlc

After [installing sqlc](https://docs.sqlc.dev/en/latest/overview/install.html) on your device, getting up and running with sqlc is quite trivial. The generic installation instructions are found in the [sqlc docs](https://docs.sqlc.dev/en/latest/tutorials/getting-started-postgresql.html), but I'm using a bit of a modified configuration.

We start with creating the `sql/` and `migrations/` folders, for SQL queries and database migrations.

In the migrations directory, add a file `0000_schema.up.sql` and `0000_schema.down.sql` for adding your initial database schema, take this up migration for example:

```sql
BEGIN;

-- Enable uuid extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
    -- User fields
);

-- The rest of your schema

COMMIT;
```

Make sure to add the down migrations as well. The migrations are used by sqlc to generate the database structure and add typed columns for database manipulations. They will also be used to perform actual database migrations. Wrap your migration logic in `BEGIN` and `COMMIT` so you can `ROLLBACK` on a failed migration.

## Full sqlc config example

Here is the full configuration I'm using for the Capsa API service:

```yaml
version: "2"
sql:
  - engine: "postgresql"
    queries: "sql/"
    schema: "migrations/"
    gen:
      go:
        package: "database"
        out: "internal/data/database"
        sql_package: "pgx/v5"
        emit_json_tags: true
        json_tags_case_style: "camel"
        emit_pointers_for_null_types: true
        overrides:
          # UUID
          - db_type: "uuid"
            go_type:
              import: "github.com/google/uuid"
              type: "UUID"
          - db_type: "uuid"
            nullable: true
            go_type:
              import: "github.com/google/uuid"
              type: "UUID"
              pointer: true
          # Timestamp
          - db_type: "pg_catalog.timestamp"
            nullable: true
            go_type:
              import: "time"
              type: "Time"
              pointer: true
          - db_type: "pg_catalog.timestamp"
            go_type: "time.Time"
          # Custom
          - column: "logs_chunks.category_counts"
            go_type:
              import: "github.com/capsa-gg/capsa/server/internal/entities"
              type: "LogChunkMetadata"
          - column: "logs_chunks.severity_counts"
            go_type:
              import: "github.com/capsa-gg/capsa/server/internal/entities"
              type: "LogChunkMetadata"
```

This configuration replaces the pgx (Postgres database driver) UUID and Timestamps with the Google and standard library implementations respectively. It also specifies a few column types to be used, so the returned data has better compatibility with my domain logic. For further explanation on this, see the [docs](https://docs.sqlc.dev/en/latest/reference/config.html).

## Writing SQL statements

With sqlc configured, we can write some SQL code! The [docs](https://docs.sqlc.dev/en/latest/howto/select.html) explain things in more detail, but here are two very simple examples:

```sql
-- name: GetUserByID :one
SELECT * FROM users
WHERE id = $1;
```

Gets a user by their ID. The `*` return value here will use the database schema to determine the return type to make it fully typesafe.

```sql
-- name: UpdateUser :one
-- Update a user with optional parameters
UPDATE users
SET first_name = @first_name,
    last_name = @last_name,
    user_role = @user_role
WHERE id = $1
RETURNING *;
```

For updating a user, this also shows how arguments can be named with sqlc for clarity in the domain logic.

## Complex SQL

The two examples above are the 'hello world' equivalent of SQL statements. In larger applications things become more complex. An example of this is searching. Although there might be better ways, this is the way I have implemented search for Capsa, which is not too complex:

```sql
-- name: SearchResources :many
-- Searches in some database tables to find matching resources based on a "contains string" pattern (LIKE '%<arg>%')
WITH resources AS (
    SELECT
        'Environment' AS table_name,
        lower(e.key::text) AS identifier,
        concat(e.name, ' environment for ', t.name) AS description,
        '' AS details
    FROM environments e
    LEFT JOIN titles t ON t.id = e.title

    UNION ALL

    SELECT
        'Logs' ,
        lower(l.log_uuid::text) ,
        concat(l.log_type, ' log on ', platform, ' (', t.name, ', ', e.name, ')'),
        count(lc)::text
    FROM logs l
    LEFT JOIN environments e ON e.id = l.environment
    LEFT JOIN titles t on t.id = e.title
    LEFT JOIN logs_chunks lc ON l.id = lc.log
    GROUP BY l.log_uuid, l.log_type, platform, t.name, e.name
)
SELECT table_name, identifier, description::text, details::text
FROM resources
WHERE identifier LIKE '%' || lower(@search) || '%'
LIMIT sqlc.arg('limit');
```

Another more complex example is filtering with optional arguments. The full statement is over 50 lines long, but here is the most important part of the implementation for Capsa:

```sql
-- name: ListAvailableLogs :many
-- Fetches all log chunks and aggregates an overview.
-- LogUUID is an optional field used as a filter, which if set will return only a single result.
WITH -- Omitted
SELECT -- Omitted
FROM logs l
JOIN cat_counts cc ON cc.log = l.id
JOIN sev_counts sc ON sc.log = l.id
JOIN chunk_data cd ON cd.log = l.id
JOIN environments e on l.environment = e.id
JOIN titles t on e.title = t.id
LEFT JOIN links ll on l.id = ll.source
WHERE ( l.log_uuid =  sqlc.narg(filter_by_log_uuid)          OR sqlc.narg(filter_by_log_uuid)    IS NULL )  -- Optionally filter by Log UUID
AND   ( e.key =       sqlc.narg(filter_by_environment)::uuid OR sqlc.narg(filter_by_environment) IS NULL )  -- Optionally filter by Environment
AND   ( l.platform =  sqlc.narg(filter_by_platform)::varchar OR sqlc.narg(filter_by_platform)    IS NULL )  -- Optionally filter by Platform
AND   ( l.log_type =  sqlc.narg(filter_by_logtype)           OR sqlc.narg(filter_by_logtype)     IS NULL )  -- Optionally filter by LogType
GROUP BY l.id, t.name, e.name, cd.line_count, cd.chunk_count, cd.earliest_start, cd.latest_end, ll.sum
ORDER BY earliest DESC
LIMIT @fetchlimit::int;
```

This will simply ignore all arguments that are not set, or include them if they are. In all honesty: the syntax with an ORM would be cleaner, but I do suspect the performance will take a hit. If performance with `ListAvailableLogs` becomes an issue, I can optimize it, with ORMs, that is a lot harder.

## Generating the code

To generate the code, simply run `sqlc generate` in the root of your project, and you should have your code! There are more commands you can use for analysis and linting, which are outlined in the [docs](https://docs.sqlc.dev/en/latest/howto/generate.html).

## Using the generated code

During the application start, you can use your config to generate the instance of the sql-generated structs:

```go
package example

import (
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/capsa-gg/capsa/server/internal/data/database"
)

// NewDatabase initializes a Database instance.
func NewDatabase(c *entities.Config) (*database.Queries, error) {
	ctx := context.Background()

	// Database connection
	dbConn, err := pgxpool.New(ctx, c.DatabaseConnectionString())
	if err != nil {
		return nil, fmt.Errorf("error opening database connection: %w", err)
	}

	// Ping database
	err = dbConn.Ping(ctx)
	if err != nil {
		return nil, fmt.Errorf("error pinging database: %w", err)
	}

	// Database instance
	db := database.New(dbConn)

	return db, nil
}
```

You now have a `*database.Queries` instance that you can use to use query the database! Using it is as simple as

```go
user, err := db.GetUserByID(ctx, userId)
```

There is also support for performing logic inside of a transaction, as outlined in the [docs](https://docs.sqlc.dev/en/latest/howto/transactions.html#using-transactions).

## Handling migrations

You should only be changing the database structure using migrations. We already have the migration scripts used by sqlc, which we can use to perform the database migrations.

For migrations, I'm using the golang-migrate package, with a small wrapper. This is the full code of the migrator package for Capsa:

```go
package migrator

import (
	"database/sql"
	"errors"
	"fmt"
	"net/http"

	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database/pgx/v5" //nolint:gocritic,stylecheck // Needs import for using pgx.WithInstance
	"github.com/golang-migrate/migrate/v4/source/httpfs"

	// Needs side effect from pgx/v5.
	_ "github.com/golang-migrate/migrate/v4/database/pgx/v5" //nolint:gocritic,stylecheck // Needs import for side effect

	"github.com/capsa-gg/capsa/server/migrations"
)

// Direction indicates the migration direction.
type Direction string

// UpAll and DownAll indicate the migration direction.
const (
	UpAll   = Direction("UpAll")
	DownAll = Direction("DownAll")
)

// New returns a migrator closure that will accept UpAll or DownAll to up or down migrate the database.
func New(dbConn *sql.DB, dbName string) func(Direction) error {
	return func(direction Direction) error {
		// Direction check
		if direction != UpAll && direction != DownAll {
			return errors.New("migration direction should be 'UpAll' or 'DownAll'")
		}

		driver, err := pgx.WithInstance(dbConn, &pgx.Config{})
		if err != nil {
			return fmt.Errorf("invalid target postgres instance, %w", err)
		}
		// Source instance for the migrations embedded in server binary
		sourceInstance, err := httpfs.New(http.FS(migrations.Migrations), ".")
		if err != nil {
			return fmt.Errorf("invalid source instance, %w", err)
		}

		// Create migrator instance
		migrator, err := migrate.NewWithInstance("httpfs", sourceInstance, dbName, driver)
		if err != nil {
			return fmt.Errorf("failed to initialize migrate instance, %w", err)
		}

		// Do the actual migration
		if direction == UpAll {
			return handleMigratorErrors(migrator.Up())
		}

		if direction == DownAll {
			return handleMigratorErrors(migrator.Down())
		}

		return errors.New("you should not see this")
	}
}

func handleMigratorErrors(err error) error {
	if errors.Is(err, migrate.ErrNoChange) { // Do not report error when no database change
		return nil
	}

	return err
}
```

With this, performing the database migrations is as simple as

```go
import "path/to/migrator"

migrate := migrator.New(db, config.DatabaseName)
err = migrate(migrationDirection)
```

Now you have good 'ol plain SQL for migrations as well as database queries in Golang with code generation!

## Example to see this in action

An example of this approach in action can be found in the [Capsa API server](https://github.com/capsa-gg/capsa/blob/main/server/). Capsa is still work in progress, but I highly doubt the SQL approach will change.
