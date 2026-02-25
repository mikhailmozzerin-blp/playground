package main

import (
	"context"
	"fmt"
	"log"
	"os"

	"playground/internal/analytics"
	"playground/internal/edi"
	"playground/internal/redisstore"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	if len(os.Args) < 2 {
		printUsage()
		os.Exit(1)
	}

	switch os.Args[1] {
	case "server":
		runServer()
	case "load-redis":
		runLoadRedis()
	case "test-mysql":
		runTestMySQL()
	default:
		printUsage()
		os.Exit(1)
	}
}

func printUsage() {
	fmt.Println("Usage: playground <command>")
	fmt.Println()
	fmt.Println("Commands:")
	fmt.Println("  server       Start the HTTP server")
	fmt.Println("  load-redis   Load JSON files into Redis")
	fmt.Println("  test-mysql   Test MySQL connectivity")
}

func runServer() {
	e := echo.New()

	e.Use(middleware.Logger())
	e.Use(middleware.Recover())

	e.POST("/api/edi/blp-format/:docId", edi.UploadBLPFormat)

	log.Println("starting server on :8080")
	if err := e.Start(":8080"); err != nil {
		log.Fatal(err)
	}
}

func runLoadRedis() {
	ctx := context.Background()
	store := redisstore.New("localhost:6379")
	defer store.Close()

	if err := store.Client.Ping(ctx).Err(); err != nil {
		log.Fatalf("redis ping failed: %v", err)
	}
	log.Println("connected to redis")

	const (
		key   = "36c26fb2-1245-4d08-87f3-e7a188c49ae9"
		file1 = "/Users/mozhzherin/Library/Application Support/JetBrains/GoLand2025.3/scratches/prediction_jsonata.json"
		file2 = "/Users/mozhzherin/Library/Application Support/JetBrains/GoLand2025.3/scratches/prediction_xslt.json"
	)

	if err := store.PutJSON(ctx, key, "v1", file1); err != nil {
		log.Fatalf("failed to store json: %v", err)
	}

	if err := store.PutJSON(ctx, key, "v2", file2); err != nil {
		log.Fatalf("failed to store json: %v", err)
	}

	fields, err := store.ListFields(ctx, key)
	if err != nil {
		log.Fatalf("failed to list fields: %v", err)
	}
	log.Printf("key %s has %d field(s): %v", key, len(fields), fields)
}

func runTestMySQL() {
	store, err := analytics.New("app:apppass@tcp(localhost:3310)/analytics?parseTime=true")
	if err != nil {
		log.Fatalf("mysql connection failed: %v", err)
	}
	defer store.Close()

	events, err := store.ListEvents(10)
	if err != nil {
		log.Fatalf("list events failed: %v", err)
	}
	log.Printf("found %d events", len(events))
	for _, e := range events {
		log.Printf("  [%d] %s at %s", e.ID, e.EventType, e.CreatedAt)
	}
}
